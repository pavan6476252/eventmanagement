import 'package:equatable/equatable.dart';

class BusinessTemplateModel extends Equatable {
  final String? id;
  final String businessId;
  final String templateName;
  final List<ItemModel> items;
  final String visibility;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BusinessTemplateModel({
    this.id,
    required this.businessId,
    required this.templateName,
    required this.items,
    required this.visibility,
    this.createdAt,
    this.updatedAt,
  });

  factory BusinessTemplateModel.fromJson(Map<String, dynamic> json) {
    return BusinessTemplateModel(
      id: json['_id'] as String?,
      businessId: json['businessId'] as String? ?? '',
      templateName: json['templateName'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => ItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      visibility: json['visibility'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'businessId': businessId,
      'templateName': templateName,
      'items': items.map((item) => item.toJson()).toList(),
      'visibility': visibility,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props =>
      [id, businessId, templateName, items, visibility, createdAt, updatedAt];
}

class ItemModel extends Equatable {
  final String itemName;
  final double rentCost;
  final int quantity;
  final String details;
  final String? rent_type;

  final String? id;

  const ItemModel({
    required this.itemName,
    required this.rentCost,
    required this.quantity,
    required this.details,
    this.rent_type,
    this.id,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      itemName: json['itemName'] as String? ?? '',
      rentCost: (json['rentCost'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      details: json['details'] as String? ?? '',
      rent_type: json['rent_type'] as String? ?? '',
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'rentCost': rentCost,
      'quantity': quantity,
      'details': details,
      'rent_type': rent_type,
      '_id': id,
    };
  }

  @override
  List<Object?> get props =>
      [itemName, rentCost, quantity, details, id, rent_type];
}
