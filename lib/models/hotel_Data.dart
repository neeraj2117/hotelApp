import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HotelData {
  final String title;
  final String address;
  final String contact;
  final String description;
  final String selectedBed;
  final String selectedBath;
  final String selectedBalcony;
  final String selectedFurnishing;
  final String parking;
  final String selectedPet;
  final String selectedSmoke;
  final String selectedWifi;
  final String price;
  final List<String> imageUrls;

  HotelData({
    required this.title,
    required this.address,
    required this.contact,
    required this.description,
    required this.selectedBed,
    required this.selectedBath,
    required this.selectedBalcony,
    required this.selectedFurnishing,
    required this.parking,
    required this.selectedPet,
    required this.selectedSmoke,
    required this.selectedWifi,
    required this.price,
    required this.imageUrls,
  });
}

class TimePassScreen extends StatefulWidget {
  @override
  _TimePassScreenState createState() => _TimePassScreenState();
}

class _TimePassScreenState extends State<TimePassScreen> {
  List<HotelData> hotels = [];

  @override
  void initState() {
    super.initState();
    fetchHotelData();
  }

  Future<void> fetchHotelData() async {
    try {
      QuerySnapshot hotelSnapshot =
          await FirebaseFirestore.instance.collection('HotelsData').get();

      hotels.clear();

      hotelSnapshot.docs.forEach((doc) {
        List<dynamic> images = doc['image_urls'];

        HotelData hotel = HotelData(
          title: doc['title'] ?? '',
          address: doc['address'] ?? '',
          contact: doc['contact'] ?? '',
          description: doc['description'] ?? '',
          selectedBed: doc['selectedBed'] ?? '',
          selectedBath: doc['selectedBath'] ?? '',
          selectedBalcony: doc['selectedBalcony'] ?? '',
          selectedFurnishing: doc['selectedFurnishing'] ?? '',
          parking: doc['parking'] ?? '',
          selectedPet: doc['selectedPet'] ?? '',
          selectedSmoke: doc['selectedSmoke'] ?? '',
          selectedWifi: doc['selectedWifi'] ?? '',
          price: doc['price'] ?? '',
          imageUrls: List<String>.from(images.map((image) => image.toString())),
        );

        setState(() {
          hotels.add(hotel);
        });
      });
    } catch (e) {
      print('Error fetching hotel data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotels'),
      ),
      body: ListView.builder(
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          HotelData hotel = hotels[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(hotel.title),
              subtitle: Text(hotel.address),
              trailing: Text('Price: ${hotel.price}'),
            ),
          );
        },
      ),
    );
  }
}
