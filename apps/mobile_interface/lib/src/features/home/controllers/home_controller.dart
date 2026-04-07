import 'package:flutter/foundation.dart';

import 'package:mobile_interface/src/common/services/api_client.dart';
import 'package:mobile_interface/src/common/services/auth_service.dart';

class HomeController extends ChangeNotifier {
  HomeController({ApiClient? api, AuthService? auth})
      : _api = api ?? ApiClient(),
        _auth = auth ?? AuthService();

  final ApiClient _api;
  final AuthService _auth;

  bool _isLoading = false;
  String? _error;
  String _displayName = 'there';

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get displayName => _displayName;

  Future<void> load() async {
    if (_isLoading) return;

    final accessToken = _auth.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      _displayName = 'there';
      _error = 'You must be logged in to load profile.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final profile = await _api.getJson(
        '/profile',
        accessToken: accessToken,
      );

      final fullName = (profile['full_name'] as String?)?.trim();
      final username = (profile['username'] as String?)?.trim();
      _displayName = _pickDisplayName(fullName: fullName, username: username);
    } catch (e) {
      _error = e.toString();
      _displayName = 'there';
      debugPrint('Failed to load home profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _pickDisplayName({String? fullName, String? username}) {
    if (fullName != null && fullName.isNotEmpty) return fullName;
    if (username != null && username.isNotEmpty) return username;
    return 'there';
  }
}
