import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/constants.dart';
import '../controllers/group_session_controller.dart';
import '../../../common/widgets/bottom_nav_bar.dart' as bot_nav_bar;

class GroupSessionPrivateJoinPage extends StatefulWidget {
  const GroupSessionPrivateJoinPage({super.key});

  @override
  State<GroupSessionPrivateJoinPage> createState() => _GroupSessionPrivateJoinPageState();
}

class _GroupSessionPrivateJoinPageState extends State<GroupSessionPrivateJoinPage> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupSessionController>().loadLobby();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<GroupSessionController>();
    final t = Theme.of(context);

    String lobbyCode = 'No lobby found';
    for (final lobby in ctrl.privateLobby) {
      if (lobby.username.toLowerCase() == 'test5') {
        lobbyCode = lobby.lobbyId;
        break;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),

                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top:8),
                          child: RichText(
                            text: TextSpan(
                              style: t.textTheme.headlineMedium,
                              children: [
                                const TextSpan(text: 'Join Lobby'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Divider(
                    color: AppColors.border,
                    thickness: 5,
                  ),

                  Spacer(),
                  // const SizedBox(height: 30),

                  if (ctrl.isLoading)
                    const CircularProgressIndicator()
                  else if (ctrl.error != null)
                    Text(
                      'Failed to load lobbies: ${ctrl.error}',
                      textAlign: TextAlign.center,
                      style: t.textTheme.bodyMedium,
                    )
                  else
                    RichText(
                      text: TextSpan(
                        style: t.textTheme.headlineMedium,
                        children: [
                          const TextSpan(text: 'Lobby Code: '),
                          TextSpan(
                            text: lobbyCode,
                            style: t.textTheme.headlineMedium?.copyWith(color: AppColors.accent),
                          ),
                        ],
                      ),
                    ),

                  Spacer(),

                  bot_nav_bar.BottomNavBar(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (index) => setState(() => _selectedIndex = index),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}