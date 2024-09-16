// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class ApiResponse<T> extends Equatable {
  final String msg;
  final int status;
  final T data;

  const ApiResponse({
    required this.msg,
    required this.status,
    required this.data,
  });

  Map<String, dynamic> toMap(Function(T) toMapFunction) {
    return <String, dynamic>{
      'msg': msg,
      'status': status,
      'data': toMapFunction(data),
    };
  }

  factory ApiResponse.fromMap(
    Map<String, dynamic> map,
    T Function(dynamic) fromMapFunction,
  ) {
    return ApiResponse<T>(
      msg: map['msg'] as String,
      status: map['status'] as int,
      data: fromMapFunction(map['data'] as dynamic),
    );
  }

  String toJson(Function(T) toMapFunction) => json.encode(toMap(toMapFunction));

  factory ApiResponse.fromJson(
    String source,
    T Function(dynamic) fromMapFunction,
  ) =>
      ApiResponse.fromMap(
        json.decode(source) as dynamic,
        fromMapFunction,
      );

  @override
  String toString() => 'ApiResponse(msg: $msg, status: $status, data: $data)';

  @override
  List<Object?> get props => [data, msg, status];

  ApiResponse<T> copyWith({
    String? msg,
    int? status,
    T? data,
  }) {
    return ApiResponse<T>(
      msg: msg ?? this.msg,
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}
