import "dart:async";

import "package:flutter/material.dart";

import "package:shared_todo_app/api/user_api.dart";
import "package:shared_todo_app/models/user_info_model.dart";

class AuthProvider with ChangeNotifier {
  late final UserApi userApi;
  StreamSubscription<UserInfo>? _loggedInUserSubscription;
  UserInfo? loggedInUser;

  AuthProvider({fakeFirestoreDb, fakeFirebaseAuth}) {
    userApi = UserApi(
      fakeFirestoreDb: fakeFirestoreDb,
      fakeFirebaseAuth: fakeFirebaseAuth,
    );

    final loggedInUserUidStream = userApi.getLoggedInUserUidStream();
    loggedInUserUidStream.listen(
      (loggedInUserUid) {
        if (loggedInUserUid == null) {
          loggedInUser = null;
          notifyListeners();
          return;
        }

        final loggedInUserStream = userApi.getUserInfoStreamOf(loggedInUserUid);

        _loggedInUserSubscription?.cancel();
        _loggedInUserSubscription = loggedInUserStream?.listen((loggedInUser) {
          this.loggedInUser = loggedInUser;
          notifyListeners();
        });
      },
    );
  }

  bool get isAuthenticated {
    return loggedInUser != null;
  }

  Future<String?> signIn(String email, String password) async {
    return await userApi.signIn(email, password);
  }

  Future signOut() async {
    await userApi.signOut();
  }

  Future<String?> signUp(
    String firstName,
    String lastName,
    String userName,
    String email,
    String password,
    DateTime birthDate,
    String location,
  ) async {
    return await userApi.signUp(
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
    if (loggedInUser == null) {
      return null;
    }

    return userApi.getUsersInfoStreamOf(loggedInUser!.friendsIds);
  }

  Stream<List<UserInfo>>? getFriendRequestsStream() {
    if (loggedInUser == null) {
      return null;
    }

    return userApi
        .getUsersInfoStreamOf(loggedInUser!.receivedFriendRequestsIds);
  }

  bool isLoggedInUser(UserInfo user) {
    return loggedInUser != null ? loggedInUser!.uid == user.uid : false;
  }

  bool hasPendingFriendRequestFrom(UserInfo user) {
    return loggedInUser != null
        ? loggedInUser!.receivedFriendRequestsIds.contains(user.uid)
        : false;
  }

  bool hasPendingFriendRequestTo(UserInfo user) {
    return loggedInUser != null
        ? loggedInUser!.sentFriendRequestsIds.contains(user.uid)
        : false;
  }

  bool isFriendsWith(UserInfo user) {
    return loggedInUser != null
        ? loggedInUser!.friendsIds.contains(user.uid)
        : false;
  }

  Future acceptFriendRequestFrom(UserInfo user) async {
    if (loggedInUser != null) {
      await userApi.setAsFriends(loggedInUser!, user);
      await userApi.removeFriendRequest(user, loggedInUser!);
    }
  }

  Future rejectFriendRequestFrom(UserInfo user) async {
    if (loggedInUser != null) {
      await userApi.removeFriendRequest(user, loggedInUser!);
    }
  }

  Future cancelFriendRequestTo(UserInfo user) async {
    if (loggedInUser != null) {
      await userApi.removeFriendRequest(loggedInUser!, user);
    }
  }

  Future unfriend(UserInfo user) async {
    if (loggedInUser != null) {
      await userApi.unsetAsFriends(loggedInUser!, user);
    }
  }

  Future sendFriendRequestTo(UserInfo user) async {
    if (loggedInUser != null) {
      await userApi.createFriendRequest(loggedInUser!, user);
    }
  }
}
