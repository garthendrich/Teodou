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
                  const SizedBox(height: 80)
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildToDoTile(ToDo toDo, BuildContext context) {
    return Card(
      color: const Color(0xFFEFF3F3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      elevation: 1,
      shadowColor: Theme.of(context).colorScheme.primary,
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            toDo.title,
            style: toDo.isDone
                ? TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    decoration: TextDecoration.lineThrough,
                  )
                : const TextStyle(),
          ),
        ),
        leading: Checkbox(
          value: toDo.isDone,
          onChanged: (isChecked) {},
          shape: const CircleBorder(),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          fillColor: MaterialStateProperty.resolveWith((states) {
            return Theme.of(context).colorScheme.secondary;
          }),
        ),
        trailing: PopupMenuButton(
          icon: Icon(
            Icons.more_horiz,
            color: toDo.isDone
                ? Theme.of(context).colorScheme.secondary
                : Colors.grey,
          ),
          splashRadius: 24,
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              child: Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Icon(Icons.edit, size: 20),
                  Text("Edit", style: TextStyle(color: Colors.grey[700]))
                ],
              ),
            ),
            PopupMenuItem(
              child: Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: const [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  Text("Delete", style: TextStyle(color: Colors.red))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
