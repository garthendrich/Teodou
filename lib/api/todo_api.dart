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

  Future add(ToDo toDo) async {
    try {
      final docRef = await db.collection("todos").add(toDo.toJson());
      await db.collection("todos").doc(docRef.id).update({"id": docRef.id});
    } on FirebaseException catch (error) {
      print(
        "Error adding to-do \"${toDo.title}\": [${error.code}] ${error.message}",
      );
    }
  }

  Future edit(ToDo toDo, Map<String, dynamic> newToDoDetails) async {
    try {
      await db.collection("todos").doc(toDo.id).update(newToDoDetails);
    } on FirebaseException catch (error) {
      print(
        "Error editing to-do \"${toDo.title}\": [${error.code}] ${error.message}",
      );
    }
  }

  Future delete(ToDo toDo) async {
    try {
      await db.collection("todos").doc(toDo.id).delete();
    } on FirebaseException catch (error) {
      print(
        "Error deleting to-do \"${toDo.title}\": [${error.code}] ${error.message}",
      );
    }
  }

  Future setIsDone(ToDo toDo, bool isDone) async {
    try {
      await db.collection("todos").doc(toDo.id).update({"isDone": isDone});
    } on FirebaseException catch (error) {
      print(
        "Error marking \"${toDo.title}\" as done: [${error.code}] ${error.message}",
      );
    }
  }
}
