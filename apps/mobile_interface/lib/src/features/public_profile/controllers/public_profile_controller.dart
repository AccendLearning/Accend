import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/constants.dart';
import 'package:mobile_interface/src/common/services/api_client.dart';
import 'package:mobile_interface/src/common/services/auth_service.dart';

import '../models/profile_page_data.dart';

class PublicProfileController extends ChangeNotifier {
  PublicProfileController({ApiClient? api, AuthService? auth})
      : _api = api ?? ApiClient(),
        _auth = auth ?? AuthService();

  final ApiClient _api;
  final AuthService _auth;

  ProfilePageData? _data;
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isUploadingImage = false;
  bool _hasLoaded = false;
  String? _error;

  ProfilePageData? get data => _data;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get isUploadingImage => _isUploadingImage;
  bool get hasLoaded => _hasLoaded;
  String? get error => _error;

  Future<void> logOut() async {
    _error = null;
    notifyListeners();

    try {
      await _auth.signOut();
      _data = null;
      _hasLoaded = false;
    } catch (e) {
      _error = 'Unable to log out right now. Please try again.';
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> load({bool force = false}) async {
    if (_isLoading) return;
    if (_hasLoaded && !force) return;

    final accessToken = _auth.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      _error = 'You must be logged in to view your profile.';
      _hasLoaded = true;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final json = await _api.getJson('/profile/page', accessToken: accessToken);
      _data = ProfilePageData.fromJson(json);
      _hasLoaded = true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Failed to load profile page: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveProfileDetails({
    required String fullName,
    required String nativeLanguage,
    required String learningGoal,
    required String feedbackTone,
    required String accent,
    required String dailyPace,
    required String focusAreas,
  }) async {
    final accessToken = _auth.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      _error = 'You must be logged in to update your profile.';
      notifyListeners();
      return;
    }

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await _api.patchJson(
        '/profile',
        accessToken: accessToken,
        body: {
          'full_name': fullName,
          'native_language': nativeLanguage,
          'learning_goal': learningGoal,
          'feedback_tone': feedbackTone,
          'accent': accent,
          'daily_pace': dailyPace,
          'focus_areas': focusAreas,
        },
      );
      await load(force: true);
    } catch (e) {
      _error = e.toString();
      debugPrint('Failed to save profile details: $e');
      rethrow;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> uploadProfileImageFromGallery() async {
    final accessToken = _auth.accessToken;
    final userId = _auth.currentUser?.id ?? _data?.id;

    if (accessToken == null || accessToken.isEmpty || userId == null || userId.isEmpty) {
      _error = 'You must be logged in to update your profile image.';
      notifyListeners();
      return;
    }

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1280,
      maxHeight: 1280,
    );

    if (picked == null) {
      return;
    }

    _isUploadingImage = true;
    _error = null;
    notifyListeners();

    try {
      final bytes = await picked.readAsBytes();
      if (bytes.isEmpty) {
        throw Exception('Selected image is empty.');
      }

      final ext = _fileExtension(picked.name);
      final contentType = _contentTypeForExtension(ext);
      final objectPath = AppStorage.profileImagePath(userId: userId, extension: ext);
      final folderPath = 'profiles/$userId';

      final bucketsToTry = <String>[
        AppStorage.profileImageBucket,
        AppStorage.courseImageBucket,
      ].toSet().toList(growable: false);

      String? uploadedBucket;
      for (final bucket in bucketsToTry) {
        try {
          // Best-effort cleanup of previous uploads in this user's avatar folder.
          await _removeExistingProfileImages(bucket: bucket, folderPath: folderPath);

          await _auth.client.storage.from(bucket).uploadBinary(
                objectPath,
                bytes,
                fileOptions: FileOptions(contentType: contentType, upsert: true),
              );
          uploadedBucket = bucket;
          break;
        } catch (e) {
          if (_isMissingBucketError(e)) {
            debugPrint('Storage bucket not found: $bucket. Trying fallback bucket.');
            continue;
          }
          rethrow;
        }
      }

      if (uploadedBucket == null) {
        throw Exception('No upload bucket available. Please create profile-images storage bucket.');
      }

      final imageUrl = _auth.client.storage.from(uploadedBucket).getPublicUrl(objectPath);

      await _api.patchJson(
        '/profile/image',
        accessToken: accessToken,
        body: {'profile_image_url': imageUrl},
      );

      await load(force: true);
    } catch (e) {
      _error = e.toString();
      debugPrint('Failed to upload profile image: $e');
      rethrow;
    } finally {
      _isUploadingImage = false;
      notifyListeners();
    }
  }

  String _fileExtension(String filename) {
    final dot = filename.lastIndexOf('.');
    if (dot <= 0 || dot == filename.length - 1) {
      return 'jpg';
    }
    final ext = filename.substring(dot + 1).toLowerCase();
    if (ext == 'jpeg') {
      return 'jpg';
    }
    if (ext == 'png' || ext == 'webp' || ext == 'jpg') {
      return ext;
    }
    return 'jpg';
  }

  String _contentTypeForExtension(String ext) {
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'jpg':
      default:
        return 'image/jpeg';
    }
  }

  bool _isMissingBucketError(Object error) {
    final raw = error.toString().toLowerCase();
    return raw.contains('bucket not found') || raw.contains('status code: 404');
  }

  Future<void> _removeExistingProfileImages({
    required String bucket,
    required String folderPath,
  }) async {
    try {
      final existing = await _auth.client.storage.from(bucket).list(path: folderPath);
      if (existing.isEmpty) {
        return;
      }

      final pathsToDelete = existing
          .map((file) => '$folderPath/${file.name}')
          .toList(growable: false);

      if (pathsToDelete.isNotEmpty) {
        await _auth.client.storage.from(bucket).remove(pathsToDelete);
      }
    } catch (e) {
      debugPrint('Could not clean previous profile images in $bucket/$folderPath: $e');
    }
  }
}
