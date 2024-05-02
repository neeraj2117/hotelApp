import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveModel {
  final String src, artboard, stateMachineName;

  late SMIBool? status;

  RiveModel({
    required this.src,
    required this.artboard,
    required this.stateMachineName,
    this.status,
  });

  set setStaus(SMIBool state) {
    status = state;
  }
}
