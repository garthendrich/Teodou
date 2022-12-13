import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

import "package:shared_todo_app/models/user_info_model.dart" as user_info_model;

class UserApi {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Stream<String?> getLoggedInUserUidStream() {
    final loggedInUserStream = auth.authStateChanges();
    final loggedInUserUidStream = loggedInUserStream.map((user) => user?.uid);
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

  Stream<List>? getSearchedItemsStream(String searchQuery) {
    final allUsersStream = getAllUsersInfoStream();
    if (allUsersStream == null) {
      print("Error searching users: \"$searchQuery\"");

      return null;
    }

    final searchedUsersStream = allUsersStream.map((users) {
      return users.where((user) => user.isMatchingName(searchQuery)).toList();
    });

    return searchedUsersStream;
  }

  Stream<List<user_info_model.UserInfo>>? getAllUsersInfoStream() {
    try {
      final allUsersSnapshotStream = db.collection("users").snapshots();

      final allUsersStream = allUsersSnapshotStream.map((userSnapshot) {
        return userSnapshot.docs
            .map((doc) => user_info_model.UserInfo.fromJson(doc.data()))
            .toList();
      });

      return allUsersStream;
    } on FirebaseException catch (error) {
      print("Error getting all users: [${error.code}] ${error.message}");
    }

    return null;
  }

  Future removeFriendRequest(
    user_info_model.UserInfo sender,
    user_info_model.UserInfo receiver,
  ) async {
    try {
      await db.collection("users").doc(sender.uid).update({
        "sentFriendRequestsIds": FieldValue.arrayRemove([receiver.uid])
      });

      await db.collection("users").doc(receiver.uid).update({
        "receivedFriendRequestsIds": FieldValue.arrayRemove([sender.uid])
      });

      print(
        "Successfully rejected friend request of user id ${sender.uid} to user id ${receiver.uid}",
      );
    } on FirebaseException catch (error) {
      print(
        "Error rejecting friend request of user id ${sender.uid} to user id ${receiver.uid}: [${error.code}] ${error.message}",
      );
    }
  }

  Future setAsFriends(
    user_info_model.UserInfo user1,
    user_info_model.UserInfo user2,
  ) async {
    try {
      await db.collection("users").doc(user1.uid).update({
        "friendsIds": FieldValue.arrayUnion([user2.uid])
      });

      await db.collection("users").doc(user2.uid).update({
        "friendsIds": FieldValue.arrayUnion([user1.uid])
      });

      print(
        "Successfully set user id ${user1.uid} and user id ${user2.uid} as friends",
      );
    } on FirebaseException catch (error) {
      print(
        "Error setting user id ${user1.uid} and user id ${user2.uid} as friends: [${error.code}] ${error.message}",
      );
    }
  }

  Future unsetAsFriends(
    user_info_model.UserInfo user1,
    user_info_model.UserInfo user2,
  ) async {
    try {
      await db.collection("users").doc(user1.uid).update({
        "friendsIds": FieldValue.arrayRemove([user2.uid])
      });

      await db.collection("users").doc(user2.uid).update({
        "friendsIds": FieldValue.arrayRemove([user1.uid])
      });

      print(
        "Successfully unset user id ${user1.uid} and user id ${user2.uid} as friends",
      );
    } on FirebaseException catch (error) {
      print(
        "Error unsetting user id ${user1.uid} and user id ${user2.uid} as friends: [${error.code}] ${error.message}",
      );
    }
  }

  createFriendRequest(
    user_info_model.UserInfo sender,
    user_info_model.UserInfo receiver,
  ) async {
    try {
      await db.collection("users").doc(sender.uid).update({
        "sentFriendRequestsIds": FieldValue.arrayUnion([receiver.uid])
      });

      await db.collection("users").doc(receiver.uid).update({
        "receivedFriendRequestsIds": FieldValue.arrayUnion([sender.uid])
      });

      print(
        "Successfully sent friend request to user id ${receiver.uid} from user id ${sender.uid}",
      );
    } on FirebaseException catch (error) {
      print(
        "Error sending friend request to user id ${receiver.uid} from user id ${sender.uid}: [${error.code}] ${error.message}",
      );
    }
  }
}
