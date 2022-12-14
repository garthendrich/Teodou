import "package:fake_cloud_firestore/fake_cloud_firestore.dart";
import "package:firebase_auth_mocks/firebase_auth_mocks.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/main.dart";
import "package:shared_todo_app/providers/auth_provider.dart";
import "package:shared_todo_app/providers/todo_provider.dart";

void main() async {
  final fakeFirestoreDb = FakeFirebaseFirestore();
  final fakeFirebaseAuth = MockFirebaseAuth();

  Widget buildAuthWrapper() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            fakeFirestoreDb: fakeFirestoreDb,
            fakeFirebaseAuth: fakeFirebaseAuth,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ToDosProvider(fakeFirestoreDb: fakeFirestoreDb),
        ),
      ],
      child: const MaterialApp(home: AuthWrapper()),
    );
  }

  renderSignUpPage(WidgetTester tester) async {
    await tester.pumpWidget(buildAuthWrapper());

    final signUpPageButton = find.byKey(const Key("sign-up-page-button"));
    await tester.tap(signUpPageButton);
    await tester.pumpAndSettle();
  }

  // Happy path
  testWidgets("successfully sign-up", (WidgetTester tester) async {
    await renderSignUpPage(tester);

    final firstNameField = find.byKey(const Key("first-name-field"));
    final lastNameField = find.byKey(const Key("last-name-field"));
    final userNameField = find.byKey(const Key("user-name-field"));
    final emailField = find.byKey(const Key("email-field"));
    final passwordField = find.byKey(const Key("password-field"));
    final locationField = find.byKey(const Key("location-field"));
    final signUpButton = find.byKey(const Key("sign-up-button"));

    expect(firstNameField, findsOneWidget);
    expect(lastNameField, findsOneWidget);
    expect(userNameField, findsOneWidget);
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(locationField, findsOneWidget);
    expect(signUpButton, findsOneWidget);

    const mockUserFirstName = "Seungyoun";
    await tester.enterText(firstNameField, mockUserFirstName);
    await tester.enterText(lastNameField, "Cho");
    await tester.enterText(userNameField, "woodz_dnwm");
    await tester.enterText(emailField, "woodz_dnwm@gmail.com");
    await tester.enterText(passwordField, "val!dPassw0rd");
    await tester.enterText(locationField, "jan sa tabi tabi");

    await tester.tap(signUpButton);
    await tester.pump();

    final homeScreenGreeting = find.text("Hi, $mockUserFirstName!");
    expect(homeScreenGreeting, findsOneWidget);
  });

  // Unhappy path
  testWidgets("sign-up with unmet password requirements",
      (WidgetTester tester) async {
    await renderSignUpPage(tester);

    final firstNameField = find.byKey(const Key("first-name-field"));
    final lastNameField = find.byKey(const Key("last-name-field"));
    final userNameField = find.byKey(const Key("user-name-field"));
    final emailField = find.byKey(const Key("email-field"));
    final passwordField = find.byKey(const Key("password-field"));
    final locationField = find.byKey(const Key("location-field"));
    final signUpButton = find.byKey(const Key("sign-up-button"));

    expect(firstNameField, findsOneWidget);
    expect(lastNameField, findsOneWidget);
    expect(userNameField, findsOneWidget);
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(locationField, findsOneWidget);
    expect(signUpButton, findsOneWidget);

    const mockUserFirstName = "Seungyoun";
    await tester.enterText(firstNameField, mockUserFirstName);
    await tester.enterText(lastNameField, "Cho");
    await tester.enterText(userNameField, "woodz_dnwm");
    await tester.enterText(emailField, "woodz_dnwm@gmail.com");
    await tester.enterText(passwordField, "passwordn0tSpecialhuhu");
    await tester.enterText(locationField, "jan sa tabi tabi");

    await tester.tap(signUpButton);
    await tester.pump();

    final passwordErrorMessage = find.text(
      "Password must contain at least one lowercase, uppercase, numeric, and special character",
    );
    expect(passwordErrorMessage, findsOneWidget);
  });
}
