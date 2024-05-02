import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotels/constants/fonts.dart';
import 'package:hotels/view/detailed_hotel_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  double _minPrice = 0;
  double _maxPrice = 1500;
  late RangeValues _selectedRange = RangeValues(_minPrice, _maxPrice);
  late TextEditingController _searchController = TextEditingController();
  String? _selectedPropertyType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Filter List',
          style: CustomFonts.secondaryTextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: const Icon(Icons.filter_alt),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${_selectedRange.start.toInt()}'),
                Text('\$${_selectedRange.end.toInt()}'),
              ],
            ),
          ),
          RangeSlider(
            values: _selectedRange,
            min: _minPrice,
            max: _maxPrice,
            onChanged: (RangeValues values) {
              setState(() {
                _selectedRange = values;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 0.0, right: 12.0),
                      child: Image.asset(
                        'lib/assets/search.png',
                        height: 23,
                        width: 25,
                        color: Colors.black,
                      ),
                    ),
                    hintText: 'Search by hotel name...',
                    hintStyle: CustomFonts.secondaryTextStyle(
                      fontSize: 20,
                      color: Colors.grey[600]!,
                    ),
                    border: InputBorder.none,
                  ),
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      // Handle onChanged event
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),

          // Scrollable horizontal containers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPropertyType = 'Apartment';
                      });
                    },
                    child: Container(
                      height: 45,
                      width: 135,
                      decoration: BoxDecoration(
                        color: _selectedPropertyType == 'Apartment'
                            ? Colors.grey[800]
                            : Colors.grey[500],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'lib/assets/house.png',
                              height: 23,
                              width: 23,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Apartment',
                              style: CustomFonts.secondaryTextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPropertyType = 'House/Villa';
                      });
                    },
                    child: Container(
                      height: 45,
                      width: 137,
                      decoration: BoxDecoration(
                        color: _selectedPropertyType == 'House/Villa'
                            ? Colors.grey[800]
                            : Colors.grey[500],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'lib/assets/villa.png',
                              height: 23,
                              width: 23,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'House / Villa',
                              style: CustomFonts.secondaryTextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPropertyType = 'Farmhouse';
                      });
                    },
                    child: Container(
                      height: 45,
                      width: 135,
                      decoration: BoxDecoration(
                        color: _selectedPropertyType == 'Farmhouse'
                            ? Colors.grey[800]
                            : Colors.grey[500],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'lib/assets/warehouse-1.png',
                              height: 19,
                              width: 19,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Farmhouse',
                              style: CustomFonts.secondaryTextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: fetchHotels(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  // Filter hotels based on selected price range, search query, and property type
                  final filteredHotels = snapshot.data!.where((hotel) {
                    final price =
                        double.tryParse(hotel['priceController'] ?? '');
                    final title =
                        hotel['titleController'].toString().toLowerCase();
                    final searchQuery = _searchController.text.toLowerCase();
                    final propertyType =
                        hotel['selectedPropertyTypeController'].toString();

                    return price != null &&
                        price >= _selectedRange.start &&
                        price <= _selectedRange.end &&
                        (searchQuery.isEmpty || title.contains(searchQuery)) &&
                        (_selectedPropertyType == null ||
                            propertyType == _selectedPropertyType);
                  }).toList();

                  if (filteredHotels.isEmpty) {
                    return Center(
                        child: Text(
                      'No hotels found.',
                      style: CustomFonts.primaryTextStyle(),
                    ));
                  }

                  return ListView.builder(
                    itemCount: filteredHotels.length,
                    itemBuilder: (context, index) {
                      final hotel = filteredHotels[index];
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
                      final balcony = hotel['selectedBalconyController'];
                      final furnishing = hotel['selectedFurnishingController'];
                      final selectedKindOfPropertyController =
                          hotel['selectedKindOfPropertyController'];
                      final pet = hotel['selectedPetController'];
                      final smoke = hotel['selectedSmokeController'];
                      final wifi = hotel['selectedWifiController'];
                      final rating = hotel['rating'];

                      final List<dynamic> images = hotel['image_urls'];
                      final String firstImage =
                          images.isNotEmpty ? images[0] : '';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey[300]!),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(1, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HotelDetailsScreen(
                                              hotelId: hotelId,
                                              imageUrl: firstImage,
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
                                              rating: rating),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7.0),
                                        child: Container(
                                          width: 360,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(firstImage),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      hotel['titleController'],
                                      style: CustomFonts.secondaryTextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 21,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Price: \$${hotel['priceController']}',
                                      style: CustomFonts.secondaryTextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<DocumentSnapshot>> fetchHotels() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('HotelsData').get();
    return querySnapshot.docs;
  }
}
