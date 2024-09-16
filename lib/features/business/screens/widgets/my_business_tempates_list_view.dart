import 'dart:developer';

import 'package:eventmanagement/features/business/bloc/business_bloc.dart';
import 'package:eventmanagement/features/business/bloc/template/business_template_management_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyBusinessTemplatesListView extends StatefulWidget {
  const MyBusinessTemplatesListView({
    super.key,
  });

  @override
  State<MyBusinessTemplatesListView> createState() =>
      _MyBusinessTemplatesListViewState();
}

class _MyBusinessTemplatesListViewState
    extends State<MyBusinessTemplatesListView> {
  @override
  void initState() {
    super.initState();
    // final temBloc = context.read<BusinessBloc>();
    // log("${temBloc.state.businessStatus}");
    // if (temBloc.state.businesses.data.isNotEmpty) {
    //   final businessId = temBloc.state.businesses.data.first.id;
    //   if (businessId != null) {
    //     context
    //         .read<BusinessTemplateManagementBloc>()
    //         .add(FetchBusinessTemplateEvent(businessId));
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 250,
      width: double.maxFinite,
      child: BlocConsumer<BusinessTemplateManagementBloc,
          BusinessTemplateManagementState>(
        builder: (context, state) {
          final templateData = state.templates.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Business Templates', style: style.titleSmall),
                    if ((templateData.isEmpty ||
                            state.status ==
                                BusinessTemplateStatus.fetchSuccess) &&
                        (state.status != BusinessTemplateStatus.loading))
                      if (templateData.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            context.goNamed('createNewBusinessTemplate',
                                pathParameters: {
                                  'businessId': templateData[0].businessId
                                });
                          },
                          child: const Text('Create'),
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              if (state.status == BusinessTemplateStatus.fetchFailed)
                const Center(
                  child: Text('Fetching failed'),
                ),
              if (templateData.isEmpty &&
                  (state.status == BusinessTemplateStatus.fetchSuccess))
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No Templates found.'),
                      TextButton(
                        onPressed: () {
                          final selectedBusinessId = context
                              .read<BusinessBloc>()
                              .state
                              .selectedBusinessId;
                          if (selectedBusinessId.isNotEmpty) {
                            context.goNamed('createNewBusinessTemplate',
                                pathParameters: {
                                  'businessId': selectedBusinessId
                                });
                          } else {
                            log("selectedBusinessId is null");
                          }
                        },
                        child: const Text("Create Now"),
                      ),
                    ],
                  ),
                ),
              if (templateData.isNotEmpty)
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: templateData.length,
                    itemBuilder: (context, index) {
                      final template = templateData[index];
                      return SizedBox(
                        width: 300,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          template.templateName,
                                          style: style.titleMedium?.copyWith(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Chip(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 0),
                                              color: WidgetStatePropertyAll(
                                                  template.visibility ==
                                                          'private'
                                                      ? color.errorContainer
                                                      : color.primaryContainer),
                                              label: Text(
                                                template.visibility,
                                              ),
                                            ),
                                            PopupMenuButton(
                                              padding: const EdgeInsets.all(5),
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  onTap: () {
                                                    context.goNamed(
                                                        'createNewBusinessBill',
                                                        queryParameters: {
                                                          'templateId':
                                                              template.id
                                                        });
                                                    print(template.id);
                                                  },
                                                  child: const Row(
                                                    children: [
                                                      Icon(Icons.done),
                                                      SizedBox(width: 5),
                                                      Text("Use")
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuItem(
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.edit),
                                                      SizedBox(width: 5),
                                                      Text("Edit")
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuItem(
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.delete),
                                                      SizedBox(width: 5),
                                                      Text("Delete")
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: template.items.length,
                                        itemBuilder: (context, itemIndex) {
                                          final item =
                                              template.items[itemIndex];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.itemName,
                                                ),
                                                Text(
                                                  'Details: ${item.details}',
                                                ),
                                                Text(
                                                  'Rent Cost: \$${item.rentCost.toStringAsFixed(2)}',
                                                ),
                                                Text(
                                                  'Quantity: ${item.quantity}',
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (template.createdAt != null)
                                      Text(
                                        'Created At: ${template.createdAt}',
                                      ),
                                    if (template.updatedAt != null)
                                      Text(
                                        'Updated At: ${template.updatedAt}',
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (state.status == BusinessTemplateStatus.loading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if (state.status == BusinessTemplateStatus.fetchFailed)
                Center(
                  child: TextButton(
                    child: const Text('Load templates'),
                    onPressed: () {
                      final temBloc = context.read<BusinessBloc>();
                      if (temBloc.state.businesses.data.isNotEmpty) {
                        final businessId =
                            temBloc.state.businesses.data.first.id;
                        if (businessId != null) {
                          context
                              .read<BusinessTemplateManagementBloc>()
                              .add(FetchBusinessTemplateEvent(businessId));
                        }
                      }
                    },
                  ),
                ),
            ],
          );
        },
        listener: (context, state) {
          log('State [$this] ${state.status}');
        },
      ),
    );
  }
}
