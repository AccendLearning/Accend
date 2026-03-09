import 'package:flutter/material.dart';
import '../features/onboarding/pages/onboarding_user_info_page.dart' as onboard_user_info;
import '../features/group_session/pages/group_session_select_page.dart' as group_session_select;
import '../features/group_session/pages/group_session_private_select_page.dart' as group_session_private_select;
import '../features/group_session/pages/group_session_private_create_page.dart' as group_session_private_create;
import '../features/group_session/pages/group_session_private_join_page.dart' as group_session_private_join;

class AppRoutes {
  static const onboardingUserInfo = '/onboarding/user-info';
  static const groupSessionSelect = '/group_session/session-select';
  static const groupSessionPrivateSelect = '/group_session/private-select';
  static const groupSessionPrivateCreate = '/group_session/private-create';
  static const groupSessionPrivateJoin = '/group_session/private-join';

  // Keep these for later if you want:
  static const login = '/login';
  static const onboardingIntro = '/onboarding/intro';
  static const courses = '/courses';

  static Map<String, WidgetBuilder> get table => {
        onboardingUserInfo: (_) => const onboard_user_info.OnboardingUserInfoPage(),
        // LEO TODO 
        groupSessionSelect: (_) => const group_session_select.GroupSessionSelectPage(),
        groupSessionPrivateSelect: (_) => const group_session_private_select.GroupSessionPrivateSelectPage(),
        groupSessionPrivateCreate: (_) => const group_session_private_create.GroupSessionPrivateCreatePage(),
        groupSessionPrivateJoin: (_) => const group_session_private_join.GroupSessionPrivateJoinPage(),
     
      };
}