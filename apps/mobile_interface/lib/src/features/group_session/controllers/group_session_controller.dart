import 'package:flutter/foundation.dart';
import '../../../common/services/api_client.dart';
import '../../../common/services/auth_service.dart';
import '../models/private_lobby.dart';

class GroupSessionController extends ChangeNotifier {
  GroupSessionController({
    required ApiClient api,
    required AuthService auth,
  })  : _api = api,
        _auth = auth;

  final ApiClient _api;
  final AuthService _auth;

  bool _isLoading = false;
  String? _error;
  List<PrivateLobby> _privateLobby = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<PrivateLobby> get privateLobby => List.unmodifiable(_privateLobby);

  Future<void> loadLobby() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = _auth.accessToken;
      if (token == null) {
        throw Exception("User not authenticated");
      }

      final list = await _api.getList(
        "/private_lobbies",
        accessToken: token,
      );

      _privateLobby = list
          .cast<Map<String, dynamic>>()
          .map((e) => PrivateLobby.fromJson(e))
          .toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}