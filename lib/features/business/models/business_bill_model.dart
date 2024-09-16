import 'package:equatable/equatable.dart';
import 'package:eventmanagement/features/business/models/business_model.dart';
import 'package:eventmanagement/features/business/models/business_template_model.dart';
import 'package:eventmanagement/features/profile/models/profile_model.dart';

class BusinessBillCreationModel extends Equatable {
  final String? id;
  final String business;
  final String customer;
  final String? template;
  final List<ItemModel> items;
  final double totalCost;
  final double finalCost;
  final DateTime issueDate;
  final String status;
  final String? invoiceNumber;
  final PaymentInfo paymentInfo;

  const BusinessBillCreationModel({
    this.id,
    required this.business,
    required this.customer,
    this.template,
    required this.items,
    required this.totalCost,
    required this.finalCost,
    required this.issueDate,
    required this.status,
    this.invoiceNumber,
    required this.paymentInfo,
  });

  factory BusinessBillCreationModel.fromJson(Map<String, dynamic> json) {
    return BusinessBillCreationModel(
      id: json['id'] as String?,
      business: json['business'],
      customer: json['customer'],
      template: json['template'],
      items: (json['items'] as List<dynamic>)
          .map((item) => ItemModel.fromJson(item))
          .toList(),
      totalCost: json['totalCost'].toDouble(),
      finalCost: json['finalCost'].toDouble(),
      issueDate: DateTime.parse(json['issueDate']),
      status: json['status'],
      invoiceNumber: json['invoiceNumber'],
      paymentInfo: PaymentInfo.fromJson(json['paymentInfo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'business': business,
      'customer': customer,
      'template': template,
      'items': items.map((item) => item.toJson()).toList(),
      'totalCost': totalCost,
      'finalCost': finalCost,
      'issueDate': issueDate.toIso8601String(),
      'status': status,
      'invoiceNumber': invoiceNumber,
      'paymentInfo': paymentInfo.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        business,
        customer,
        template,
        items,
        totalCost,
        finalCost,
        issueDate,
        status,
        invoiceNumber,
        paymentInfo,
      ];
}

class BillResponseModel extends Equatable {
  final String? id;
  final BusinessModel business;
  final UserModel customer;
  final String? template;
  final List<ItemModel> items;
  final double totalCost;
  final double finalCost;
  final DateTime issueDate;
  final String status;
  final String? invoiceNumber;
  final PaymentInfo paymentInfo;

  const BillResponseModel({
    this.id,
    required this.business,
    required this.customer,
    this.template,
    required this.items,
    required this.totalCost,
    required this.finalCost,
    required this.issueDate,
    required this.status,
    this.invoiceNumber,
    required this.paymentInfo,
  });

  factory BillResponseModel.fromJson(Map<String, dynamic> json) {
    return BillResponseModel(
      id: json['_id'] as String?,
      business: BusinessModel.fromJson(json['business']),
      customer: UserModel.fromJson(json['customer']),
      template: json['template'],
      items: (json['items'] as List<dynamic>)
          .map((item) => ItemModel.fromJson(item))
          .toList(),
      totalCost: (json['totalCost'] as num).toDouble(),
      finalCost: (json['finalCost'] as num).toDouble(),
      issueDate: DateTime.parse(json['issueDate']),
      status: json['status'],
      invoiceNumber: json['invoiceNumber'],
      paymentInfo: PaymentInfo.fromJson(json['paymentInfo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'business': business.toJson(),
      'customer': customer.toJson(),
      'template': template,
      'items': items.map((item) => item.toJson()).toList(),
      'totalCost': totalCost,
      'finalCost': finalCost,
      'issueDate': issueDate.toIso8601String(),
      'status': status,
      'invoiceNumber': invoiceNumber,
      'paymentInfo': paymentInfo.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        business,
        customer,
        template,
        items,
        totalCost,
        finalCost,
        issueDate,
        status,
        invoiceNumber,
        paymentInfo,
      ];
}

class PaymentInfo extends Equatable {
  final String method;
  final String? transactionId;
  final String status;

  const PaymentInfo({
    required this.method,
    this.transactionId,
    required this.status,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      method: json['method'],
      transactionId: json['transactionId'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'transactionId': transactionId,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [method, transactionId, status];
}
