import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/components/main_layout.dart";
import "package:shared_todo_app/components/todo_list.dart";
import "package:shared_todo_app/components/todo_modal.dart";
import "package:shared_todo_app/providers/auth_provider.dart";
import "package:shared_todo_app/providers/todo_provider.dart";

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().loggedInUser;
    context.read<ToDosProvider>().fetchToDosOf(currentUser!.uid);

    final toDosStream = context.watch<ToDosProvider>().toDosStream;

    return MainLayout(
      head: Text(
        "Hi, ${currentUser.firstName}!",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: ToDoList(title: "Your to-dos", toDosStream: toDosStream),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => ToDoModal(type: "Add"),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
