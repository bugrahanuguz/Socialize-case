import 'package:flutter/material.dart';
import 'package:toni_case_study/extension.dart';

import '../view_model/user_profile_view_model.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    super.key,
    required this.viewModel,
  });

  final UserProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: viewModel.pickAndUploadImage,
      child: CircleAvatar(
        radius: context.width * 0.25,
        backgroundColor: Colors.grey[300],
        backgroundImage: (viewModel.user?.profileImageUrl != null &&
      viewModel.user!.profileImageUrl!.isNotEmpty)
            ? NetworkImage(viewModel.user!.profileImageUrl!)
            : null,
        child: (viewModel.user?.profileImageUrl == null ||
      viewModel.user!.profileImageUrl!.isEmpty)
            ? const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.camera_alt, size: 40.0, color: Colors.teal),
        SizedBox(height: 5),
        Text(
          'Tap to upload profile image',
          style: TextStyle(color: Colors.black38),
          textAlign: TextAlign.center,
        )
      ],
    )
            : null,
      ),
    );
  }
}
