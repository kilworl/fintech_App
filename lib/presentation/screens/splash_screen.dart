import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../../core/navigation/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _progress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.8, curve: Curves.easeInOutCubic)),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.8, 1.0, curve: Curves.easeIn)),
    );

    _controller.forward().then((_) {
      if (mounted) {
        context.go(AppRouter.login);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A1A),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: w * 0.6,
                  height: h * 0.3,
                  child: AnimatedBuilder(
                    animation: _progress,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: StonksPainter(_progress.value),
                      );
                    },
                  ),
                ),
                SizedBox(height: h * 0.05),
                FadeTransition(
                  opacity: _opacity,
                  child: Text(
                    'FINANTECH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.08,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: h * 0.08,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _opacity,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StonksPainter extends CustomPainter {
  final double progress;

  StonksPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00E676) // Stonks Green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final shadowPaint = Paint()
      ..color = const Color(0xFF00E676).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final path = Path();
    
    // Draw a "stonks" path: small dips but overall strong upward trend
    path.moveTo(0, size.height * 0.8);
    path.lineTo(size.width * 0.2 * progress, size.height * (0.8 - 0.1 * progress));
    path.lineTo(size.width * 0.4 * progress, size.height * (0.7 - 0.2 * progress));
    path.lineTo(size.width * 0.6 * progress, size.height * (0.5 + 0.1 * progress));
    path.lineTo(size.width * 0.8 * progress, size.height * (0.6 - 0.4 * progress));
    path.lineTo(size.width * progress, size.height * (0.2 - 0.2 * progress));

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);

    // Draw an arrow head at the end
    if (progress > 0.9) {
      final arrowPaint = Paint()
        ..color = const Color(0xFF00E676)
        ..style = PaintingStyle.fill;
      
      final arrowPath = Path();
      arrowPath.moveTo(size.width, size.height * 0.0);
      arrowPath.lineTo(size.width - 15, size.height * 0.0 + 5);
      arrowPath.lineTo(size.width - 5, size.height * 0.0 + 15);
      arrowPath.close();
      canvas.drawPath(arrowPath, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant StonksPainter oldDelegate) => oldDelegate.progress != progress;
}
