import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_call_assignment/controllers/user_controller.dart';
import 'package:video_call_assignment/controllers/video_call_controller.dart';
import 'package:video_call_assignment/views/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => VideoCallController()),
      ],
      child: MaterialApp(
        title: 'Video Call App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginView(),
      ),
    );
  }
}
