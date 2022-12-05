import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/components/profile.dart";
import "package:shared_todo_app/providers/auth_provider.dart";

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().loggedInUser;

    return Profile(user: currentUser!);
  }
}
