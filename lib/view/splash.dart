import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hotels/constants/fonts.dart';
import 'package:hotels/view/allOnboards.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(milliseconds: 5000),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AllOnboardScreens(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 80,
          ),
          Center(
            child: Column(
              children: [
                Lottie.asset(
                  'lib/assets/splash.json',
                  height: 400,
                  width: 400,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Welcome to ApnaPG',
                  style: CustomFonts.primaryTextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    'Unlock Your Dream Stay: Your Perfect Getaway Awaits with Our Seamless Hotel Booking ApnaPG App!',
                    style: CustomFonts.secondaryTextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[700]!,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Lottie.asset(
                  'lib/assets/load2.json',
                  height: 90,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
