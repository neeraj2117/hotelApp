import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotels/constants/fonts.dart';
import 'package:hotels/constants/snackbar.dart';
import 'package:hotels/view/booking_success_screen.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:slide_to_act/slide_to_act.dart';

class BookingScreen extends StatefulWidget {
  final User? currUser;
  final String hotelId;

  const BookingScreen({Key? key, this.currUser, required this.hotelId})
      : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime? _selectedStart;
  late DateTime? _selectedEnd;

  // current user
  final currUser = FirebaseAuth.instance.currentUser!;

  // user's data
  String name = '';
  String email = '';
  String phone = '';

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
          phone = snapshot.data()!["phone"];
        });
        print('Guest Name: $name');
        print('Guest Email: $email');
        print('Guest Phone: $phone');
      }
    } else {
      print('user not exists');
    }
  }

  // hotel's data
  String? hotelId;
  String? hotelName;
  String? hotelContact;
  String? hotelAddress;
  String? hotelAmenitiesBeds;
  String? hotelAmenitiesBaths;
  String? hotelAmenitiesBalconys;
  String? hotelAmenitiesFurnishing;
  String? hotelAmenitiesWifi;
  String? hotelAmenitiesParking;
  String? hotelPrice;

  // // fetching hotel data from firebase database
  Future<void> fetchHotelData({String? hotelId}) async {
    if (hotelId == null) {
      print('Error: hotelId is null');
      return;
    }

    try {
      QuerySnapshot hotelSnapshot = await FirebaseFirestore.instance
          .collection('HotelsData')
          .where('hotelId', isEqualTo: hotelId)
          .get();

      if (hotelSnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = hotelSnapshot.docs.first;
        if (doc['hotelId'] == hotelId) {
          hotelName = doc['titleController'];
          hotelAddress = doc['addressController'];
          hotelContact = doc['contactController'];
          hotelAmenitiesBeds = doc['selectedBedController'];
          hotelAmenitiesBaths = doc['selectedBathController'];
          hotelAmenitiesBalconys = doc['selectedBalconyController'];
          hotelAmenitiesWifi = doc['selectedWifiController'];
          hotelAmenitiesParking = doc['parkingController'];
          hotelPrice = doc['priceController'];
        } else {
          print('No hotel found with ID: $hotelId');
        }
      } else {
        print('No hotel found with ID: $hotelId');
      }
    } catch (e) {
      print('Error fetching hotel data: $e');
    }
  }

  // Guests controllers
  int adults = 0;
  int children = 0;
  int numberOfRooms = 0;

  // controllers for selecting the payment mode
  bool isCardSelected = false;
  bool isCashSelected = false;
  bool isUpiSelected = false;

  // Define a function to get the selected payment mode
  String getSelectedPaymentMode() {
    if (isCardSelected) {
      return 'Card';
    } else if (isCashSelected) {
      return 'Cash';
    } else if (isUpiSelected) {
      return 'UPI';
    } else {
      return '';
    }
  }

  // Define a function to handle booking
  void bookHotel() {
    // Check if all necessary data is available for booking
    if (_selectedStart != null &&
        _selectedEnd != null &&
        adults > 0 &&
        numberOfRooms > 0) {
      // Retrieve hotel data
      fetchHotelData(hotelId: widget.hotelId).then((_) {
        // Retrieve user data
        retrieveUserInfo().then((_) {
          // Create a booking object
          var bookingData = {
            'checkInDate': _selectedStart,
            'checkOutDate': _selectedEnd,
            'adults': adults,
            'children': children,
            'numberOfRooms': numberOfRooms,
            'paymentMode': getSelectedPaymentMode(),
            'bookingDateTime': DateTime.now(),
            'hotelData': {
              'hotelId': widget.hotelId,
              'hotelName': hotelName,
              'hotelContact': hotelContact,
              'hotelAddress': hotelAddress,
              'hotelAmenitiesBeds': hotelAmenitiesBeds,
              'hotelAmenitiesBaths': hotelAmenitiesBaths,
              'hotelAmenitiesBalconys': hotelAmenitiesBalconys,
              'hotelAmenitiesFurnishing': hotelAmenitiesFurnishing,
              'hotelAmenitiesWifi': hotelAmenitiesWifi,
              'hotelAmenitiesParking': hotelAmenitiesParking,
              'hotelPrice': hotelPrice,
            },
            'userData': {
              'userId': currUser.uid,
              'name': name,
              'email': email,
              'phone': phone,
            },
          };

          // Update user's booking details
          updateUserBooking(bookingData);

          // Update hotel's booking details
          updateHotelBooking(bookingData);

          ReusableSnackbar.show(
              context, 'Booking successfull', 'Success', Colors.blue);

          // Delay navigation to new page by 1 second
          Timer(const Duration(seconds: 1), () {
            // Navigate to new page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BookingSuccessfullScreen(
                  hotelId: widget.hotelId,
                ),
              ),
            );
          });
        });
      });
    } else {
      // Show error message if any required data is missing
      ReusableSnackbar.show(
          context, 'Booking Unsuccessfull', 'Unsuccess', Colors.red);
      print('Please select all necessary details for booking.');
    }
  }

  // Define a function to update hotel's booking details
  void updateHotelBooking(Map<String, dynamic> bookingData) {
    // Create a new document for booking in the hotel's collection
    FirebaseFirestore.instance
        .collection('HotelsData')
        .doc(widget.hotelId)
        .collection('Bookings')
        .add(bookingData)
        .then((_) {
      print('Hotel booking details updated successfully.');
    }).catchError((error) {
      print('Failed to update hotel booking details: $error');
    });
  }

  // Define a function to update user's booking details
  void updateUserBooking(Map<String, dynamic> bookingData) {
    // Update user's booking details in Firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(currUser.uid)
        .update({'bookingData': bookingData}).then((_) {
      print('User booking details updated successfully.');
    }).catchError((error) {
      print('Failed to update user booking details: $error');
    });
  }

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedStart = null;
    _selectedEnd = null;
    retrieveUserInfo();
    fetchHotelData(hotelId: widget.hotelId);
  }

  void incrementAdults() {
    setState(() {
      adults++;
    });
  }

  void incrementRooms() {
    setState(() {
      numberOfRooms++;
    });
  }

  void decrementRooms() {
    if (numberOfRooms > 0) {
      setState(() {
        numberOfRooms--;
      });
    }
  }

  void decrementAdults() {
    if (adults > 0) {
      setState(() {
        adults--;
      });
    }
  }

  void incrementChildren() {
    setState(() {
      children++;
    });
  }

  void decrementChildren() {
    if (children > 0) {
      setState(() {
        children--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      // appBar: AppBar(
      //   backgroundColor: Colors.grey.shade300,
      //   titleSpacing: 0,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       InkWell(
      //         onTap: () {
      //           Navigator.pop(context);
      //         },
      //         child: Padding(
      //           padding: const EdgeInsets.only(left: 15.0, top: 5),
      //           child: Container(
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(30),
      //               border: Border.all(
      //                 color: Colors.grey,
      //               ),
      //             ),
      //             child: Padding(
      //               padding: const EdgeInsets.all(6.0),
      //               child: Image.asset(
      //                 'lib/assets/x.png',
      //                 height: 23,
      //                 width: 23,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //       Container(
      //         height: 5,
      //         width: 60,
      //         decoration: BoxDecoration(
      //           color: Colors.grey,
      //           border: Border.all(
      //             color: Colors.grey,
      //           ),
      //           borderRadius: BorderRadius.circular(10),
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.only(right: 15.0, top: 5),
      //         child: Container(
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(30),
      //             border: Border.all(
      //               color: Colors.grey,
      //             ),
      //           ),
      //           child: IconButton(
      //             icon: const Icon(
      //               Icons.edit_sharp,
      //               size: 25,
      //             ),
      //             onPressed: () {},
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      //   toolbarHeight: 43,
      //   automaticallyImplyLeading: false,
      // ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.5),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20), // Adjust the radius as needed
          ),
          child: AppBar(
            backgroundColor: Colors.grey.shade300,
            titleSpacing: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Image.asset(
                          'lib/assets/x.png',
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 5,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, top: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit_sharp,
                        size: 24,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            toolbarHeight: 63.5,
            automaticallyImplyLeading: false,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 29.0),
                  child: Text(
                    'Select Dates',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),

            // calendar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                ),
              ),
              margin: const EdgeInsets.only(left: 25, right: 25, top: 5),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TableCalendar(
                  firstDay: DateTime(2000),
                  lastDay: DateTime(3000),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: RangeSelectionMode.toggledOff,
                  rangeStartDay: _selectedStart,
                  rangeEndDay: _selectedEnd,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      if (_selectedStart == null || _selectedEnd != null) {
                        _selectedStart = selectedDay;
                        _selectedEnd = null;
                      } else {
                        if (_selectedStart!.isBefore(selectedDay)) {
                          _selectedEnd = selectedDay;
                        } else {
                          _selectedEnd = _selectedStart;
                          _selectedStart = selectedDay;
                        }
                      }
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            // check in - check out
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 70,
                        width: 162,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                size: 28,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                _formatDate(_selectedStart),
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        left: 14,
                        child: Text(
                          'Check In',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600]!,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 70,
                        width: 164,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                size: 28,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                _formatDate(_selectedEnd),
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        left: 14,
                        child: Text(
                          'Check Out',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600]!,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // select guests text
            const Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 29.0),
                  child: Text(
                    'Select Guests',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // adults
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 13.0),
                    child: Row(
                      children: [
                        Text(
                          'Adults',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700]!,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.remove,
                            size: 18,
                          ),
                          onPressed: decrementAdults,
                        ),
                        Text(
                          '$adults',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add,
                            size: 18,
                          ),
                          onPressed: incrementAdults,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  width: 6,
                ),

                // children
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 13.0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Children',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700]!,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.remove,
                            size: 18,
                          ),
                          onPressed: decrementChildren,
                        ),
                        Text(
                          '$children',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add,
                            size: 18,
                          ),
                          onPressed: incrementChildren,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 25,
            ),

            // select rooms text
            const Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 29.0),
                  child: Text(
                    'Select Number of Rooms',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 23.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // rooms
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: [
                          Text(
                            'Rooms',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700]!,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove,
                              size: 18,
                            ),
                            onPressed: decrementRooms,
                          ),
                          Text(
                            '$numberOfRooms',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add,
                              size: 18,
                            ),
                            onPressed: incrementRooms,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            // payment method text
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 29.0),
                  child: Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),

            GestureDetector(
              onTap: () {
                setState(() {
                  isCardSelected = true;
                  isUpiSelected = false;
                  isCashSelected = false;
                });
              },
              child: Container(
                height: 40,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                decoration: BoxDecoration(
                  color: isCardSelected
                      ? Color.fromARGB(255, 191, 221, 246)
                      : Colors.white,
                  border: Border.all(
                    color: isCardSelected ? Colors.blue : Colors.white,
                    width: .7,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    'Card',
                    style: TextStyle(
                      color: isCardSelected ? Colors.black : Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isCardSelected = false;
                  isUpiSelected = false;
                  isCashSelected = true;
                });
              },
              child: Container(
                height: 40,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                decoration: BoxDecoration(
                  color: isCashSelected
                      ? Color.fromARGB(255, 191, 221, 246)
                      : Colors.white,
                  border: Border.all(
                    color: isCashSelected ? Colors.blue : Colors.white,
                    width: .7,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    'Cash',
                    style: TextStyle(
                      color: isCashSelected ? Colors.black : Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isCardSelected = false;
                  isCashSelected = false;
                  isUpiSelected = true;
                });
              },
              child: Container(
                height: 40,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                decoration: BoxDecoration(
                  color: isUpiSelected
                      ? Color.fromARGB(255, 191, 221, 246)
                      : Colors.white,
                  border: Border.all(
                    color: isUpiSelected ? Colors.blue : Colors.white,
                    width: .7,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    'Upi (online)',
                    style: TextStyle(
                      color: isUpiSelected ? Colors.black : Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            // booking buttton
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
              child: SlideAction(
                height: 57,
                text: ' Slide to Book!',
                textColor: Colors.blue,
                textStyle: CustomFonts.secondaryTextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
                onSubmit: () {
                  bookHotel();
                },
                elevation: 0,
                innerColor: Colors.blue.shade600,
                outerColor: Colors.blue.shade300,
                sliderButtonIcon: const Icon(
                  Icons.monetization_on,
                  color: Colors.white,
                ),
                sliderButtonIconPadding: 12,
              ),
            ),

            const SizedBox(
              height: 200,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    return date != null ? DateFormat('MMMM d').format(date) : "";
  }
}
