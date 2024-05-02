import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotels/constants/favorate.dart';
import 'package:hotels/constants/fonts.dart';
import 'package:hotels/constants/search_textfield.dart';
import 'package:hotels/constants/snackbar.dart';
import 'package:hotels/view/detailed_hotel_screen.dart';
import 'package:hotels/view/post_screen.dart';
import 'package:hotels/view/profile_screen.dart';
import 'package:hotels/view/booking_screen.dart';

class HomeScreen extends StatefulWidget {
  final User? currUser;

  HomeScreen({
    Key? key,
    this.currUser,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  bool isFavorite = false;

  // current user
  final currUser = FirebaseAuth.instance.currentUser!;

  // user's data
  String name = '';
  String email = '';
  String gender = '';
  String phone = '';
  String city = '';
  String state = '';
  String country = '';
  String address = '';

  // List to store hotel data
  List<Map<String, dynamic>> hotels = [];

  // fetching user data from firebase database
  Future<void> retrieveUserInfo() async {
    if (widget.currUser != null) {
      print('user exists');
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.currUser!.uid)
          .get();
      if (snapshot.exists) {
        setState(() {
          name = snapshot.data()!["name"];
          email = snapshot.data()!["email"];
          gender = snapshot.data()!["gender"];
          phone = snapshot.data()!["phone"];
          city = snapshot.data()!["city"];
          state = snapshot.data()!["state"];
          country = snapshot.data()!["country"];
          address = snapshot.data()!["address"];
        });
      }
    } else {
      print('user not exists');
    }
  }

  // hotel's data
  String? selectedLookingToController;
  String? selectedKindOfPropertyController;
  String? selectedPropertyTypeController;
  String? titleController;
  String? addressController;
  String? contactController;
  String? descController;
  String? selectedBedController;
  String? selectedBathController;
  String? selectedBalconyController;
  String? selectedFurnishingController;
  String? parkingController;
  String? selectedPetController;
  String? selectedSmokeController;
  String? selectedWifiController;
  String? priceController;
  String? hotelId;
  String? rating;

  List<String> hotelImages = [];

  Future<void> fetchHotelData() async {
    try {
      QuerySnapshot hotelSnapshot =
          await FirebaseFirestore.instance.collection('HotelsData').get();

      hotelSnapshot.docs.forEach((doc) {
        hotelId = doc['hotelId'];
        selectedLookingToController = doc['selectedLookingToController'];
        selectedKindOfPropertyController =
            doc['selectedKindOfPropertyController'];
        selectedPropertyTypeController = doc['selectedPropertyTypeController'];
        titleController = doc['titleController'];
        addressController = doc['addressController'];
        contactController = doc['contactController'];
        descController = doc['descController'];
        addressController = doc['addressController'];
        selectedBedController = doc['selectedBedController'];
        selectedBathController = doc['selectedBathController'];
        selectedBalconyController = doc['selectedBalconyController'];
        selectedFurnishingController = doc['selectedFurnishingController'];
        parkingController = doc['parkingController'];
        selectedPetController = doc['selectedPetController'];
        selectedSmokeController = doc['selectedSmokeController'];
        selectedWifiController = doc['selectedWifiController'];
        priceController = doc['priceController'];
        rating = doc['rating'];

        // Fetch images array
        List<dynamic> images = doc['image_urls'];
        hotelImages.clear(); // Clear previous images
        images.forEach((image) {
          hotelImages.add(image.toString());
        });
      });
    } catch (e) {
      print('Error fetching hotel data: $e');
    }
  }

  DecorationImage _getImageDecoration() {
    if (hotelImages.isNotEmpty) {
      // Use the first image URL from the hotelImages list
      return DecorationImage(
        image: NetworkImage(hotelImages.first),
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      );
    } else {
      // Fallback to the default asset image if hotelImages is empty
      return const DecorationImage(
        image: AssetImage('lib/assets/hotels/1.png'),
        alignment: Alignment.topCenter,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    retrieveUserInfo();
    fetchHotelData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(48),
                              ),
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.45),
                                  BlendMode.srcOver,
                                ),
                                child: Image.asset(
                                  'lib/assets/hotels/banner1.jpeg',
                                  fit: BoxFit.cover,
                                  height: 291,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 60,
                          left: 20,
                          right: 15,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'lib/assets/hotels/send.png',
                                      height: 27,
                                      width: 27,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      city,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: ((context) =>
                                                const PostScreen()),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 30, 125, 208),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 8),
                                          child: Text(
                                            'Post',
                                            style:
                                                CustomFonts.secondaryTextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 120,
                          left: 19,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Hey, $name! Tell us \nwhere you want to go',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 210,
                          left: 20,
                          right: 20,
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => const SearchScreen(),
                              //   ),
                              // );
                            },
                            child: CustomSearchField(
                              controller: searchController,
                              hintText: 'Search in $city',
                            ),
                          ),
                        )
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 21.0, left: 21),
                      child: Text(
                        'The most relevant',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    // Display hotel data here
                    FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('HotelsData')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final hotels = snapshot.data!.docs;
                          return Container(
                            height: 335,
                            width: 418,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: hotels.map((hotel) {
                                final hotelId = hotel['hotelId'];
                                final title = hotel['titleController'];
                                final address = hotel['addressController'];
                                final price = hotel['priceController'];
                                final beds = hotel['selectedBedController'];
                                final baths = hotel['selectedBathController'];
                                final Address = hotel['addressController'];
                                final contact = hotel['contactController'];
                                final description = hotel['descController'];
                                final parking = hotel['parkingController'];
                                final balcony =
                                    hotel['selectedBalconyController'];
                                final furnishing =
                                    hotel['selectedFurnishingController'];
                                final selectedKindOfPropertyController =
                                    hotel['selectedKindOfPropertyController'];
                                final pet = hotel['selectedPetController'];
                                final smoke = hotel['selectedSmokeController'];
                                final wifi = hotel['selectedWifiController'];
                                final rating = hotel['rating'];

                                final List<dynamic> images =
                                    hotel['image_urls'];

                                // Extract the first image URL
                                final String firstImageUrl =
                                    images.isNotEmpty ? images[0] : '';

                                return Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      margin: const EdgeInsets.only(
                                          left: 12, top: 8),
                                      width: 320,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Display the first hotel image
                                          if (firstImageUrl.isNotEmpty)
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HotelDetailsScreen(
                                                      hotelId: hotelId,
                                                      imageUrl: firstImageUrl,
                                                      title: title,
                                                      address: address,
                                                      price: price,
                                                      beds: beds,
                                                      baths: baths,
                                                      images: images,
                                                      Address: Address,
                                                      contact: contact,
                                                      description: description,
                                                      parking: parking,
                                                      balcony: balcony,
                                                      furnishing: furnishing,
                                                      selectedKindOfPropertyController:
                                                          selectedKindOfPropertyController,
                                                      pet: pet,
                                                      wifi: wifi,
                                                      smoke: smoke,
                                                      rating: rating,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                  bottom: Radius.circular(25),
                                                  top: Radius.circular(25),
                                                ),
                                                child: Image.network(
                                                  firstImageUrl,
                                                  fit: BoxFit.cover,
                                                  width: 320,
                                                  height: 237,
                                                ),
                                              ),
                                            ),

                                          ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Hotel title
                                                Text(
                                                  title,
                                                  style: CustomFonts
                                                      .secondaryTextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18,
                                                  ),
                                                ),

                                                // Ratings
                                                Row(
                                                  children: [
                                                    Row(
                                                      children: List.generate(
                                                        double.parse(rating)
                                                            .floor(),
                                                        (index) => const Icon(
                                                          Icons.star,
                                                          size: 20,
                                                          color: Color.fromARGB(
                                                              255, 255, 191, 0),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),

                                            // Amenities
                                            subtitle: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Amenities
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Amenities : ',
                                                      style: CustomFonts
                                                          .secondaryTextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 6,
                                                    ),
                                                    Text(
                                                      '$beds bedrooms',
                                                      style: CustomFonts
                                                          .secondaryTextStyle(
                                                        color:
                                                            Colors.grey[600]!,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      '•',
                                                      style: CustomFonts
                                                          .secondaryTextStyle(
                                                        color:
                                                            Colors.grey[600]!,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      '$baths bathrooms',
                                                      style: CustomFonts
                                                          .secondaryTextStyle(
                                                        color:
                                                            Colors.grey[600]!,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                // Price
                                                Row(
                                                  children: [
                                                    Text(
                                                      '€120',
                                                      style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        fontSize: 13,
                                                        color:
                                                            Colors.grey[600]!,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '€$price per night',
                                                      style: CustomFonts
                                                          .secondaryTextStyle(
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          );
                        }
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // divider
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(),
                    ),

                    // new homes text
                    const Padding(
                      padding: EdgeInsets.only(top: 5.0, left: 22),
                      child: Text(
                        'Discover new places',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // Display hotel data here
                    FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('HotelsData')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final hotels = snapshot.data!.docs;
                          return Container(
                            height: 320,
                            width: 420,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: hotels.map((hotel) {
                                  final hotelId = hotel['hotelId'];
                                  final title = hotel['titleController'];
                                  final address = hotel['addressController'];
                                  final price = hotel['priceController'];
                                  final beds = hotel['selectedBedController'];
                                  final baths = hotel['selectedBathController'];
                                  final Address = hotel['addressController'];
                                  final contact = hotel['contactController'];
                                  final description = hotel['descController'];
                                  final parking = hotel['parkingController'];
                                  final balcony =
                                      hotel['selectedBalconyController'];
                                  final furnishing =
                                      hotel['selectedFurnishingController'];
                                  final selectedKindOfPropertyController =
                                      hotel['selectedKindOfPropertyController'];
                                  final pet = hotel['selectedPetController'];
                                  final smoke =
                                      hotel['selectedSmokeController'];
                                  final wifi = hotel['selectedWifiController'];
                                  final rating = hotel['rating'];

                                  final List<dynamic> images =
                                      hotel['image_urls'];

                                  // Extract the first image URL
                                  final String firstImageUrl =
                                      images.isNotEmpty ? images[0] : '';

                                  return GestureDetector(
                                    onTap: () {
                                      // Navigate to detailed page screen 
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HotelDetailsScreen(
                                            hotelId: hotelId,
                                            imageUrl: firstImageUrl,
                                            title: title,
                                            address: address,
                                            price: price,
                                            beds: beds,
                                            baths: baths,
                                            images: images,
                                            Address: Address,
                                            contact: contact,
                                            description: description,
                                            parking: parking,
                                            balcony: balcony,
                                            furnishing: furnishing,
                                            selectedKindOfPropertyController:
                                                selectedKindOfPropertyController,
                                            pet: pet,
                                            wifi: wifi,
                                            smoke: smoke,
                                            rating: rating,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      margin: const EdgeInsets.only(
                                          left: 17,
                                          top: 2,
                                          right: 3,
                                          bottom: 10),
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Display the first hotel image
                                          if (firstImageUrl.isNotEmpty)
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                firstImageUrl,
                                                fit: BoxFit.cover,
                                                width: 125,
                                                height: 174,
                                              ),
                                            ),
                                          const SizedBox(width: 10),

                                          // Display hotel details
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  title,
                                                  style: CustomFonts
                                                      .secondaryTextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  address,
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  '$beds bedrooms • $baths bathrooms',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          '\$$price/night',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 17,
                                                          ),
                                                        ),
                                                        const Text(
                                                          '\$350/night',
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 13,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10.0),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.blue,
                                                          foregroundColor:
                                                              Colors.white,
                                                        ),
                                                        onPressed: () {},
                                                        child:
                                                            const Text('Book'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
