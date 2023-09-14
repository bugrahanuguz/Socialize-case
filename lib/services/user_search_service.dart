import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toni_case_study/models/user_model.dart';

class UserSearchService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future<List<UserModel>> searchUsers(String query) async {
    List<UserModel> users = [];
    final currentUserId = _auth.currentUser!.uid;

    // Kullanıcı adına göre arama
    QuerySnapshot usernameSnapshot = await FirebaseFirestore.instance
        .collection('userDocs')
        .where('username', isEqualTo: query)
        .get();

    for (var doc in usernameSnapshot.docs) {
      if (doc.id != currentUserId) {
        users.add(UserModel.fromSnapshot(doc));
      }
    }

    
    QuerySnapshot nameSnapshot = await FirebaseFirestore.instance
        .collection('userDocs')
        .where('name', isEqualTo: query)
        .get();

    for (var doc in nameSnapshot.docs) {
      UserModel user = UserModel.fromSnapshot(doc);
      if (!users.any((element) => element.id == user.id) && doc.id != currentUserId) {
        users.add(user);
      }
    }

    return users;
  }
}
