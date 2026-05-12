import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Shows a full-screen animated success overlay.
/// The overlay closes itself using its own internal context — avoiding
/// the null-context crash that happens when the calling screen is already popped.
class SuccessOverlay extends StatefulWidget {
  final String title;
  final String subtitle;

  const SuccessOverlay({super.key, required this.title, required this.subtitle});

  static void show(BuildContext context, {required String title, required String subtitle}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (ctx, a1, a2) => SuccessOverlay(title: title, subtitle: subtitle),
      ),
    );
  }

  @override
  State<SuccessOverlay> createState() => _SuccessOverlayState();
}

class _SuccessOverlayState extends State<SuccessOverlay> with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _checkController;
  late AnimationController _textController;
  late AnimationController _rippleController;

  late Animation<double> _bgOpacity;
  late Animation<double> _circleScale;
  late Animation<double> _checkScale;
  late Animation<double> _checkOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _rippleScale;
  late Animation<double> _rippleOpacity;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _checkController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _textController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _rippleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();

    _bgOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _bgController, curve: Curves.easeIn));
    _circleScale = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _checkController, curve: Curves.elasticOut));
    _checkScale = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _checkController, curve: const Interval(0.4, 1.0, curve: Curves.elasticOut)));
    _checkOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _checkController, curve: const Interval(0.3, 0.7, curve: Curves.easeIn)));
    _textOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));
    _textSlide = Tween(begin: 30.0, end: 0.0).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _rippleScale = Tween(begin: 1.0, end: 2.2).animate(CurvedAnimation(parent: _rippleController, curve: Curves.easeOut));
    _rippleOpacity = Tween(begin: 0.4, end: 0.0).animate(CurvedAnimation(parent: _rippleController, curve: Curves.easeOut));

    _runSequence();
  }

  Future<void> _runSequence() async {
    await _bgController.forward();
    await _checkController.forward();
    await _textController.forward();
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;
    await _bgController.reverse();
    // Use the overlay's OWN context — never the caller's captured context
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _checkController.dispose();
    _textController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _bgOpacity,
      child: Material(
        color: Colors.black.withValues(alpha: 0.65),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _rippleController,
                      builder: (ctx, child) => Transform.scale(
                        scale: _rippleScale.value,
                        child: Opacity(
                          opacity: _rippleOpacity.value,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.successGreen, width: 3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ScaleTransition(
                      scale: _circleScale,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [AppTheme.successGreen, AppTheme.successGreen.withValues(alpha: 0.75)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(color: AppTheme.successGreen.withValues(alpha: 0.45), blurRadius: 28, spreadRadius: 4),
                          ],
                        ),
                      ),
                    ),
                    FadeTransition(
                      opacity: _checkOpacity,
                      child: ScaleTransition(
                        scale: _checkScale,
                        child: const Icon(Icons.check_rounded, color: Colors.white, size: 54),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              AnimatedBuilder(
                animation: _textController,
                builder: (ctx, child) => Transform.translate(
                  offset: Offset(0, _textSlide.value),
                  child: FadeTransition(
                    opacity: _textOpacity,
                    child: Column(
                      children: [
                        Text(widget.title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          widget.subtitle,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
