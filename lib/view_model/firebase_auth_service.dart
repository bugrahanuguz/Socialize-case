import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:toni_case_study/view/main_page.dart';


class FirebaseAuthServices with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Tebrikler giriş yapıldı",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => MainPage()));
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hata: $e"),
        ),
      );
      print("Hata: $e");
      return false;
    }
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }

  Future<bool> createEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await postUserField(
        email,
      );
      return true;
    } on FirebaseAuthException catch (exception) {
      switch (exception.code) {
        case "invalid-email":
          print("Not a valid email address.");
          break;
        default:
          print("Unknown error. ${exception.toString()}");
      }
      return false;
    }
  }

  Future<void> postUserField(
    String email,
  ) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection("userDocs").doc(user.uid).set({
        "email": email,
        "name": "",
        "profileImage": "",
        "username": "",
        'followers': [],
        'following': [],
      });
    }
  }
}
