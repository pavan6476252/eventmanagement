part of 'business_bloc.dart';

enum BusinessStatus {
  initial,
  loading,
  fetchSuccess,
  fetchFailed,
  updateSuccess,
  updateFailed,
  createSuccessfully,
  createOpFailed,
}

class BusinessState extends Equatable {
  final BusinessStatus businessStatus;
  final ApiResponse<List<BusinessModel>> businesses;
  final String selectedBusinessId;

  const BusinessState(
      {required this.businessStatus,
      required this.businesses,
      required this.selectedBusinessId});

  factory BusinessState.initial() {
    return const BusinessState(
        businessStatus: BusinessStatus.initial,
        selectedBusinessId: '',
        businesses:
            ApiResponse<List<BusinessModel>>(msg: '', status: 0, data: []));
  }

  BusinessState copyWith(
      {BusinessStatus? businessStatus,
      String? selectedBusinessId,
      ApiResponse<List<BusinessModel>>? businesses}) {
    return BusinessState(
        businessStatus: businessStatus ?? this.businessStatus,
        businesses: businesses ?? this.businesses,
        selectedBusinessId: selectedBusinessId ?? this.selectedBusinessId);
  }

  @override
  List<Object> get props => [businessStatus, businesses, selectedBusinessId];
}
