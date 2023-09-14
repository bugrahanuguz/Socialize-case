import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toni_case_study/models/user_model.dart';

import '../services/user_service.dart';

class UserProfileViewModel with ChangeNotifier {
  final UserService _userService = UserService();

  UserModel? _user;
  UserModel? get user => _user;

  Future<void> fetchUserProfile(String userId) async {
    _user = await _userService.fetchUserProfile(userId);
    notifyListeners();
  }

  Future<UserModel?> getUserByID(String userId) async {
    _user = await _userService.getUserById(userId);
    notifyListeners();
    return _user;
    
  }

  Future<bool> updateUserDetails(String name, String username) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return await _userService.updateUserDetails(userId, name, username);
  }

  Future<void> pickAndUploadImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);
      String? imageUrl = await _userService.uploadImageToFirebase(file);
      if (imageUrl != null) {
        _user!.profileImageUrl = imageUrl;
        notifyListeners();
        await _userService.saveImageUrlToFirestore(_user!.id!, imageUrl);
      }
    }
  }

  Future<void> followUser(String currentUserId, String targetUserId) async {
    await _userService.followUser(currentUserId, targetUserId);
    notifyListeners();
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    await _userService.unfollowUser(currentUserId, targetUserId);
    notifyListeners();
  }

  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    return await _userService.isFollowing(currentUserId, targetUserId);
  }
}
