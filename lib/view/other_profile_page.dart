import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toni_case_study/extension.dart';
import 'package:toni_case_study/view_model/notification_view_model.dart';
import 'package:toni_case_study/view_model/user_profile_view_model.dart';

import '../models/user_model.dart';
import '../widgets/followers_following_widget.dart';

class OtherProfilePage extends StatelessWidget {
  final UserModel user;
  final UserModel? currentUserId;
  const OtherProfilePage(
      {super.key, required this.user, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          user.username!,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: context.height * 0.05),
            profileImageWidget(context),
            SizedBox(height: context.height * 0.02),
            nameText(context),
            SizedBox(height: context.height * 0.01),
            usernameText(context),
            SizedBox(height: context.height * 0.01),
            Text(user.email!),
            SizedBox(height: context.height * 0.02),
            FollowersAndFollowingWidget(userID: user.id.toString()),
            SizedBox(height: context.height * 0.03),
            followButton(context),
          ],
        ),
      ),
    );
  }

  CircleAvatar profileImageWidget(BuildContext context) {
    return CircleAvatar(
      radius: context.width * 0.2,
      backgroundImage: NetworkImage(user.profileImageUrl!),
    );
  }

  Text nameText(BuildContext context) {
    return Text(
      user.name!,
      style: TextStyle(
        fontSize: context.width * 0.06,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text usernameText(BuildContext context) {
    return Text(
      "@" + user.username!,
      style: TextStyle(
        fontSize: context.width * 0.04,
        color: Colors.grey,
      ),
    );
  }

  SizedBox followButton(BuildContext context) {
    return SizedBox(
      width: context.width * 0.5,
      child: ElevatedButton(
        onPressed: () async {
          final viewModel = context.read<UserProfileViewModel>();
          UserModel? targetUser =
              await viewModel.getUserByID(currentUserId!.id!);
          final notificationViewModel = context.read<NotificationViewModel>();

          bool isFollowing =
              await viewModel.isFollowing(currentUserId!.id!, user.id!);
          if (isFollowing) {
            await viewModel.unfollowUser(currentUserId!.id!, user.id!);
          } else {
            await viewModel.followUser(currentUserId!.id!, user.id!);
            notificationViewModel.followUser(targetUser!, user);
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: FutureBuilder<bool>(
          future: context
              .watch<UserProfileViewModel>()
              .isFollowing(currentUserId!.id!, user.id!),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              return const Text('Takipten Çık');
            } else {
              return const Text('Takip Et');
            }
          },
        ),
      ),
    );
  }
}
