import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/components/items_stream_list.dart";
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
