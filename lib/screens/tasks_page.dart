import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/components/items_stream_list.dart";
import "package:shared_todo_app/components/todo_modal.dart";
import "package:shared_todo_app/models/todo_model.dart";
import "package:shared_todo_app/providers/auth_provider.dart";
import "package:shared_todo_app/providers/todo_provider.dart";

class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().loggedInUser;
    context.read<ToDosProvider>().fetchToDosOf(currentUser!.uid);

    final toDosStream = context.watch<ToDosProvider>().toDosStream;

    return ItemsStreamList(
      stream: toDosStream,
      title: "Your to-dos",
      itemName: "to-do",
      itemBuilder: (items) => _buildToDoTile(items, context),
    );
  }

  Widget _buildToDoTile(ToDo toDo, BuildContext context) {
    return Card(
      color: const Color(0xFFEFF3F3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 8),
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
          onChanged: (isChecked) {
            context.read<ToDosProvider>().setIsDone(toDo, isChecked!);
          },
          shape: const CircleBorder(),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          fillColor: MaterialStateProperty.resolveWith((states) {
            return Theme.of(context).colorScheme.secondary;
          }),
        ),
        trailing: Wrap(
          children: [
            IconButton(
              splashRadius: 24,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ToDoModal(type: "Edit", toDo: toDo),
                );
              },
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              color: Colors.red,
              splashRadius: 24,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ToDoModal(type: "Delete", toDo: toDo),
                );
              },
              icon: const Icon(Icons.delete_outline),
            )
          ],
        ),
      ),
    );
  }
}
