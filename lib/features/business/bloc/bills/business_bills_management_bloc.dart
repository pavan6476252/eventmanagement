import 'package:equatable/equatable.dart';
import 'package:eventmanagement/api/ApiResponse.dart';
import 'package:eventmanagement/features/auth/bloc/authentication_bloc.dart';
import 'package:eventmanagement/features/business/models/business_bill_model.dart';
import 'package:eventmanagement/services/business_bills_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'business_bills_management_event.dart';
part 'business_bills_management_state.dart';

class BusinessBillsManagementBloc
    extends Bloc<BusinessBillsManagementEvent, BusinessBillsManagementState> {
  final BuildContext context;
  final BusinessBillsService billsRepository;

  BusinessBillsManagementBloc(this.context, this.billsRepository)
      : super(BusinessBillsManagementState.initial()) {
    on<CreateBusinessBillsEvent>(_onCreateBill);
    on<FetchBusinessBillsEvent>(_onFetchBills);
    on<UpdateBusinessBillsEvent>(_onUpdateBill);
    on<DeleteBusinessBillsEvent>(_onDeleteBill);
  }
  Future<void> _onCreateBill(
    CreateBusinessBillsEvent event,
    Emitter<BusinessBillsManagementState> emit,
  ) async {
    emit(state.copyWith(status: BusinessBillsStatus.loading));
    try {
      final authBloc = context.read<AuthenticationBloc>();
      if (authBloc.state is AuthenticationAuthenticated) {
        String? accessToken = (authBloc.state as AuthenticationAuthenticated)
            .tokenModel
            .accessToken;
        ApiResponse<BillResponseModel> response =
            await billsRepository.createBills(accessToken, event.template);
        if (response.status == 201 || response.status == 200) {
          emit(state.copyWith(
              status: BusinessBillsStatus.createdBill,
              bills: state.bills
                  .copyWith(data: [...state.bills.data, response.data])));
        } else {
          emit(state.copyWith(
              status: BusinessBillsStatus.failedCreatingBill,
              bills: state.bills
                  .copyWith(status: response.status, msg: response.msg)));
        }
      } else {
        emit(state.copyWith(status: BusinessBillsStatus.failedCreatingBill));
      }
    } catch (e) {
      emit(state.copyWith(status: BusinessBillsStatus.failedCreatingBill));
    }
  }

  Future<void> _onFetchBills(
    FetchBusinessBillsEvent event,
    Emitter<BusinessBillsManagementState> emit,
  ) async {
    emit(state.copyWith(status: BusinessBillsStatus.loading));
    try {
      final authBloc = context.read<AuthenticationBloc>();
      if (authBloc.state is AuthenticationAuthenticated) {
        String? accessToken = (authBloc.state as AuthenticationAuthenticated)
            .tokenModel
            .accessToken;
        final response =
            await billsRepository.fetchBills(accessToken, event.businessId);
        print("billsResponse: $response"); // Debug print
        emit(state.copyWith(
          status: BusinessBillsStatus.fetchSuccess,
          bills: response,
        ));
      } else {
        emit(state.copyWith(status: BusinessBillsStatus.fetchFailed));
      }
    } catch (e) {
      print("Fetch Bills Error: $e"); // Debug print
      emit(state.copyWith(status: BusinessBillsStatus.fetchFailed));
    }
  }

  Future<void> _onUpdateBill(
    UpdateBusinessBillsEvent event,
    Emitter<BusinessBillsManagementState> emit,
  ) async {
    emit(state.copyWith(status: BusinessBillsStatus.loading));
    try {
      final authBloc = context.read<AuthenticationBloc>();
      if (authBloc.state is AuthenticationAuthenticated) {
        String? accessToken = (authBloc.state as AuthenticationAuthenticated)
            .tokenModel
            .accessToken;
        final response = await billsRepository.updateBill(
            accessToken, event.businessId, event.template);

        final updatedTemplates = state.bills.data.map((template) {
          if (template.id == event.template.id) {
            return response.data;
          }
          return template;
        }).toList();

        emit(state.copyWith(
          status: BusinessBillsStatus.updateSuccess,
          bills: state.bills.copyWith(data: updatedTemplates),
        ));
      } else {
        emit(state.copyWith(status: BusinessBillsStatus.updateFailed));
      }
    } catch (e) {
      emit(state.copyWith(status: BusinessBillsStatus.updateFailed));
    }
  }

  Future<void> _onDeleteBill(
    DeleteBusinessBillsEvent event,
    Emitter<BusinessBillsManagementState> emit,
  ) async {
    emit(state.copyWith(status: BusinessBillsStatus.loading));
    try {
      final authBloc = context.read<AuthenticationBloc>();
      if (authBloc.state is AuthenticationAuthenticated) {
        String? accessToken = (authBloc.state as AuthenticationAuthenticated)
            .tokenModel
            .accessToken;
        await billsRepository.deleteBill(accessToken, event.billId);

        final updatedTemplates = state.bills.data
            .where((template) => template.id != event.billId)
            .toList();

        emit(state.copyWith(
          status: BusinessBillsStatus.deleteSuccess,
          bills: state.bills.copyWith(data: updatedTemplates),
        ));
      } else {
        emit(state.copyWith(status: BusinessBillsStatus.deleteFailed));
      }
    } catch (e) {
      emit(state.copyWith(status: BusinessBillsStatus.deleteFailed));
    }
  }

  @override
  BusinessBillsManagementState? fromJson(Map<String, dynamic> json) {
    if (json['myBusinessesBills'] != null) {
      return BusinessBillsManagementState(
        status: BusinessBillsStatus.fetchSuccess,
        bills: ApiResponse.fromMap(
          json['myBusinessesBills'],
          (p0) => (p0 as List<dynamic>)
              .map((business) =>
                  BillResponseModel.fromJson(business as Map<String, dynamic>))
              .toList(),
        ),
      );
    }
    return BusinessBillsManagementState.initial();
  }

  @override
  Map<String, dynamic>? toJson(BusinessBillsManagementState state) {
    if (state.status == BusinessBillsStatus.fetchSuccess ||
        state.status == BusinessBillsStatus.updateSuccess ||
        state.status == BusinessBillsStatus.deleteSuccess ||
        state.status == BusinessBillsStatus.createdBill) {
      return {
        'myBusinessesBills': state.bills
            .toMap((p0) => p0.map((business) => business.toJson()).toList()),
      };
    } else {
      return null;
    }
  }
}
