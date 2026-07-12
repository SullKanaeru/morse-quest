import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:morsequest/shared/providers/user_provider.dart';
import 'package:morsequest/shared/utils/constants.dart';

class MainHeader extends StatelessWidget {
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/images/morse-quest-logo.png', width: 28, height: 28),
              const SizedBox(width: 8),
              const Text(
                'MorseQuest',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF005A9C),
                ),
              ),
            ],
          ),
          Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              final user = userProvider.user;
              final points = user?.points ?? 0;
              final hints = user?.hints ?? 0;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$points',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 1, height: 12, color: Colors.grey.shade400),
                    const SizedBox(width: 8),
                    const Icon(Icons.lightbulb, color: Color(0xFFFFD500), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$hints',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MainTitle extends StatelessWidget {
  const MainTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Pilih Level',
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
            'Seberapa menantang\npetualanganmu hari ini?',
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
}

class LevelCarousel extends StatelessWidget {
  final PageController pageController;
  final List<LevelData> levels;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const LevelCarousel({
    super.key,
    required this.pageController,
    required this.levels,
    required this.onPageChanged,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildArrowButton(Icons.arrow_back_ios_new, onPrev),
          const SizedBox(width: 15),
          SizedBox(
            width: 220,
            height: 240,
            child: PageView.builder(
              controller: pageController,
              onPageChanged: onPageChanged,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final realIndex = index % levels.length;
                return Center(child: _LevelCard(data: levels[realIndex]));
              },
            ),
          ),
          const SizedBox(width: 15),
          _buildArrowButton(Icons.arrow_forward_ios, onNext),
        ],
      ),
    );
  }

  Widget _buildArrowButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 18),
        color: Colors.black87,
        onPressed: onTap,
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final LevelData data;

  const _LevelCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD500),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(
                  data.starCount,
                  (index) =>
                      const Icon(Icons.star, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 4),
                Text(
                  data.starCount.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class PaginationDots extends StatelessWidget {
  final int totalDots;
  final int activeIndex;

  const PaginationDots({
    super.key,
    this.totalDots = 3,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDots, (index) {
        bool isActive = index == activeIndex;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFF005A9C) : Colors.transparent,
            border: Border.all(
              color: isActive ? const Color(0xFF005A9C) : Colors.grey.shade400,
              width: 1.5,
            ),
          ),
        );
      }),
    );
  }
}

class PlayButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PlayButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD500),
          foregroundColor: Colors.black87,
          elevation: 4,
          shadowColor: const Color(0xFFFFD500).withOpacity(0.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'MAIN SEKARANG',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.play_arrow, size: 24),
          ],
        ),
      ),
    );
  }
}
