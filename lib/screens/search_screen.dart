import "package:flutter/material.dart";

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (String value) {
            // context.read<SearchProvider>().search(value);
          },
          decoration: InputDecoration(
            hintText: "Search",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide.none,
            ),
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
      body: ListView(),
    );
  }
}
