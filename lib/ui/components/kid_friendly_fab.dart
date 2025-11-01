import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors.dart';

class KidFriendlyFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final String emoji;

  const KidFriendlyFAB({
    super.key,
    required this.onPressed,
    this.label = 'New What-If',
    this.emoji = '✨',
  });

  @override
  State<KidFriendlyFAB> createState() => _KidFriendlyFABState();
}

class _KidFriendlyFABState extends State<KidFriendlyFAB>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _onTap() {
    HapticFeedback.mediumImpact();
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _bounceController]),
      builder: (context, child) {
        final pulseValue = _pulseController.value;
        final bounceValue = _bounceController.value;

        return Transform.scale(
          scale: 1.0 + (bounceValue * 0.1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: TurfitColors.accentLight.withOpacity(
                    0.4 + (pulseValue * 0.2),
                  ),
                  offset: const Offset(0, 8),
                  blurRadius: 20 + (pulseValue * 10),
                  spreadRadius: pulseValue * 5,
                ),
              ],
            ),
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isHovered = true),
              onTapUp: (_) => setState(() => _isHovered = false),
              onTapCancel: () => setState(() => _isHovered = false),
              onTap: _onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _isHovered
                        ? [const Color(0xFFFFA726), TurfitColors.accentLight]
                        : [TurfitColors.accentLight, const Color(0xFFFFA726)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.emoji, style: TextStyle(fontSize: 20.sp)),
                    SizedBox(width: 2.w),
                    Text(
                      widget.label,
                      style: GoogleFonts.nunito(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
