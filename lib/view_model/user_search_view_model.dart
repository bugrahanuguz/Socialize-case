import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/user_search_service.dart';

class UserSearchViewModel with ChangeNotifier {
  final UserSearchService _searchService = UserSearchService();

  List<UserModel> _searchResults = [];
  List<UserModel> get searchResults => _searchResults;

  void search(String query) async {
    _searchResults = await _searchService.searchUsers(query);
    notifyListeners();
  }
}
