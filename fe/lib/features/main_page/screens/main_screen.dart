import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:morsequest/features/game_page/screens/game_screen.dart';
import 'package:morsequest/features/library_page/screens/library_screen.dart';
import 'package:morsequest/features/profile_page/screens/profile_screen.dart';
import 'package:morsequest/features/shop_page/shop_screen.dart';
import 'package:morsequest/features/auth_page/screens/login_screen.dart';
import '../widgets/main_widgets.dart';
import '../../../../shared/widgets/custom_bottom_nav.dart';
import '../../../../shared/utils/constants.dart';
import '../../../../shared/utils/navigation_helper.dart';
import '../../../../shared/providers/sound_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentNavIndex = 0;
  int _currentLevelIndex = 0;
  late PageController _pageController;

  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final soundProvider = Provider.of<SoundProvider>(context, listen: false);
      soundProvider.playBackgroundMusic();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPrevLevel() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
  }

  void _goToNextLevel() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
  }

  void _handlePlayButtonPressed() {
    if (!_isLoggedIn) {
      _showLoginRequiredDialog();
    } else {
      final selectedLevel = AppConstants.levels[_currentLevelIndex];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(levelData: selectedLevel),
        ),
      );
    }
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD500).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFFFFD500),
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '🎯 Login Dulu Yuk!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Petualangan Morse menantimu!\nLogin sekarang untuk mulai bermain,\nsimpan progress, dan kumpulkan bintang!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: Icons.star,
                      label: 'Bintang',
                      color: const Color(0xFFFFD500),
                    ),
                    _buildStatItem(
                      icon: Icons.lightbulb,
                      label: 'Hint',
                      color: const Color(0xFFFFD500),
                    ),
                    _buildStatItem(
                      icon: Icons.emoji_events,
                      label: 'Peringkat',
                      color: const Color(0xFFFFD500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text(
                        'Nanti Saja',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD500),
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'LOGIN SEKARANG',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Column(
          children: [
            const MainHeader(),
            const SizedBox(height: 40),
            const MainTitle(),
            const SizedBox(height: 20),
            LevelCarousel(
              pageController: _pageController,
              levels: AppConstants.levels,
              onPageChanged: (index) {
                setState(() {
                  _currentLevelIndex = index % AppConstants.levels.length;
                });
              },
              onPrev: _goToPrevLevel,
              onNext: _goToNextLevel,
            ),
            const SizedBox(height: 10),
            PaginationDots(
              activeIndex: _currentLevelIndex,
              totalDots: AppConstants.levels.length,
            ),
            const SizedBox(height: 40),
            PlayButton(onPressed: _handlePlayButtonPressed),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentNavIndex,
        onTap: (index) =>
            NavigationHelper.onNavTapped(context, index, _currentNavIndex),
      ),
    );
  }
}
