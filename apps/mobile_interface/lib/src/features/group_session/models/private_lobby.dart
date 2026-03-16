// lib/src/features/courses/models/course.dart
class PrivateLobby {
  final String id;
  final String lobbyId;
  final String username;
  final String userId;
  final String? host;
  final String? sessionStart;
  final DateTime? joinedAt;

  PrivateLobby({
    required this.id,
    required this.lobbyId,
    required this.username,
    required this.userId,
    this.host,
    this.sessionStart,
    this.joinedAt,
  });

  factory PrivateLobby.fromJson(Map<String, dynamic> json) {
    final joinedAtRaw = json["joined_at"];
    return PrivateLobby(
      id: (json["id"] ?? '').toString(),
      lobbyId: (json["lobby_id"] ?? '').toString(),
      username: (json["username"] ?? '').toString(),
      userId: (json["user_id"] ?? '').toString(),
      host: json["host"]?.toString(),
      sessionStart: json["session_start"]?.toString(),
      joinedAt: joinedAtRaw == null ? null : DateTime.tryParse(joinedAtRaw.toString()),
    );
  }
}