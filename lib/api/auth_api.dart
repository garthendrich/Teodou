import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

import "package:shared_todo_app/models/user_info_model.dart" as user_info_model;

class AuthApi {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Stream<user_info_model.UserInfo?> getLoggedInUserInfoStream() {
    final loggedInUserStream = auth.authStateChanges();

    final loggedInUserInfoStream = loggedInUserStream.asyncMap((user) async {
      if (user != null) {
        return await getUserInfoOf(user);
      }
    });

    return loggedInUserInfoStream;
  }

  Future<user_info_model.UserInfo?> getUserInfoOf(User user) async {
    try {
      final userInfoSnapshot = await db.collection("users").doc(user.uid).get();

      Map<String, dynamic>? userInfoJson = userInfoSnapshot.data();

      if (userInfoJson == null) {
        return null;
      }

      userInfoJson["uid"] = user.uid;
      userInfoJson["email"] = user.email;

      final userInfo = user_info_model.UserInfo.fromJson(userInfoJson);

      return userInfo;
    } on FirebaseException catch (error) {
      print("Error getting user info: [${error.code}] ${error.message}");
      return null;
    }
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
    String email,
    String password,
  ) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await saveUserToFirestore(
        credential.user!.uid,
        firstName,
        lastName,
        email,
      );
    } on FirebaseAuthException catch (error) {
      print(error.code);
      print(error.message);
    }
  }

  Future saveUserToFirestore(
    String uid,
    String firstName,
    String lastName,
    String email,
  ) async {
    try {
      await db
          .collection("users")
          .doc(uid)
          .set({"firstName": firstName, "lastName": lastName, "email": email});
    } on FirebaseException catch (error) {
      print(error.code);
      print(error.message);
    }
  }
}
