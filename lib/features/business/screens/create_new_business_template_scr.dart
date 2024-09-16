import 'dart:developer';

import 'package:eventmanagement/features/business/bloc/template/business_template_management_bloc.dart';
import 'package:eventmanagement/features/business/models/business_template_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateNewBusinessTemplate extends StatefulWidget {
  const CreateNewBusinessTemplate({super.key, required this.businessId});
  final String? businessId;
  @override
  State<CreateNewBusinessTemplate> createState() =>
      _CreateNewBusinessTemplateState();
}

class _CreateNewBusinessTemplateState extends State<CreateNewBusinessTemplate> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _templateNameController = TextEditingController();
  final TextEditingController _visibilityController =
      TextEditingController(text: 'public');
  final List<ItemModel> _items = [
    const ItemModel(
        details: "skdjfk nsksj sndk dn",
        itemName: "test 2",
        quantity: 5,
        rent_type: 'per_day',
        rentCost: 258),
    const ItemModel(
        details: "skdjfk nsksj sndk dn",
        itemName: "test 2",
        quantity: 5,
        rentCost: 258),
    const ItemModel(
        details: "skdjfk nsksj sndk dn",
        itemName: "test 2",
        rent_type: 'per_day',
        quantity: 5,
        rentCost: 258),
  ];

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (widget.businessId != null) {
        BusinessTemplateModel template = BusinessTemplateModel(
            businessId: widget.businessId!,
            templateName: _templateNameController.text,
            items: _items,
            visibility: _visibilityController.text);
        // log(template.toString());
        context
            .read<BusinessTemplateManagementBloc>()
            .add(CreateBusinessTemplateEvent(template));
      }
    } else {
      log('business id null');
    }
  }

  ScrollController tableScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Template'),
      ),
      body: BlocConsumer<BusinessTemplateManagementBloc,
          BusinessTemplateManagementState>(
        listener: (context, state) {
          if (state.status == BusinessTemplateStatus.createdTemplate) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Upload success")));
          }
          if (state.status == BusinessTemplateStatus.failedCreatingTemplate) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text("Upload failed")));
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _templateNameController,
                    decoration: const InputDecoration(
                        labelText: 'Template Name',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a template name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  DropdownMenu(
                      controller: _visibilityController,
                      label: const Text('Template Visibility'),
                      expandedInsets: const EdgeInsets.symmetric(horizontal: 0),
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(value: 'public', label: 'public'),
                        DropdownMenuEntry(value: 'private', label: 'private'),
                      ]),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Items',
                          style: Theme.of(context).textTheme.headlineSmall),
                      TextButton(
                        onPressed: () => _showItemDialog(),
                        child: const Text('Add Item'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Scrollbar(
                    controller: tableScrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: tableScrollController,
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
                              DataCell(Text(entry.value.rent_type.toString())),
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
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: state.status == BusinessTemplateStatus.loading
                        ? const CircularProgressIndicator()
                        : const Text('Submit'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
