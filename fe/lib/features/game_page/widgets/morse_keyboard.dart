import 'dart:async';
import 'package:flutter/material.dart';

class MorseKeyboard extends StatefulWidget {
  final VoidCallback onDot;
  final VoidCallback onDash;
  final VoidCallback onSpace;
  final VoidCallback onBackspace;
  final VoidCallback onTransmit;
  final bool isSubmitting;

  const MorseKeyboard({
    Key? key,
    required this.onDot,
    required this.onDash,
    required this.onSpace,
    required this.onBackspace,
    required this.onTransmit,
    this.isSubmitting = false,
  }) : super(key: key);

  @override
  State<MorseKeyboard> createState() => _MorseKeyboardState();
}

class _MorseKeyboardState extends State<MorseKeyboard> {
  Timer? _timer;
  bool _isHolding = false;
  int _holdDuration = 0;
  static const int _dashThreshold = 300; // 300ms untuk jadi dash

  void _startHold() {
    setState(() {
      _isHolding = true;
      _holdDuration = 0;
    });

    // Timer untuk menghitung durasi hold
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _holdDuration += 50;
      });
    });
  }

  void _endHold() {
    _timer?.cancel();
    _timer = null;

    if (_isHolding) {
      setState(() {
        _isHolding = false;
      });

      // Decision: dot atau dash?
      if (_holdDuration < _dashThreshold) {
        // Dot (tekan singkat)
        widget.onDot();
      } else {
        // Dash (tekan panjang)
        widget.onDash();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
          // Bar indicator
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // ============ MORSE BUTTON (TAP SHORT / HOLD LONG) ============
          _buildMorseButton(),

          const SizedBox(height: 16),

          // ============ ROW: SPACE + BACKSPACE + TRANSMIT ============
          Row(
            children: [              
              _buildActionButton(
                label: '',
                icon: Icons.backspace,
                onPressed: widget.onBackspace,
                color: Colors.grey.shade900,
                textColor: Colors.grey.shade300,
                flex: 1,
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                label: 'SPACE',
                icon: Icons.space_bar,
                onPressed: widget.onSpace,
                color: Colors.grey.shade300,
                textColor: Colors.black87,
                flex: 2,
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                label: '',
                icon: Icons.send,
                onPressed: widget.onTransmit,
                color: const Color(0xFF005A9C),
                textColor: Colors.white,
                flex: 1,
                isLoading: widget.isSubmitting,
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ============ INSTRUCTION ============
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD500),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Tap = • (titik)  |  Hold = — (garis)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============ MORSE BUTTON (UTAMA) ============
  Widget _buildMorseButton() {
    return GestureDetector(
      onTapDown: (_) => _startHold(),
      onTapUp: (_) => _endHold(),
      onTapCancel: _endHold,
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isHolding
                ? [
                    const Color(0xFF005A9C).withOpacity(0.3),
                    const Color(0xFF005A9C).withOpacity(0.5),
                  ]
                : [
                    const Color(0xFF005A9C).withOpacity(0.1),
                    const Color(0xFF005A9C).withOpacity(0.2),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHolding
                ? const Color(0xFF005A9C)
                : const Color(0xFF005A9C).withOpacity(0.3),
            width: _isHolding ? 3 : 1.5,
          ),
          boxShadow: _isHolding
              ? [
                  BoxShadow(
                    color: const Color(0xFF005A9C).withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isHolding ? Icons.touch_app : Icons.tap_and_play,
                color: _isHolding
                    ? const Color(0xFF005A9C)
                    : Colors.grey.shade600,
                size: 32,
              ),
              const SizedBox(height: 4),
              Text(
                _isHolding
                    ? '${(_holdDuration / 1000).toStringAsFixed(1)}s'
                    : 'TAP or HOLD',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _isHolding
                      ? const Color(0xFF005A9C)
                      : Colors.grey.shade500,
                ),
              ),
              if (_isHolding) ...[
                const SizedBox(height: 2),
                Container(
                  width: 100,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _holdDuration >= _dashThreshold
                        ? Colors.red
                        : const Color(0xFFFFD500),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _holdDuration >= _dashThreshold ? '— DASH' : '• DOT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _holdDuration >= _dashThreshold
                        ? Colors.red
                        : const Color(0xFFFFD500),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ============ ACTION BUTTON ============
  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    required Color textColor,
    int flex = 1,
    bool isLoading = false,
  }) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: isLoading ? null : onPressed,
        child: Container(
          height: 50,
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
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: textColor, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
