import 'package:flutter/material.dart';
import '../widgets/quit_group_session_back_button.dart';
import '../../../app/constants.dart';

class GroupSessionActiveLobbyPage extends StatefulWidget {
  const GroupSessionActiveLobbyPage({super.key});

  @override
  State<GroupSessionActiveLobbyPage> createState() =>
      _GroupSessionActiveLobbyPageState();
}

class _GroupSessionActiveLobbyPageState
    extends State<GroupSessionActiveLobbyPage> {
  final _lobbyCode = TextEditingController();

  @override
  void dispose() {
    _lobbyCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

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
                      const QuitGroupSessionBackButton(),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: RichText(
                            text: TextSpan(
                              style: t.textTheme.headlineMedium,
                              children: const [
                                TextSpan(text: '[TEMP PAGE]'),
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
                  const Spacer(),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}