// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  final String id;
  final String uid;
  final bool primary;
  final String addressLine;
  final int zipCode;
  final String cityName;
  final String state;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  const AddressModel({
    required this.id,
    required this.uid,
    required this.primary,
    required this.addressLine,
    required this.zipCode,
    required this.cityName,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id'],
      uid: json['uid'],
      primary: json['primary'],
      addressLine: json['address_line'],
      zipCode: json['zip_code'],
      cityName: json['city_name'],
      state: json['state'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'uid': uid,
      'primary': primary,
      'address_line': addressLine,
      'zip_code': zipCode,
      'city_name': cityName,
      'state': state,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }

  @override
  List<Object?> get props => [
        uid,
        primary,
        addressLine,
        zipCode,
        cityName,
        state,
        createdAt,
        updatedAt,
        version,
      ];

  AddressModel copyWith({
    String? id,
    String? uid,
    bool? primary,
    String? addressLine,
    int? zipCode,
    String? cityName,
    String? state,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return AddressModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      primary: primary ?? this.primary,
      addressLine: addressLine ?? this.addressLine,
      zipCode: zipCode ?? this.zipCode,
      cityName: cityName ?? this.cityName,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}
