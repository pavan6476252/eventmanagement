// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:eventmanagement/features/profile/models/address_model.dart';

class UserModel extends Equatable {
  final String id;
  final String uid;
  final String? email;
  final bool emailVerified;
  final PhotoUrlModel photoUrlModel;
  final List<String> role;
  final String accountStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final AddressModel? address;

  const UserModel({
    required this.id,
    required this.uid,
    this.email,
    required this.emailVerified,
    required this.photoUrlModel,
    required this.role,
    required this.accountStatus,
    required this.createdAt,
    required this.updatedAt,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print(json["address"].runtimeType == String);
    return UserModel(
      id: json['_id'],
      uid: json['uid'],
      email: json['email'],
      emailVerified: json['email_verified'],
      photoUrlModel: PhotoUrlModel.fromJson(json['photo_url']),
      role: List<String>.from(json['role']),
      accountStatus: json['accountStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      address:
          (json["address"] == null || json["address"].runtimeType == String)
              ? null
              : AddressModel.fromJson(json["address"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'uid': uid,
      'email': email,
      'email_verified': emailVerified,
      'photo_url': photoUrlModel.toJson(),
      'role': role,
      'accountStatus': accountStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'address': address?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        uid,
        email,
        emailVerified,
        photoUrlModel,
        role,
        accountStatus,
        createdAt,
        updatedAt,
        firstName,
        lastName,
        phoneNumber,
        address,
      ];

  UserModel copyWith({
    String? id,
    String? uid,
    String? email,
    bool? emailVerified,
    PhotoUrlModel? photoUrlModel,
    List<String>? role,
    String? accountStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    AddressModel? address,
  }) {
    return UserModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      photoUrlModel: photoUrlModel ?? this.photoUrlModel,
      role: role ?? this.role,
      accountStatus: accountStatus ?? this.accountStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
    );
  }
}

class PhotoUrlModel extends Equatable {
  final String secureUrl;
  final String? publicId;
  final String? mimeType;
  final String? uploadedType;

  const PhotoUrlModel({
    required this.secureUrl,
    this.publicId,
    this.mimeType,
    required this.uploadedType,
  });

  factory PhotoUrlModel.fromJson(Map<String, dynamic> json) {
    return PhotoUrlModel(
      secureUrl: json['secure_url'],
      publicId: json['public_id'],
      mimeType: json['mime_type'],
      uploadedType: json['uploaded_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'secure_url': secureUrl,
      'public_id': publicId,
      'mime_type': mimeType,
      'uploaded_type': uploadedType,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [secureUrl, publicId, mimeType, uploadedType];

  PhotoUrlModel copyWith({
    String? secureUrl,
    String? publicId,
    String? mimeType,
    String? uploadedType,
  }) {
    return PhotoUrlModel(
      secureUrl: secureUrl ?? this.secureUrl,
      publicId: publicId ?? this.publicId,
      mimeType: mimeType ?? this.mimeType,
      uploadedType: uploadedType ?? this.uploadedType,
    );
  }
}
