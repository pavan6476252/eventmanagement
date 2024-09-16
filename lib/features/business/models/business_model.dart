import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String type;
  final List<double> coordinates;

  const Address({required this.type, required this.coordinates});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }

  @override
  List<Object?> get props => [type, coordinates];
}

class Banner extends Equatable {
  final String secureUrl;
  final String publicId;
  final String mimeType;

  const Banner(
      {required this.secureUrl,
      required this.publicId,
      required this.mimeType});

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      secureUrl: json['secure_url'],
      publicId: json['public_id'],
      mimeType: json['mime_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'secure_url': secureUrl,
      'public_id': publicId,
      'mime_type': mimeType,
    };
  }

  @override
  List<Object?> get props => [secureUrl, publicId, mimeType];
}

class BusinessModel extends Equatable {
  final Address address;
  final String? id;
  final String? owner;
  final String businessName;
  final Banner? banner;
  final String description;
  final String contactNumber;
  final String alternativeContactNumber;
  final String category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BusinessModel({
    required this.address,
    this.id,
    this.owner,
    this.banner,
    required this.businessName,
    required this.description,
    required this.contactNumber,
    required this.alternativeContactNumber,
    required this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      address: Address.fromJson(json['address']),
      id: json['_id'],
      owner: json['owner'],
      businessName: json['businessName'],
      banner: Banner.fromJson(json['banner']),
      description: json['description'],
      contactNumber: json['contactNumber'],
      alternativeContactNumber: json['alternativecontactNumber'],
      category: json['category'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'address': address.toJson(),
      'businessName': businessName,
      'banner': banner?.toJson(),
      'description': description,
      'contactNumber': contactNumber,
      'alternativecontactNumber': alternativeContactNumber,
      'category': category,
    };
  }

  @override
  List<Object?> get props => [
        address,
        owner,
        businessName,
        banner,
        description,
        contactNumber,
        alternativeContactNumber,
        category,
        createdAt,
        updatedAt,
      ];

  BusinessModel copyWith({
    Address? address,
    String? id,
    String? owner,
    String? businessName,
    Banner? banner,
    String? description,
    String? contactNumber,
    String? alternativeContactNumber,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BusinessModel(
      address: address ?? this.address,
      id: id ?? this.id,
      owner: owner ?? this.owner,
      businessName: businessName ?? this.businessName,
      banner: banner ?? this.banner,
      description: description ?? this.description,
      contactNumber: contactNumber ?? this.contactNumber,
      alternativeContactNumber:
          alternativeContactNumber ?? this.alternativeContactNumber,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
