import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eventmanagement/api/ApiResponse.dart';
import 'package:eventmanagement/api/api_handler.dart';
import 'package:eventmanagement/features/profile/models/address_model.dart';
import 'package:eventmanagement/features/profile/models/profile_model.dart';

class UserService {
  final ApiHandler apiHandler;

  UserService(this.apiHandler);

  Future<ApiResponse<UserModel>> getUserProfile(String token) async {
    return await apiHandler.get<UserModel>(
        token: token,
        route: '/users/me',
        fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>));
  }

  Future<ApiResponse<Null>> updateUserProfile({
    required String token,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String accountStatus,
    File? photo,
  }) async {
    final formData = FormData.fromMap({
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'accountStatus': accountStatus,
      'photo': photo != null ? await MultipartFile.fromFile(photo.path) : null,
    });

    return await apiHandler.put<Null>(
      token: token,
      route: '/users',
      data: formData,
      fromJson: (json) => null,
    );
  }

  Future<ApiResponse<AddressModel>> createUserAddress({
    required String token,
    required String addressLine,
    required int zipCode,
    required String cityName,
    required String state,
  }) async {
    final body = {
      'address_line': addressLine,
      'zip_code': zipCode,
      'city_name': cityName,
      'state': state,
    };

    return await apiHandler.post<AddressModel>(
      token: token,
      route: '/users/address',
      data: body,
      fromJson: (json) => AddressModel.fromJson(json),
    );
  }

  Future<ApiResponse<AddressModel>> updateUserAddress({
    required String token,
    required String addressLine,
    required int zipCode,
    required String state,
  }) async {
    final body = {
      'address_line': addressLine,
      'zip_code': zipCode,
      'state': state,
    };

    return await apiHandler.put<AddressModel>(
      token: token,
      route: '/users/address',
      data: body,
      fromJson: (json) => AddressModel.fromJson(json),
    );
  }

  Future<ApiResponse<Null>> deleteUserAddress(String token) async {
    return await apiHandler.delete<Null>(
      token: token,
      route: '/users/address',
      fromJson: (_) => null,
    );
  }
}
