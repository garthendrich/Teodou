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
}
