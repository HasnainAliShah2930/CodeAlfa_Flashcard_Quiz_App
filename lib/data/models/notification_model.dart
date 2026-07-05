import 'package:equatable/equatable.dart';

enum NotificationType { added, deleted, studied }

class NotificationModel extends Equatable {
  final String id;
  final String message;
  final DateTime timestamp;
  final NotificationType type;

  const NotificationModel({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.type,
  });

  @override
  List<Object?> get props => [id, message, timestamp, type];
}
