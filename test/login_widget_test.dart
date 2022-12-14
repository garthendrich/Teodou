import "package:fake_cloud_firestore/fake_cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_auth_mocks/firebase_auth_mocks.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/main.dart";
import "package:shared_todo_app/models/user_info_model.dart" as user_info_model;
import "package:shared_todo_app/providers/auth_provider.dart";
import "package:shared_todo_app/providers/todo_provider.dart";

void main() async {
  final mockUser = MockUser(email: "woodz_dnwm@gmail.com");
  final mockUserInfo = user_info_model.UserInfo(
    uid: mockUser.uid,
    firstName: "Seungyoun",
    lastName: "Cho",
    userName: "",
    biography: "",
    birthDate: DateTime.now(),
    location: "",
    email: "",
    friendsIds: [],
    receivedFriendRequestsIds: [],
    sentFriendRequestsIds: [],
  );

  final fakeFirestoreDb = FakeFirebaseFirestore();
  await fakeFirestoreDb
      .collection("users")
      .doc(mockUser.uid)
      .set(mockUserInfo.toJson());

  Widget buildAuthWrapper(
    FakeFirebaseFirestore fakeFirestoreDb,
    MockFirebaseAuth fakeFirebaseAuth,
  ) {
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

  // Happy path
  testWidgets("successfully log-in", (WidgetTester tester) async {
    final fakeFirebaseAuth = MockFirebaseAuth(mockUser: mockUser);

    await tester.pumpWidget(
      buildAuthWrapper(fakeFirestoreDb, fakeFirebaseAuth),
    );

    final emailField = find.byKey(const Key("email-field"));
    final passwordField = find.byKey(const Key("password-field"));
    final loginButton = find.byKey(const Key("login-button"));

    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    await tester.enterText(emailField, mockUser.email!);
    await tester.enterText(passwordField, "placeholder");

    await tester.tap(loginButton);
    await tester.pump();

    final homeScreenGreeting = find.text("Hi, ${mockUserInfo.firstName}!");
    expect(homeScreenGreeting, findsOneWidget);
  });

  // Unhappy path
  testWidgets("log-in with empty fields", (WidgetTester tester) async {
    final fakeFirebaseAuth = MockFirebaseAuth();

    await tester.pumpWidget(
      buildAuthWrapper(fakeFirestoreDb, fakeFirebaseAuth),
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
  testWidgets("display login error message", (WidgetTester tester) async {
    final fakeFirebaseAuth = MockFirebaseAuth(
      authExceptions: AuthExceptions(
        signInWithEmailAndPassword: FirebaseAuthException(
          code: "wrong-password",
          message: "The password is invalid",
        ),
      ),
    );

    await tester.pumpWidget(
      buildAuthWrapper(fakeFirestoreDb, fakeFirebaseAuth),
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
