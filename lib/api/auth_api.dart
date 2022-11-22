import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

class AuthApi {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Stream<User?> getLoggedInUser() {
    return auth.authStateChanges();
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
