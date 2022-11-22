import "package:cloud_firestore/cloud_firestore.dart";

import "package:shared_todo_app/models/todo_model.dart";

class ToDoApi {
  final db = FirebaseFirestore.instance;

  Stream<List<ToDo>>? getAllToDosOf(String userId) {
    try {
      final userToDosSnapshotStream =
          db.collection("todos").where("userId", isEqualTo: userId).snapshots();

      final userToDosStream = userToDosSnapshotStream.map((userToDosSnapshot) {
        return userToDosSnapshot.docs
            .map((doc) => ToDo.fromJson(doc.data()))
            .toList();
      });

      return userToDosStream;
    } on FirebaseException catch (error) {
      print("Error fetching to-dos: [${error.code}] ${error.message}");
      return null;
    }
  }

  Future addToDo(ToDo toDo) async {
    try {
      final docRef = await db.collection("todos").add(toDo.toJson());
      await db.collection("todos").doc(docRef.id).update({"id": docRef.id});
    } on FirebaseException catch (error) {
      print(
        "Error adding to-do \"${toDo.title}\": [${error.code}] ${error.message}",
      );
    }
  }

  Future editToDoTitle(ToDo toDo, String newTitle) async {
    try {
      await db.collection("todos").doc(toDo.id).update({"title": newTitle});
    } on FirebaseException catch (error) {
      print(
        "Error editing to-do from \"${toDo.title}\" to \"$newTitle\": [${error.code}] ${error.message}",
      );
    }
  }

  Future deleteToDo(ToDo toDo) async {
    try {
      await db.collection("todos").doc(toDo.id).delete();
    } on FirebaseException catch (error) {
      print(
        "Error deleting to-do \"${toDo.title}\": [${error.code}] ${error.message}",
      );
    }
  }
}
