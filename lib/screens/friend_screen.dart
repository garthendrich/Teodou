import "package:flutter/material.dart";

import "package:shared_todo_app/components/profile.dart";
import "package:shared_todo_app/components/todos_list.dart";
import "package:shared_todo_app/models/user_info_model.dart";

class FriendScreen extends StatelessWidget {
  final UserInfo user;

  const FriendScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          children: [
            Profile(user: user),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Expanded(
              child: ToDosList(
                user: user,
                willShowCheckbox: false,
                willShowDeleteButton: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}
