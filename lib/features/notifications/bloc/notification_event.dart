part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class FetchNotificationsEvent extends NotificationEvent {}

class ReadNotificationEvent extends NotificationEvent {
  final String notificationId;

  const ReadNotificationEvent(this.notificationId);
}

class DeleteNotificationEvent extends NotificationEvent {
  final String notificationId;

  const DeleteNotificationEvent(this.notificationId);
}
