import "package:flutter/material.dart";

import "package:shared_todo_app/models/todo_model.dart";

class ToDoList extends StatelessWidget {
  final String title;
  final Stream<List<ToDo>>? toDosStream;

  const ToDoList({Key? key, required this.title, required this.toDosStream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Expanded(
          child: StreamBuilder(
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
                children: [
                  ...toDos.map((toDo) {
                    return _buildToDoTile(toDo, context);
                  }).toList(),
                  const SizedBox(height: 92)
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildToDoTile(ToDo toDo, BuildContext context) {
    return ListTile(
      title: Text(toDo.title),
      leading: Checkbox(
        value: toDo.isDone,
        onChanged: (isChecked) {},
      ),
      trailing: Wrap(
        children: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})
        ],
      ),
    );
  }
}
