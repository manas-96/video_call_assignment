import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_call_assignment/screens/video_call_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<dynamic> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final response =
          await http.get(Uri.parse('https://reqres.in/api/users'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _users = data['data'];
          _isLoading = false;
        });
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
      setState(() {
        _users = data['data'];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['avatar']),
                  ),
                  title: Text('${user['first_name']} ${user['last_name']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VideoCallScreen(),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
