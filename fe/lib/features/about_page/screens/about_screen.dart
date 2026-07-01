import 'package:flutter/material.dart';
import '../widgets/about_widgets.dart';
import '../../../../shared/widgets/custom_bottom_nav.dart';
import '../../../../shared/utils/navigation_helper.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  int _currentNavIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Column(
          children: [
            const AboutHeader(),
            Divider(color: Colors.grey.shade300, thickness: 1),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const SectionTitle(icon: Icons.stars, title: 'Misi Kami'),
                    const SizedBox(height: 12),
                    const MissionCard(),
                    const SizedBox(height: 30),
                    const SectionTitle(
                      icon: Icons.people_outline,
                      title: 'Kenalan dengan Developer',
                    ),
                    const SizedBox(height: 12),
                    DeveloperCard(
                      name: 'Muhammad Hanif Karomi',
                      role: 'Frontend Developer',
                      description:
                          'Mahasiswa Informatika UBHINUS semester 6 yang sangat suka coding dan mengajar anak-anak. Sebagai Frontend Developer, Hanif bertanggung jawab atas tampilan dan pengalaman pengguna dalam game ini.',
                      imagePath: 'assets/images/hanif.jpeg',
                      linkedInUrl:
                          'https://www.linkedin.com/in/hanif-karomi-7b661b32b',
                      instagramUrl: 'https://www.instagram.com/hanif.krm',
                    ),
                    const SizedBox(height: 8),
                    DeveloperCard(
                      name: 'Zulhan Arif Fasya Hidayat',
                      role: 'Backend Developer',
                      description:
                          'Mahasiswa Informatika UBHINUS semester 6 yang handal di balik layar MorseQuest. Sebagai Backend Developer, Zulhan memastikan semua data dan sistem berjalan dengan lancar.',
                      imagePath: 'assets/images/zulhan.jpeg',
                      linkedInUrl:
                          'https://www.linkedin.com/in/zulhanariffasyahidayat',
                      instagramUrl: 'https://www.instagram.com/zulhan.arif_',
                    ),
                    const SizedBox(height: 30),
                    const SectionTitle(icon: Icons.domain, title: 'Kampus'),
                    const SizedBox(height: 12),
                    const UbhinusCard(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
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
