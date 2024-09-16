part of 'business_bills_management_bloc.dart';

enum BusinessBillsStatus {
  initial,
  loading,
  createdBill,
  failedCreatingBill,
  fetchSuccess,
  fetchFailed,
  updateSuccess,
  updateFailed,
  deleteSuccess,
  deleteFailed,
}

class BusinessBillsManagementState extends Equatable {
  final BusinessBillsStatus status;
  final ApiResponse<List<BillResponseModel>> bills;
  const BusinessBillsManagementState(
      {required this.status, required this.bills});

  BusinessBillsManagementState copyWith(
      {BusinessBillsStatus? status,
      ApiResponse<List<BillResponseModel>>? bills}) {
    return BusinessBillsManagementState(
        status: status ?? this.status, bills: bills ?? this.bills);
  }

  factory BusinessBillsManagementState.initial() {
    return const BusinessBillsManagementState(
      status: BusinessBillsStatus.initial,
      bills: ApiResponse<List<BillResponseModel>>(
          msg: '', status: 0, data: []),
    );
  }

  @override
  List<Object> get props => [status, bills];
}
