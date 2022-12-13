import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/components/items_stream_list.dart";
import "package:shared_todo_app/models/user_info_model.dart";
import "package:shared_todo_app/providers/auth_provider.dart";
import "package:shared_todo_app/providers/search_provider.dart";

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchedItemsStream =
        context.watch<SearchProvider>().searchedItemsStream;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (String value) {
            context.read<SearchProvider>().search(value);
          },
          decoration: InputDecoration(
            hintText: "Search",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
      body: ItemsStreamList(
        stream: searchedItemsStream,
        itemName: "item",
        itemBuilder: (item) => _buildUserTile(context, item),
        showSearchFilter: false,
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, UserInfo user) {
    return ListTile(
      title: Text(
        user.fullName,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        "@${user.userName}",
        style: TextStyle(color: Colors.grey[700]),
      ),
      trailing: _buildUserTileButtons(context, user),
    );
  }

  Widget _buildUserTileButtons(BuildContext context, UserInfo user) {
    final isLoggedInUser = context.read<AuthProvider>().isLoggedInUser(user);

    if (isLoggedInUser) {
      return const SizedBox();
    }

    final hasPendingFriendRequestFromUser =
        context.read<AuthProvider>().hasPendingFriendRequestFrom(user);

    if (hasPendingFriendRequestFromUser) {
      final GlobalKey<PopupMenuButtonState> respondFriendRequestDropdownKey =
          GlobalKey();

      return PopupMenuButton(
        key: respondFriendRequestDropdownKey,
        child: TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          icon: const Icon(Icons.person_add, size: 16),
          label: const Text("Respond"),
          onPressed: () {
            respondFriendRequestDropdownKey.currentState?.showButtonMenu();
          },
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: "accept",
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                Icon(
                  Icons.person_add,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const Text("Accept request")
              ],
            ),
          ),
          PopupMenuItem(
            value: "reject",
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                Icon(Icons.person_remove, size: 16, color: Colors.red[700]),
                Text(
                  "Reject request",
                  style: TextStyle(color: Colors.red[700]),
                )
              ],
            ),
          )
        ],
        onSelected: (action) {
          switch (action) {
            case "accept":
              context.read<AuthProvider>().acceptFriendRequestFrom(user);
              break;
            case "reject":
              context.read<AuthProvider>().rejectFriendRequestFrom(user);
              break;
          }
        },
      );
    }

    final hasPendingFriendRequestToUser =
        context.read<AuthProvider>().hasPendingFriendRequestTo(user);

    if (hasPendingFriendRequestToUser) {
      return TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        icon: const Icon(Icons.person_remove, size: 16),
        label: const Text("Cancel request"),
        onPressed: () {
          context.read<AuthProvider>().cancelFriendRequestTo(user);
        },
      );
    }

    final isFriendsWithUser = context.read<AuthProvider>().isFriendsWith(user);

    if (isFriendsWithUser) {
      return TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        icon: const Icon(Icons.person_remove, size: 16),
        label: const Text("Unfriend"),
        onPressed: () {
          context.read<AuthProvider>().unfriend(user);
        },
      );
    }

    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      icon: const Icon(Icons.person_add, size: 16),
      label: const Text("Send request"),
      onPressed: () {
        context.read<AuthProvider>().sendFriendRequestTo(user);
      },
    );
  }
}
