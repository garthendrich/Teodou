import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/models/todo_model.dart";
import "package:shared_todo_app/providers/auth_provider.dart";
import "package:shared_todo_app/providers/todo_provider.dart";

class ToDoModal extends StatelessWidget {
  final ToDo? toDo;
  final String type;
  final TextEditingController _titleFieldController = TextEditingController();

  ToDoModal({
    super.key,
    this.toDo,
    required this.type,
  });

  Text _buildTitle() {
    switch (type) {
      case "Add":
        return const Text("Add new todo");
      case "Edit":
        return const Text("Edit todo");
      case "Delete":
        return const Text("Delete todo");
      default:
        return const Text("");
    }
  }

  Widget _buildContent() {
    switch (type) {
      case "Delete":
        {
          return Text(
            "Are you sure you want to delete \"${toDo!.title}\"?",
          );
        }
      case "Add":
      case "Edit":
      default:
        {
          return TextField(
            controller: _titleFieldController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          );
        }
    }
  }

  TextButton _buildDialogAction(BuildContext context) {
    return TextButton(
      onPressed: () {
        switch (type) {
          case "Add":
            {
              final loggedInUser = context.read<AuthProvider>().loggedInUser;
              ToDo newToDo = ToDo(
                userId: loggedInUser!.uid,
                isDone: false,
                title: _titleFieldController.text,
              );

              context.read<ToDosProvider>().add(newToDo);
              break;
            }
          case "Edit":
            {
              context
                  .read<ToDosProvider>()
                  .editTitle(toDo!, _titleFieldController.text);

              break;
            }
          case "Delete":
            {
              context.read<ToDosProvider>().delete(toDo!);

              break;
            }
        }

        Navigator.pop(context);
      },
      child: Text(type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(),
      actions: [
        _buildDialogAction(context),
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
