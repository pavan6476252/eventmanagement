
import 'package:eventmanagement/api/ApiResponse.dart';
import 'package:eventmanagement/api/api_handler.dart';
import 'package:eventmanagement/features/business/models/business_bill_model.dart';

class BusinessBillsService {
  final ApiHandler apiHandler;

  BusinessBillsService(this.apiHandler);

  Future<ApiResponse<BillResponseModel>> createBills(
      String token, BusinessBillCreationModel data) async {
    return await apiHandler.post(
        route: '/bills',
        token: token,
        data: data.toJson(),
        fromJson: (p0) =>
            BillResponseModel.fromJson(p0 as Map<String, dynamic>));
  }

  Future<ApiResponse<List<BillResponseModel>>> fetchBills(
      String token, String businessId) async {
    return await apiHandler.get(
      route: '/bills/business/$businessId',
      token: token,
      fromJson: (p0) => (p0 as List<dynamic>)
          .map((template) =>
              BillResponseModel.fromJson(template as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<BillResponseModel>> updateBill(
      String token, String businessId, BillResponseModel template) async {
    return apiHandler.put(
      token: token,
      route: '/bills/${template.id}',
      data: template.toJson(),
      fromJson: (p0) => BillResponseModel.fromJson(p0),
    );
  }

  Future<ApiResponse<BillResponseModel?>> deleteBill(
      String token, String billId) async {
    return await apiHandler.delete(
        token: token,
        route: 'bills/$billId',
        fromJson: (p0) => p0 == null ? null : BillResponseModel.fromJson(p0));
  }
}
