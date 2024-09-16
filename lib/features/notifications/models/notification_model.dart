// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NotificationModel {
  final String id;
  final String message;
  final bool read;
  final String type;
  final dynamic payload;
  final DateTime? createdAt;

  NotificationModel({
    required this.id,
    required this.message,
    required this.read,
    required this.type,
    this.payload,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'message': message,
      'read': read,
      'type': type,
      'payload': payload,
      // 'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      message: map['message'] as String,
      read: map['read'] as bool,
      type: map['type'] as String,
      payload: map['payload'] as dynamic,
      // createdAt: map['createdAt'] != null
      //     ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
      //     : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
