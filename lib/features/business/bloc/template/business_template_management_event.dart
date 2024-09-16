part of 'business_template_management_bloc.dart';

sealed class BusinessTemplateManagementEvent extends Equatable {
  const BusinessTemplateManagementEvent();

  @override
  List<Object> get props => [];
}

class FetchBusinessTemplateEvent extends BusinessTemplateManagementEvent {
  final String businessId;

  const FetchBusinessTemplateEvent(this.businessId);

  @override
  List<Object> get props => [businessId];
}

class UpdateBusinessTemplateEvent extends BusinessTemplateManagementEvent {
  final String businessId;
  final BusinessTemplateModel template;

  const UpdateBusinessTemplateEvent(this.businessId, this.template);

  @override
  List<Object> get props => [businessId, template];
}

class CreateBusinessTemplateEvent extends BusinessTemplateManagementEvent {
  final BusinessTemplateModel template;

  const CreateBusinessTemplateEvent(this.template);

  @override
  List<Object> get props => [template];
}

class DeleteBusinessTemplateEvent extends BusinessTemplateManagementEvent {
  final String businessId;
  final String templateId;

  const DeleteBusinessTemplateEvent(this.businessId, this.templateId);

  @override
  List<Object> get props => [businessId, templateId];
}
