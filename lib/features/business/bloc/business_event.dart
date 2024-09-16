part of 'business_bloc.dart';

sealed class BusinessEvent extends Equatable {
  const BusinessEvent();

  @override
  List<Object> get props => [];
}

class FetchMyBusinessesEvent extends BusinessEvent {}

class CreateMyNewBusinessEvent extends BusinessEvent {
  final BusinessModel businessModel;
  final File? banner;
  const CreateMyNewBusinessEvent(this.businessModel, this.banner);

  @override
  List<Object> get props => [businessModel];
}

class UpdateMyBusinessEvent extends BusinessEvent {
  final BusinessModel businessModel;
  final File? banner;
  const UpdateMyBusinessEvent(this.businessModel, this.banner);
  @override
  List<Object> get props => [businessModel];
}

class ChangeMySelectedBusinessEvent extends BusinessEvent {
  final String selectedBusinessId;
  const ChangeMySelectedBusinessEvent(this.selectedBusinessId);

  @override
  List<Object> get props => [selectedBusinessId];
}
