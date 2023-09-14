import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/notification_service.dart';

class NotificationViewModel with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  void initialize() {
    _notificationService.initializeToken();
  }

  Future<void> followUser(UserModel targetUser, UserModel currentUser) async {
    await _notificationService.sendFollowerNotification(
        targetUser.tokens!.first, currentUser.name!);
  }
}
