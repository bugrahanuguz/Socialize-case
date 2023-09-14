import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toni_case_study/extension.dart';
import 'package:toni_case_study/models/user_model.dart';
import 'package:toni_case_study/view/other_profile_page.dart';
import 'package:toni_case_study/view_model/user_profile_view_model.dart';
import 'package:toni_case_study/view_model/user_search_view_model.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            searchBarWidget(context, searchController),
            searchResultWidget(),
          ],
        ),
      ),
    );
  }

  Expanded searchResultWidget() {
    return Expanded(
      child: Consumer<UserSearchViewModel>(
        builder: (context, viewModel, _) {
          return ListView.builder(
            itemCount: viewModel.searchResults.length,
            itemBuilder: (context, index) {
              final user = viewModel.searchResults[index];
              return GestureDetector(
                onTap: () async {
                  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
                  UserModel? currentUser = await context
                      .read<UserProfileViewModel>()
                      .getUserByID(currentUserId);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OtherProfilePage(
                                user: user,
                                currentUserId: currentUser,
                              )));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: Container(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: context.width * 0.08,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: NetworkImage(user.profileImageUrl!),
                        ),
                        SizedBox(width: context.width * 0.1),
                        SizedBox(
                          width: context.width * 0.55,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name!.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Text(user.username!),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.teal,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Align searchBarWidget(
      BuildContext context, TextEditingController searchController) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: context.height * 0.04),
        child: Container(
          height: context.height * 0.058,
          width: context.width * 0.9,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 202, 200, 200),
              borderRadius: BorderRadius.circular(11)),
          child: TextField(
            onTap: () {},
            onChanged: (value) {
              context.read<UserSearchViewModel>().search(value);
            },
            cursorWidth: 1,
            style: const TextStyle(color: Colors.black),
            controller: searchController,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 5),
                hintText: "Ara",
                hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.w500),
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  size: 25,
                  color: Colors.black,
                )),
          ),
        ),
      ),
    );
  }
}
