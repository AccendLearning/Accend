import 'package:flutter/foundation.dart';

import 'package:mobile_interface/src/common/services/api_client.dart';
import 'package:mobile_interface/src/common/services/auth_service.dart';
import 'package:mobile_interface/src/features/group_session/models/private_lobby.dart';

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
  PrivateLobby? _createPrivateLobby;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<PrivateLobby> get privateLobby => List.unmodifiable(_privateLobby);
  PrivateLobby? get createPrivateLobby => _createPrivateLobby;

  Future<List<PrivateLobby>> getLobby(String lobbyId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = _auth.accessToken;
      if (token == null || token.isEmpty) {
        throw StateError('Not authenticated');
      }

      final list = await _api.getList(
        '/private_lobbies/$lobbyId',
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
    return _privateLobby;

  }


  Future<PrivateLobby?> createLobby(String userId, String name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = _auth.accessToken;
      if (token == null || token.isEmpty) {
        throw StateError('Not authenticated');
      }

      final row = await _api.postJson(
        '/private_lobbies/create',
        accessToken: token,
        body: {
          "username": name,
          "user_id": userId,
        },
      );
      _createPrivateLobby = PrivateLobby.fromJson(row);
    } catch (e) {
      _error = e.toString();
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return _createPrivateLobby;
  }


  Future<void> loadMyLobby() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = _auth.accessToken;
      if (token == null || token.isEmpty) {
        throw StateError('Not authenticated');
      }

      final list = await _api.getList(
        '/private_lobbies/me',
        accessToken: token,
      );

      _privateLobby = list
          .cast<Map<String, dynamic>>()
          .map(PrivateLobby.fromJson)
          .toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deletePrivateLobbyRow(String rowId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = _auth.accessToken;
      if (token == null || token.isEmpty) {
        throw StateError('Not authenticated');
      }

      final res = await _api.deleteJson(
        '/private_lobbies/$rowId',
        accessToken: token,
      );

      final deleted = res['deleted'] == true;
      if (deleted) {
        _privateLobby = _privateLobby.where((e) => e.id != rowId).toList();
      }
      return deleted;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> subscribeToLobby(String lobbyId) async {
    // Placeholder: realtime subscription can be added later.
  }

  void unsubscribeFromLobby() {
    // Placeholder: realtime unsubscription can be added later.
  }

}