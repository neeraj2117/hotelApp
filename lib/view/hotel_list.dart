import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HotelListScreen extends StatefulWidget {
  @override
  _HotelListScreenState createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  double _minPrice = 0;
  double _maxPrice = 1200; // Initial max price
  late RangeValues _selectedRange = RangeValues(_minPrice, _maxPrice);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel List'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
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
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: fetchHotels(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  // Filter hotels based on selected price range
                  final filteredHotels = snapshot.data!.where((hotel) {
                    final price =
                        double.tryParse(hotel['priceController'] ?? '');
                    return price != null &&
                        price >= _selectedRange.start &&
                        price <= _selectedRange.end;
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredHotels.length,
                    itemBuilder: (context, index) {
                      final hotel = filteredHotels[index];
                      final List<dynamic> images = hotel['image_urls'] ?? [];
                      final String firstImage =
                          images.isNotEmpty ? images[0] : '';

                      return ListTile(
                        leading: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(firstImage),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        title: Text(hotel['titleController']),
                        subtitle: Text('Price: \$${hotel['priceController']}'),
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

void main() {
  runApp(MaterialApp(
    home: HotelListScreen(),
  ));
}
