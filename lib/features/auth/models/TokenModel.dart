// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class TokenModel extends Equatable {
  final String accessToken;
  final String refreshToken;

  const TokenModel(
    this.accessToken,
    this.refreshToken,
  );

  TokenModel copyWith({
    String? accessToken,
    String? refreshToken,
  }) {
    return TokenModel(
      accessToken ?? this.accessToken,
      refreshToken ?? this.refreshToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  factory TokenModel.fromMap(Map<String, dynamic> map) {
    return TokenModel(
      map['accessToken'] as String,
      map['refreshToken'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TokenModel.fromJson(String source) =>
      TokenModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TokenModel(accessToken: $accessToken, refreshToken: $refreshToken)';

  @override
  // TODO: implement props
  List<Object?> get props => [accessToken, refreshToken];
}
