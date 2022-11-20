import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final _todosData = [
    {"title": "To-do 1", "isDone": false},
    {"title": "To-do 2", "isDone": false},
    {"title": "To-do 3", "isDone": true},
  ];

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shared To-Do App")),
      body: ListView(
        children: _todosData.map((todoData) {
          return _buildTodoTile(todoData);
        }).toList(),
      ),
    );
  }

  Widget _buildTodoTile(Map<String, dynamic> todoData) {
    return ListTile(
      title: Text(todoData["title"]),
      leading: Checkbox(
        value: todoData["isDone"],
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
