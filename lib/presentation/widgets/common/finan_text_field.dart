import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class FinanTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType keyboardType;
  final Widget? suffix;
  final String? label;
  final String? errorText;
  final bool isDark;

  const FinanTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.suffix,
    this.label,
    this.errorText,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              color: isDark ? Colors.white70 : AppTheme.textGray,
              fontSize: w * 0.032,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: h * 0.01),
        ],
        Container(
          decoration: BoxDecoration(
            color: isDark 
                ? Colors.white.withValues(alpha: 0.07) 
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark 
                  ? Colors.white.withValues(alpha: 0.12) 
                  : Colors.black.withValues(alpha: 0.05),
            ),
            boxShadow: isDark ? [] : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            style: TextStyle(
              color: isDark ? Colors.white : AppTheme.textDark,
              fontSize: w * 0.038,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: isDark 
                    ? Colors.white.withValues(alpha: 0.3) 
                    : AppTheme.textGray.withValues(alpha: 0.5),
                fontSize: w * 0.038,
              ),
              prefixIcon: Icon(
                icon, 
                color: isDark ? Colors.white38 : AppTheme.primaryPurple.withValues(alpha: 0.5), 
                size: w * 0.05,
              ),
              suffixIcon: suffix,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: h * 0.02, 
                horizontal: w * 0.04
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: h * 0.006),
          Padding(
            padding: EdgeInsets.only(left: w * 0.02),
            child: Text(
              errorText!,
              style: TextStyle(
                color: AppTheme.errorRed,
                fontSize: w * 0.028,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
