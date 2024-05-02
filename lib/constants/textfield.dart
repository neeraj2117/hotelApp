import 'package:flutter/material.dart';
import 'package:hotels/constants/fonts.dart';

class ReusableTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final IconData iconData;
  final TextEditingController? controller;

  ReusableTextField({
    Key? key,
    required this.hintText,
    this.isPassword = false,
    required this.iconData,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.end,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(iconData),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class PostTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final IconData iconData;
  final TextEditingController? controller;

  PostTextField({
    Key? key,
    required this.hintText,
    this.isPassword = false,
    required this.iconData,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: CustomFonts.secondaryTextStyle(
              color: Colors.grey[700]!, fontSize: 17),
          prefixIcon: Icon(iconData),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
