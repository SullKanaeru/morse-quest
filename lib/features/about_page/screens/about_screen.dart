import 'package:flutter/material.dart';
import '../widgets/about_widget.dart';
import '../../../../shared/widgets/custom_bottom_nav.dart';
import '../../main_page/screens/main_screen.dart';
import '../../library_page/screens/library_screen.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  // Tetap index 4 karena masih bagian dari menu Profil
  int _currentNavIndex = 4;

  void _onNavbarTapped(int index) {
    if (index == _currentNavIndex) return;

    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => const MainScreen(),
          transitionDuration: Duration.zero,
        ),
        (route) => false, // Membersihkan stack agar tidak menumpuk
      );
    } else if (index == 1) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => const LibraryScreen(),
          transitionDuration: Duration.zero,
        ),
        (route) => false,
      );
    } else {
      // Jika tab Profil diklik ulang, kembali ke menu Profil utama
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Column(
          children: [
            const AboutHeader(),
            Divider(color: Colors.grey.shade300, thickness: 1),

            // Area yang bisa di-scroll
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: const [
                    SizedBox(height: 16),

                    // SECTION 1: Misi Kami
                    SectionTitle(icon: Icons.stars, title: 'Misi Kami'),
                    SizedBox(height: 12),
                    MissionCard(),
                    SizedBox(height: 30),

                    // SECTION 2: Kenalan dengan Developer
                    SectionTitle(
                      icon: Icons.video_label_outlined,
                      title: 'Kenalan dengan Developer',
                    ),
                    SizedBox(height: 12),
                    DeveloperCard(
                      name: 'Alex',
                      description:
                          'Alex adalah kreator MorseQuest yang sangat suka coding dan mengajar anak-anak. Melalui game ini, Alex ingin membagikan keseruan berkomunikasi dengan kode rahasia!',
                    ),
                    DeveloperCard(
                      name: 'Alex', // Sesuai dengan desain (tampak duplikat)
                      description:
                          'Alex adalah kreator MorseQuest yang sangat suka coding dan mengajar anak-anak. Melalui game ini, Alex ingin membagikan keseruan berkomunikasi dengan kode rahasia!',
                    ),
                    SizedBox(height: 30),

                    // SECTION 3: UBHINUS
                    SectionTitle(icon: Icons.domain, title: 'UBHINUS'),
                    SizedBox(height: 12),
                    DeveloperCard(
                      name: 'Alex',
                      description:
                          'Alex adalah kreator MorseQuest yang sangat suka coding dan mengajar anak-anak. Melalui game ini, Alex ingin membagikan keseruan berkomunikasi dengan kode rahasia!',
                    ),

                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Tambahkan Navbar agar konsisten dengan desain
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentNavIndex,
        onTap: _onNavbarTapped,
      ),
    );
  }
}
