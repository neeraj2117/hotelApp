import 'package:flutter/material.dart';
import 'package:hotels/constants/fonts.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const CustomSearchField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.grey.withOpacity(0.45),
      ),
      child: ClipRect(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: CustomFonts.secondaryTextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 13.0, right: 13.0),
                child: Image.asset(
                  'lib/assets/search.png',
                  height: 23,
                  width: 23,
                  color: Colors.white,
                ),
              ),
            ),
            cursorColor: Colors.white70,
          ),
        ),
      ),
    );
  }
}
