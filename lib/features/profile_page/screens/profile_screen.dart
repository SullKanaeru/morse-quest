import 'package:flutter/material.dart';
import 'package:morsequest/features/about_page/screens/about_screen.dart';
import 'package:morsequest/features/library_page/screens/library_screen.dart';
import '../widgets/profile_widget.dart';
import '../../main_page/screens/main_screen.dart';
import '../../../../shared/widgets/custom_bottom_nav.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Index untuk Navbar, halaman profil ada di index 4
  int _currentNavIndex = 4;

  // State untuk Toggle Pengaturan Suara
  bool _isSoundOn = true;

  // Fungsi navigasi yang sudah diseragamkan
  void _onNavbarTapped(int index) {
    if (index == _currentNavIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => const MainScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => const LibraryScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else {
      setState(() {
        _currentNavIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: SingleChildScrollView(
          // Agar tidak overflow di layar kecil
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const ProfileHeader(),
              const SizedBox(height: 16),

              const ProfileInfoCard(),
              const SizedBox(height: 24),

              // Menu 1: Ubah Kata Sandi
              ProfileMenuItem(
                icon: Icons.lock_reset_outlined,
                title: 'Ubah Kata Sandi',
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                onTap: () {
                  // Aksi ganti password
                },
              ),

              // Menu 2: Pengaturan Suara (dengan Switch)
              ProfileMenuItem(
                icon: Icons.volume_up_outlined,
                title: 'Pengaturan Suara',
                trailing: Switch(
                  value: _isSoundOn,
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF007BFF), // Biru
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey.shade300,
                  onChanged: (value) {
                    setState(() {
                      _isSoundOn = value;
                    });
                  },
                ),
              ),

              // Menu 3: Tentang Game
              ProfileMenuItem(
                icon: Icons.info_outline,
                title: 'Tentang Game',
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                onTap: () {
                  // Navigasi ke Halaman About
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Tombol Logout
              LogoutButton(
                onTap: () {
                  // Aksi logout
                  print("Logout ditekan");
                },
              ),

              const SizedBox(height: 30), // Spasi ekstra di bawah
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentNavIndex,
        onTap: _onNavbarTapped,
      ),
    );
  }
}
