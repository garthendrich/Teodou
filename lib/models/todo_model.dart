class ToDo {
  final String? id;
  String title;
  bool isDone;
  final String userId;

  ToDo({
    this.id,
    required this.title,
    required this.isDone,
    required this.userId,
  });

  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json["id"],
      title: json["title"],
      isDone: json["isDone"],
      userId: json["userId"],
    );
  }
}
