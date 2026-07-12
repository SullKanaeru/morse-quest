import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:morsequest/shared/providers/sound_provider.dart';
import 'package:morsequest/shared/providers/user_provider.dart';

class HintPackageCard extends StatelessWidget {
  final int amount;
  final int price;
  final bool isBestDeal;
  final int currentPoints;

  const HintPackageCard({
    super.key,
    required this.amount,
    required this.price,
    required this.isBestDeal,
    required this.currentPoints,
  });

  @override
  Widget build(BuildContext context) {
    final bool canAfford = currentPoints >= price;
    final String priceFormatted = _formatPrice(price);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isBestDeal ? Colors.white : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isBestDeal ? const Color(0xFFFFD500) : Colors.grey.shade200,
          width: isBestDeal ? 2.5 : 1.5,
        ),
        gradient: isBestDeal
            ? const LinearGradient(
                colors: [
                  Color(0xFFFFFDF0),
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        boxShadow: [
          if (isBestDeal)
            BoxShadow(
              color: const Color(0xFFFFD500).withValues(alpha: 0.3),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            )
          else
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Row(
        children: [
          _buildPackageIcon(),
          const SizedBox(width: 16),
          Expanded(child: _buildPackageInfo(priceFormatted)),
          _buildBuyButton(context, canAfford),
        ],
      ),
    );
  }

  Widget _buildPackageIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isBestDeal
              ? [const Color(0xFFFFD500), const Color(0xFFFBC02D)]
              : [const Color(0xFFFFE082), const Color(0xFFFFCA28)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD500).withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.lightbulb, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildPackageInfo(String priceFormatted) {
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
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1E1E),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isBestDeal) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF5252), Color(0xFFFF1744)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF5252).withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'BEST DEAL',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.monetization_on, size: 16, color: Color(0xFFFBC02D)),
            const SizedBox(width: 6),
            Text(
              priceFormatted,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBuyButton(BuildContext context, bool canAfford) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 85,
      height: 42,
      child: ElevatedButton(
        onPressed: canAfford ? () => _showPurchaseDialog(context) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canAfford ? const Color(0xFF005A9C) : Colors.grey.shade300,
          foregroundColor: canAfford ? Colors.white : Colors.grey.shade600,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: canAfford ? 4 : 0,
        ),
        child: Text(
          canAfford ? 'BELI' : 'KURANG',
          style: TextStyle(
            fontSize: canAfford ? 14 : 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context) {
    final soundProvider = Provider.of<SoundProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD500).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shopping_cart, color: Color(0xFFFFD500), size: 28),
            ),
            const SizedBox(width: 12),
            const Text(
              'Konfirmasi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black87, fontSize: 16, height: 1.5),
            children: [
              const TextSpan(text: 'Kamu akan membeli '),
              TextSpan(
                text: '$amount Hint ',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF005A9C)),
              ),
              const TextSpan(text: 'seharga '),
              TextSpan(
                text: '${_formatPrice(price)} Poin',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFBC02D)),
              ),
              const TextSpan(text: '?\n\nLanjutkan pembelian?'),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              final success = await userProvider.buyHint(amount, price);

              if (!context.mounted) return;

              if (success) {
                soundProvider.playCorrectForShop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 12),
                        Text('Berhasil membeli $amount hint!', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    backgroundColor: Colors.green.shade600,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                );
              } else {
                soundProvider.playWrongForShop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.white),
                        const SizedBox(width: 12),
                        const Text('Gagal membeli hint! Poin tidak cukup.', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    backgroundColor: Colors.red.shade600,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005A9C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
            ),
            child: const Text('Beli', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }
}
