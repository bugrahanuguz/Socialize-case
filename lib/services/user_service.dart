import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toni_case_study/models/user_model.dart';

class UserService {
  final _firestore = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;

  Future<UserModel?> fetchUserProfile(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('userDocs').doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson(data);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<UserModel?> getUserById(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('userDocs').doc(id).get();
      if (doc.exists) {
        return UserModel.fromSnapshot(doc);
      } else {
        return null;
      }
    } catch (e) {
      print("Kullanıcı alınırken hata: $e");
      return null;
    }
  }

  Future<bool> updateUserDetails(
      String userId, String name, String username) async {
    try {
      await _firestore.collection('userDocs').doc(userId).update({
        'name': name,
        'username': username,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      Reference ref = _firebaseStorage
          .ref()
          .child('profileImages')
          .child(DateTime.now().toIso8601String());

      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> saveImageUrlToFirestore(String userId, String imageUrl) async {
    await _firestore.collection('userDocs').doc(userId).update({
      'profileImage': imageUrl,
    });
  }

  Future<void> followUser(String currentUserId, String targetUserId) async {
    await _firestore.collection('userDocs').doc(currentUserId).update({
      'following': FieldValue.arrayUnion([targetUserId]),
    });

    await _firestore.collection('userDocs').doc(targetUserId).update({
      'followers': FieldValue.arrayUnion([currentUserId]),
    });
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    await _firestore.collection('userDocs').doc(currentUserId).update({
      'following': FieldValue.arrayRemove([targetUserId]),
    });

    await _firestore.collection('userDocs').doc(targetUserId).update({
      'followers': FieldValue.arrayRemove([currentUserId]),
    });
  }

  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    final doc =
        await _firestore.collection('userDocs').doc(currentUserId).get();
    if (doc.exists) {
      final userData = doc.data() as Map<String, dynamic>;
      final followingList = userData['following'] as List<dynamic>;
      return followingList.contains(targetUserId);
    }
    return false;
  }
}
