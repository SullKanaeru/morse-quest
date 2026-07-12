import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:morsequest/shared/utils/constants.dart';
import 'package:morsequest/shared/widgets/custom_bottom_nav.dart';
import 'package:morsequest/shared/utils/navigation_helper.dart';
import 'package:morsequest/shared/providers/user_provider.dart';
import 'package:morsequest/features/main_page/widgets/main_widgets.dart';
import 'package:morsequest/features/shop_page/widgets/shop_widgets.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final int _currentNavIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final user = userProvider.user;
            final currentPoints = user?.points ?? 0;

            return Column(
              children: [
                const MainHeader(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildSectionTitle(),
                        const SizedBox(height: 24),
                        HintPackageCard(
                          amount: 1,
                          price: AppConstants.hintPrice1,
                          isBestDeal: false,
                          currentPoints: currentPoints,
                        ),
                        const SizedBox(height: 16),
                        HintPackageCard(
                          amount: 3,
                          price: AppConstants.hintPrice3,
                          isBestDeal: false,
                          currentPoints: currentPoints,
                        ),
                        const SizedBox(height: 16),
                        HintPackageCard(
                          amount: 5,
                          price: AppConstants.hintPrice5,
                          isBestDeal: true,
                          currentPoints: currentPoints,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSectionTitle() {
    return Column(
      children: [
        const Text(
          'Beli Hint',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF005A9C),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Gunakan hint untuk membantu saat mengerjakan soal',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildBottomNav() {
    return CustomBottomNav(
      currentIndex: _currentNavIndex,
      onTap: (index) =>
          NavigationHelper.onNavTapped(context, index, _currentNavIndex),
    );
  }
}
