import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/providers/auth_provider.dart";

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().loggedInUser;
    currentUser!;

    final List<Map<String, dynamic>> userDetails = [
      {"iconData": Icons.badge, "value": currentUser.uid},
      {"iconData": Icons.cake_sharp, "value": currentUser.birthDateDisplay},
      {"iconData": Icons.location_pin, "value": currentUser.location},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            currentUser.fullName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text("@${currentUser.userName}"),
          const SizedBox(height: 24),
          Text(currentUser.biography),
          const SizedBox(height: 24),
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
                    dense: true,
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
