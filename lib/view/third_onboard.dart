import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hotels/constants/fonts.dart';
import 'package:hotels/view/explore.dart';

class ThirdOnboard extends StatefulWidget {
  const ThirdOnboard({super.key});

  @override
  State<ThirdOnboard> createState() => _ThirdOnboardState();
}

class _ThirdOnboardState extends State<ThirdOnboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'lib/assets/img3.jpeg',
                      fit: BoxFit.cover,
                    ),
                    // Adding a blur effect
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 33),
                          child: Text(
                            'Hurry Up! \nand get start exploring.',
                            style: CustomFonts.primaryTextStyle(
                              fontSize: 45,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF3C3633),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 25.0,
                                bottom: 40,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.black12,
                                    ),
                                    borderRadius: BorderRadius.circular(40)),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) =>
                                              const ExploreScreen()),
                                        ),
                                      );
                                    },
                                    child: Image.asset(
                                      'lib/assets/arrow1.png',
                                      height: 66,
                                      width: 66,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
