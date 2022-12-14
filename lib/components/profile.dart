import "package:flutter/material.dart";

import "package:shared_todo_app/models/user_info_model.dart";

class Profile extends StatelessWidget {
  final UserInfo user;

  const Profile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> userDetails = [
      {"iconData": Icons.badge, "value": user.uid},
      {"iconData": Icons.cake_sharp, "value": user.birthDateDisplay},
      {"iconData": Icons.location_pin, "value": user.location},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            user.fullName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text("@${user.userName}"),
          const SizedBox(height: 24),
          if (user.biography.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(user.biography),
            ),
          Column(
            children: userDetails
                .map(
                  (detail) => ListTile(
                    title: Text(detail["value"]),
                    leading: Icon(
                      detail["iconData"],
                      size: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    horizontalTitleGap: 0,
                    visualDensity: const VisualDensity(
                      vertical: VisualDensity.minimumDensity,
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
