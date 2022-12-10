import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/components/items_stream_list.dart";
import "package:shared_todo_app/components/todo_modal.dart";
import "package:shared_todo_app/models/todo_model.dart";
import "package:shared_todo_app/models/user_info_model.dart";
import "package:shared_todo_app/providers/todo_provider.dart";

class ToDosList extends StatelessWidget {
  final UserInfo user;
  final String title;
  final bool willShowCheckbox;
  final bool willShowDeleteButton;

  const ToDosList({
    Key? key,
    required this.user,
    required this.title,
    this.willShowCheckbox = true,
    this.willShowDeleteButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ToDosProvider>().fetchToDosOf(user.uid);
    final toDosStream = context.watch<ToDosProvider>().toDosStream;

    return ItemsStreamList(
      stream: toDosStream,
      title: title,
      itemName: "to-do",
      itemBuilder: (toDo) => _buildToDoTile(toDo, context),
      itemsFilterHelper: (toDos, query) {
        return toDos
            .where(
              (ToDo toDo) =>
                  toDo.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      },
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
        leading: willShowCheckbox ? _buildCheckbox(context, toDo) : null,
        trailing: Wrap(
          children: [
            _buildEditButton(context, toDo),
            if (willShowDeleteButton) _buildDeleteButton(context, toDo),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context, ToDo toDo) {
    return Checkbox(
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
    );
  }

  Widget _buildEditButton(BuildContext context, ToDo toDo) {
    return IconButton(
      splashRadius: 24,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => ToDoModal(type: "Edit", toDo: toDo),
        );
      },
      icon: const Icon(Icons.edit_outlined),
    );
  }

  Widget _buildDeleteButton(BuildContext context, ToDo toDo) {
    return IconButton(
      color: Colors.red,
      splashRadius: 24,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => ToDoModal(type: "Delete", toDo: toDo),
        );
      },
      icon: const Icon(Icons.delete_outline),
    );
  }
}
