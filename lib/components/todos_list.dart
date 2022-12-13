import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/components/items_stream_list.dart";
import "package:shared_todo_app/components/todo_modal.dart";
import "package:shared_todo_app/models/todo_model.dart";
import "package:shared_todo_app/models/user_info_model.dart";
import "package:shared_todo_app/providers/todo_provider.dart";
import "package:shared_todo_app/utils/format_deadline.dart";

class ToDosList extends StatelessWidget {
  final UserInfo user;
  final bool willShowCheckbox;
  final bool willShowDeleteButton;

  const ToDosList({
    Key? key,
    required this.user,
    this.willShowCheckbox = true,
    this.willShowDeleteButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ToDosProvider>().fetchToDosOf(user.uid);
    final toDosStream = context.watch<ToDosProvider>().toDosStream;

    return ItemsStreamList(
      stream: toDosStream,
      itemName: "to-do",
      itemBuilder: (toDo) => _buildToDoTile(context, toDo),
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

  Widget _buildToDoTile(BuildContext context, ToDo toDo) {
    return Card(
      color: const Color(0xFFEFF3F3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1,
      shadowColor: Theme.of(context).colorScheme.primary,
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _buildToDoTileContent(context, toDo),
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

  Widget _buildToDoTileContent(BuildContext context, ToDo toDo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          toDo.title,
          style: !toDo.isDone
              ? null
              : TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  decoration: TextDecoration.lineThrough,
                ),
        ),
        if (!toDo.isDone && toDo.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              toDo.description,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
        if (!toDo.isDone && toDo.deadline != null)
          Chip(
            avatar: Icon(
              Icons.event,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: Text(formatDeadline(toDo.deadline!)),
          )
      ],
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
