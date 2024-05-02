import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:hotels/constants/bottom_bar.dart';
import 'package:hotels/constants/fonts.dart';
import 'package:hotels/constants/snackbar.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HotelDetailsScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String address;
  final String price;
  final String beds;
  final String baths;
  final List<dynamic> images;
  final String Address;
  final String contact;
  final String description;
  final String parking;
  final String balcony;
  final String furnishing;
  final String selectedKindOfPropertyController;
  final String pet;
  final String smoke;
  final String wifi;
  final String hotelId;
  final String rating;

  //

  HotelDetailsScreen({
    required this.imageUrl,
    required this.title,
    required this.address,
    required this.price,
    required this.beds,
    required this.baths,
    required this.images,
    required this.Address,
    required this.contact,
    required this.description,
    required this.parking,
    required this.balcony,
    required this.furnishing,
    required this.selectedKindOfPropertyController,
    required this.pet,
    required this.smoke,
    required this.wifi,
    required this.hotelId, 
    required this.rating,
  });

  @override
  _HotelDetailsScreenState createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  late int _currentIndex = 0;
  late Timer _timer;
  late PageController _pageController;
  final TextEditingController _commentController = TextEditingController();
  final CollectionReference _commentsCollection =
      FirebaseFirestore.instance.collection('comments');
  List<Map<String, dynamic>> _comments = [];

  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    fetchFavoriteStatus();
    _pageController = PageController(initialPage: _currentIndex);

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentIndex < widget.images.length - 1) {
        setState(() {
          _currentIndex++;
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        });
      } else {
        setState(() {
          _currentIndex = 0;
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        });
      }
    });

    // Fetch comments when the screen initializes
    _fetchComments();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // function for adding in favorate collection
  Future<void> addToFavourite() async {
    print(widget.hotelId);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid;
      String hotelId = widget.hotelId;
      String title = widget.title;
      String address = widget.address;
      String price = widget.price;
      String imageUrl = widget.imageUrl;
      String beds = widget.beds;
      String baths = widget.baths;
      String balcony = widget.balcony;
      String parking = widget.parking;
      String description = widget.description;
      String furnishing = widget.furnishing;
      String selectedKindOfPropertyController =
          widget.selectedKindOfPropertyController;
      String pet = widget.pet;
      String smoke = widget.smoke;
      String wifi = widget.wifi;
      final List<dynamic> images = widget.images;

      try {
        await FirebaseFirestore.instance
            .collection('Favorite-hotels')
            .doc(hotelId)
            .set({
          'user_id': userId,
          'hotel_Id': hotelId,
          'title': title,
          'address': address,
          'price': price,
          'imageUrl': imageUrl,
          'beds': beds,
          'baths': baths,
          'balcony': balcony,
          'parking': parking,
          'description': description,
          'furnishing': furnishing,
          'selectedKindOfPropertyController': selectedKindOfPropertyController,
          'pet': pet,
          'smoke': smoke,
          'wifi': wifi,
          'images': images,
          'timestamp': Timestamp.now(),
        });

        // Show a success message or perform any other action if necessary
        ReusableSnackbar.show(
          context,
          'Added to favorate list.',
          'Congrats!',
          Colors.blue,
        );
      } catch (error) {
        print('Failed to add hotel to favorites: $error');
      }
    } else {
      print('User is not authenticated');
    }
  }

  // function for removing in favorate collection
  Future<void> removeFromFavorite(String hotelId) async {
    print(widget.hotelId);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('Favorite-hotels')
            .doc(hotelId)
            .delete();

        // Show a success message or perform any other action if necessary
        ReusableSnackbar.show(
          context,
          'Removed from favorite list.',
          'Success!',
          Colors.blue,
        );
      } catch (error) {
        print('Failed to remove hotel from favorites: $error');
      }
    } else {
      print('User is not authenticated');
    }
  }

  // fetch status of favorate hotel
  Future<void> fetchFavoriteStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool(widget.hotelId) ?? false;
    });
  }

  // Function to toggle the favorite status and update the icon accordingly
  Future<bool?> toggleFavorite(bool isCurrentlyLiked) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isCurrentlyLiked;
    });
    await prefs.setBool(widget.hotelId, isFavorite);

    // Call the function to add/remove the hotel from favorites based on the new status
    if (isFavorite) {
      addToFavourite();
    } else {
      removeFromFavorite(widget.hotelId);
    }

    // Return the new status of the like
    return Future.value(isFavorite);
  }

  // // Function to parse timestamp
  String _parseTimestamp(Timestamp timestamp) {
    DateTime postDateTime = timestamp.toDate();
    DateTime now = DateTime.now();
    Duration difference = now.difference(postDateTime);

    if (difference.inDays > 365) {
      // If the post was posted more than a year ago
      int years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays >= 1) {
      // If the post was posted more than one day ago
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours >= 1) {
      // If the post was posted more than one hour ago
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes >= 1) {
      // If the post was posted more than one minute ago
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      // If the post was posted less than a minute ago
      return 'Just now';
    }
  }

  // // Function to fetch comments from Firebase
  void _fetchComments() async {
    QuerySnapshot querySnapshot = await _commentsCollection
        .where('hotel_id', isEqualTo: widget.hotelId)
        .get();
    setState(() {
      _comments = querySnapshot.docs
          .map((doc) => {
                'comment': doc['comment'] as String,
                'commenterImageUrl': doc['commenterImageUrl'] as String,
                'commenterEmail': doc['commenterEmail'] as String,
                'timestamp': _parseTimestamp(doc['timestamp'] as Timestamp),
              })
          .toList();

      // Sort comments based on timestamp
      _comments.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the image slider with dot indicators
            Container(
              height: 380,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    itemCount: widget.images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          widget.images[index].toString(),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    controller: _pageController,
                  ),

                  // back arrow icon
                  Positioned(
                    top: 70.0,
                    left: 30.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFDADCDE).withOpacity(.85),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // heart icon
                  Positioned(
                    top: 70,
                    right: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFDADCDE).withOpacity(0.85),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: LikeButton(
                          size: 30,
                          countPostion: CountPostion.bottom,
                          onTap: (isLiked) => toggleFavorite(isLiked),
                          isLiked: isFavorite,
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border_sharp,
                              color: isLiked ? Colors.red : Colors.white,
                              size: 28,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  // dots indicator
                  Positioned(
                    bottom: 15.0,
                    child: DotsIndicator(
                      dotsCount: widget.images.length,
                      position: _currentIndex,
                      decorator: DotsDecorator(
                        color: Colors.grey[400]!,
                        activeColor: Colors.blue,
                        size: const Size.square(9.0),
                        activeSize: const Size(20.0, 9.0),
                        spacing: const EdgeInsets.all(3.0),
                        activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(
              color: Colors.grey,
              height: 2,
              thickness: 1,
            ),

            const SizedBox(
              height: 5,
            ),

            // Display hotel details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Title and ratings
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.title,
                          style: CustomFonts.secondaryTextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                          ),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 18,
                            ),
                            Text(
                              '4.9',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  // Address
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'lib/assets/locc.png',
                          height: 22,
                          width: 26,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 3),
                        Container(
                          width: 330,
                          child: Text(
                            widget.address,
                            style: CustomFonts.secondaryTextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  // description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(children: [
                      Container(
                        width: 350,
                        child: Text(
                          widget.description,
                          style: CustomFonts.secondaryTextStyle(
                            fontSize: 13,
                            color: Colors.grey[900]!,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // Facilities
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Container(
                    width: 350,
                    child: Text(
                      'Facilities',
                      style: CustomFonts.secondaryTextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            // square tiles for facilities
            SizedBox(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Row(
                      children: [
                        _WifibuildContainerWithShadow(widget.wifi, 'Wi-Fi'),
                        const SizedBox(width: 15),
                        _ParkingbuildContainerWithShadow(
                            'Parking', int.parse(widget.parking)),
                        const SizedBox(width: 15),
                        _SmokebuildContainerWithShadow(widget.smoke, 'Smoke'),
                        const SizedBox(width: 15),
                        _PetbuildContainerWithShadow(widget.pet, 'Pet'),
                        const SizedBox(width: 15),
                        _BedbuildContainerWithShadow(
                            int.parse(widget.beds), 'Beds'),
                        const SizedBox(width: 15),
                        _BathbuildContainerWithShadow(
                            int.parse(widget.baths), 'Bath'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            // contact
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Container(
                    width: 350,
                    child: Text(
                      'Contact Details',
                      style: CustomFonts.secondaryTextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Mobile : ',
                        style: CustomFonts.secondaryTextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        widget.contact,
                        style: CustomFonts.secondaryTextStyle(
                          color: Colors.grey[600]!,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      final Uri url = Uri(scheme: 'tel', path: "7715949586");
                      if (await canLaunch(url.toString())) {
                        await launch(url.toString());
                      } else {
                        print('cannot launch this url');
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Icon(
                          Icons.phone,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              child: Divider(),
            ),

            const SizedBox(
              height: 15,
            ),

            // // comment
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Container(
                    width: 350,
                    child: Text(
                      'Comment',
                      style: CustomFonts.secondaryTextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // comment textfield
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Write your comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey, // Border color
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.blue, // Focused border color
                      width: 2.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                  ),
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
              ),
            ),

            // post btn
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () => _handlePostComment(),
                    child: const Text(
                      'Post',
                    ),
                  ),
                ],
              ),
            ),

            // display
            Padding(
              padding: const EdgeInsets.only(
                left: 7.0,
                right: 7,
                top: 10,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                ),
                child: Column(
                  children: [
                    // Display comments with commenter's profile image
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        String comment = _comments[index]['comment']!;
                        String commenterImageUrl =
                            _comments[index]['commenterImageUrl']!;
                        String commenterEmail =
                            _comments[index]['commenterEmail'] ?? 'No email ';

                        String timestamp =
                            _comments[index]['timestamp'] ?? 'No timestamp ';

                        return Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(commenterImageUrl),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  width: 270,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '$commenterEmail',
                                            style:
                                                CustomFonts.secondaryTextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: Colors.grey[900]!,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 7,
                                          ),
                                          Text(
                                            '$timestamp',
                                            style:
                                                CustomFonts.secondaryTextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                              color: Colors.grey[600]!,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        comment,
                                        style: const TextStyle(
                                          // overflow: TextOverflow.ellipsis,
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 5.0, right: 10),
                              child: Divider(),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            //
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomAppBar(
        price: widget.price,
        hotelId: widget.hotelId,
      ),
    );
  }

  Container _SmokebuildContainerWithShadow(
      String availability, String facility) {
    bool available = availability.toLowerCase() == 'yes';
    IconData iconData;

    // Determine which icon to show based on the facility
    switch (facility) {
      case 'smoking':
        iconData = Icons.smoking_rooms;
        break;
      default:
        iconData =
            Icons.smoking_rooms; // Default icon if facility not recognized
    }

    return Container(
      height: 90,
      width: 73,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 203, 226, 246),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          available
              ? Icon(
                  iconData,
                  color: Colors.black,
                )
              : const Icon(
                  Icons.smoke_free,
                  color: Colors.black,
                ),
          const SizedBox(height: 5),
          Text(
            facility,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Container _WifibuildContainerWithShadow(
      String availability, String facility) {
    print('Availability: $availability, Facility: $facility'); // Add this line

    bool available = availability.toLowerCase() == 'yes';
    IconData iconData;

    // Determine which icon to show based on the facility
    switch (facility) {
      case 'Wi-Fi':
        iconData = Icons.wifi;
        break;
      default:
        iconData =
            Icons.help_outline; // Default icon if facility not recognized
    }

    return Container(
      height: 80,
      width: 75,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 203, 226, 246),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          available
              ? Icon(
                  iconData,
                  color: Colors.black,
                )
              : const Icon(
                  Icons.signal_wifi_statusbar_connected_no_internet_4_outlined,
                  color: Colors.black,
                ),
          const SizedBox(height: 5),
          Text(
            facility,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Container _PetbuildContainerWithShadow(String availability, String facility) {
    bool available = availability.toLowerCase() == 'yes';
    IconData iconData;

    // Determine which icon to show based on the facility
    switch (facility.toLowerCase()) {
      case 'pet':
        iconData = Icons.pets;
        break;
      default:
        iconData =
            Icons.help_outline; // Default icon if facility not recognized
    }

    return Container(
      height: 80,
      width: 78,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 203, 226, 246),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          available
              ? Icon(
                  iconData,
                  color: Colors.black,
                )
              : Image.asset(
                  'lib/assets/pet.png',
                  height: 26,
                  width: 26,
                ),
          const SizedBox(height: 5),
          Text(
            facility,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Container _ParkingbuildContainerWithShadow(
      String facility, int availability) {
    bool available = availability == 1;

    return Container(
      height: 80,
      width: 75,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 203, 226, 246),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          available
              ? Image.asset(
                  'lib/assets/car.png',
                  height: 25,
                  width: 25,
                )
              : Image.asset(
                  'lib/assets/no_park.png',
                  height: 25,
                  width: 35,
                ),
          const SizedBox(height: 5),
          Text(
            facility,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Container _BedbuildContainerWithShadow(int availability, String facility) {
    bool available = availability > 0;

    return Container(
      height: 80,
      width: 75,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 203, 226, 246),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          available
              ? const Icon(
                  Icons.bed,
                  size: 27,
                )
              : Image.asset(
                  'lib/assets/bed.png',
                  height: 25,
                  width: 25,
                ),
          const SizedBox(height: 5),
          Text(
            facility,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Container _BathbuildContainerWithShadow(int availability, String facility) {
    bool available = availability > 0;

    return Container(
      height: 80,
      width: 75,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 203, 226, 246),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          available
              ? const Icon(Icons.bathtub)
              : Image.asset(
                  'lib/assets/bathh.png',
                  height: 27,
                  width: 27,
                ),
          const SizedBox(height: 5),
          Text(
            facility,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _postComment(String commenterImageUrl, String commenterEmail) {
    String comment = _commentController.text.trim();
    if (comment.isNotEmpty) {
      String hotelId = widget.hotelId;

      // Create a timestamp variable to store the current timestamp
      Timestamp timestamp = Timestamp.now();

      // // Add comment to the hotel's collection
      FirebaseFirestore.instance
          .collection('HotelsData')
          .doc(hotelId)
          .collection('comments')
          .add({
        'comment': comment,
        'commenterImageUrl': commenterImageUrl,
        'commenterEmail': commenterEmail,
        'timestamp': timestamp,
      }).then((value) {
        // Add comment to the separate comments collection
        _commentsCollection.add({
          'hotel_id': hotelId,
          'comment': comment,
          'commenterImageUrl': commenterImageUrl,
          'commenterEmail': commenterEmail,
          'timestamp': timestamp,
        }).then((value) {
          setState(() {
            print('clearing..');
            _commentController.clear();
            _comments.insert(
              0, // Insert at the beginning of the list
              {
                'comment': comment,
                'commenterImageUrl': commenterImageUrl,
                'commenterEmail': commenterEmail,
                'timestamp':
                    _parseTimestamp(timestamp), // Use _parseTimestamp here
              },
            );
          });
        }).catchError((error) {
          print('Failed to add comment to separate collection: $error');
          // Handle error
        });
      }).catchError((error) {
        print('Failed to add comment to hotel collection: $error');
        // Handle error
      });
    }
  }

  // Function to retrieve the commenter's profile image URL
  Future<String?> getCommenterImageUrl() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Assuming you have stored the profile image URL in the user's document in Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      // Assuming 'profileImageUrl' is the field name where you store the profile image URL
      return userDoc.get('imageProfile');
    } else {
      return null;
    }
  }

  // Method to fetch the current user's email
  Future<String?> fetchUserEmail() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      return user.email;
    } else {
      return null;
    }
  }

  // main handle comment
  void _handlePostComment() async {
    String? commenterImageUrl = await getCommenterImageUrl();
    String? commenterEmail = await fetchUserEmail(); // Fetch user's email
    if (commenterImageUrl != null && commenterEmail != null) {
      _postComment(commenterImageUrl, commenterEmail);
    } else {
      // Handle the case where either the commenter's profile image URL or email is not available
      print('Error: Commenter profile image URL or email not available');
    }
  }

  List<Widget> _buildCommentsList() {
    return _comments.map((comment) {
      // Extract comment text from the map
      String commentText = comment['comment'] ?? '';
      return Text(commentText);
    }).toList();
  }
}
