import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

import "package:shared_todo_app/models/user_info_model.dart" as user_info_model;

class AuthApi {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Stream<String?> getLoggedInUserUidStream() {
    final loggedInUserStream = auth.authStateChanges();

    final loggedInUserUidStream = loggedInUserStream.map((user) {
      if (user != null) {
        return user.uid;
      }
    });

    return loggedInUserUidStream;
  }

  Stream<user_info_model.UserInfo>? getUserInfoStreamOf(String userUid) {
    try {
      final userInfoSnapshotStream =
          db.collection("users").doc(userUid).snapshots();

      final userInfoStream = userInfoSnapshotStream.map((userInfoSnapshot) {
        return user_info_model.UserInfo.fromJson(userInfoSnapshot.data()!);
      });

      return userInfoStream;
    } on FirebaseException catch (error) {
      print("Error getting user info: [${error.code}] ${error.message}");
      return null;
    }
  }

  Stream<List<user_info_model.UserInfo>>? getUsersInfoStreamOf(
    List<String> usersIds,
  ) {
    if (usersIds.isEmpty) {
      return Stream.value([]);
    }

    try {
      final usersInfoSnapshotStream =
          db.collection("users").where("uid", whereIn: usersIds).snapshots();

      final usersInfoStream = usersInfoSnapshotStream.map((userInfoSnapshot) {
        return userInfoSnapshot.docs.map((doc) {
          return user_info_model.UserInfo.fromJson(doc.data());
        }).toList();
      });

      return usersInfoStream;
    } on FirebaseException catch (error) {
      print("Error getting users info: [${error.code}] ${error.message}");
    }

    return null;
  }

  Future signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      print(error.code);
      print(error.message);
    }
  }

  Future signOut() async {
    await auth.signOut();
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
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = credential.user!.uid;

      final newUser = user_info_model.UserInfo(
        uid: userId,
        firstName: firstName,
        lastName: lastName,
        userName: userName,
        biography: "",
        birthDate: birthDate,
        location: location,
        email: email,
        friendsIds: [],
        receivedFriendRequestsIds: [],
        sentFriendRequestsIds: [],
      );

      await saveUserToFirestore(userId, newUser);
    } on FirebaseAuthException catch (error) {
      print(error.code);
      print(error.message);
    }
  }

  Future saveUserToFirestore(
    String userId,
    user_info_model.UserInfo newUser,
  ) async {
    try {
      await db.collection("users").doc(userId).set(newUser.toJson());
    } on FirebaseException catch (error) {
      print(error.code);
      print(error.message);
    }
  }
}
