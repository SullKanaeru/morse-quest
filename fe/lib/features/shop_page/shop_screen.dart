import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:morsequest/shared/utils/constants.dart';
import 'package:morsequest/shared/widgets/custom_bottom_nav.dart';
import 'package:morsequest/shared/utils/navigation_helper.dart';
import 'package:morsequest/shared/providers/sound_provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int _currentNavIndex = 2;

  final int _currentPoints = 15000;
  final int _currentHints = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Toko Hint',
        style: TextStyle(
          color: Color(0xFF005A9C),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF005A9C)),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBalanceCard(),
          const SizedBox(height: 32),
          _buildSectionTitle(),
          const SizedBox(height: 8),
          _buildSectionSubtitle(),
          const SizedBox(height: 24),
          _buildHintPackage(
            amount: 4,
            price: AppConstants.hintPrice4,
            isBestDeal: false,
          ),
          const SizedBox(height: 16),
          _buildHintPackage(
            amount: 10,
            price: AppConstants.hintPrice10,
            isBestDeal: true,
          ),
          const SizedBox(height: 24),
          _buildFreeHintInfo(),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBalanceItem(
            icon: Icons.monetization_on,
            label: 'Point',
            value: _currentPoints.toString(),
            color: Colors.grey.shade700,
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          _buildBalanceItem(
            icon: Icons.lightbulb,
            label: 'Hint',
            value: _currentHints.toString(),
            color: const Color(0xFFFFD500),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildSectionTitle() {
    return const Center(
      child: Text(
        '💡 Beli Hint',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSectionSubtitle() {
    return const Center(
      child: Text(
        'Gunakan hint untuk membantu saat mengerjakan soal',
        style: TextStyle(color: Colors.grey, fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildHintPackage({
    required int amount,
    required int price,
    required bool isBestDeal,
  }) {
    final bool canAfford = _currentPoints >= price;
    final String priceFormatted = _formatPrice(price);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isBestDeal ? const Color(0xFFFFD500) : Colors.grey.shade200,
          width: isBestDeal ? 2 : 1,
        ),
        boxShadow: isBestDeal
            ? [
                BoxShadow(
                  color: const Color(0xFFFFD500).withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          _buildPackageIcon(isBestDeal),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: _buildPackageInfo(amount, priceFormatted, isBestDeal),
          ),
          const SizedBox(width: 8),
          _buildBuyButton(amount, price, canAfford),
        ],
      ),
    );
  }

  Widget _buildPackageIcon(bool isBestDeal) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isBestDeal
            ? const Color(0xFFFFD500).withOpacity(0.15)
            : const Color(0xFFFFD500).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(Icons.lightbulb, color: const Color(0xFFFFD500), size: 24),
      ),
    );
  }

  Widget _buildPackageInfo(int amount, String price, bool isBestDeal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                '$amount Hint',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isBestDeal) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD500),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'BEST',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'Rp $price',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildBuyButton(int amount, int price, bool canAfford) {
    return SizedBox(
      width: 70,
      height: 36,
      child: ElevatedButton(
        onPressed: canAfford
            ? () => _showPurchaseDialog(context, amount, price)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canAfford
              ? const Color(0xFFFFD500)
              : Colors.grey.shade300,
          foregroundColor: canAfford ? Colors.black87 : Colors.grey.shade600,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: canAfford ? 2 : 0,
          minimumSize: const Size(60, 36),
        ),
        child: Text(
          canAfford ? 'BELI' : 'Tidak\nCukup',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: canAfford ? 12 : 10,
            fontWeight: FontWeight.bold,
            color: canAfford ? Colors.black87 : Colors.grey.shade600,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildFreeHintInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD500).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFD500).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD500).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star, color: Color(0xFFFFD500), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '⭐ Dapatkan 1 HINT GRATIS setiap mengumpulkan 25 bintang!',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, int amount, int price) {
    final soundProvider = Provider.of<SoundProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.lightbulb, color: Color(0xFFFFD500)),
            const SizedBox(width: 8),
            const Text('Beli Hint'),
          ],
        ),
        content: Text(
          'Kamu akan membeli $amount hint seharga Rp ${_formatPrice(price)}. Lanjutkan?',
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              soundProvider.playCorrectForShop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('✅ Berhasil membeli $amount hint!'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD500),
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Beli'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return CustomBottomNav(
      currentIndex: _currentNavIndex,
      onTap: (index) =>
          NavigationHelper.onNavTapped(context, index, _currentNavIndex),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }
}
