import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotels/constants/snackbar.dart';

class FavoriteHotel {
  final String userId;
  final String hotelId;
  final String title;
  final String address;
  final String price;
  final String imageUrl;
  final String beds;
  final String baths;
  final String balcony;
  final String parking;
  final String description;
  final String furnishing;
  final String selectedKindOfPropertyController;
  final String pet;
  final String smoke;
  final String wifi;
  final List<dynamic> images;

  FavoriteHotel({
    required this.userId,
    required this.hotelId,
    required this.title,
    required this.address,
    required this.price,
    required this.imageUrl,
    required this.beds,
    required this.baths,
    required this.balcony,
    required this.parking,
    required this.description,
    required this.furnishing,
    required this.selectedKindOfPropertyController,
    required this.pet,
    required this.smoke,
    required this.wifi,
    required this.images,
  });
}

// function for adding in favorite collection
Future<void> addToFavorite(
    BuildContext context, FavoriteHotel favoriteHotel) async {
  try {
    await FirebaseFirestore.instance
        .collection('Favorite-hotels')
        .doc(favoriteHotel.hotelId)
        .set({
      'user_id': favoriteHotel.userId,
      'hotel_Id': favoriteHotel.hotelId,
      'title': favoriteHotel.title,
      'address': favoriteHotel.address,
      'price': favoriteHotel.price,
      'imageUrl': favoriteHotel.imageUrl,
      'beds': favoriteHotel.beds,
      'baths': favoriteHotel.baths,
      'balcony': favoriteHotel.balcony,
      'parking': favoriteHotel.parking,
      'description': favoriteHotel.description,
      'furnishing': favoriteHotel.furnishing,
      'selectedKindOfPropertyController':
          favoriteHotel.selectedKindOfPropertyController,
      'pet': favoriteHotel.pet,
      'smoke': favoriteHotel.smoke,
      'wifi': favoriteHotel.wifi,
      'images': favoriteHotel.images,
      'timestamp': Timestamp.now(),
    });

    // Show a success message or perform any other action if necessary
    ReusableSnackbar.show(
      context,
      'Added to favorite list.',
      'Congrats!',
      Colors.blue,
    );
  } catch (error) {
    print('Failed to add hotel to favorites: $error');
  }
}
