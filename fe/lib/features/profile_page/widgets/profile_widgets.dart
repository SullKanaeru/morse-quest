import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:morsequest/shared/providers/user_provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$points',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 12,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.lightbulb,
                      color: Color(0xFFFFD500),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$hints',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
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

class ProfileInfoCard extends StatelessWidget {
  final String username;
  final String rank;
  final int points;
  final int hints;
  final String avatarUrl;
  final VoidCallback? onEditUsername;
  final VoidCallback? onEditAvatar;

  const ProfileInfoCard({
    super.key,
    required this.username,
    required this.rank,
    required this.points,
    required this.hints,
    required this.avatarUrl,
    this.onEditUsername,
    this.onEditAvatar,
  });

  ImageProvider? _getAvatarProvider() {
    if (avatarUrl.isEmpty) return null;
    if (avatarUrl.startsWith('http')) {
      return NetworkImage(avatarUrl);
    }
    return AssetImage(avatarUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0277BD),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0277BD).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomRight,
            children: [
              GestureDetector(
                onTap: onEditAvatar,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _getAvatarProvider(),
                    child: avatarUrl.isEmpty
                        ? Icon(Icons.person, size: 50, color: Colors.grey.shade500)
                        : null,
                  ),
                ),
              ),
              if (onEditAvatar != null)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onEditAvatar,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF0277BD),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Color(0xFF0277BD),
                      ),
                    ),
                  ),
                ),
              // Positioned(
              //   bottom: -5,
              //   left:
              //       -10, // move rank badge to the left so it doesn't overlap with camera
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 10,
              //       vertical: 4,
              //     ),
              //     decoration: BoxDecoration(
              //       color: const Color(0xFFFFD500),
              //       borderRadius: BorderRadius.circular(12),
              //       border: Border.all(color: Colors.white, width: 2),
              //     ),
              // child: const Text(
              //   'LV. 5',
              //   style: TextStyle(
              //     fontSize: 10,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.black87,
              //   ),
              // ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                username,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (onEditUsername != null) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onEditUsername,
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            rank,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatBadge(Icons.star, Colors.amber, points.toString()),
              const SizedBox(width: 16),
              _buildStatBadge(
                Icons.lightbulb,
                const Color(0xFFFFD500),
                hints.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, Color iconColor, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade200, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF005A9C), size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEF5350),
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(color: Colors.red.shade800, width: 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout, size: 20),
            SizedBox(width: 8),
            Text(
              'Keluar / Logout',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
