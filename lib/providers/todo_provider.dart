import "package:flutter/material.dart";

import "package:shared_todo_app/api/todo_api.dart";
import "package:shared_todo_app/models/todo_model.dart";

class ToDosProvider with ChangeNotifier {
  late final ToDoApi toDoApi;
  Stream<List<ToDo>>? toDosStream;

  ToDosProvider({fakeFirestoreDb}) {
    toDoApi = ToDoApi(fakeFirestoreDb: fakeFirestoreDb);
  }

  void fetchToDosOf(String userId) {
    toDosStream = toDoApi.getAllToDosOf(userId);
  }

  Future add(ToDo toDo) async {
    await toDoApi.add(toDo);
  }

  Future edit(ToDo toDo, Map<String, dynamic> newToDoDetails) async {
    await toDoApi.edit(toDo, newToDoDetails);
  }

  Future delete(ToDo toDo) async {
    await toDoApi.delete(toDo);
  }

  Future setIsDone(ToDo toDo, bool isDone) async {
    await toDoApi.setIsDone(toDo, isDone);
  }
}
