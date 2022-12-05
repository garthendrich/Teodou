import "package:flutter/material.dart";

import "package:shared_todo_app/components/profile.dart";
import "package:shared_todo_app/models/user_info_model.dart";

class FriendScreen extends StatelessWidget {
  final UserInfo user;

  const FriendScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [Profile(user: user)],
      ),
    );
  }
}
