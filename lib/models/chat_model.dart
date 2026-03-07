import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final String user1Id;
  final String user2Id;
  final String user1Name;
  final String user2Name;
  final String user1PhotoUrl;
  final String user2PhotoUrl;
  final DateTime lastMessageTime;
  final String lastMessage;
  final String senderId;

  ChatModel({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.user1Name,
    required this.user2Name,
    required this.user1PhotoUrl,
    required this.user2PhotoUrl,
    required this.lastMessageTime,
    required this.lastMessage,
    required this.senderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user1Id': user1Id,
      'user2Id': user2Id,
      'user1Name': user1Name,
      'user2Name': user2Name,
      'user1PhotoUrl': user1PhotoUrl,
      'user2PhotoUrl': user2PhotoUrl,
      'lastMessageTime': lastMessageTime,
      'lastMessage': lastMessage,
      'senderId': senderId,
    };
  }

  static ChatModel fromMap(Map<String, dynamic> map) {
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

    return ChatModel(
      id: map['id'] ?? '',
      user1Id: map['user1Id'] ?? '',
      user2Id: map['user2Id'] ?? '',
      user1Name: map['user1Name'] ?? '',
      user2Name: map['user2Name'] ?? '',
      user1PhotoUrl: map['user1PhotoUrl'] ?? '',
      user2PhotoUrl: map['user2PhotoUrl'] ?? '',
      lastMessageTime: _parseDateTime(map['lastMessageTime']),
      lastMessage: map['lastMessage'] ?? '',
      senderId: map['senderId'] ?? '',
    );
  }

  ChatModel copyWith({
    String? id,
    String? user1Id,
    String? user2Id,
    String? user1Name,
    String? user2Name,
    String? user1PhotoUrl,
    String? user2PhotoUrl,
    DateTime? lastMessageTime,
    String? lastMessage,
    String? senderId,
  }) {
    return ChatModel(
      id: id ?? this.id,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      user1Name: user1Name ?? this.user1Name,
      user2Name: user2Name ?? this.user2Name,
      user1PhotoUrl: user1PhotoUrl ?? this.user1PhotoUrl,
      user2PhotoUrl: user2PhotoUrl ?? this.user2PhotoUrl,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessage: lastMessage ?? this.lastMessage,
      senderId: senderId ?? this.senderId,
    );
  }
}
