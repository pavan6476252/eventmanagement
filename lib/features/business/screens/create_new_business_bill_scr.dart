import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:eventmanagement/features/business/bloc/bills/business_bills_management_bloc.dart';
import 'package:eventmanagement/features/business/bloc/business_bloc.dart';
import 'package:eventmanagement/features/business/bloc/template/business_template_management_bloc.dart';
import 'package:eventmanagement/features/business/models/business_bill_model.dart';
import 'package:eventmanagement/features/business/models/business_template_model.dart';
import 'package:eventmanagement/features/business/screens/widgets/user_search_bottom_sheet.dart';
import 'package:eventmanagement/features/profile/models/profile_model.dart';
import 'package:eventmanagement/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

Future<List<UserModel>> fetchUsers() async {
  final response = await Dio().get('$baseUrl/users');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.data)['data'] as List;
    return data.map((json) => UserModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load users');
  }
}

class CreateNewBusinessBillScreen extends StatefulWidget {
  final String? templateId;
  const CreateNewBusinessBillScreen({super.key, required this.templateId});

  @override
  State<CreateNewBusinessBillScreen> createState() =>
      _CreateNewBusinessBillScreenState();
}

class _CreateNewBusinessBillScreenState
    extends State<CreateNewBusinessBillScreen> {
  UserModel? _selectedUser;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _totalCostController = TextEditingController();
  final TextEditingController _finalCostController = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _statusController =
      TextEditingController(text: 'issued');
  final TextEditingController _paymentMethodController =
      TextEditingController(text: 'cash');
  final TextEditingController _paymentStatusController =
      TextEditingController(text: 'pending');
  final TextEditingController _invoiceNumberController =
      TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedUser != null) {
      final bill = BusinessBillCreationModel(
        business: context.read<BusinessBloc>().state.selectedBusinessId ?? "",
        customer: _selectedUser!.id,
        items: _items,
        totalCost: double.parse(_totalCostController.text),
        finalCost: double.parse(_finalCostController.text),
        issueDate: DateFormat('yyyy/MM/dd').parse(_issueDateController.text),
        status: _statusController.text,
        paymentInfo: PaymentInfo(
          method: _paymentMethodController.text,
          status: _paymentStatusController.text,
        ),
        invoiceNumber: _invoiceNumberController.text.isEmpty
            ? null
            : _invoiceNumberController.text,
      );
      log(bill.toJson().toString());

      context
          .read<BusinessBillsManagementBloc>()
          .add(CreateBusinessBillsEvent(bill));
    } else {
      log('Form validation failed or user not selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Bill"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            Card(
              child: ListTile(
                trailing: TextButton(
                  child: const Text("Pick User"),
                  onPressed: () => _showUserPicker(context),
                ),
                title: _selectedUser != null
                    ? ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              _selectedUser!.photoUrlModel.secureUrl ??
                                  'https://via.placeholder.com/150'),
                        ),
                        title: Text(
                            '${_selectedUser!.firstName} ${_selectedUser!.lastName}'),
                        subtitle: Text(_selectedUser!.email ?? ""),
                      )
                    : null,
              ),
            ),
            // BlocBuilder<BusinessTemplateManagementBloc,
            //     BusinessTemplateManagementState>(
            //   builder: (context, state) {
            //     return MyWidget(
            //       businessTemplateModel: state.templates.data
            //           .firstWhere((bus) => bus.id == widget.templateId),
            //     );
            //   },
            // ),
            _renderTableContent(context),
            TextFormField(
              controller: _totalCostController,
              decoration: const InputDecoration(
                labelText: 'Total Cost',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter total cost';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _finalCostController,
              decoration: const InputDecoration(
                labelText: 'Final Cost',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter final cost';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2015, 8),
                    lastDate: DateTime.now());
                if (picked != null) {
                  _issueDateController.text =
                      "${picked.year}/${picked.month}/${picked.day}";
                }
              },
              controller: _issueDateController,
              decoration: const InputDecoration(
                labelText: 'Issue Date',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter issue date';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            DropdownMenu(
                controller: _statusController,
                hintText: 'Payment Status',
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 'issued', label: 'issued'),
                  DropdownMenuEntry(value: 'paid', label: 'paid'),
                  DropdownMenuEntry(value: 'cancelled', label: 'cancelled')
                ]),
            const Text('Payment Method'),
            DropdownMenu(
                controller: _paymentMethodController,
                hintText: 'Payment Method',
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 'cash', label: 'cash'),
                  DropdownMenuEntry(value: 'upi', label: 'upi'),
                ]),
            const SizedBox(height: 10),
            DropdownMenu(
                controller: _paymentStatusController,
                hintText: 'Payment Status',
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 'pending', label: 'pending'),
                  DropdownMenuEntry(value: 'complete', label: 'complete'),
                  DropdownMenuEntry(value: 'failed', label: 'failed')
                ]),
            const SizedBox(height: 10),
            TextFormField(
              controller: _invoiceNumberController,
              decoration: const InputDecoration(
                labelText: 'Invoice Number (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            BlocConsumer<BusinessBillsManagementBloc,
                BusinessBillsManagementState>(
              listener: (context, state) {
                if (state.status == BusinessBillsStatus.createdBill) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Success')));
                }
                if (state.status == BusinessBillsStatus.failedCreatingBill) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: color.errorContainer,
                      content: const Text('Failed')));
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state.status == BusinessBillsStatus.loading
                      ? null
                      : _submitForm,
                  child: state.status == BusinessBillsStatus.loading
                      ? const CircularProgressIndicator()
                      : const Text('Create Bill'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUserPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (BuildContext context) {
        return const UserSearchBottomSheet();
      },
    ).then((selectedUser) {
      if (selectedUser != null) {
        setState(() {
          _selectedUser = selectedUser;
        });
      }
    });
  }

  List<ItemModel> _items = [];
  void _calculateTotalCost() {
    double totalCost = 0;

    for (var item in _items) {
      log("$totalCost + ${item.rentCost} * ${item.quantity}");
      totalCost += (item.rentCost *
          item.quantity); // Use += to accumulate the total cost
    }

    log('Total Cost: $totalCost');
    _totalCostController.text = totalCost.toString();
  }

  void _addItem(ItemModel item) {
    setState(() {
      _items.add(item);
      _calculateTotalCost();
    });
  }

  void _editItem(int index, ItemModel item) {
    setState(() {
      _items[index] = item;
      _calculateTotalCost();
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      _calculateTotalCost();
    });
  }

  @override
  void initState() {
    super.initState();
    print("templateId ${widget.templateId}");
    if (widget.templateId != null) {
      BusinessTemplateModel? data;

      for (var bus in context
          .read<BusinessTemplateManagementBloc>()
          .state
          .templates
          .data) {
        if (bus.id == widget.templateId) {
          data = bus;
          break;
        }
      }

      _items = data?.items ?? [];
      _calculateTotalCost();
    }
  }

  final ScrollController _tableScrollController = ScrollController();

  void _showItemDialog({ItemModel? item, int? index}) {
    final TextEditingController itemNameController =
        TextEditingController(text: item != null ? item.itemName : '');

    final TextEditingController rentTypeController =
        TextEditingController(text: item?.rent_type ?? "per_day");
    final TextEditingController rentCostController = TextEditingController(
        text: item != null ? item.rentCost.toString() : '');
    final TextEditingController quantityController = TextEditingController(
        text: item != null ? item.quantity.toString() : '');
    final TextEditingController detailsController =
        TextEditingController(text: item != null ? item.details : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item == null ? 'Add Item' : 'Edit Item'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: itemNameController,
                  decoration: const InputDecoration(
                      labelText: 'Item Name', border: OutlineInputBorder()),
                ),
                TextFormField(
                  controller: rentCostController,
                  decoration: const InputDecoration(
                      labelText: 'Rent Cost', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
                DropdownMenu(
                  controller: rentTypeController,
                  expandedInsets: const EdgeInsets.symmetric(horizontal: 0),
                  label: const Text('Rent Type'),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 'per_day', label: 'per_day'),
                    DropdownMenuEntry(value: 'per_hour', label: 'per_hour'),
                  ],
                ),
                TextFormField(
                  controller: quantityController,
                  decoration: const InputDecoration(
                      labelText: 'Quantity', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: detailsController,
                  decoration: const InputDecoration(
                      labelText: 'Details', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newItem = ItemModel(
                    itemName: itemNameController.text,
                    rentCost: double.tryParse(rentCostController.text) ?? 0,
                    quantity: int.tryParse(quantityController.text) ?? 0,
                    details: detailsController.text,
                    rent_type: rentTypeController.text);
                if (item == null) {
                  _addItem(newItem);
                } else {
                  _editItem(index!, newItem);
                }
                Navigator.of(context).pop();
              },
              child: Text(item == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  _renderTableContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Items'),
              TextButton(
                onPressed: () => _showItemDialog(),
                child: const Text('Add Item'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Scrollbar(
            controller: _tableScrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _tableScrollController,
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Item Name')),
                  DataColumn(label: Text('Rent Cost')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Rent Type')),
                  DataColumn(label: Text('Details')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _items.asMap().entries.map((entry) {
                  return DataRow(
                    cells: [
                      DataCell(Text(entry.value.itemName)),
                      DataCell(Text(entry.value.rentCost.toString())),
                      DataCell(Text(entry.value.quantity.toString())),
                      DataCell(Text(entry.value.rent_type ?? "per_day")),
                      DataCell(Text(entry.value.details)),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showItemDialog(
                                  item: entry.value, index: entry.key),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeItem(entry.key),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key, this.businessTemplateModel});
  final BusinessTemplateModel? businessTemplateModel;

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.businessTemplateModel != null) {
      _items = widget.businessTemplateModel!.items;
    }
  }

  List<ItemModel> _items = [];

  void _addItem(ItemModel item) {
    setState(() {
      _items.add(item);
    });
  }

  void _editItem(int index, ItemModel item) {
    setState(() {
      _items[index] = item;
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _showItemDialog({ItemModel? item, int? index}) {
    final TextEditingController itemNameController =
        TextEditingController(text: item != null ? item.itemName : '');

    final TextEditingController rentTypeController =
        TextEditingController(text: item?.rent_type ?? "per_day");
    final TextEditingController rentCostController = TextEditingController(
        text: item != null ? item.rentCost.toString() : '');
    final TextEditingController quantityController = TextEditingController(
        text: item != null ? item.quantity.toString() : '');
    final TextEditingController detailsController =
        TextEditingController(text: item != null ? item.details : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item == null ? 'Add Item' : 'Edit Item'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: itemNameController,
                  decoration: const InputDecoration(
                      labelText: 'Item Name', border: OutlineInputBorder()),
                ),
                TextFormField(
                  controller: rentCostController,
                  decoration: const InputDecoration(
                      labelText: 'Rent Cost', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
                DropdownMenu(
                  controller: rentTypeController,
                  expandedInsets: const EdgeInsets.symmetric(horizontal: 0),
                  label: const Text('Rent Type'),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 'per_day', label: 'per_day'),
                    DropdownMenuEntry(value: 'per_hour', label: 'per_hour'),
                  ],
                ),
                TextFormField(
                  controller: quantityController,
                  decoration: const InputDecoration(
                      labelText: 'Quantity', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: detailsController,
                  decoration: const InputDecoration(
                      labelText: 'Details', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newItem = ItemModel(
                    itemName: itemNameController.text,
                    rentCost: double.tryParse(rentCostController.text) ?? 0,
                    quantity: int.tryParse(quantityController.text) ?? 0,
                    details: detailsController.text,
                    rent_type: rentTypeController.text);
                if (item == null) {
                  _addItem(newItem);
                } else {
                  _editItem(index!, newItem);
                }
                Navigator.of(context).pop();
              },
              child: Text(item == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Items'),
              TextButton(
                onPressed: () => _showItemDialog(),
                child: const Text('Add Item'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Scrollbar(
            controller: ScrollController(),
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Item Name')),
                  DataColumn(label: Text('Rent Cost')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Rent Type')),
                  DataColumn(label: Text('Details')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _items.asMap().entries.map((entry) {
                  return DataRow(
                    cells: [
                      DataCell(Text(entry.value.itemName)),
                      DataCell(Text(entry.value.rentCost.toString())),
                      DataCell(Text(entry.value.quantity.toString())),
                      DataCell(Text(entry.value.rent_type ?? "per_day")),
                      DataCell(Text(entry.value.details)),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showItemDialog(
                                  item: entry.value, index: entry.key),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeItem(entry.key),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
