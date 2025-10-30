import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_call_assignment/models/user_model.dart';

class UserController with ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = true;

  List<User> get users => _users;
  bool get isLoading => _isLoading;

  UserController() {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final response =
          await http.get(Uri.parse('https://reqres.in/api/users'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _users = (data['data'] as List)
            .map((user) => User.fromJson(user))
            .toList();
        _isLoading = false;
        notifyListeners();
        _cacheUsers(response.body);
      } else {
        _loadCachedUsers();
      }
    } catch (e) {
      _loadCachedUsers();
    }
  }

  Future<void> _cacheUsers(String usersJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_users', usersJson);
  }

  Future<void> _loadCachedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('cached_users');
    if (usersJson != null) {
      final data = json.decode(usersJson);
      _users = (data['data'] as List)
          .map((user) => User.fromJson(user))
          .toList();
      _isLoading = false;
      notifyListeners();
    }
  }
}
