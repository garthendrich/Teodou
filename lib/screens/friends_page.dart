import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/components/items_stream_list.dart";
import "package:shared_todo_app/models/user_info_model.dart";
import "package:shared_todo_app/providers/auth_provider.dart";

class FriendsPage extends StatelessWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final friendsStream = context.watch<AuthProvider>().getFriendsStream();

    return ItemsStreamList(
      stream: friendsStream,
      title: "Your friends",
      itemName: "friend",
      itemBuilder: (friend) => _buildFriendTile(friend, context),
      itemsFilterHelper: (friends, query) {
        return friends
            .where(
              (UserInfo friend) => (friend.userName + friend.fullName)
                  .toLowerCase()
                  .contains(query.toLowerCase()),
            )
            .toList();
      },
    );
  }

  Widget _buildFriendTile(UserInfo friend, BuildContext context) {
    return ListTile(
      title: Text(
        friend.fullName,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        "@${friend.userName}",
        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_horiz),
        onPressed: () {
          showFriendActions(friend, context);
        },
      ),
    );
  }

  showFriendActions(UserInfo friend, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListTile(
            title: Text(
              "Unfriend ${friend.firstName} ${friend.lastName}",
              style: const TextStyle(color: Colors.red),
            ),
            leading: const Icon(Icons.person_remove),
            iconColor: Colors.red,
            onTap: () {
              // context.read<AuthProvider>().unfriend(friend.id);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
