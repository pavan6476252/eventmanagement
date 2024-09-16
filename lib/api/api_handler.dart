import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:eventmanagement/api/ApiResponse.dart';
import 'package:eventmanagement/features/auth/bloc/authentication_bloc.dart';
import 'package:eventmanagement/features/auth/models/TokenModel.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApiHandler {
  final String baseUrl;
  late Dio _dio;
  final BuildContext? context;

  ApiHandler(this.baseUrl, this.context) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      // connectTimeout: const Duration(milliseconds: 5000),
      // receiveTimeout: const Duration(milliseconds: 3000),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        log("REQUEST[${options.method}] => PATH: ${options.path} => DATA: ${options.data}");
        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        log("RESPONSE[${response.statusCode}] => DATA: ${response.data}");
        return handler.next(response);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        log("ERROR[${error.response?.statusCode}] => MESSAGE: ${error.message}");

        if (error.response?.statusCode == 401) {
          String? newAccessToken = await refreshToken();
          if (newAccessToken == null) {
            return handler.next(error);
          }
          error.requestOptions.headers['authorization'] =
              'Bearer $newAccessToken';
          return handler.resolve(await _dio.fetch(error.requestOptions));
        }
        return handler.next(error);
      },
    ));
  }

  Future<String?> refreshToken() async {
    if (context == null) {
      return null;
    } else {
      String? refreshToken = (context?.read<AuthenticationBloc>().state
              as AuthenticationAuthenticated)
          .tokenModel
          .refreshToken;
      ApiResponse<TokenModel> newTokens = await post<TokenModel>(
        token: refreshToken,
        route: 'auth/refresh-tokens',
        data: jsonEncode({
          {"refreshToken": refreshToken}
        }),
        fromJson: (p0) => TokenModel.fromMap(p0),
      );

      context?.read<AuthenticationBloc>().add(NewTokensEvent(newTokens.data));
      return newTokens.data.refreshToken;
    }
  }

  Future<ApiResponse<T>> get<T>({
    required String token,
    required String route,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      Response response = await _dio.get(
        route,
        options: Options(
          headers: {
            "authorization": "Bearer $token",
            'Content-Type': 'application/json'
          },
        ),
      );
      return ApiResponse<T>.fromMap(response.data, fromJson);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    }
  }

  Future<ApiResponse<T>> post<T>({
    required String token,
    required String route,
    required Object data,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      Options options;
      if (data is FormData) {
        options = Options(
          headers: {
            "authorization": "Bearer $token",
          },
        );
      } else {
        options = Options(
          headers: {
            "authorization": "Bearer $token",
            'Content-Type': 'application/json',
          },
        );
      }

      Response response = await _dio.post(
        route,
        data: data,
        options: options,
      );
      return ApiResponse<T>.fromMap(response.data, fromJson);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    }
  }

  Future<ApiResponse<T>> patch<T>({
    required String token,
    required String route,
    Object? data,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      Response response = await _dio.patch(
        route,
        data: data,
        options: Options(
          headers: {
            "authorization": "Bearer $token",
            // 'Content-Type': 'application/json'
          },
        ),
      );
      return ApiResponse<T>.fromMap(response.data, fromJson);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    }
  }

  Future<ApiResponse<T>> put<T>({
    required String token,
    required String route,
    Object? data,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      Response response = await _dio.put(
        route,
        data: data,
        options: Options(
          headers: {
            "authorization": "Bearer $token",
            'Content-Type': 'application/json'
          },
        ),
      );
      return ApiResponse<T>.fromMap(response.data, fromJson);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    }
  }

  Future<ApiResponse<T>> delete<T>({
    required String token,
    required String route,
    Object? data,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      Response response = await _dio.delete(
        route,
        data: data,
        options: Options(
          headers: {
            "authorization": "Bearer $token",
            'Content-Type': 'application/json'
          },
        ),
      );
      return ApiResponse<T>.fromMap(response.data, fromJson);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    }
  }

  ApiResponse<T> _handleDioError<T>(DioException error) {
    final statusCode = error.response?.statusCode ?? 500;
    final msg = _getDioErrorMsg(error);

    final exceptionMsg =
        ApiResponse<T>(msg: msg, status: statusCode, data: null as T);
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
        return "Request cancelled";
      case DioExceptionType.unknown:
        return "No Internet Connection";
      case DioExceptionType.badCertificate:
        return "Bad Certificate";
      case DioExceptionType.connectionError:
        return "Connection Error";
      default:
        return "Unknown Error";
    }
    return "Unknown Error";
  }
}
