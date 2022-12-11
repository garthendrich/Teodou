import "dart:async";

import "package:flutter/material.dart";

import "package:shared_todo_app/api/auth_api.dart";
import "package:shared_todo_app/models/user_info_model.dart";

class AuthProvider with ChangeNotifier {
  AuthApi authApi = AuthApi();
  StreamSubscription<UserInfo>? _loggedInUserSubscription;
  UserInfo? loggedInUser;

  AuthProvider() {
    final loggedInUserUidStream = authApi.getLoggedInUserUidStream();
    loggedInUserUidStream.listen(
      (loggedInUserUid) {
        if (loggedInUserUid != null) {
          final loggedInUserStream =
              authApi.getUserInfoStreamOf(loggedInUserUid);

          _loggedInUserSubscription?.cancel();

          _loggedInUserSubscription =
              loggedInUserStream?.listen((loggedInUser) {
            this.loggedInUser = loggedInUser;
            notifyListeners();
          });
        }
      },
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
    String userName,
    String email,
    String password,
    DateTime birthDate,
    String location,
  ) async {
    await authApi.signUp(
      firstName,
      lastName,
      userName,
      email,
      password,
      birthDate,
      location,
    );
  }

  Stream<List<UserInfo>>? getFriendsStream() {
    print("possible update on friends list");

    if (loggedInUser == null) {
      return null;
    }

    if (loggedInUser!.friendsIds.isEmpty) {
      return const Stream.empty();
    }

    return authApi.getUsersInfoStreamOf(loggedInUser!.friendsIds);
  }

  Stream<List<UserInfo>>? getFriendRequestsStream() {
    if (loggedInUser == null) {
      return null;
    }

    if (loggedInUser!.receivedFriendRequestsIds.isEmpty) {
      return const Stream.empty();
    }

    return authApi
        .getUsersInfoStreamOf(loggedInUser!.receivedFriendRequestsIds);
  }
}
