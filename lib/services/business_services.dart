import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eventmanagement/api/ApiResponse.dart';
import 'package:eventmanagement/api/api_handler.dart';
import 'package:eventmanagement/features/business/models/business_model.dart';

class BusinessService {
  final ApiHandler apiHandler;

  BusinessService(this.apiHandler);

  Future<ApiResponse<BusinessModel?>> createBusiness(String accessToken,
      {required BusinessModel data, File? banner}) async {
    final x = {
      ...data.toJson(),
      'address': jsonEncode(data.address.toJson()),
    };
    FormData formData = FormData.fromMap(x);
    log(x.toString());

    if (banner != null) {
      // Add the banner file to the form data
      final file = await MultipartFile.fromFile(banner.path);
      formData.files.add(MapEntry('banner', file));
    }

    return await apiHandler.post<BusinessModel?>(
      token: accessToken,
      route: '/businesses',
      data: formData,
      fromJson: (json) => json == null ? null : BusinessModel.fromJson(json),
    );
  }

  Future<ApiResponse<BusinessModel>> updateBusiness(String accessToken,
      {required BusinessModel data, File? banner}) async {
    Map<String, dynamic> formData = {
      ...data.toJson(),
    };
    if (banner != null) {
      Map<String, dynamic> x = {'banner': banner};
      formData.addAll(x);
    }
    return await apiHandler.put<BusinessModel>(
        token: accessToken,
        route: '/business',
        data: formData,
        fromJson: (json) => BusinessModel.fromJson(json));
  }

  Future<ApiResponse<List<BusinessModel>>> getMyBusinesses(
    String accessToken,
  ) async {
    return await apiHandler.get<List<BusinessModel>>(
        token: accessToken,
        route: '/businesses/me',
        fromJson: (json) => (json as List<dynamic>)
            .map((business) =>
                BusinessModel.fromJson(business as Map<String, dynamic>))
            .toList());
  }
}
