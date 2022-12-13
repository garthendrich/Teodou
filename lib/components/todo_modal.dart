import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/models/todo_model.dart";
import "package:shared_todo_app/providers/auth_provider.dart";
import "package:shared_todo_app/providers/todo_provider.dart";
import "package:shared_todo_app/utils/format_deadline.dart";

class ToDoModal extends StatefulWidget {
  final ToDo? toDo;
  final String type;
  late final TextEditingController _titleFieldController;
  late final TextEditingController _descriptionFieldController;

  ToDoModal({
    super.key,
    this.toDo,
    required this.type,
  }) {
    _titleFieldController = TextEditingController(text: toDo?.title ?? "");
    _descriptionFieldController =
        TextEditingController(text: toDo?.description ?? "");
  }

  @override
  State<ToDoModal> createState() => _ToDoModalState();
}

class _ToDoModalState extends State<ToDoModal> {
  late DateTime? _deadline = widget.toDo?.deadline;

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

  Text _buildTitle() {
    switch (widget.type) {
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
    switch (widget.type) {
      case "Delete":
        {
          return Text(
            "Are you sure you want to delete \"${widget.toDo!.title}\"?",
          );
        }
      case "Add":
      case "Edit":
      default:
        {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: widget._titleFieldController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: widget._descriptionFieldController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              const SizedBox(height: 4),
              _buildDeadlineButton()
            ],
          );
        }
    }
  }

  Widget _buildDeadlineButton() {
    final label = _deadline == null
        ? const Text("Set date")
        : Text(formatDeadline(_deadline!));

    return Wrap(
      spacing: -8,
      children: [
        ActionChip(
          avatar: Icon(
            Icons.event,
            color: Theme.of(context).colorScheme.primary,
          ),
          label: label,
          onPressed: toggleDatePicker,
        ),
        if (_deadline != null)
          IconButton(
            icon: const Icon(Icons.cancel_rounded),
            onPressed: () => setState(() => _deadline = null),
            iconSize: 16,
            color: Colors.grey,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          )
      ],
    );
  }

  toggleDatePicker() async {
    final now = DateTime.now();

    final newDeadline = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now,
      firstDate: DateTime(now.year - 150, now.month, now.day),
      lastDate: DateTime(now.year + 150, now.month, now.day),
    );

    if (newDeadline != null) setState(() => _deadline = newDeadline);
  }

  TextButton _buildDialogAction(BuildContext context) {
    return TextButton(
      onPressed: () {
        switch (widget.type) {
          case "Add":
            {
              final loggedInUser = context.read<AuthProvider>().loggedInUser;
              ToDo newToDo = ToDo(
                userId: loggedInUser!.uid,
                title: widget._titleFieldController.text,
                description: widget._descriptionFieldController.text,
                deadline: _deadline,
              );

              context.read<ToDosProvider>().add(newToDo);

              break;
            }
          case "Edit":
            {
              context.read<ToDosProvider>().edit(widget.toDo!, {
                "title": widget._titleFieldController.text,
                "description": widget._descriptionFieldController.text,
                "deadline": _deadline
              });

              break;
            }
          case "Delete":
            {
              context.read<ToDosProvider>().delete(widget.toDo!);

              break;
            }
        }

        Navigator.pop(context);
      },
      child: Text(widget.type),
    );
  }
}
