import "package:fake_cloud_firestore/fake_cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_auth_mocks/firebase_auth_mocks.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/models/user_info_model.dart" as user_info_model;
import "package:shared_todo_app/providers/auth_provider.dart";
import "package:shared_todo_app/screens/login_screen.dart";

void main() async {
  Widget buildLoginWidget(
    FakeFirebaseFirestore fakeFirestoreDb,
    MockFirebaseAuth fakeFirebaseAuth,
  ) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(
        fakeFirestoreDb: fakeFirestoreDb,
        fakeFirebaseAuth: fakeFirebaseAuth,
      ),
      child: const MaterialApp(home: LoginPage()),
    );
  }

  // Unhappy path
  testWidgets("Login empty fields", (WidgetTester tester) async {
    final fakeFirestoreDb = FakeFirebaseFirestore();
    final fakeFirebaseAuth = MockFirebaseAuth();

    await tester.pumpWidget(
      buildLoginWidget(fakeFirestoreDb, fakeFirebaseAuth),
    );

    final emailField = find.byKey(const Key("email-field"));
    final passwordField = find.byKey(const Key("password-field"));
    final loginButton = find.byKey(const Key("login-button"));

    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    await tester.enterText(emailField, "");
    await tester.enterText(passwordField, "");

    await tester.tap(loginButton);
    await tester.pump();

    final errorMessageTexts = find.text("This field is required");
    expect(errorMessageTexts, findsNWidgets(2));
  });

  // Unhappy path
  testWidgets("Login display error message", (WidgetTester tester) async {
    final fakeFirestoreDb = FakeFirebaseFirestore();
    final fakeFirebaseAuth = MockFirebaseAuth(
      authExceptions: AuthExceptions(
        signInWithEmailAndPassword: FirebaseAuthException(
          code: "wrong-password",
          message: "The password is invalid",
        ),
      ),
    );

    await tester.pumpWidget(
      buildLoginWidget(fakeFirestoreDb, fakeFirebaseAuth),
    );

    final emailField = find.byKey(const Key("email-field"));
    final passwordField = find.byKey(const Key("password-field"));
    final loginButton = find.byKey(const Key("login-button"));

    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    await tester.enterText(emailField, "placeholder");
    await tester.enterText(passwordField, "placeholder");

    await tester.tap(loginButton);
    await tester.pump();

    final errorMessageTexts = find.text("The password is invalid");
    expect(errorMessageTexts, findsOneWidget);
  });
}
