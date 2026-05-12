import '../../core/types/either_result.dart';
import '../../domain/entities/fund.dart';
import '../../domain/services/notification_service.dart';

/// Sends a subscription/cancellation notification via the chosen method.
class SendNotification {
  final NotificationService service;
  SendNotification(this.service);

  Future<EitherResult<NotificationResult>> call({
    required NotificationMethod method,
    required String contact,      // email address OR phone number
    required String userName,
    required Fund fund,
    required double amount,
    required String action,       // 'Suscripción' | 'Cancelación'
  }) async {
    try {
      NotificationResult result;
      
      switch (method) {
        case NotificationMethod.email:
          result = await service.sendEmail(
            toEmail: contact,
            toName: userName,
            fundName: fund.name,
            amount: amount,
            action: action,
            date: DateTime.now(),
          );
          break;
        case NotificationMethod.sms:
          result = await service.sendSms(
            phone: contact,
            fundName: fund.name,
            amount: amount,
            action: action,
          );
          break;
        case NotificationMethod.whatsapp:
          result = await service.sendWhatsApp(
            phone: contact,
            fundName: fund.name,
            amount: amount,
            action: action,
          );
          break;
      }
      
      return result.isSuccess
          ? success(result)
          : failure(result.message);
    } catch (e) {
      return failure('Error inesperado al notificar: $e');
    }
  }
}
