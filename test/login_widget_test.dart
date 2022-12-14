import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/providers/auth_provider.dart";
import "package:shared_todo_app/screens/login_screen.dart";

void main() {
  testWidgets("Login empty fields", (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AuthProvider(),
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    final emailField = find.text("Email");
    final passwordField = find.text("Password");
    final loginButton = find.byKey(const Key("login-button"));

    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    await tester.tap(loginButton);
    await tester.pump();

    final errorMessageTexts = find.text("This field is required");
    expect(errorMessageTexts, findsNWidgets(2));
  });
}
