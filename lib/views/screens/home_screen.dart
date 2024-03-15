import 'package:flutter/material.dart';
import 'package:traxi/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traxi'),
      ),
      body: const Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
