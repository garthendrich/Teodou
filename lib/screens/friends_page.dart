import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/components/items_stream_list.dart";
import "package:shared_todo_app/models/user_info_model.dart";
import "package:shared_todo_app/providers/auth_provider.dart";
import "package:shared_todo_app/screens/friend_requests_screen.dart";
import "package:shared_todo_app/screens/friend_screen.dart";
import "package:shared_todo_app/screens/search_screen.dart";

class FriendsPage extends StatelessWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final friendsStream = context.watch<AuthProvider>().getFriendsStream();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Friends",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // context.read<SearchProvider>().resetSearch();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.grey[300],
              shape: const StadiumBorder(),
            ),
            child: const Text("Friend requests"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FriendRequestsScreen(),
                ),
              );
            },
          ),
        ),
        const Divider(color: Colors.grey),
        const SizedBox(height: 8),
        Expanded(
          child: ItemsStreamList(
            stream: friendsStream,
            itemName: "friend",
            itemBuilder: (friend) => _buildFriendTile(context, friend),
            itemsFilterHelper: (friends, query) {
              return friends.where(
                (UserInfo friend) {
                  return (friend.userName + friend.fullName)
                      .toLowerCase()
                      .contains(query.toLowerCase());
                },
              ).toList();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFriendTile(BuildContext context, UserInfo friend) {
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
          showFriendActions(context, friend);
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FriendScreen(user: friend)),
        );
      },
    );
  }

  showFriendActions(BuildContext context, UserInfo friend) {
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
