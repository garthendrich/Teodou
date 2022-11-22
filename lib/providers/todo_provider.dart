import "package:flutter/material.dart";

import "package:shared_todo_app/api/todo_api.dart";
import "package:shared_todo_app/models/todo_model.dart";

class ToDosProvider with ChangeNotifier {
  ToDoApi toDoApi = ToDoApi();
  Stream<List<ToDo>>? toDosStream;

  void fetchToDosOf(String userId) {
    toDosStream = toDoApi.getAllToDosOf(userId);
  }
}
