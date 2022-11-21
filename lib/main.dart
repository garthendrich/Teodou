import "package:flutter/material.dart";

import "package:shared_todo_app/screens/home_page.dart";
import "package:shared_todo_app/screens/login_page.dart";

void main() {
  runApp(const SharedToDoApp());
}

class SharedToDoApp extends StatelessWidget {
  const SharedToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shared To-Do App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
