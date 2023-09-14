import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toni_case_study/view/profile_page.dart';
import 'package:toni_case_study/view/search_page.dart';
import 'package:toni_case_study/view_model/change_screen.dart';

import '../view_model/notification_view_model.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = [
    const ProfilePage(),
    SearchPage(),
  ];
  final NotificationViewModel _notificationViewModel = NotificationViewModel();
  @override
  void initState() {
    super.initState();
    _notificationViewModel.initialize();
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = context.watch<ChangeScreens>().selectedIndex;
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Ara',
          ),
        ],
        onTap: (index) {
          context.read<ChangeScreens>().changeScreen(index);
        },
      ),
    );
  }
}
