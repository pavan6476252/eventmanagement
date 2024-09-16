import 'dart:developer';

import 'package:eventmanagement/features/business/bloc/bills/business_bills_management_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyBusinessBillsListView extends StatefulWidget {
  const MyBusinessBillsListView({super.key});

  @override
  State<MyBusinessBillsListView> createState() =>
      _MyBusinessBillsListViewState();
}

class _MyBusinessBillsListViewState extends State<MyBusinessBillsListView> {
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 350,
      width: double.maxFinite,
      child: BlocConsumer<BusinessBillsManagementBloc,
          BusinessBillsManagementState>(
        builder: (context, state) {
          final billData = state.bills.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Business Bills', style: style.titleSmall),
                    if ((billData.isEmpty ||
                            state.status == BusinessBillsStatus.fetchSuccess) &&
                        (state.status != BusinessBillsStatus.loading))
                      TextButton(
                        onPressed: () {
                          context.goNamed('createNewBusinessBill');
                        },
                        child: const Text('Create'),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              if (state.status == BusinessBillsStatus.fetchFailed)
                const Center(
                  child: Text('Fetching failed'),
                ),
              if (billData.isEmpty &&
                  (state.status == BusinessBillsStatus.fetchSuccess))
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No Templates found.'),
                      TextButton(
                        onPressed: () {
                          context.goNamed('createNewBusinessTemplate');
                        },
                        child: const Text("Create Now"),
                      ),
                    ],
                  ),
                ),
              if (billData.isNotEmpty)
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: billData.length,
                    itemBuilder: (context, index) {
                      final bill = billData[index];
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
                                          bill.business.businessName,
                                          style: style.titleMedium?.copyWith(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: bill.items.length,
                                        itemBuilder: (context, itemIndex) {
                                          final item = bill.items[itemIndex];
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
              if (state.status == BusinessBillsStatus.loading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if (state.status == BusinessBillsStatus.fetchFailed)
                Center(
                  child: TextButton(
                    child: const Text('Load bills'),
                    onPressed: () {
                      final temBloc =
                          context.read<BusinessBillsManagementBloc>();
                      if (temBloc.state.bills.data.isNotEmpty) {
                        final businessId = temBloc.state.bills.data.first.id;
                        if (businessId != null) {
                          context
                              .read<BusinessBillsManagementBloc>()
                              .add(FetchBusinessBillsEvent(businessId));
                        }
                      }
                    },
                  ),
                ),
            ],
          );
        },
        listener: (context, state) {
          log('State Pavan [$this] ${state.status}');
        },
      ),
    );
  }
}
