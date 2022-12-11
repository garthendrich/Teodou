import "package:flutter/material.dart";

import "package:shared_todo_app/api/user_api.dart";

class SearchProvider with ChangeNotifier {
  UserApi userApi = UserApi();
  Stream<List>? searchedItemsStream;

  search(String searchQuery) {
    if (searchQuery == "") {
      resetSearch();
      return;
    }

    searchedItemsStream = userApi.getSearchedItemsStream(searchQuery);
    notifyListeners();
  }

  resetSearch() {
    searchedItemsStream = null;
    notifyListeners();
  }
}
