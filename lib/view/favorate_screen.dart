import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotels/constants/fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:shared_preferences/shared_preferences.dart';

class FavorateScreen extends StatefulWidget {
  const FavorateScreen({Key? key}) : super(key: key);

  @override
  State<FavorateScreen> createState() => _FavorateScreenState();
}

class _FavorateScreenState extends State<FavorateScreen> {
  late List<DocumentSnapshot<Map<String, dynamic>>> favoriteHotels = [];

  @override
  void initState() {
    super.initState();
    // Fetch favorite hotels when the screen initializes
    fetchFavoriteHotels();
  }

  Future<void> fetchFavoriteHotels() async {
    // Access the Firestore collection 'Favorite-hotels' and fetch documents
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('Favorite-hotels').get();
    setState(() {
      favoriteHotels = snapshot.docs.toList();
    });
  }

  Future<void> removeFromFavorites(String hotelId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(hotelId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(
          'Favorite Hotels',
          style: CustomFonts.secondaryTextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All fav hotels',
                    style: CustomFonts.secondaryTextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Icon(Icons.arrow_forward),
                ],
              ),
            ),
            const SizedBox(
              height: 9,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 17.0),
              child: Divider(),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: favoriteHotels.isEmpty
                  ? Center(
                      child: Column(
                      children: [
                        Lottie.asset(
                          'lib/assets/404.json',
                          height: 400,
                          width: 400,
                        ),
                        Text(
                          'No favorite hotels found.',
                          style: CustomFonts.secondaryTextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ))
                  : ListView.builder(
                      itemCount: favoriteHotels.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot<Map<String, dynamic>> document =
                            favoriteHotels[index];
                        Map<String, dynamic> data = document.data()!;
                        // Retrieve the list of images
                        List<dynamic>? images = data['images'];
                        // Extract the first image URL
                        String firstImageUrl =
                            (images != null && images.isNotEmpty)
                                ? images[0]
                                : 'No Image';
                        return Dismissible(
                          key: Key(document.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) async {
                            // Remove the dismissed item from the list
                            setState(() {
                              favoriteHotels.removeAt(index);
                            });
                            // Remove the item from the Firestore database
                            await FirebaseFirestore.instance
                                .collection('Favorite-hotels')
                                .doc(document.id)
                                .delete();
                            // Remove the item from shared preferences
                            await removeFromFavorites(document.id);
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            color: Colors.red,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                firstImageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data['title'] ?? '',
                                  style: CustomFonts.secondaryTextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                            subtitle: Text(
                              data['address'] ?? '',
                              style: CustomFonts.secondaryTextStyle(
                                fontSize: 13,
                                color: Colors.grey[700]!,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
