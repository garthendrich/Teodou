import "package:flutter/material.dart";

class MainLayout extends StatelessWidget {
  final Widget head;
  final Widget body;
  final Widget? floatingActionButton;

  const MainLayout({
    Key? key,
    required this.head,
    required this.body,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text(
          "Teodou",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: head,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    offset: const Offset(0, -10),
                    blurRadius: 15,
                    spreadRadius: -3,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    offset: const Offset(0, -4),
                    blurRadius: 6,
                    spreadRadius: -4,
                  )
                ],
              ),
              padding: const EdgeInsets.only(top: 24),
              child: body,
            ),
          )
        ],
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pop(context);
              Navigator.pushNamed(context, "/");
              break;
            case 1:
              Navigator.pop(context);
              Navigator.pushNamed(context, "/friends");
              break;
          }
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
