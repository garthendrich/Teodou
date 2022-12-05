import "package:flutter/material.dart";

class MainLayout extends StatelessWidget {
  final Widget head;
  final Widget body;

  const MainLayout({Key? key, required this.head, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 8, bottom: 16, left: 20, right: 20),
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
    );
  }
}
