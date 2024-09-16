import 'package:eventmanagement/api/ApiResponse.dart';
import 'package:eventmanagement/api/api_handler.dart';
import 'dart:convert';

import 'package:eventmanagement/features/notifications/models/notification_model.dart';

class NotificationService {
  final ApiHandler apiHandler;

  NotificationService(this.apiHandler);

  Future<ApiResponse<List<NotificationModel>>> getNotifications(
      String accessToken) async {
    return await apiHandler.get<List<NotificationModel>>(
        token: accessToken,
        route: '/notifications',
        fromJson: (p0) => (p0 as List<dynamic>)
            .map((e) => NotificationModel.fromMap(e as Map<String, dynamic>))
            .toList());
  }

  Future<ApiResponse<Null>> markAsRead(
      String accessToken, String notificationId) async {
    return await apiHandler.patch<Null>(
        token: accessToken,
        route: '/notifications/$notificationId/read',
        data: jsonEncode({}),
        fromJson: (p0) => null);
  }

  Future<ApiResponse<Null>> deleteNotification(
      String accessToken, String notificationId) async {
    return await apiHandler.delete<Null>(
      token: accessToken,
      route: '/notifications/$notificationId',
      data: jsonEncode({}),
      fromJson: (p0) => null,
    );
  }
}
