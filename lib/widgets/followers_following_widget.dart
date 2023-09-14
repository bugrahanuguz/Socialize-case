import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FollowersAndFollowingWidget extends StatelessWidget {
  const FollowersAndFollowingWidget({
    super.key,
    required this.userID,
  });

  final String userID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('userDocs')
          .doc(userID)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;

        if (!userData.containsKey('followers') ||
            !userData.containsKey('following')) {
          return const Text('No data available');
        }

        var followersCount = (userData['followers'] as List).length;
        var followingCount = (userData['following'] as List).length;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            followersText(followersCount),
            followingText(followingCount),
          ],
        );
      },
    );
  }

  Column followingText(int followingCount) {
    return Column(
      children: [
        const Text(
          'Takip Edilen',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 6, 43, 65),
              fontSize: 16),
        ),
        Text(followingCount.toString())
      ],
    );
  }

  Column followersText(int followersCount) {
    return Column(
      children: [
        const Text(
          ' Takipçi',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 6, 43, 65),
              fontSize: 16),
        ),
        Text(followersCount.toString())
      ],
    );
  }
}
