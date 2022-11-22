import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/models/todo_model.dart";
import "package:shared_todo_app/providers/auth_provider.dart";
import "package:shared_todo_app/providers/todo_provider.dart";

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().loggedInUser;
    context.read<ToDosProvider>().fetchToDosOf(currentUser!.uid);

    final toDosStream = context.watch<ToDosProvider>().toDosStream;

    return Scaffold(
      appBar: AppBar(title: const Text("Shared To-Do App")),
      body: _buildToDoList(toDosStream),
    );
  }

  Widget _buildToDoList(Stream<List<ToDo>>? toDosStream) {
    return StreamBuilder(
      stream: toDosStream,
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          print("Error fetching to-dos: ${snapshot.error}");
          print(snapshot.stackTrace);

          return const Center(
            child: Text("Error fetching to-dos"),
          );
        }

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
        }

        if (!snapshot.hasData) {
          return const Center(child: Text("No to-dos found"));
        }

        final toDos = snapshot.data!;

        return ListView(
          children: toDos.map((toDo) {
            return _buildToDoTile(toDo);
          }).toList(),
        );
      }),
    );
  }

  Widget _buildToDoTile(ToDo toDo) {
    return ListTile(
      title: Text(toDo.title),
      leading: Checkbox(
        value: toDo.isDone,
        onChanged: (isChecked) {},
      ),
      trailing: Wrap(
        children: [
          IconButton(
            icon: const Icon(Icons.create_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete_outlined),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
