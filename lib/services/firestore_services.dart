import 'package:chat_flow/models/chat_model.dart';
import 'package:chat_flow/models/friend_request_model.dart';
import 'package:chat_flow/models/message_model.dart';
import 'package:chat_flow/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== USER OPERATIONS ====================

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to create User: ${e.toString()}');
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromMap(data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: ${e.toString()}');
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return UserModel.fromMap(data);
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to get all users: ${e.toString()}');
    }
  }

  Future<List<UserModel>> searchUsers(String query) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('displayName', isGreaterThanOrEqualTo: query)
          .where('displayName', isLessThan: query + 'z')
          .get();
      return querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return UserModel.fromMap(data);
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to search users: ${e.toString()}');
    }
  }

  Future<void> updateUserOnlineStatus(String userId, bool isOnline) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        await _firestore.collection('users').doc(userId).update({
          'isOnline': isOnline,
          'lastSeen': DateTime.now().millisecondsSinceEpoch,
        });
      }
    } catch (e) {
      throw Exception('Failed to update online status: ${e.toString()}');
    }
  }

  Future<void> updateUserProfile(
    String userId,
    String displayName,
    String photoUrl,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'displayName': displayName,
        'photoUrl': photoUrl,
      });
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }

  Future<void> updateUserPassword(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'lastSeen': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw Exception('Failed to update user: ${e.toString()}');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user: ${e.toString()}');
    }
  }

  // ==================== FRIEND REQUEST OPERATIONS ====================

  Future<void> sendFriendRequest(
    String senderId,
    String receiverId,
    String senderName,
    String senderEmail,
    String senderPhotoUrl,
  ) async {
    try {
      final requestId =
          'fr_${senderId}_${receiverId}_${DateTime.now().millisecondsSinceEpoch}';
      final friendRequest = FriendRequestModel(
        id: requestId,
        senderId: senderId,
        receiverId: receiverId,
        timestamp: DateTime.now(),
        status: 'pending',
        senderName: senderName,
        senderEmail: senderEmail,
        senderPhotoUrl: senderPhotoUrl,
      );
      await _firestore
          .collection('friendRequests')
          .doc(requestId)
          .set(friendRequest.toMap());
    } catch (e) {
      throw Exception('Failed to send friend request: ${e.toString()}');
    }
  }

  Future<List<FriendRequestModel>> getReceivedFriendRequests(
    String userId,
  ) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('friendRequests')
          .where('receiverId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .get();
      return querySnapshot.docs
          .map(
            (doc) {
              final data = doc.data() as Map<String, dynamic>;
              return FriendRequestModel.fromMap(data);
            },
          )
          .toList();
    } catch (e) {
      throw Exception(
        'Failed to get received friend requests: ${e.toString()}',
      );
    }
  }

  Future<List<FriendRequestModel>> getSentFriendRequests(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('friendRequests')
          .where('senderId', isEqualTo: userId)
          .get();
      return querySnapshot.docs
          .map(
            (doc) {
              final data = doc.data() as Map<String, dynamic>;
              return FriendRequestModel.fromMap(data);
            }
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get sent friend requests: ${e.toString()}');
    }
  }

  Future<void> acceptFriendRequest(String requestId) async {
    try {
      DocumentSnapshot docSnap = await _firestore
          .collection('friendRequests')
          .doc(requestId)
          .get();
      if (docSnap.exists) {
        FriendRequestModel request = FriendRequestModel.fromMap(
          docSnap.data() as Map<String, dynamic>,
        );

        // Update request status
        await _firestore.collection('friendRequests').doc(requestId).update({
          'status': 'accepted',
        });

        // Add both users to each other's friend lists
        await _firestore
            .collection('users')
            .doc(request.receiverId)
            .collection('friends')
            .doc(request.senderId)
            .set({
              'friendId': request.senderId,
              'addedAt': DateTime.now().millisecondsSinceEpoch,
            });

        await _firestore
            .collection('users')
            .doc(request.senderId)
            .collection('friends')
            .doc(request.receiverId)
            .set({
              'friendId': request.receiverId,
              'addedAt': DateTime.now().millisecondsSinceEpoch,
            });
      }
    } catch (e) {
      throw Exception('Failed to accept friend request: ${e.toString()}');
    }
  }

  Future<void> rejectFriendRequest(String requestId) async {
    try {
      await _firestore.collection('friendRequests').doc(requestId).update({
        'status': 'rejected',
      });
    } catch (e) {
      throw Exception('Failed to reject friend request: ${e.toString()}');
    }
  }

  Future<List<UserModel>> getUserFriends(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('friends')
          .get();

      List<UserModel> friends = [];
      for (var doc in querySnapshot.docs) {
        String friendId = doc['friendId'];
        UserModel? friend = await getUser(friendId);
        if (friend != null) {
          friends.add(friend);
        }
      }
      return friends;
    } catch (e) {
      throw Exception('Failed to get user friends: ${e.toString()}');
    }
  }

  Future<bool> areFriends(String userId1, String userId2) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId1)
          .collection('friends')
          .doc(userId2)
          .get();
      return doc.exists;
    } catch (e) {
      throw Exception('Failed to check friendship: ${e.toString()}');
    }
  }

  // ==================== MESSAGE OPERATIONS ====================

  Future<void> sendMessage(MessageModel message) async {
    try {
      await _firestore
          .collection('chats')
          .doc(message.chatId)
          .collection('messages')
          .doc(message.id)
          .set(message.toMap());

      // Update chat's last message
      await _firestore.collection('chats').doc(message.chatId).update({
        'lastMessage': message.content,
        'lastMessageTime': message.timestamp.millisecondsSinceEpoch,
        'senderId': message.senderId,
      });
    } catch (e) {
      throw Exception('Failed to send message: ${e.toString()}');
    }
  }

  Stream<List<MessageModel>> getMessagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs
              .map((doc) => MessageModel.fromMap(doc.data()))
              .toList();
        });
  }

  Stream<List<MessageModel>> getAllMessagesStream(String userId) {
    return _firestore
        .collectionGroup('messages')
        .where('receiverId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs
              .map((doc) => MessageModel.fromMap(doc.data()))
              .toList();
        });
  }

  Future<void> editMessage(
    String chatId,
    String messageId,
    String newContent,
  ) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({
            'content': newContent,
            'editedAt': DateTime.now().millisecondsSinceEpoch,
          });
    } catch (e) {
      throw Exception('Failed to edit message: ${e.toString()}');
    }
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete message: ${e.toString()}');
    }
  }

  // ==================== CHAT OPERATIONS ====================

  Future<String> getOrCreateChatId(String user1Id, String user2Id) async {
    try {
      // Create a deterministic chat ID
      String chatId = user1Id.compareTo(user2Id) < 0
          ? '${user1Id}_${user2Id}'
          : '${user2Id}_${user1Id}';

      // Check if chat exists
      DocumentSnapshot doc = await _firestore
          .collection('chats')
          .doc(chatId)
          .get();
      if (!doc.exists) {
        // Create new chat
        UserModel? user1 = await getUser(user1Id);
        UserModel? user2 = await getUser(user2Id);

        if (user1 != null && user2 != null) {
          ChatModel chat = ChatModel(
            id: chatId,
            user1Id: user1Id,
            user2Id: user2Id,
            user1Name: user1.displayName,
            user2Name: user2.displayName,
            user1PhotoUrl: user1.photoUrl,
            user2PhotoUrl: user2.photoUrl,
            lastMessageTime: DateTime.now(),
            lastMessage: '',
            senderId: '',
          );
          await _firestore.collection('chats').doc(chatId).set(chat.toMap());
        }
      }
      return chatId;
    } catch (e) {
      throw Exception('Failed to get or create chat: ${e.toString()}');
    }
  }

  Future<ChatModel?> getChat(String chatId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('chats')
          .doc(chatId)
          .get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return ChatModel.fromMap(data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get chat: ${e.toString()}');
    }
  }

  Stream<List<ChatModel>> getUserChatsStream(String userId) {
    return _firestore
        .collection('chats')
        .where('user1Id', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot1) async {
          List<ChatModel> chats1 = snapshot1.docs
              .map(
                (doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return ChatModel.fromMap(data);
                },
              )
              .toList();

          QuerySnapshot snapshot2 = await _firestore
              .collection('chats')
              .where('user2Id', isEqualTo: userId)
              .get();

          List<ChatModel> chats2 = snapshot2.docs
              .map(
                (doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return ChatModel.fromMap(data);
                },
              )
              .toList();

          List<ChatModel> allChats = [...chats1, ...chats2];
          allChats.sort(
            (a, b) => b.lastMessageTime.compareTo(a.lastMessageTime),
          );
          return allChats;
        });
  }
}
