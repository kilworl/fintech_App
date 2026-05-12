enum NotificationMethod { email, sms, whatsapp }

enum NotificationStatus { sent, failed, simulated }

class NotificationResult {
  final NotificationStatus status;
  final String message;

  const NotificationResult({required this.status, required this.message});

  bool get isSuccess => status == NotificationStatus.sent || status == NotificationStatus.simulated;
}

abstract class NotificationService {
  /// Sends an email notification about a fund transaction.
  Future<NotificationResult> sendEmail({
    required String toEmail,
    required String toName,
    required String fundName,
    required double amount,
    required String action, // 'Suscripción' or 'Cancelación'
    required DateTime date,
  });

  /// Sends an SMS notification about a fund transaction.
  Future<NotificationResult> sendSms({
    required String phone,
    required String fundName,
    required double amount,
    required String action,
  });

  /// Opens WhatsApp with a pre-filled message.
  Future<NotificationResult> sendWhatsApp({
    required String phone,
    required String fundName,
    required double amount,
    required String action,
  });
}
