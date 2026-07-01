import 'package:flutter/material.dart';

class MorseKeyboard extends StatelessWidget {
  final VoidCallback onDot;
  final VoidCallback onDash;
  final VoidCallback onSpace;
  final VoidCallback onBackspace;
  final VoidCallback onSubmit;
  final bool isSubmitting;

  const MorseKeyboard({
    Key? key,
    required this.onDot,
    required this.onDash,
    required this.onSpace,
    required this.onBackspace,
    required this.onSubmit,
    this.isSubmitting = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildKey(
                label: '•',
                onPressed: onDot,
                color: const Color(0xFFFFD500),
                flex: 1,
              ),
              const SizedBox(width: 12),
              _buildKey(
                label: '—',
                onPressed: onDash,
                color: const Color(0xFFE53935),
                flex: 1,
              ),
              const SizedBox(width: 12),
              _buildKey(
                label: 'SPACE',
                onPressed: onSpace,
                color: Colors.grey.shade300,
                flex: 1,
                textColor: Colors.black87,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildKey(
                label: '⌫',
                onPressed: onBackspace,
                color: Colors.grey.shade200,
                flex: 1,
                textColor: Colors.black87,
              ),
              const SizedBox(width: 12),
              _buildKey(
                label: 'TRANSMIT',
                onPressed: onSubmit,
                color: const Color(0xFF005A9C),
                flex: 2,
                textColor: Colors.white,
                isLoading: isSubmitting,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey({
    required String label,
    required VoidCallback onPressed,
    required Color color,
    int flex = 1,
    Color textColor = Colors.white,
    bool isLoading = false,
  }) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: isLoading ? null : onPressed,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: label.length > 3 ? 14 : 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
