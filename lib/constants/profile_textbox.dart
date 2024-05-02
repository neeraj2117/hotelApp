import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String labelText;
  final String initialValue;
  final void Function(String?)? onSaved;

  const MyTextBox({
    Key? key,
    required this.labelText,
    required this.initialValue,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        onSaved: onSaved,
      ),
    );
  }
}
