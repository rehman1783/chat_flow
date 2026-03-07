import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestModel {
  final String id;
  final String senderId;
  final String receiverId;
  final DateTime timestamp;
  final String status; // 'pending', 'accepted', 'rejected'
  final String senderName;
  final String senderEmail;
  final String senderPhotoUrl;

  FriendRequestModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    this.status = 'pending',
    required this.senderName,
    required this.senderEmail,
    required this.senderPhotoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': timestamp,
      'status': status,
      'senderName': senderName,
      'senderEmail': senderEmail,
      'senderPhotoUrl': senderPhotoUrl,
    };
  }

  static FriendRequestModel fromMap(Map<String, dynamic> map) {
    DateTime _parseDateTime(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      } else if (value is String) {
        return DateTime.parse(value);
      }
      return DateTime.now();
    }

    return FriendRequestModel(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      timestamp: _parseDateTime(map['timestamp']),
      status: map['status'] ?? 'pending',
      senderName: map['senderName'] ?? '',
      senderEmail: map['senderEmail'] ?? '',
      senderPhotoUrl: map['senderPhotoUrl'] ?? '',
    );
  }

  FriendRequestModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    DateTime? timestamp,
    String? status,
    String? senderName,
    String? senderEmail,
    String? senderPhotoUrl,
  }) {
    return FriendRequestModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      senderName: senderName ?? this.senderName,
      senderEmail: senderEmail ?? this.senderEmail,
      senderPhotoUrl: senderPhotoUrl ?? this.senderPhotoUrl,
    );
  }
}
