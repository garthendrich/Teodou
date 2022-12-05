import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/components/main_layout.dart";
import "package:shared_todo_app/components/todo_modal.dart";
import "package:shared_todo_app/providers/auth_provider.dart";
import "package:shared_todo_app/screens/friends_page.dart";
import "package:shared_todo_app/screens/profile_page.dart";
import "package:shared_todo_app/screens/todos_page.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();

  int _pageIndex = 0;

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
        head: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Hi, ${currentUser!.firstName}!",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            PopupMenuButton(
              icon: const Icon(Icons.expand_more, color: Colors.white),
              splashRadius: 24,
              position: PopupMenuPosition.under,
              offset: const Offset(0, 16),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.logout, size: 20, color: Colors.grey[700]),
                      const SizedBox(width: 16),
                      Text(
                        "Sign out",
                        style: TextStyle(color: Colors.grey[700]),
                      )
                    ],
                  ),
                  onTap: () => context.read<AuthProvider>().signOut(),
                ),
              ],
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (newPageIndex) {
            setState(() => _pageIndex = newPageIndex);
          },
          children: const [ToDosPage(), FriendsPage(), ProfilePage()],
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
        currentIndex: _pageIndex,
        onTap: (newPageIndex) {
          _pageController.animateToPage(
            newPageIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
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
