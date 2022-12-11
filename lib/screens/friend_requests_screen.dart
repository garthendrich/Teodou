import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/components/items_stream_list.dart";
import "package:shared_todo_app/models/user_info_model.dart";
import "package:shared_todo_app/providers/auth_provider.dart";

class FriendRequestsScreen extends StatelessWidget {
  const FriendRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final friendRequestsStream =
        context.watch<AuthProvider>().getFriendRequestsStream();

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              "Friend requests",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: ItemsStreamList(
              stream: friendRequestsStream,
              itemName: "friend request",
              itemBuilder: (friendRequest) {
                return _buildFriendRequestTile(context, friendRequest);
              },
              itemsFilterHelper: (friendRequests, query) {
                return friendRequests.where(
                  (UserInfo friendRequest) {
                    return (friendRequest.userName + friendRequest.fullName)
                        .toLowerCase()
                        .contains(query.toLowerCase());
                  },
                ).toList();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendRequestTile(BuildContext context, UserInfo friendRequest) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                friendRequest.fullName,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                "@${friendRequest.userName}",
                style: TextStyle(color: Colors.grey[700]),
              )
            ],
          ),
          const SizedBox(height: 8),
          _buildFriendRequestButtons(context, friendRequest)
        ],
      ),
    );
  }

  Widget _buildFriendRequestButtons(
    BuildContext context,
    UserInfo friendRequest,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text("Confirm"),
            onPressed: () {
              context
                  .read<AuthProvider>()
                  .acceptFriendRequestFrom(friendRequest);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text("Delete"),
            onPressed: () {
              context
                  .read<AuthProvider>()
                  .rejectFriendRequestFrom(friendRequest);
            },
          ),
        )
      ],
    );
  }
}
