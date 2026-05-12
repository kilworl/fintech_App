import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class FinanButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isSecondary;
  final Color? color;
  final double? width;
  final double? height;
  
  const FinanButton({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.isSecondary = false,
    this.color,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final h = size.height;
    final w = size.width;
    
    final dynamicHeight = height ?? h * 0.065;
    final dynamicFontSize = w * 0.04;

    return SizedBox(
      width: width ?? double.infinity,
      height: dynamicHeight,
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: (isLoading || isSecondary) ? null : AppTheme.primaryGradient,
            color: isSecondary 
                ? (color ?? AppTheme.textGray.withValues(alpha: 0.1)) 
                : (isLoading ? AppTheme.primaryPurple.withValues(alpha: 0.4) : (color ?? Colors.transparent)),
            borderRadius: BorderRadius.circular(16),
            boxShadow: (isLoading || isSecondary)
                ? []
                : [
                    BoxShadow(
                      color: AppTheme.primaryPurple.withValues(alpha: 0.35),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
          ),
          alignment: Alignment.center,
          child: isLoading
              ? SizedBox(
                  width: w * 0.06,
                  height: w * 0.06,
                  child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: isSecondary ? (color == null ? AppTheme.textDark : Colors.white) : Colors.white,
                    fontSize: dynamicFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
