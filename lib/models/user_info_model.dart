import "package:cloud_firestore/cloud_firestore.dart";

class UserInfo {
  final String uid;
  final String firstName;
  final String lastName;
  final String userName;
  final String biography;
  final DateTime birthDate;
  final String location;
  final String email;
  final List<String> friendsIds;
  final List<String> receivedFriendRequestsIds;
  final List<String> sentFriendRequestsIds;

  get fullName => "$firstName $lastName";

  get birthDateDisplay {
    final List<String> birthMonths = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    final birthMonthDisplay = birthMonths[birthDate.month - 1];
    final birthDayDisplay = birthDate.day.toString().padLeft(2, "0");

    return "$birthMonthDisplay $birthDayDisplay, ${birthDate.year}";
  }

  UserInfo({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.biography,
    required this.birthDate,
    required this.location,
    required this.email,
    required this.friendsIds,
    required this.receivedFriendRequestsIds,
    required this.sentFriendRequestsIds,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      uid: json["uid"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      userName: json["userName"],
      biography: json["biography"],
      birthDate: json["birthDate"].toDate(),
      location: json["location"],
      email: json["email"],
      friendsIds: List.from(json["friendsIds"]),
      receivedFriendRequestsIds: List.from(json["receivedFriendRequestsIds"]),
      sentFriendRequestsIds: List.from(json["sentFriendRequestsIds"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "firstName": firstName,
      "lastName": lastName,
      "userName": userName,
      "biography": biography,
      "birthDate": Timestamp.fromDate(birthDate),
      "location": location,
      "email": email,
      "friendsIds": friendsIds,
      "receivedFriendRequestsIds": receivedFriendRequestsIds,
      "sentFriendRequestsIds": sentFriendRequestsIds,
    };
  }

  bool isMatchingName(String query) {
    final isMatchingFullName =
        fullName.toLowerCase().contains(query.toLowerCase());
    final isMatchingUserName =
        userName.toLowerCase().contains(query.toLowerCase());

    return isMatchingFullName || isMatchingUserName;
  }
}
