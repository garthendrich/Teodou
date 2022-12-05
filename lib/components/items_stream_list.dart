import "package:flutter/material.dart";

class ItemsStreamList extends StatefulWidget {
  final Stream<List<dynamic>>? stream;
  final String title;
  final String itemName;
  final Widget Function(dynamic) itemBuilder;
  final List<dynamic> Function(dynamic, String) itemsFilterHelper;

  const ItemsStreamList({
    Key? key,
    required this.stream,
    required this.title,
    required this.itemName,
    required this.itemBuilder,
    required this.itemsFilterHelper,
  }) : super(key: key);

  @override
  State<ItemsStreamList> createState() => _ItemsStreamListState();
}

class _ItemsStreamListState extends State<ItemsStreamList> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            onChanged: (newText) => setState(() => _searchQuery = newText),
            decoration: InputDecoration(hintText: "Search ${widget.itemName}s"),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: StreamBuilder(
            stream: widget.stream,
            builder: ((context, snapshot) {
              if (snapshot.hasError) {
                print("Error fetching ${widget.itemName}s: ${snapshot.error}");
                print(snapshot.stackTrace);

                return Center(
                  child: Text("Error fetching ${widget.itemName}s"),
                );
              }

              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
              }

              if (!snapshot.hasData) {
                return Center(child: Text("No ${widget.itemName}s found"));
              }

              final items = snapshot.data!;
              final filteredItems =
                  widget.itemsFilterHelper(items, _searchQuery);

              return ListView(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 80),
                children:
                    filteredItems.map<Widget>(widget.itemBuilder).toList(),
              );
            }),
          ),
        ),
      ],
    );
  }
}
