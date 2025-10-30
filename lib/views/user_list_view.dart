import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_call_assignment/controllers/user_controller.dart';
import 'package:video_call_assignment/views/video_call_view.dart';

class UserListView extends StatelessWidget {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: userController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: userController.users.length,
              itemBuilder: (context, index) {
                final user = userController.users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatar),
                  ),
                  title: Text('${user.firstName} ${user.lastName}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VideoCallView(),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
