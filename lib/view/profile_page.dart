import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toni_case_study/extension.dart';
import 'package:toni_case_study/widgets/followers_following_widget.dart';
import '../view_model/user_profile_view_model.dart';
import '../widgets/profile_image_widget.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<UserProfileViewModel>();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    viewModel.fetchUserProfile(userId);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserProfileViewModel>();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: context.width * 0.05,
              vertical: context.height * 0.02),
          child: Column(
            children: [
              SizedBox(height: context.height * 0.05),
              ProfileImageWidget(viewModel: viewModel),
              SizedBox(height: context.height * 0.025),
              _buildEmail(viewModel),
              SizedBox(height: context.height * 0.03),
              FollowersAndFollowingWidget(userID: userId),
              SizedBox(height: context.height * 0.03),
              _buildProfileDetailsForm(viewModel),
              SizedBox(height: context.height * 0.05),
              _buildUpdateButton(viewModel),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "Profil",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      elevation: 0.0, // Flat appbar

      leading: IconButton(
        icon: const Icon(Icons.logout, color: Colors.white),
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        },
      ),
    );
  }


  Widget _buildEmail(UserProfileViewModel viewModel) {
    return Text(
      'Email: ${viewModel.user?.email}',
      style: TextStyle(
          color: const Color.fromARGB(255, 6, 43, 65),
          fontWeight: FontWeight.w500,
          fontSize: context.width * 0.05),
    );
  }

  Widget _buildProfileDetailsForm(UserProfileViewModel viewModel) {
    _nameController.text = viewModel.user?.name ?? '';
    _usernameController.text = viewModel.user?.username ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  'İsim',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF557689)),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              _buildNameTextField(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  'Kullanıcı Adı',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF557689)),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              _buildUsernameTextField(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNameTextField() {
    return SizedBox(
      width: context.width * 0.38,
      child: TextField(
        controller: _nameController,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blueGrey.shade400,
                ),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.teal),
                borderRadius: BorderRadius.circular(20))),
      ),
    );
  }

  Widget _buildUsernameTextField() {
    return SizedBox(
      width: context.width * 0.38,
      child: TextField(
        controller: _usernameController,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blueGrey.shade400,
                ),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.teal),
                borderRadius: BorderRadius.circular(20))),
      ),
    );
  }

  Container _buildUpdateButton(UserProfileViewModel viewModel) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.06),
      width: context.width,
      child: ElevatedButton(
        onPressed: () async {
          bool success = await viewModel.updateUserDetails(
            _nameController.text,
            _usernameController.text,
          );
          if (success) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Başarıyla güncellendi!')));
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text('Güncelleme başarısız oldu! Lütfen tekrar deneyin.')));
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          "Güncelle",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

