import 'package:flutter/material.dart';
import 'package:morsequest/features/game_page/screens/game_screen.dart';
import 'package:morsequest/features/library_page/screens/library_screen.dart';
import 'package:morsequest/features/profile_page/screens/profile_screen.dart';
import '../widgets/main_page_widget.dart';
import '../../../../shared/widgets/custom_bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentNavIndex = 1;
  int _currentLevelIndex = 0;

  // Controller untuk animasi Carousel
  late PageController _pageController;

  // Data Level sesuai gambar desain
  final List<LevelData> _levels = [
    LevelData(
      starCount: 1,
      title: "Gampang",
      description: "Praktekkan huruf\ndasar",
    ),
    LevelData(
      starCount: 2,
      title: "Sedang",
      description: "Pelajari kata-kata\numum",
    ),
    LevelData(
      starCount: 3,
      title: "Sulit",
      description: "Kosa kata yang\nlebih rumit",
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan halaman awal 0 (Gampang)
    _pageController = PageController(initialPage: 3000);
  }

  @override
  void dispose() {
    _pageController.dispose(); // Wajib di-dispose agar tidak memory leak
    super.dispose();
  }

  // Fungsi geser ke kiri (Prev)
  void _goToPrevLevel() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 350), // Durasi transisi
      curve: Curves.easeInOutCubic, // Efek transisi smooth
    );
  }

  // Fungsi geser ke kanan (Next)
  void _goToNextLevel() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const MainHeader(),
                const SizedBox(height: 40),
                const MainTitle(),
                const SizedBox(height: 20),

                // Gunakan Carousel yang baru
                LevelCarousel(
                  pageController: _pageController,
                  levels: _levels,
                  onPageChanged: (index) {
                    setState(() {
                      _currentLevelIndex = index % _levels.length;
                    });
                  },
                  onPrev: _goToPrevLevel,
                  onNext: _goToNextLevel,
                ),

                const SizedBox(height: 10),
                PaginationDots(
                  activeIndex: _currentLevelIndex,
                  totalDots: _levels.length,
                ),
                const SizedBox(height: 40),
                PlayButton(
                  onPressed: () {
                    // Navigasi ke GameScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentNavIndex, // Akan otomatis menyorot index 0 (Main)
        onTap: (index) {
          if (index == _currentNavIndex)
            return; // Cegah reload jika tab yang sama diklik

          if (index == 1) {
            // Index 1 adalah tab "Belajar"
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, anim1, anim2) => const LibraryScreen(),
                transitionDuration:
                    Duration.zero, // Transisi instan tanpa animasi slide
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, anim1, anim2) => const ProfileScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else {
            // Untuk tab lain (Peringkat, Toko, Profil) jika belum ada halamannya
            setState(() {
              _currentNavIndex = index;
            });
          }
        },
      ),
    );
  }
}
