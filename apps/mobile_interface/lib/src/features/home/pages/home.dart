import 'package:flutter/material.dart';
import '../../../common/widgets/bottom_nav_bar.dart';
import '../../../common/widgets/colored_button.dart';
import '../../../app/routes.dart';
import '../widgets/home_top_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed(AppRoutes.social);
        break;
      case 1:
        break; // already here
      case 2:
        Navigator.of(context).pushReplacementNamed(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HomeTopBar(name: "Minh", imagePath: 'assets/images/profile.png'),
            Spacer(),
            ColoredButton(
              title: 'Solo Practice',
              subtitle: 'Personalized AI drills',
              icon: Icons.headphones,
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.courses);
              },
              firstColor: 0xFF06B6D5,
              secondColor: 0xFF49DC7E,
              shadow: 0xFF06B6D5,
            ),
            const SizedBox(height: 24),
            ColoredButton(
              icon: Icons.group,
              title: 'Group Practice',
              subtitle: 'Join a live conversation group',
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.groupSessionSelect);
              },
              firstColor: 0xFF06B6D5,
              secondColor: 0xFF984ADD,
              shadow: 0xFF06B6D5,
            ),
            Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 1,
        onDestinationSelected: (i) => _onNavTap(context, i),
      ),
    );
  }
}