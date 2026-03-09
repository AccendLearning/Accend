import 'package:flutter/material.dart';
import '../../../app/constants.dart';
import '../../../common/widgets/primary_button.dart';
import '../controllers/group_session_lobby_code_controller.dart';
import '../widgets/widget1.dart';

class GroupSessionPrivateSelectPage extends StatefulWidget {
  const GroupSessionPrivateSelectPage({super.key});

  @override
  State<GroupSessionPrivateSelectPage> createState() => _GroupSessionSelectPageState();
}

class _GroupSessionSelectPageState extends State<GroupSessionPrivateSelectPage> {
  final _c = OnboardingUserInfoController();

  final _lobbyCode = TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _lobbyCode.dispose();
    super.dispose();
  }

  void _validate() {
    _c.validate(
      lobbyCode: _lobbyCode.text
    );
    setState(() {});
  }

  Future<void> _onContinue() async {
    _validate();
    if (!_c.isValid) return;

    setState(() => _submitting = true);
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Continue (backend hookup next)')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
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
                                const TextSpan(text: 'Group Session '),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Divider(
                    color: AppColors.border,
                    thickness: 5,
                    indent: 0,
                  ),

                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Begin your journey to fluency', style: t.textTheme.bodyMedium),
                  ),

                  const SizedBox(height: 18),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [

                          OnboardingLabeledField(
                            label: 'Lobby Code',
                            rightLabel: _c.lobbyCodeErr != null ? 'Cannot be empty' : null,
                            rightLabelColor: AppColors.failure,
                            child: TextField(
                              controller: _lobbyCode,
                              onChanged: (_) {
                                if (_c.lobbyCodeErr != null) _validate();
                              },
                              decoration: InputDecoration(
                                hintText: '@OHHOHOHOHOHOHOH',
                                errorText: _c.lobbyCodeErr,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),


                          const SizedBox(height: 18),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have an account? ', style: t.textTheme.bodyMedium),
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Login page coming next')),
                                  );
                                },
                                child: Text(
                                  'Log in',
                                  style: t.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          PrimaryButton(
                            text: 'Continue',
                            loading: _submitting,
                            onPressed: _onContinue,
                          ),
                        ],
                      ),
                    ),
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