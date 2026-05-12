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
    return Row(
      children: [
        Expanded(child: _notificationPill('Email', Icons.email_outlined, NotificationMethod.email)),
        const SizedBox(width: 8),
        Expanded(child: _notificationPill('SMS', Icons.sms_outlined, NotificationMethod.sms)),
        const SizedBox(width: 8),
        Expanded(child: _notificationPill('WSP', Icons.chat_outlined, NotificationMethod.whatsapp)),
      ],
    );
  }

  Widget _notificationPill(String title, IconData icon, NotificationMethod method) {
    final isSelected = selectedMethod == method;
    return GestureDetector(
      onTap: () => onMethodChanged(method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
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
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? activeColor : AppTheme.textDark,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
