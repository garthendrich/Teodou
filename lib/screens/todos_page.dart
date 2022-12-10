import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/components/todos_list.dart";
import "package:shared_todo_app/providers/auth_provider.dart";

class ToDosPage extends StatelessWidget {
  const ToDosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().loggedInUser;

    return ToDosList(user: currentUser!);
  }
}
