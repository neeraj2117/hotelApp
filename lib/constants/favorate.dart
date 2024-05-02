// import 'package:flutter/material.dart';

// class FavoritesManager extends ChangeNotifier {
//   List<String> _favorites = [];

//   List<String> get favorites => _favorites;

//   void addToFavorites(String hotelTitle) {
//     _favorites.add(hotelTitle);
//     notifyListeners();
//   }

//   void removeFromFavorites(String hotelTitle) {
//     _favorites.remove(hotelTitle);
//     notifyListeners();
//   }

//   bool isFavorite(String hotelTitle) {
//     return _favorites.contains(hotelTitle);
//   }
// }

class FavoritesManager {
  List<String> _favorites = [];

  List<String> get favorites => _favorites;

  void addToFavorites(String hotelTitle) {
    _favorites.add(hotelTitle);
  }

  void removeFromFavorites(String hotelTitle) {
    _favorites.remove(hotelTitle);
  }

  bool isFavorite(String hotelTitle) {
    return _favorites.contains(hotelTitle);
  }
}
