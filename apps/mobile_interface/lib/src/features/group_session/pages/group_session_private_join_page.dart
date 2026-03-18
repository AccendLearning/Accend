import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/constants.dart';
import '../../../common/widgets/primary_button.dart';
import '../controllers/group_session_controller.dart';
import '../widgets/widget1.dart';
import '../../../app/routes.dart' as routes;
import '../widgets/private_button.dart' as private_button;
import'package:mobile_interface/src/common/services/auth_service.dart';
import '../widgets/private_code_display.dart';

class GroupSessionPrivateJoinPage extends StatefulWidget {
  const GroupSessionPrivateJoinPage({super.key});

  @override
  State<GroupSessionPrivateJoinPage> createState() => _GroupSessionSelectPageState();
}



class _GroupSessionSelectPageState extends State<GroupSessionPrivateJoinPage> {
 

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<GroupSessionController>();

      final userId = context.read<AuthService>().currentUser?.id ?? 'Unknown';
      final username = context.read<AuthService>().currentUser?.email ?? 'Unknown';
      
      ctrl.joinLobby(userId, 972910, username);
    });
  }



  @override
  Widget build(BuildContext context) {

    // final ctrl = context.watch<GroupSessionController>();
    final t = Theme.of(context);

    final ctrl = context.watch<GroupSessionController>();
    
    final String lobbyCode;
    if (ctrl.isLoading) {
      lobbyCode = 'Loading...';
    } else if (ctrl.joinPrivateLobby?.lobbyId != null) {
      lobbyCode = (ctrl.joinPrivateLobby?.lobbyId).toString();
    } else if (ctrl.error != null) {
      lobbyCode = 'Error';
    } else {
      lobbyCode = '------';
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
                        onPressed: () {
                          Navigator.pushNamed(context, routes.AppRoutes.groupSessionPrivateSelect);

                          ctrl.leaveLobby();
                        }, 
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

                  PrivateCodeDisplay(
                    code: lobbyCode,
                  ),

                  Spacer(),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}