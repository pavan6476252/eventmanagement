import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:eventmanagement/api/ApiResponse.dart';
import 'package:eventmanagement/features/auth/bloc/authentication_bloc.dart';
import 'package:eventmanagement/features/notifications/models/notification_model.dart';
import 'package:eventmanagement/services/notification_services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService notificationService;
  final BuildContext context;
  NotificationBloc(this.context, this.notificationService)
      : super(NotificationInitial()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<ReadNotificationEvent>(_onReadNotification);
    on<DeleteNotificationEvent>(_onDeleteNotification);
  }

  Future<void> _onFetchNotifications(
      FetchNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      if (context.read<AuthenticationBloc>().state
          is AuthenticationAuthenticated) {
        String accessToken = (context.read<AuthenticationBloc>().state
                as AuthenticationAuthenticated)
            .tokenModel
            .accessToken;
        ApiResponse<List<NotificationModel>> response =
            await notificationService.getNotifications(accessToken);

        emit(NotificationLoaded(response.data));
      } else {
        throw Exception('not authenticated');
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onReadNotification(
      ReadNotificationEvent event, Emitter<NotificationState> emit) async {
    try {
      if (context.read<AuthenticationBloc>().state
          is AuthenticationAuthenticated) {
        String accessToken =
            (context.read<AuthenticationBloc>() as AuthenticationAuthenticated)
                .tokenModel
                .accessToken;
        await notificationService.markAsRead(accessToken, event.notificationId);
        add(FetchNotificationsEvent());
      } else {
        throw Exception('failed to make authenticated');
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onDeleteNotification(
      DeleteNotificationEvent event, Emitter<NotificationState> emit) async {
    try {
      if (context.read<AuthenticationBloc>().state
          is AuthenticationAuthenticated) {
        String token =
            (context.read<AuthenticationBloc>() as AuthenticationAuthenticated)
                .tokenModel
                .accessToken;
        await notificationService.deleteNotification(
            token, event.notificationId);

        add(FetchNotificationsEvent());
      } else {
        throw Exception('failed to delete notification');
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  @override
  NotificationState? fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      final notifications = (json['notifications'] as List)
          .map((e) => NotificationModel.fromMap(e as Map<String, dynamic>))
          .toList();
      return NotificationLoaded(notifications);
    }
    return NotificationInitial();
  }

  @override
  Map<String, dynamic>? toJson(NotificationState state) {
    if (state is NotificationLoaded) {
      return {
        'notifications': state.notifications.map((e) => e.toMap()).toList()
      };
    }
    return null;
  }
}
