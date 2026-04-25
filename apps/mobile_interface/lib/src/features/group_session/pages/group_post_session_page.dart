import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../app/constants.dart';
import '../../../app/routes.dart';
import '../../../common/services/auth_service.dart';
import '../../social/controllers/social_controller.dart';
import '../models/private_lobby.dart';

// Vote state per participant within a single session.
enum _VoteState { none, upvoted, downvoted }

class GroupPostSessionPage extends StatefulWidget {
  const GroupPostSessionPage({super.key, required this.participants});

  final List<PrivateLobby> participants;

  @override
  State<GroupPostSessionPage> createState() => _GroupPostSessionPageState();
}

class _GroupPostSessionPageState extends State<GroupPostSessionPage> {
  late final List<PrivateLobby> _participants;
  // Tracks vote state per participant userId for this session.
  final Map<String, _VoteState> _votes = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      final currentUserId = context.read<AuthService>().currentUser?.id;
      _participants = widget.participants
          .where((p) => p.userId != currentUserId)
          .toList();
      context.read<SocialController>().load();
    }
  }

  bool _isInitialized = false;

  Future<void> _toggleFollow(
    BuildContext context,
    String userId,
    bool currentlyFollowing,
  ) async {
    final social = context.read<SocialController>();
    if (currentlyFollowing) {
      await social.unfollow(userId);
    } else {
      await social.follow(userId);
    }
  }

  Future<void> _toggleBlock(
    BuildContext context,
    String userId,
    bool currentlyBlocked,
  ) async {
    final social = context.read<SocialController>();
    if (currentlyBlocked) {
      await social.unblock(userId);
    } else {
      await social.block(userId);
    }
  }

  Future<void> _handleVote(String userId, bool isUpvote) async {
    final social = context.read<SocialController>();
    final current = _votes[userId] ?? _VoteState.none;

    int delta;
    _VoteState next;

    if (isUpvote) {
      switch (current) {
        case _VoteState.none:
          delta = 1;
          next = _VoteState.upvoted;
        case _VoteState.upvoted:
          // Toggle off
          delta = -1;
          next = _VoteState.none;
        case _VoteState.downvoted:
          // Flip from down to up: cancel -1 and add +1 = net +2
          delta = 2;
          next = _VoteState.upvoted;
      }
    } else {
      switch (current) {
        case _VoteState.none:
          delta = -1;
          next = _VoteState.downvoted;
        case _VoteState.downvoted:
          // Toggle off
          delta = 1;
          next = _VoteState.none;
        case _VoteState.upvoted:
          // Flip from up to down: cancel +1 and add -1 = net -2
          delta = -2;
          next = _VoteState.downvoted;
      }
    }

    setState(() => _votes[userId] = next);

    try {
      await social.vote(userId, delta);
    } catch (_) {
      // Revert optimistic update on failure
      setState(() => _votes[userId] = current);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final social = context.watch<SocialController>();

    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Participants:',
                style: GoogleFonts.montserrat(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _participants.isEmpty
                    ? Center(
                        child: Text(
                          'No other participants in this session.',
                          style: t.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.separated(
                        itemCount: _participants.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final p = _participants[index];
                          final isFollowing = social.following
                              .any((u) => u.id == p.userId);
                          final isBlocked = social.blockedIds.contains(p.userId);
                          final voteState = _votes[p.userId] ?? _VoteState.none;
                          final knownUser = [
                            ...social.followers,
                            ...social.following,
                          ].where((u) => u.id == p.userId).firstOrNull;
                          return _ParticipantCard(
                            username: p.username,
                            profileImageUrl: knownUser?.profileImageUrl,
                            isFollowing: isFollowing,
                            isBlocked: isBlocked,
                            voteState: voteState,
                            onFollowTap: () =>
                                _toggleFollow(context, p.userId, isFollowing),
                            onAvoidTap: () =>
                                _toggleBlock(context, p.userId, isBlocked),
                            onUpvoteTap: () => _handleVote(p.userId, true),
                            onDownvoteTap: () => _handleVote(p.userId, false),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.shell,
                    (_) => false,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.textPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.md),
                      side: const BorderSide(color: AppColors.border, width: 1.5),
                    ),
                    textStyle: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Quit to Sessions'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ParticipantCard extends StatelessWidget {
  const _ParticipantCard({
    required this.username,
    required this.isFollowing,
    required this.isBlocked,
    required this.voteState,
    required this.onFollowTap,
    required this.onAvoidTap,
    required this.onUpvoteTap,
    required this.onDownvoteTap,
    this.profileImageUrl,
  });

  final String username;
  final String? profileImageUrl;
  final bool isFollowing;
  final bool isBlocked;
  final _VoteState voteState;
  final VoidCallback onFollowTap;
  final VoidCallback onAvoidTap;
  final VoidCallback onUpvoteTap;
  final VoidCallback onDownvoteTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          _Avatar(username: username, imageUrl: profileImageUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              username,
              style: t.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          _VoteButton(
            icon: Icons.thumb_up_rounded,
            active: voteState == _VoteState.upvoted,
            activeColor: const Color(0xFF22C55E),
            onTap: onUpvoteTap,
          ),
          const SizedBox(width: 6),
          _VoteButton(
            icon: Icons.thumb_down_rounded,
            active: voteState == _VoteState.downvoted,
            activeColor: AppColors.failure,
            onTap: onDownvoteTap,
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: onFollowTap,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor:
                    isFollowing ? Colors.transparent : AppColors.accent,
                foregroundColor:
                    isFollowing ? AppColors.textSecondary : AppColors.primaryBg,
                side: isFollowing
                    ? const BorderSide(color: Color(0x7F64748B), width: 1)
                    : BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(86, 36),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                textStyle: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Text(isFollowing ? 'Following' : 'Follow'),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: onAvoidTap,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor:
                    isBlocked ? AppColors.failure : Colors.transparent,
                foregroundColor:
                    isBlocked ? Colors.white : AppColors.failure,
                side: isBlocked
                    ? BorderSide.none
                    : const BorderSide(color: AppColors.failure, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(76, 36),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                textStyle: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Text(isBlocked ? 'Avoided' : 'Avoid'),
            ),
          ),
        ],
      ),
    );
  }
}

class _VoteButton extends StatelessWidget {
  const _VoteButton({
    required this.icon,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  final IconData icon;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: active ? activeColor.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? activeColor : AppColors.border,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 17,
          color: active ? activeColor : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.username, this.imageUrl});

  final String username;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final initial =
        username.trim().isNotEmpty ? username.trim()[0].toUpperCase() : '?';

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.inputFill,
        border: Border.all(color: AppColors.accent, width: 1.5),
        image: imageUrl != null && imageUrl!.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      alignment: Alignment.center,
      child: imageUrl == null || imageUrl!.isEmpty
          ? Text(
              initial,
              style: GoogleFonts.montserrat(
                color: AppColors.accent,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            )
          : null,
    );
  }
}
