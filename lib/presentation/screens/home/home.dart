
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shagf/presentation/screens/notification/notifications_screen.dart';
import 'package:shagf/presentation/screens/profile/settings.dart';

import 'home_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required User user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 1; // Home page as default

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    // نحفظ الصفحات مرة واحدة بس
    pages = [ NotificationScreen(notifications: [], onClearAll: () {  },), const HomePage(), SettingsPage()];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xffF2F0D9),

      // ----- المحتوى -----
      body: IndexedStack(index: currentIndex, children: pages),

      // ----- الناف بار -----
      bottomNavigationBar: CircleNavBar(
        activeIndex: currentIndex,
        activeIcons: const [
          Icon(Icons.notifications_active, color: Color(0xffF2F0D9)),
          Icon(Icons.home, color: Color(0xffF2F0D9)),
          Icon(Icons.settings, color: Color(0xffF2F0D9)),
        ],
        inactiveIcons: const [
          Text("Notification", style: TextStyle(color: Color(0xff1D4036))),
          Text("Home", style: TextStyle(color: Color(0xff1D4036))),
          Text("Settings", style: TextStyle(color: Color(0xff1D4036))),
        ],
        color: theme.bottomNavigationBarTheme.backgroundColor ?? Colors.white,
        circleColor: const Color(0xff1D4036),
        height: 60,
        circleWidth: 50,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
        padding: EdgeInsets.zero,
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }
}
