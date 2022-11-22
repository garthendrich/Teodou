import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/firebase_options.dart";
import "package:shared_todo_app/providers/auth_provider.dart";
import "package:shared_todo_app/providers/todo_provider.dart";
import "package:shared_todo_app/screens/home_page.dart";
import "package:shared_todo_app/screens/login_page.dart";

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SharedToDoApp());
}

class SharedToDoApp extends StatelessWidget {
  const SharedToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => AuthProvider())),
        ChangeNotifierProvider(create: ((context) => ToDosProvider())),
      ],
      child: MaterialApp(
        title: "Shared To-Do App",
        initialRoute: "/",
        routes: {"/": (context) => const AuthWrapper()},
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthProvider>().isAuthenticated) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
