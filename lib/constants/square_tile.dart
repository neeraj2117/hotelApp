import 'package:flutter/material.dart';

class SquareTile extends StatefulWidget {
  final Color color;

  const SquareTile({super.key, required this.color});

  @override
  State<SquareTile> createState() => _SquareTileState();
}

class _SquareTileState extends State<SquareTile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 80,
        width: 75,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }
}
