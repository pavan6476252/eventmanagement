import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventmanagement/features/business/bloc/business_bloc.dart';
import 'package:eventmanagement/features/business/bloc/template/business_template_management_bloc.dart';
import 'package:eventmanagement/features/business/screens/widgets/my_business_bills_list_view.dart';
import 'package:eventmanagement/features/business/screens/widgets/my_business_tempates_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyBusinessesScreen extends StatefulWidget {
  const MyBusinessesScreen({super.key});

  @override
  State<MyBusinessesScreen> createState() => _MyBusinessesScreenState();
}

class _MyBusinessesScreenState extends State<MyBusinessesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _fetchData();
  }

  _fetchData() async {
    final temBloc = context.read<BusinessBloc>();
    temBloc.add(FetchMyBusinessesEvent());

    if (temBloc.state.businesses.data.isNotEmpty) {
      final businessId = temBloc.state.businesses.data[0].id;

      if (businessId != null) {
        context
            .read<BusinessTemplateManagementBloc>()
            .add(FetchBusinessTemplateEvent(businessId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Businesses'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _fetchData();
        },
        child: ListView(
          children: [
            _buildBusinessHorizontalList(context),
            const MyBusinessTemplatesListView(),
            const MyBusinessBillsListView()
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessHorizontalList(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 220,
      width: double.maxFinite,
      child: BlocConsumer<BusinessBloc, BusinessState>(
        builder: (context, state) {
          final businessData = state.businesses.data;
          if (state.businessStatus == BusinessStatus.fetchFailed) {
            return const Center(
              child: Text('Fetching failed'),
            );
          }
          if (businessData.isEmpty &&
              state.businessStatus == BusinessStatus.fetchSuccess) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No businesses found.'),
                  TextButton(
                    onPressed: () {
                      context.goNamed('createNewBusiness');
                    },
                    child: const Text("Create Now"),
                  ),
                ],
              ),
            );
          }
          if (businessData.isNotEmpty) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: businessData.length,
              itemBuilder: (context, index) {
                final business = businessData[index];
                return Container(
                  width: MediaQuery.of(context).size.width - 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 0.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (business.banner?.secureUrl != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                          child: CachedNetworkImage(
                            imageUrl: business.banner!.secureUrl,
                            width: double.infinity,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 8),
                      ListTile(
                        title: Text(business.businessName,
                            style: style.titleSmall),
                        subtitle: Text(
                          business.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: style.labelSmall,
                        ),
                        trailing: state.selectedBusinessId == business.id
                            ? CircleAvatar(
                                child: Icon(
                                  Icons.done,
                                  color: color.primary,
                                ),
                              )
                            : TextButton(
                                onPressed: () {
                                  if (business.id != null) {
                                    context.read<BusinessBloc>().add(
                                        ChangeMySelectedBusinessEvent(
                                            business.id!));
                                  } else {
                                    log('bunsiness id not found');
                                  }
                                },
                                child: const Text('Select')),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return Center(
            child: TextButton(
              child: const Text('Load Businesses'),
              onPressed: () {
                context.read<BusinessBloc>().add(FetchMyBusinessesEvent());
              },
            ),
          );
        },
        listener: (context, state) {
          log('$state');
        },
      ),
    );
  }
}
