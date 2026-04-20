import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Persisted [current_streak] and [current_minutes] from `GET /home` for fast
/// home UI. Keyed by Supabase user id.
class HomeSnapshotCache {
  static const _keyPrefix = 'home_snapshot_v1_';

  String _key(String userId) => '$_keyPrefix$userId';

  Future<HomeSnapshot?> read(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(userId));
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return HomeSnapshot(
        currentStreak: (map['streak'] as num?)?.toInt() ?? 0,
        currentMinutes: (map['minutes'] as num?)?.toInt() ?? 0,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> write(
    String userId, {
    required int currentStreak,
    required int currentMinutes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key(userId),
      jsonEncode({
        'streak': currentStreak,
        'minutes': currentMinutes,
      }),
    );
  }

  Future<void> clear(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(userId));
  }
}

class HomeSnapshot {
  const HomeSnapshot({
    required this.currentStreak,
    required this.currentMinutes,
  });

  final int currentStreak;
  final int currentMinutes;
}
