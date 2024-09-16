part of 'business_bills_management_bloc.dart';

sealed class BusinessBillsManagementEvent extends Equatable {
  const BusinessBillsManagementEvent();

  @override
  List<Object> get props => [];
}

class FetchBusinessBillsEvent extends BusinessBillsManagementEvent {
  final String businessId;

  const FetchBusinessBillsEvent(this.businessId);

  @override
  List<Object> get props => [businessId];
}

class UpdateBusinessBillsEvent extends BusinessBillsManagementEvent {
  final String businessId;
  final BillResponseModel template;

  const UpdateBusinessBillsEvent(this.businessId, this.template);

  @override
  List<Object> get props => [businessId, template];
}

class CreateBusinessBillsEvent extends BusinessBillsManagementEvent {
  final BusinessBillCreationModel template;

  const CreateBusinessBillsEvent(this.template);

  @override
  List<Object> get props => [template];
}

class DeleteBusinessBillsEvent extends BusinessBillsManagementEvent {
  final String billId;

  const DeleteBusinessBillsEvent(this.billId);

  @override
  List<Object> get props => [billId];
}
