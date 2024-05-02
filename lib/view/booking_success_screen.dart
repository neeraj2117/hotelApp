import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hotels/constants/fonts.dart';
import 'package:hotels/view/home_screen.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';

class BookingSuccessfullScreen extends StatefulWidget {
  final String hotelId;
  const BookingSuccessfullScreen({Key? key, required this.hotelId})
      : super(key: key);

  @override
  State<BookingSuccessfullScreen> createState() =>
      _BookingSuccessfullScreenState();
}

class _BookingSuccessfullScreenState extends State<BookingSuccessfullScreen> {
  late ConfettiController _controller;
  double _userRating = 3;
  
  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 5));
    // Start confetti animation
    _controller.play();

    Future.delayed(const Duration(seconds: 15), () {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _controller.play();
    });
    print(widget.hotelId);
    return Scaffold(
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConfettiWidget(
                confettiController: _controller,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: true,
              ),
              Lottie.asset(
                'lib/assets/success.json',
                height: 300,
                width: 400,
              ),
              Text(
                'Booking Successful! 🎉',
                style: CustomFonts.secondaryTextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  'You can check your booking details on \n                   your history page.',
                  style: CustomFonts.secondaryTextStyle(
                    color: Colors.grey[600]!,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 180),
              RatingBar.builder(
                initialRating: _userRating,
                minRating: 1,
                maxRating: 5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return const Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Colors.red,
                      );
                    case 1:
                      return const Icon(
                        Icons.sentiment_dissatisfied,
                        color: Colors.redAccent,
                      );
                    case 2:
                      return const Icon(
                        Icons.sentiment_neutral,
                        color: Colors.amber,
                      );
                    case 3:
                      return const Icon(
                        Icons.sentiment_satisfied,
                        color: Colors.lightGreen,
                      );
                    case 4:
                      return const Icon(
                        Icons.sentiment_very_satisfied,
                        color: Colors.green,
                      );
                    default:
                      return const Text('');
                  }
                },
                onRatingUpdate: (rating) {
                  setState(() {
                    _userRating = rating;
                  });
                  // Update rating in Firebase
                  updateRatingInFirebase(rating);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'HomePage',
                        style: CustomFonts.secondaryTextStyle(
                          color: Colors.blue.shade500,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.blue,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void updateRatingInFirebase(double rating) {
    FirebaseFirestore.instance
        .collection('HotelsData')
        .doc(widget.hotelId)
        .update({'rating': rating}).then((_) {
      print('Rating updated successfully!');
    }).catchError((error) {
      print('Error updating rating: $error');
    });
  }
}
