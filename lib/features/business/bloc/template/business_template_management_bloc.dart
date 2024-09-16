import 'package:equatable/equatable.dart';
import 'package:eventmanagement/api/ApiResponse.dart';
import 'package:eventmanagement/features/auth/bloc/authentication_bloc.dart';
import 'package:eventmanagement/features/business/models/business_template_model.dart';
import 'package:eventmanagement/services/business_template_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'business_template_management_event.dart';
part 'business_template_management_state.dart';

class BusinessTemplateManagementBloc extends Bloc<
    BusinessTemplateManagementEvent, BusinessTemplateManagementState> {
  final BuildContext context;
  final BusinessTemplateService templateRepository;

  BusinessTemplateManagementBloc(this.context, this.templateRepository)
      : super(BusinessTemplateManagementState.initial()) {
    on<CreateBusinessTemplateEvent>(_onCreateTemplates);
    on<FetchBusinessTemplateEvent>(_onFetchTemplates);
    on<UpdateBusinessTemplateEvent>(_onUpdateTemplate);
    on<DeleteBusinessTemplateEvent>(_onDeleteTemplate);
  }

  Future<void> _onCreateTemplates(
    CreateBusinessTemplateEvent event,
    Emitter<BusinessTemplateManagementState> emit,
  ) async {
    emit(state.copyWith(status: BusinessTemplateStatus.loading));
    try {
      final authBloc = context.read<AuthenticationBloc>();
      if (authBloc.state is AuthenticationAuthenticated) {
        String? accessToken = (authBloc.state as AuthenticationAuthenticated)
            .tokenModel
            .accessToken;
        ApiResponse<BusinessTemplateModel> response = await templateRepository
            .createTemplates(accessToken, event.template);
        if (response.status == 201) {
          emit(state.copyWith(
              status: BusinessTemplateStatus.createdTemplate,
              templates: state.templates
                  .copyWith(data: [...state.templates.data, response.data])));
        } else {
          emit(state.copyWith(
              status: BusinessTemplateStatus.failedCreatingTemplate,
              templates: state.templates
                  .copyWith(status: response.status, msg: response.msg)));
        }
      } else {
        emit(state.copyWith(status: BusinessTemplateStatus.fetchFailed));
      }
    } catch (e) {
      emit(state.copyWith(status: BusinessTemplateStatus.fetchFailed));
    }
  }

  Future<void> _onFetchTemplates(
    FetchBusinessTemplateEvent event,
    Emitter<BusinessTemplateManagementState> emit,
  ) async {
    emit(state.copyWith(status: BusinessTemplateStatus.loading));
    try {
      final authBloc = context.read<AuthenticationBloc>();
      if (authBloc.state is AuthenticationAuthenticated) {
        String? accessToken = (authBloc.state as AuthenticationAuthenticated)
            .tokenModel
            .accessToken;
        final response = await templateRepository.fetchTemplates(
            accessToken, event.businessId);
        emit(state.copyWith(
          status: BusinessTemplateStatus.fetchSuccess,
          templates: response,
        ));
      } else {
        emit(state.copyWith(status: BusinessTemplateStatus.fetchFailed));
      }
    } catch (e) {
      emit(state.copyWith(status: BusinessTemplateStatus.fetchFailed));
    }
  }

  Future<void> _onUpdateTemplate(
    UpdateBusinessTemplateEvent event,
    Emitter<BusinessTemplateManagementState> emit,
  ) async {
    emit(state.copyWith(status: BusinessTemplateStatus.loading));
    try {
      final authBloc = context.read<AuthenticationBloc>();
      if (authBloc.state is AuthenticationAuthenticated) {
        String? accessToken = (authBloc.state as AuthenticationAuthenticated)
            .tokenModel
            .accessToken;
        final response = await templateRepository.updateTemplate(
            accessToken, event.businessId, event.template);

        final updatedTemplates = state.templates.data.map((template) {
          if (template.id == event.template.id) {
            return response.data;
          }
          return template;
        }).toList();

        emit(state.copyWith(
          status: BusinessTemplateStatus.updateSuccess,
          templates: state.templates.copyWith(data: updatedTemplates),
        ));
      } else {
        emit(state.copyWith(status: BusinessTemplateStatus.updateFailed));
      }
    } catch (e) {
      emit(state.copyWith(status: BusinessTemplateStatus.updateFailed));
    }
  }

  Future<void> _onDeleteTemplate(
    DeleteBusinessTemplateEvent event,
    Emitter<BusinessTemplateManagementState> emit,
  ) async {
    emit(state.copyWith(status: BusinessTemplateStatus.loading));
    try {
      final authBloc = context.read<AuthenticationBloc>();
      if (authBloc.state is AuthenticationAuthenticated) {
        String? accessToken = (authBloc.state as AuthenticationAuthenticated)
            .tokenModel
            .accessToken;
        await templateRepository.deleteTemplate(
            accessToken, event.businessId, event.templateId);

        final updatedTemplates = state.templates.data
            .where((template) => template.id != event.templateId)
            .toList();

        emit(state.copyWith(
          status: BusinessTemplateStatus.deleteSuccess,
          templates: state.templates.copyWith(data: updatedTemplates),
        ));
      } else {
        emit(state.copyWith(status: BusinessTemplateStatus.deleteFailed));
      }
    } catch (e) {
      emit(state.copyWith(status: BusinessTemplateStatus.deleteFailed));
    }
  }

  @override
  BusinessTemplateManagementState? fromJson(Map<String, dynamic> json) {
    if (json['myBusinessesTemplates'] != null) {
      return BusinessTemplateManagementState(
        status: BusinessTemplateStatus.fetchSuccess,
        templates: ApiResponse.fromMap(
          json['myBusinessesTemplates'],
          (p0) => (p0 as List<dynamic>)
              .map((business) => BusinessTemplateModel.fromJson(
                  business as Map<String, dynamic>))
              .toList(),
        ),
      );
    }
    return BusinessTemplateManagementState.initial();
  }

  @override
  Map<String, dynamic>? toJson(BusinessTemplateManagementState state) {
    if (state.status == BusinessTemplateStatus.fetchSuccess ||
        state.status == BusinessTemplateStatus.updateSuccess ||
        state.status == BusinessTemplateStatus.deleteSuccess ||
        state.status == BusinessTemplateStatus.createdTemplate) {
      return {
        'myBusinessesTemplates': state.templates
            .toMap((p0) => p0.map((business) => business.toJson()).toList()),
      };
    } else {
      return null;
    }
  }
}
