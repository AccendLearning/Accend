import 'package:flutter/material.dart';
import '../../../common/widgets/bottom_nav_bar.dart';
import '../../../common/widgets/colored_button.dart';
import '../../../app/routes.dart';
import '../../../features/home/widgets/home_introduction.dart';

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
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GoalCard(
              title: "Business English",
              //subtitle: "Today's Goal",
              currentMinutes: 8,
              totalMinutes: 10,
              streak: 124,
              progress: 0.8,
            ),
            Spacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '  Practice Modes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
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
