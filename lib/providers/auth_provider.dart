import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";

import "package:shared_todo_app/api/auth_api.dart";

class AuthProvider with ChangeNotifier {
  AuthApi authApi = AuthApi();
  User? loggedInUser;

  AuthProvider() {
    final loggedInUserStream = authApi.getLoggedInUser();
    loggedInUserStream.listen(
      (User? loggedInUser) {
        this.loggedInUser = loggedInUser;
        notifyListeners();
      },
      onError: (error) {},
    );
  }

  bool get isAuthenticated {
    return loggedInUser != null;
  }

  Future signIn(String email, String password) async {
    await authApi.signIn(email, password);
  }

  Future signOut() async {
    await authApi.signOut();
  }

  Future signUp(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    await authApi.signUp(firstName, lastName, email, password);
  }
}
