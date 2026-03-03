import 'package:flutter/material.dart';
import 'constants.dart';
import 'routes.dart';
import 'theme.dart';

/// Root app widget.
/// Owns MaterialApp + theme + routes.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),

      // Until your first page exists, use a placeholder home.
      // Once RegisterPage exists, set:
      // initialRoute: AppRoutes.register,
      // routes: AppRoutes.table,
      home: const _BootstrapPlaceholder(),
    );
  }
}

/// Temporary placeholder so the app runs before feature pages exist.
/// Delete once you wire initialRoute + routes.
class _BootstrapPlaceholder extends StatelessWidget {
  const _BootstrapPlaceholder();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Accend', style: t.textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'App bootstrapped.\nNext: create RegisterPage and wire routes.',
                textAlign: TextAlign.center,
                style: t.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}