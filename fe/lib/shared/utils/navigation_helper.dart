import 'package:flutter/material.dart';
import 'package:morsequest/features/main_page/screens/main_screen.dart';
import 'package:morsequest/features/library_page/screens/library_screen.dart';
import 'package:morsequest/features/profile_page/screens/profile_screen.dart';
import 'package:morsequest/features/shop_page/shop_screen.dart';

class NavigationHelper {
  static void goToMain(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  static void goToLibrary(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LibraryScreen()),
      (route) => false,
    );
  }

  static void goToShop(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ShopScreen()),
    );
  }

  static void goToProfile(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
      (route) => false,
    );
  }

  static void onNavTapped(BuildContext context, int index, int currentIndex) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        goToMain(context);
        break;
      case 1:
        goToLibrary(context);
        break;
      case 2:
        goToShop(context);
        break;
      case 3:
        goToProfile(context);
        break;
    }
  }
}
