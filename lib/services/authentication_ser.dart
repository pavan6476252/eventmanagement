import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eventmanagement/api/ApiResponse.dart';
import 'package:eventmanagement/api/api_handler.dart';
import 'package:eventmanagement/features/auth/models/TokenModel.dart';
import 'dart:convert';

class AuthenticationService {
  final ApiHandler apiHandler;

  AuthenticationService(this.apiHandler);

  Future<ApiResponse<Null>> signup(String token) async {
    try {
      return await apiHandler.post<Null>(
          token: token,
          route: '/auth/firebase-signup',
          data: jsonEncode({}),
          fromJson: (p0) => null);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<ApiResponse<TokenModel?>> login(String firebaseToken) async {
    try {
      return await apiHandler.post<TokenModel>(
          token: firebaseToken,
          route: '/auth/firebase-login',
          data: jsonEncode({}),
          fromJson: (p0) => TokenModel.fromMap(p0));
    } on DioException catch (e) {
      return _handleDioError<TokenModel>(e);
    }
  }

  Future<ApiResponse<Null>> logout(String accessToken) async {
    try {
      return await apiHandler.post<Null>(
          token: accessToken,
          route: '/auth/logout',
          data: jsonEncode({}),
          fromJson: (p0) => null);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<ApiResponse<TokenModel?>> refreshTokens(String refreshToken) async {
    try {
      return await apiHandler.post<TokenModel>(
        token: refreshToken,
        route: '/auth/refresh-tokens',
        data: jsonEncode({
          {"refreshToken": refreshToken}
        }),
        fromJson: (p0) => TokenModel.fromMap(p0),
      );
    } on DioException catch (e) {
      return _handleDioError<Null>(e);
    }
  }

  ApiResponse<T?> _handleDioError<T>(DioException error) {
    final statusCode = error.response?.statusCode ?? 500;
    final msg = _getDioErrorMsg(error);

    final exceptionMsg =
        ApiResponse<T?>(msg: msg, status: statusCode, data: null);
    log("[Exceptions] ${exceptionMsg.toString()}");
    return exceptionMsg;
  }

  String _getDioErrorMsg(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return "Timeout occurred while sending or receiving";
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          switch (statusCode) {
            case 400:
              return "Bad Request";
            case 401:
            case 403:
              return "Unauthorized";
            case 404:
              return "Not Found";
            case 409:
              return 'Conflict';
            case 500:
              return "Internal Server Error";
          }
        }
        break;
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
        return "No Internet Connection";
      case DioExceptionType.badCertificate:
        return "Internal Server Error";
      case DioExceptionType.connectionError:
        return "Connection Error";
      default:
        return "Unknown Error";
    }
    return "Unknown Error";
  }
}
