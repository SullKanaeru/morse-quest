import 'package:flutter/material.dart';

// --- 1. HEADER (KEMBALI & JUDUL) ---
class AboutHeader extends StatelessWidget {
  const AboutHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF005A9C),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Tentang Game',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF005A9C),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 2. JUDUL SECTION ---
class SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionTitle({Key? key, required this.icon, required this.title})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF005A9C), size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 3. CARD MISI KAMI ---
class MissionCard extends StatelessWidget {
  const MissionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade400, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Watermark Compass
          Positioned(
            top: -10,
            right: -10,
            child: Icon(
              Icons.explore,
              size: 80,
              color: Colors.blue.shade50.withOpacity(0.5),
            ),
          ),
          const Text(
            'Selamat datang di MorseQuest! Kami percaya bahwa belajar tidak harus membosankan. Misi kami adalah menghadirkan keajaiban kode Morse ke tangan anak-anak melalui petualangan yang seru. Dengan setiap titik dan garis, kita membangun jembatan menuju dunia komunikasi rahasia yang penuh misteri!',
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.6),
          ),
        ],
      ),
    );
  }
}

// --- 4. CARD DEVELOPER ---
class DeveloperCard extends StatelessWidget {
  final String name;
  final String description;

  const DeveloperCard({Key? key, required this.name, required this.description})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8), // Latar belakang abu kebiruan lembut
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        children: [
          // Bagian Header Card (Foto & Nama)
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF81C784),
                  Color(0xFF29B6F6),
                ], // Gradient hijau ke biru
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              // TODO: Tambahkan DecorationImage di sini jika aset foto developer sudah ada
              // image: DecorationImage(image: AssetImage('assets/images/alex.png'), fit: BoxFit.cover),
            ),
            child: Stack(
              children: [
                // Ornamen Icon melayang
                const Positioned(
                  top: 20,
                  left: 20,
                  child: Icon(
                    Icons.rocket_launch,
                    color: Colors.white70,
                    size: 30,
                  ),
                ),
                const Positioned(
                  top: 30,
                  right: 30,
                  child: Icon(Icons.code, color: Colors.white70, size: 40),
                ),
                const Positioned(
                  bottom: 50,
                  left: 25,
                  child: Icon(Icons.menu_book, color: Colors.white70, size: 30),
                ),
                const Positioned(
                  bottom: 40,
                  right: 20,
                  child: Icon(Icons.code_off, color: Colors.white70, size: 30),
                ),

                // Teks Nama
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        'Halo, Saya $name!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'Creator & Coder',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bagian Deskripsi & Badge
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Kotak Quote
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '"$description"',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Row Badges
                Row(
                  children: [
                    Expanded(
                      child: _buildBadge(
                        icon: Icons.code,
                        label: 'Coding Pro',
                        bgColor: const Color(0xFFFFD500),
                        textColor: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildBadge(
                        icon: Icons.favorite_border,
                        label: 'Edu Creator',
                        bgColor: const Color(0xFFEF5350), // Merah soft
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor == Colors.white
              ? Colors.red.shade700
              : Colors.orange.shade300,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
