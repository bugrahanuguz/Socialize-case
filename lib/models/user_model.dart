import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? name;
  final String? username;
  final String? email;
  late final String? profileImageUrl;
  final List<String>? followers;
  final List<String>? following;
  final List<String>? tokens;

  UserModel({
    this.id,
    this.name,
    this.username,
    this.email,
    this.profileImageUrl,
    this.followers,
    this.following,
    this.tokens,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      profileImageUrl: json['profileImage'],
      followers: (json['followers'] as List).map((e) => e as String).toList(),
      following: (json['following'] as List).map((e) => e as String).toList(),
      tokens: json['tokens'] != null ? List<String>.from(json['tokens']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'profileImage': profileImageUrl,
      'followers': followers,
      'following': following,
      'tokens': tokens,
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return UserModel(
      email: data['email'],
      id: snapshot.id,
      name: data['name'],
      username: data['username'],
      profileImageUrl: data['profileImage'],
      followers: (data['followers'] as List).map((e) => e as String).toList(),
      following: (data['following'] as List).map((e) => e as String).toList(),
      tokens: data['tokens'] != null ? List<String>.from(data['tokens']) : null,
    );
  }
}
