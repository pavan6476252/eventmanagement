
import 'package:eventmanagement/api/ApiResponse.dart';
import 'package:eventmanagement/api/api_handler.dart';
import 'package:eventmanagement/features/business/models/business_template_model.dart';

class BusinessTemplateService {
  final ApiHandler apiHandler;

  BusinessTemplateService(this.apiHandler);

  Future<ApiResponse<BusinessTemplateModel>> createTemplates(
      String token, BusinessTemplateModel data) async {
    return await apiHandler.post(
        route: '/businesses/${data.businessId}/templates',
        token: token,
        data: data.toJson(),
        fromJson: (p0) =>
            BusinessTemplateModel.fromJson(p0 as Map<String, dynamic>));
  }

  Future<ApiResponse<List<BusinessTemplateModel>>> fetchTemplates(
      String token, String businessId) async {
    return await apiHandler.get(
      route: '/businesses/$businessId/templates',
      token: token,
      fromJson: (p0) => (p0 as List<dynamic>)
          .map((template) =>
              BusinessTemplateModel.fromJson(template as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<BusinessTemplateModel>> updateTemplate(
      String token, String businessId, BusinessTemplateModel template) async {
    return apiHandler.put(
      token: token,
      route: '/businesses/$businessId/templates/${template.id}',
      data: template.toJson(),
      fromJson: (p0) => BusinessTemplateModel.fromJson(p0),
    );
  }

  Future<ApiResponse<BusinessTemplateModel?>> deleteTemplate(
      String token, String businessId, String templateId) async {
    return await apiHandler.delete(
        token: token,
        route: '/businesses/$businessId/templates/$templateId',
        fromJson: (p0) =>
            p0 == null ? null : BusinessTemplateModel.fromJson(p0));
  }
}
