import "package:cloud_firestore/cloud_firestore.dart";

class ToDo {
  final String? id;
  final String title;
  final String description;
  final DateTime? deadline;
  final bool isDone;
  final String userId;

  ToDo({
    this.id,
    required this.title,
    this.description = "",
    this.deadline,
    this.isDone = false,
    required this.userId,
  });

  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      deadline: json["deadline"]?.toDate(),
      isDone: json["isDone"],
      userId: json["userId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      if (deadline != null) "deadline": Timestamp.fromDate(deadline!),
      "isDone": isDone,
      "userId": userId,
    };
  }
}
