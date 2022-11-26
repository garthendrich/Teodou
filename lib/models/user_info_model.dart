class UserInfo {
  final String uid;
  final String firstName;
  final String lastName;
  final String userName;
  final DateTime birthDate;
  final String location;
  final String email;
  final List<String> friendsIds;
  final List<String> receivedFriendRequestsIds;
  final List<String> sentFriendRequestsIds;

  UserInfo({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.userName,
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
      birthDate: json["birthDate"].toDate(),
      location: json["location"],
      email: json["email"],
      friendsIds: List.from(json["friendsIds"]),
      receivedFriendRequestsIds: List.from(json["receivedFriendRequestsIds"]),
      sentFriendRequestsIds: List.from(json["sentFriendRequestsIds"]),
    );
  }
}
