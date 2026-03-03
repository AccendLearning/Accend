import 'package:flutter/material.dart';

/// Central route names + route table.
/// We’ll add feature pages here as you implement them.
class AppRoutes {
  // Auth / onboarding
  static const register = '/register';
  static const login = '/login';
  static const onboardingIntro = '/onboarding/intro';

  // Later:
  static const courses = '/courses';

  static Map<String, WidgetBuilder> get table => {
        // register: (_) => const RegisterPage(),
        // login: (_) => const LoginPage(),
        // onboardingIntro: (_) => const OnboardingIntroPage(),
        // courses: (_) => const CoursesListPage(),
      };
}