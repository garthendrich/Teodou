import "package:flutter/material.dart";

class ItemsStreamList extends StatelessWidget {
  final Stream<List<dynamic>>? stream;
  final String title;
  final String itemName;
  final Function(dynamic) itemBuilder;

  const ItemsStreamList({
    Key? key,
    required this.stream,
    required this.title,
    required this.itemName,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Expanded(
          child: StreamBuilder(
            stream: stream,
            builder: ((context, snapshot) {
              if (snapshot.hasError) {
                print("Error fetching ${itemName}s: ${snapshot.error}");
                print(snapshot.stackTrace);

                return Center(
                  child: Text("Error fetching ${itemName}s"),
                );
              }

              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
              }

              if (!snapshot.hasData) {
                return Center(child: Text("No ${itemName}s found"));
              }

              final items = snapshot.data!;

              return ListView(
                children: [
                  ...items.map(itemBuilder).toList(),
                  const SizedBox(height: 80)
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
