part of 'business_template_management_bloc.dart';

enum BusinessTemplateStatus {
  initial,
  loading,
  createdTemplate,
  failedCreatingTemplate,
  fetchSuccess,
  fetchFailed,
  updateSuccess,
  updateFailed,
  deleteSuccess,
  deleteFailed,
}

class BusinessTemplateManagementState extends Equatable {
  final BusinessTemplateStatus status;
  final ApiResponse<List<BusinessTemplateModel>> templates;

  const BusinessTemplateManagementState(
      {required this.status, required this.templates});

  factory BusinessTemplateManagementState.initial() {
    return const BusinessTemplateManagementState(
      status: BusinessTemplateStatus.initial,
      templates: ApiResponse<List<BusinessTemplateModel>>(
          msg: '', status: 0, data: []),
    );
  }

  BusinessTemplateManagementState copyWith({
    BusinessTemplateStatus? status,
    ApiResponse<List<BusinessTemplateModel>>? templates,
  }) {
    return BusinessTemplateManagementState(
      status: status ?? this.status,
      templates: templates ?? this.templates,
    );
  }

  @override
  List<Object> get props => [status, templates];
}
