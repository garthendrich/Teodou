import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/firebase_options.dart";
import "package:shared_todo_app/providers/auth_provider.dart";
import "package:shared_todo_app/providers/search_provider.dart";
import "package:shared_todo_app/providers/todo_provider.dart";
import "package:shared_todo_app/screens/home_screen.dart";
import "package:shared_todo_app/screens/login_screen.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        ChangeNotifierProvider(create: ((context) => SearchProvider())),
      ],
      child: MaterialApp(
        title: "Shared To-Do App",
        initialRoute: "/",
        routes: {"/": (context) => const AuthWrapper()},
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: const MaterialColor(
              0xFF004643,
              {
                50: Color(0xFFe6edec),
                100: Color(0xFFccdad9),
                200: Color(0xFF99b5b4),
                300: Color(0xFF66908e),
                400: Color(0xFF336b69),
                500: Color(0xFF004643),
                600: Color(0xFF003836),
                700: Color(0xFF002a28),
                800: Color(0xFF001c1b),
                900: Color(0xFF000e0d),
              },
            ),
            accentColor: const Color(0xFFABD1C6),
          ),
          textTheme: Theme.of(context).textTheme.apply(
                displayColor: const Color(0xFF001E1D),
                bodyColor: const Color(0xFF001E1D),
              ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(12),
            isDense: true,
          ),
          chipTheme: ChipThemeData(
            backgroundColor: Colors.transparent,
            side: BorderSide(color: Colors.grey.shade300),
            iconTheme: const IconThemeData(size: 20),
            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
          ),
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthProvider>().isAuthenticated) {
      return const HomeScreen();
    } else {
      return const LoginPage();
    }
  }
}
