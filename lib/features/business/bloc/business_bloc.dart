import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:eventmanagement/api/ApiResponse.dart';
import 'package:eventmanagement/features/auth/bloc/authentication_bloc.dart';
import 'package:eventmanagement/features/business/bloc/bills/business_bills_management_bloc.dart';
import 'package:eventmanagement/features/business/bloc/template/business_template_management_bloc.dart';
import 'package:eventmanagement/features/business/models/business_model.dart';
import 'package:eventmanagement/services/business_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'business_event.dart';
part 'business_state.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  final BusinessService businessService;
  final BuildContext context;

  BusinessBloc(this.context, this.businessService)
      : super(BusinessState.initial()) {
    on<FetchMyBusinessesEvent>((event, emit) async {
      emit(state.copyWith(businessStatus: BusinessStatus.loading));

      final authBloc = context.read<AuthenticationBloc>();
      if (authBloc.state is AuthenticationAuthenticated) {
        String? accessToken = (authBloc.state as AuthenticationAuthenticated)
            .tokenModel
            .accessToken;
        ApiResponse<List<BusinessModel>> response =
            await businessService.getMyBusinesses(accessToken);

        if (response.status == 200) {
          String businessId = state.selectedBusinessId.isEmpty
              ? response.data.firstOrNull?.id ?? ""
              : '';

          emit(state.copyWith(
            selectedBusinessId: businessId,
            businessStatus: BusinessStatus.fetchSuccess,
            businesses: response,
          ));
        } else {
          emit(state.copyWith(
            businessStatus: BusinessStatus.fetchFailed,
            businesses: response,
          ));
        }
      }
    });

    on<CreateMyNewBusinessEvent>((event, emit) async {
      emit(state.copyWith(businessStatus: BusinessStatus.loading));

      final authBloc = context.read<AuthenticationBloc>();
      if (authBloc.state is AuthenticationAuthenticated) {
        String? accessToken = (authBloc.state as AuthenticationAuthenticated)
            .tokenModel
            .accessToken;
        ApiResponse<BusinessModel?> response =
            await businessService.createBusiness(
          accessToken,
          data: event.businessModel,
          banner: event.banner,
        );

        if (response.status == 201) {
          final updatedBusinesses =
              List<BusinessModel>.from(state.businesses.data);
          if (response.data != null) updatedBusinesses.add(response.data!);
          emit(state.copyWith(
            businessStatus: BusinessStatus.createSuccessfully,
            businesses: ApiResponse(
                msg: response.msg,
                status: response.status,
                data: updatedBusinesses),
          ));
        } else {
          emit(state.copyWith(
            businessStatus: BusinessStatus.createOpFailed,
            businesses: state.businesses
                .copyWith(msg: response.msg, status: response.status),
          ));
        }
      }
    });

    on<UpdateMyBusinessEvent>((event, emit) async {
      emit(state.copyWith(businessStatus: BusinessStatus.loading));

      final authBloc = context.read<AuthenticationBloc>();
      if (authBloc.state is AuthenticationAuthenticated) {
        String? accessToken = (authBloc.state as AuthenticationAuthenticated)
            .tokenModel
            .accessToken;
        ApiResponse<BusinessModel> response =
            await businessService.updateBusiness(
          accessToken,
          data: event.businessModel,
          banner: event.banner,
        );

        if (response.status == 201 || response.status == 200) {
          final updatedBusinesses =
              List<BusinessModel>.from(state.businesses.data)
                ..add(response.data);
          emit(state.copyWith(
            businessStatus: BusinessStatus.updateSuccess,
            businesses: ApiResponse(
                msg: response.msg,
                status: response.status,
                data: updatedBusinesses),
          ));
        } else {
          emit(state.copyWith(
            businessStatus: BusinessStatus.updateFailed,
            businesses: state.businesses
                .copyWith(msg: response.msg, status: response.status),
          ));
        }
      }
    });

    on<ChangeMySelectedBusinessEvent>(
      (event, emit) {
        emit(state.copyWith(selectedBusinessId: event.selectedBusinessId));
      },
    );
  }

  @override
  BusinessState? fromJson(Map<String, dynamic> json) {
    if (json['myBusinesses'] != null) {
      return BusinessState(
        businessStatus: BusinessStatus.fetchSuccess,
        selectedBusinessId: json['selectedBusinessId'],
        businesses: ApiResponse.fromMap(
          json['myBusinesses'],
          (p0) => (p0 as List<dynamic>)
              .map((business) => BusinessModel.fromJson(business))
              .toList(),
        ),
      );
    }
    return BusinessState.initial();
  }

  @override
  Map<String, dynamic>? toJson(BusinessState state) {
    if (state.businessStatus == BusinessStatus.fetchSuccess ||
        state.businessStatus == BusinessStatus.updateSuccess ||
        state.businessStatus == BusinessStatus.createSuccessfully) {
      return {
        'myBusinesses': state.businesses
            .toMap((p0) => p0.map((business) => business.toJson()).toList()),
        'selectedBusinessId': state.selectedBusinessId
      };
    } else {
      return null;
    }
  }
}
