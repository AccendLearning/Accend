import 'package:flutter/material.dart';
import '../../../common/widgets/bottom_nav_bar.dart';
import '../../../app/routes.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        break; // already here
      case 1:
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Social")),
      body: const Center(
        child: Text("This is the social page!"),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 0,
        onDestinationSelected: (i) => _onNavTap(context, i),
      ),
    );
  }
}