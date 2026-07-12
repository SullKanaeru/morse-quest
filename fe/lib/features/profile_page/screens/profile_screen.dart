import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:morsequest/features/about_page/screens/about_screen.dart';
import 'package:morsequest/features/auth_page/screens/login_screen.dart';
import '../widgets/profile_widgets.dart';
import '../../../../shared/widgets/custom_bottom_nav.dart';
import '../../../../shared/utils/navigation_helper.dart';
import '../../../../shared/providers/sound_provider.dart';
import '../../../../shared/providers/user_provider.dart';
import 'package:morsequest/data/storage/token_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _currentNavIndex = 3;

  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final soundProvider = Provider.of<SoundProvider>(context, listen: false);
      soundProvider.resumeBackgroundMusic();
    });
  }

  Future<void> _checkLoginStatus() async {
    final token = await TokenStorage.getToken();
    if (mounted) {
      setState(() {
        _isLoggedIn = token != null;
      });
    }
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
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final user = userProvider.user;
        if (user == null) return const SizedBox.shrink();

        return ProfileInfoCard(
          username: user.username,
          rank: 'Pemula', // Rank logic can be added later based on points
          points: user.points,
          hints: user.hints,
          avatarUrl: user.avatarUrl,
          onEditUsername: () => _showEditUsernameDialog(context, userProvider),
          onEditAvatar: () => _pickAndUploadAvatar(context, userProvider),
        );
      },
    );
  }

  Future<void> _pickAndUploadAvatar(BuildContext context, UserProvider userProvider) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mengunggah avatar...')),
      );

      final success = await userProvider.uploadAvatar(pickedFile.path);

      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avatar berhasil diperbarui')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui avatar')),
        );
      }
    }
  }

  void _showEditUsernameDialog(BuildContext context, UserProvider userProvider) {
    final user = userProvider.user;
    if (user == null) return;

    final TextEditingController usernameController =
        TextEditingController(text: user.username);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Edit Username'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (usernameController.text.trim().isEmpty) return;
                    final success = await userProvider.updateProfile(
                      usernameController.text.trim(),
                      user.avatarUrl, // Keep existing avatar
                    );
                    if (mounted) {
                      Navigator.pop(context);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Username berhasil diperbarui')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gagal memperbarui username')),
                        );
                      }
                    }
                  },
                  child: userProvider.isLoading 
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
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
            activeThumbColor: Colors.white,
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
                onPressed: () async {
                  await TokenStorage.removeToken();
                  if (mounted) {
                    Provider.of<UserProvider>(context, listen: false).logout();
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
                  }
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
