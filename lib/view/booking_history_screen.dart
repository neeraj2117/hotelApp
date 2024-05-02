import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BookingHistoryScreen extends StatefulWidget {
  final User? currUser;

  const BookingHistoryScreen({super.key, this.currUser});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  final currUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    print(widget.currUser!.uid);
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking History'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: fetchBookingHistory(widget.currUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Extract data from snapshot
            List<DocumentSnapshot> bookingDocs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: bookingDocs.length,
              itemBuilder: (context, index) {
                // Extract data from each document
                DocumentSnapshot bookingDoc = bookingDocs[index];
                String bookingId = bookingDoc.id;
                Map<String, dynamic> bookingData =
                    bookingDoc.data() as Map<String, dynamic>;

                // Build a ListTile for each booking
                return ListTile(
                  title: Text('Booking ID: $bookingId'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text('Check-in: ${bookingData['checkin']}'),
                      // Text('Check-out: ${bookingData['checkout']}'),
                      Text('Adults: ${bookingData['adults']}'),
                      Text('Children: ${bookingData['children']}'),
                      // Handle array data
                      if (bookingData.containsKey('hotelData'))
                        ...List.generate(bookingData['hotelData'].length,
                            (index) {
                          return Text(
                              'Hotel ${index + 1}: ${bookingData['hotelData'][index]}');
                        }),
                      if (bookingData.containsKey('userData'))
                        ...List.generate(bookingData['userData'].length,
                            (index) {
                          return Text(
                              'User ${index + 1}: ${bookingData['userData'][index]}');
                        }),
                      // Add more conditions if needed for other array data
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<QuerySnapshot> fetchBookingHistory(String userId) async {
    try {
      // Get reference to Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the bookingData collection for the specific user
      CollectionReference bookingDataCollection =
          firestore.collection('users').doc(userId).collection('bookingData');

      // Fetch booking history documents
      return await bookingDataCollection.get();
    } catch (e) {
      throw Exception('Error fetching booking history: $e');
    }
  }
}
