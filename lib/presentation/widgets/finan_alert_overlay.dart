import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Shows a full-screen animated status overlay (Success or Error).
class FinanAlertOverlay extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool isError;

  const FinanAlertOverlay({
    super.key, 
    required this.title, 
    required this.subtitle, 
    this.isError = false
  });

  static void show(BuildContext context, {
    required String title, 
    required String subtitle, 
    bool isError = false
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (ctx, a1, a2) => FinanAlertOverlay(
          title: title, 
          subtitle: subtitle, 
          isError: isError
        ),
      ),
    );
  }

  @override
  State<FinanAlertOverlay> createState() => _FinanAlertOverlayState();
}

class _FinanAlertOverlayState extends State<FinanAlertOverlay> with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _iconController;
  late AnimationController _textController;
  late AnimationController _rippleController;

  late Animation<double> _bgOpacity;
  late Animation<double> _circleScale;
  late Animation<double> _iconScale;
  late Animation<double> _iconOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _rippleScale;
  late Animation<double> _rippleOpacity;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _iconController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _textController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _rippleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();

    _bgOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _bgController, curve: Curves.easeIn));
    _circleScale = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _iconController, curve: Curves.elasticOut));
    _iconScale = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _iconController, curve: const Interval(0.4, 1.0, curve: Curves.elasticOut)));
    _iconOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _iconController, curve: const Interval(0.3, 0.7, curve: Curves.easeIn)));
    _textOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));
    _textSlide = Tween(begin: 30.0, end: 0.0).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _rippleScale = Tween(begin: 1.0, end: 2.2).animate(CurvedAnimation(parent: _rippleController, curve: Curves.easeOut));
    _rippleOpacity = Tween(begin: 0.4, end: 0.0).animate(CurvedAnimation(parent: _rippleController, curve: Curves.easeOut));

    _runSequence();
  }

  Future<void> _runSequence() async {
    await _bgController.forward();
    await _iconController.forward();
    await _textController.forward();
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;
    await _bgController.reverse();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _iconController.dispose();
    _textController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;
    final statusColor = widget.isError ? AppTheme.errorRed : AppTheme.successGreen;

    return FadeTransition(
      opacity: _bgOpacity,
      child: Material(
        color: Colors.black.withValues(alpha: 0.75),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: w * 0.4,
                height: w * 0.4,
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
                            width: w * 0.25,
                            height: w * 0.25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: statusColor, width: 3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ScaleTransition(
                      scale: _circleScale,
                      child: Container(
                        width: w * 0.25,
                        height: w * 0.25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [statusColor, statusColor.withValues(alpha: 0.75)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(color: statusColor.withValues(alpha: 0.45), blurRadius: 28, spreadRadius: 4),
                          ],
                        ),
                      ),
                    ),
                    FadeTransition(
                      opacity: _iconOpacity,
                      child: ScaleTransition(
                        scale: _iconScale,
                        child: Icon(
                          widget.isError ? Icons.warning_amber_rounded : Icons.check_rounded, 
                          color: Colors.white, 
                          size: w * 0.13
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.03),
              AnimatedBuilder(
                animation: _textController,
                builder: (ctx, child) => Transform.translate(
                  offset: Offset(0, _textSlide.value),
                  child: FadeTransition(
                    opacity: _textOpacity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.1),
                      child: Column(
                        children: [
                          Text(
                            widget.title, 
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: w * 0.06, 
                              fontWeight: FontWeight.bold
                            )
                          ),
                          SizedBox(height: h * 0.015),
                          Text(
                            widget.subtitle,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85), 
                              fontSize: w * 0.038,
                              height: 1.4
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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
