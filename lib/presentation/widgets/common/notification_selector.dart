import 'package:flutter/material.dart';
import '../../../domain/services/notification_service.dart';
import '../../theme/app_theme.dart';

class NotificationSelector extends StatelessWidget {
  final NotificationMethod selectedMethod;
  final Function(NotificationMethod) onMethodChanged;
  final Color activeColor;

  const NotificationSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
    this.activeColor = AppTheme.primaryPurple,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    return Row(
      children: [
        Expanded(child: _notificationPill(context, 'Email', Icons.email_outlined, NotificationMethod.email)),
        SizedBox(width: w * 0.02),
        Expanded(child: _notificationPill(context, 'SMS', Icons.sms_outlined, NotificationMethod.sms)),
        SizedBox(width: w * 0.02),
        Expanded(child: _notificationPill(context, 'WSP', Icons.chat_outlined, NotificationMethod.whatsapp)),
      ],
    );
  }

  Widget _notificationPill(BuildContext context, String title, IconData icon, NotificationMethod method) {
    final isSelected = selectedMethod == method;
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    return GestureDetector(
      onTap: () => onMethodChanged(method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: h * 0.015),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activeColor : Colors.black.withValues(alpha: 0.05),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : AppTheme.textGray,
              size: w * 0.045,
            ),
            SizedBox(width: w * 0.02),
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? activeColor : AppTheme.textDark,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: w * 0.032,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
