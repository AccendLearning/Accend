import 'package:flutter/material.dart';
import '../../../common/widgets/bottom_nav_bar.dart';
import '../../../common/widgets/colored_button.dart';
import '../../../app/routes.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_top_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomeTopBar(
                name: _controller.displayName,
                imagePath: 'assets/images/profile.png',
              ),
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
      ),
    );
  }
}