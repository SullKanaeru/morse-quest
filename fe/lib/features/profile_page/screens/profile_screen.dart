import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:morsequest/features/about_page/screens/about_screen.dart';
import 'package:morsequest/features/library_page/screens/library_screen.dart';
import 'package:morsequest/features/shop_page/shop_screen.dart';
import 'package:morsequest/features/auth_page/screens/login_screen.dart';
import '../widgets/profile_widgets.dart';
import '../../main_page/screens/main_screen.dart';
import '../../../../shared/widgets/custom_bottom_nav.dart';
import '../../../../shared/utils/navigation_helper.dart';
import '../../../../shared/providers/sound_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentNavIndex = 3;

  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final soundProvider = Provider.of<SoundProvider>(context, listen: false);
      soundProvider.resumeBackgroundMusic();
    });
  }

  @override
  Widget build(BuildContext context) {
    final soundProvider = Provider.of<SoundProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const ProfileHeader(),
              const SizedBox(height: 16),

              if (!_isLoggedIn) _buildLoginPrompt(),

              if (_isLoggedIn) _buildProfileCard(),

              const SizedBox(height: 24),
              _buildMenuItems(soundProvider),
              const SizedBox(height: 16),
              _buildLogoutButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentNavIndex,
        onTap: (index) =>
            NavigationHelper.onNavTapped(context, index, _currentNavIndex),
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.lock_outline, size: 48, color: Color(0xFF005A9C)),
          const SizedBox(height: 12),
          const Text(
            'Login untuk menyimpan\nkemajuanmu!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Simpan progress, dapatkan hint,\ndan ikuti peringkat!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    final Map<String, dynamic> user = {
      'username': 'SiswaCerdas1',
      'rank': 'Sersan Morse',
      'points': 2500,
      'hints': 3,
      'totalStars': 15,
    };

    return ProfileInfoCard(
      username: user['username'] as String,
      rank: user['rank'] as String,
      points: user['points'] as int,
      hints: user['hints'] as int,
    );
  }

  Widget _buildMenuItems(SoundProvider soundProvider) {
    return Column(
      children: [
        ProfileMenuItem(
          icon: Icons.lock_reset_outlined,
          title: 'Ubah Kata Sandi',
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
          onTap: () {
            if (!_isLoggedIn) {
              _showLoginRequiredDialog();
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fitur ubah password segera hadir!'),
              ),
            );
          },
        ),
        ProfileMenuItem(
          icon: Icons.volume_up_outlined,
          title: 'Pengaturan Suara',
          trailing: Switch(
            value: soundProvider.isSoundOn,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF007BFF),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
            onChanged: (value) {
              soundProvider.toggleSound();
              if (!value) {
                soundProvider.stopBackgroundMusic();
              } else {
                soundProvider.playBackgroundMusic();
              }
            },
          ),
        ),
        ProfileMenuItem(
          icon: Icons.info_outline,
          title: 'Tentang Game',
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    if (!_isLoggedIn) return const SizedBox.shrink();

    return LogoutButton(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Konfirmasi Logout'),
            content: const Text('Apakah kamu yakin ingin keluar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLoggedIn = false;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Berhasil logout!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Login Diperlukan'),
        content: const Text(
          'Silakan login terlebih dahulu untuk menggunakan fitur ini.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD500),
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
