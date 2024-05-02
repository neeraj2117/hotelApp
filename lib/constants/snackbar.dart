import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hotels/constants/fonts.dart';

class ReusableSnackbar {
  static show(
    BuildContext context,
    String message,
    String header,
    Color color, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
              ),
              height: 60,
              child: Row(
                children: [
                  const SizedBox(
                    width: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        header,
                        style: CustomFonts.secondaryTextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        message,
                        style: CustomFonts.secondaryTextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -15,
              left: -25,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                ),
                child: SvgPicture.asset(
                  'lib/assets/bubbles.svg',
                  height: 50,
                  width: 45,
                ),
              ),
            ),
            Positioned(
              left: -15,
              top: -20,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'lib/assets/fail.svg',
                    height: 39,
                    width: 39,
                  ),
                  Positioned(
                    top: 10,
                    child: SvgPicture.asset(
                      'lib/assets/close.svg',
                      height: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}


void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3), // Adjust the duration as needed
    ),
  );
}