import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/components/main_layout.dart";
import "package:shared_todo_app/components/todo_modal.dart";
import "package:shared_todo_app/providers/auth_provider.dart";
import "package:shared_todo_app/screens/friends_page.dart";
import "package:shared_todo_app/screens/tasks_page.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().loggedInUser;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text(
          "Teodou",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        elevation: 0,
      ),
      body: MainLayout(
        head: Text(
          "Hi, ${currentUser!.firstName}!",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: PageView(
          children: const [TasksPage(), FriendsPage()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => ToDoModal(type: "Add"),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {},
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: "Friends",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
