import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MorseKeyboard extends StatefulWidget {
  final VoidCallback onDot;
  final VoidCallback onDash;
  final VoidCallback onSpace;
  final VoidCallback onBackspace;
  final VoidCallback onTransmit;
  final bool isSubmitting;
  final bool isGlowing;

  const MorseKeyboard({
    super.key,
    required this.onDot,
    required this.onDash,
    required this.onSpace,
    required this.onBackspace,
    required this.onTransmit,
    this.isSubmitting = false,
    this.isGlowing = false,
  });

  @override
  State<MorseKeyboard> createState() => _MorseKeyboardState();
}

class _MorseKeyboardState extends State<MorseKeyboard>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  bool _isHolding = false;
  int _holdDuration = 0;
  static const int _dashThreshold = 300; // 300ms untuk jadi dash
  static const int _maxHoldDuration = 1000; // 1 detik auto-release

  // Glow/pulse animation
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    if (widget.isGlowing) {
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant MorseKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isGlowing && !_glowController.isAnimating) {
      _glowController.repeat(reverse: true);
    } else if (!widget.isGlowing && _glowController.isAnimating) {
      _glowController.stop();
      _glowController.reset();
    }
  }

  void _startHold() {
    setState(() {
      _isHolding = true;
      _holdDuration = 0;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _holdDuration += 50;
      });

      // Auto-release jika melebihi batas waktu
      if (_holdDuration >= _maxHoldDuration) {
        _autoRelease();
      }
    });
  }

  void _autoRelease() {
    _timer?.cancel();
    _timer = null;

    if (_isHolding) {
      setState(() {
        _isHolding = false;
        _holdDuration = 0;
      });

      // Auto-release selalu mengirim DASH + haptic feedback
      HapticFeedback.heavyImpact();
      widget.onDash();
    }
  }

  void _endHold() {
    _timer?.cancel();
    _timer = null;

    if (_isHolding) {
      final duration = _holdDuration;
      setState(() {
        _isHolding = false;
        _holdDuration = 0;
      });

      if (duration < _dashThreshold) {
        HapticFeedback.lightImpact();
        widget.onDot();
      } else {
        HapticFeedback.mediumImpact();
        widget.onDash();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _glowController.dispose();
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

          // ============ ROW: BACKSPACE + SPACE + TRANSMIT ============
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
        ],
      ),
    );
  }

  // ============ MORSE BUTTON (UTAMA) ============
  Widget _buildMorseButton() {
    // Hitung progress dari 0.0 ke 1.0 berdasarkan maxHoldDuration
    final double progress = _isHolding
        ? (_holdDuration / _maxHoldDuration).clamp(0.0, 1.0)
        : 0.0;
    final bool isDashZone = _holdDuration >= _dashThreshold;

    // Jika mode glow (waiting state), gunakan AnimatedBuilder untuk pulse effect
    if (widget.isGlowing) {
      return AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          final glowVal = _glowAnimation.value;
          return GestureDetector(
            onTapDown: (_) => _startHold(),
            onTapUp: (_) => _endHold(),
            onTapCancel: _endHold,
            child: Container(
              width: double.infinity,
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFD500).withOpacity(0.2 + glowVal * 0.3),
                    const Color(0xFFFFD500).withOpacity(0.3 + glowVal * 0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(
                    0xFFFFD500,
                  ).withOpacity(0.5 + glowVal * 0.5),
                  width: 2 + glowVal,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD500).withOpacity(glowVal * 0.5),
                    blurRadius: 20 + glowVal * 15,
                    spreadRadius: glowVal * 8,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.touch_app,
                      color: Color.lerp(
                        const Color(0xFFFFD500).withOpacity(0.6),
                        const Color(0xFFFFD500),
                        glowVal,
                      ),
                      size: 36,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'TAP HERE!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.lerp(
                          const Color(0xFFFFD500).withOpacity(0.6),
                          const Color(0xFFFFD500),
                          glowVal,
                        ),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return GestureDetector(
      onTapDown: (_) => _startHold(),
      onTapUp: (_) => _endHold(),
      onTapCancel: _endHold,
      child: Container(
        width: double.infinity,
        height: 90,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isHolding
                ? (isDashZone
                      ? [
                          const Color(0xFF005A9C).withOpacity(0.3),
                          const Color(0xFF005A9C).withOpacity(0.5),
                        ]
                      : [
                          const Color(0xFFFFD500).withOpacity(0.2),
                          const Color(0xFFFFD500).withOpacity(0.4),
                        ])
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
                ? (isDashZone
                      ? const Color(0xFF005A9C)
                      : const Color(0xFFFFD500))
                : const Color(0xFF005A9C).withOpacity(0.3),
            width: _isHolding ? 3 : 1.5,
          ),
          boxShadow: _isHolding
              ? [
                  BoxShadow(
                    color:
                        (isDashZone
                                ? const Color(0xFF005A9C)
                                : const Color(0xFFFFD500))
                            .withOpacity(0.3),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isHolding ? Icons.touch_app : Icons.tap_and_play,
              color: _isHolding
                  ? (isDashZone
                        ? const Color(0xFF005A9C)
                        : const Color(0xFFFFD500))
                  : Colors.grey.shade600,
              size: 32,
            ),
            const SizedBox(height: 4),
            Text(
              _isHolding ? (isDashZone ? '— DASH' : '• DOT') : 'TAP or HOLD',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _isHolding
                    ? (isDashZone
                          ? const Color(0xFF005A9C)
                          : const Color(0xFFFFD500))
                    : Colors.grey.shade500,
              ),
            ),
            if (_isHolding) ...[
              const SizedBox(height: 6),
              // Progress bar dengan zona dot dan dash
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Stack(
                  children: [
                    // Background
                    Container(
                      width: double.infinity,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    // Progress fill
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFFFD500),
                              isDashZone
                                  ? const Color(0xFF005A9C)
                                  : const Color(0xFFFFD500),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    // Dash threshold marker
                    Positioned(
                      left:
                          (_dashThreshold / _maxHoldDuration) *
                          (MediaQuery.of(context).size.width - 80 - 48),
                      child: Container(
                        width: 2,
                        height: 6,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${(_holdDuration / 1000).toStringAsFixed(1)}s / ${(_maxHoldDuration / 1000).toStringAsFixed(1)}s',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
              ),
            ],
          ],
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
