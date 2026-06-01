import 'package:flutter/material.dart';
import 'package:morsequest/features/profile_page/screens/profile_screen.dart';
import '../widgets/library_page_widget.dart';
import '../../main_page/widgets/main_page_widget.dart'; // Import MainHeader
import '../../../../shared/widgets/custom_bottom_nav.dart'; // Import Navbar
import '../../main_page/screens/main_screen.dart'; // Import untuk navigasi balik

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  // State untuk Toggle: true = Alfabet, false = Angka
  bool _isAlphabetView = true;

  // State untuk Navbar (Index 1 adalah "Belajar")
  int _currentNavIndex = 1;

  void _onNavbarTapped(int index) {
    if (index == _currentNavIndex)
      return; // Cegah reload jika tab yang sama diklik

    if (index == 0) {
      // Index 0 adalah tab "Main"
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => const MainScreen(),
          transitionDuration: Duration.zero,
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
      // Untuk tab lain (Peringkat, Toko, Profil)
      setState(() {
        _currentNavIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan data mana yang akan ditampilkan berdasarkan toggle
    final List<MorseData> currentData = _isAlphabetView
        ? alphabetMorse
        : numberMorse;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Column(
          children: [
            // Kamu bisa menggunakan MainHeader yang sudah ada
            const MainHeader(),
            const SizedBox(height: 20),

            const LibraryTitle(),
            const SizedBox(height: 30),

            CustomToggle(
              isAlphabet: _isAlphabetView,
              onChanged: (value) {
                setState(() {
                  _isAlphabetView = value;
                });
              },
            ),
            const SizedBox(height: 30),

            // Area Grid View untuk Karakter
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    // Jika alfabet 3 kolom, jika angka 2 kolom
                    crossAxisCount: _isAlphabetView ? 3 : 2,
                    // Rasio angka dibuat lebih lebar agar card tidak terlalu tinggi
                    childAspectRatio: _isAlphabetView ? 1.5 : 2.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: currentData.length,
                  itemBuilder: (context, index) {
                    return MorseCard(
                      data: currentData[index],
                      onTap: () {
                        // Logic membunyikan suara morse
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentNavIndex,
        onTap: _onNavbarTapped, // Fungsi navigasi yang sudah kita buat
      ),
    );
  }
}
