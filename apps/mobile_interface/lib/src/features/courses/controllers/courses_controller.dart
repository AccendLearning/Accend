import 'package:flutter/foundation.dart';
import '../../../common/services/api_client.dart';
import '../../../common/services/auth_service.dart';
import '../models/course.dart';

class CoursesController extends ChangeNotifier {
  CoursesController({
    required ApiClient api,
    required AuthService auth,
  })  : _api = api,
        _auth = auth;

  final ApiClient _api;
  final AuthService _auth;

  bool _isLoading = false;
  String? _error;
  List<Course> _courses = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Course> get courses => List.unmodifiable(_courses);

  Future<void> loadCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = _auth.accessToken;
      if (token == null) {
        throw Exception("User not authenticated");
      }

      final list = await _api.getList(
        "/courses",
        accessToken: token,
      );

      _courses = list
          .cast<Map<String, dynamic>>()
          .map((e) => Course.fromJson(e))
          .toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}