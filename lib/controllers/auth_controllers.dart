import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotels/constants/snackbar.dart';
import 'package:hotels/models/person.dart' as personModel;
import 'package:hotels/view/bottom_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController authController = Get.find();

  late Rx<User?> firebaseCurrUser;
  late Rx<File?> pickedFile;
  File? get profileImage => pickedFile.value;
  XFile? imageFile;
  var imagePicker;
  List<XFile> selectedImages = [];
  String? hotelId;

  pickImageFileFromGallery() async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      print('image picked successfully');
    } else {
      Get.snackbar("Profile image", "image selection cancelled or failed");
      pickedFile = Rx<File?>(null);
    }

    pickedFile = Rx<File?>(File(imageFile!.path));
  }

  pickMultipleImageFileFromGallery() async {
    final List<XFile>? selectedimage = await imagePicker.pickMultiImage();

    if (selectedimage!.isNotEmpty) {
      selectedImages.addAll(selectedimage);
    }

    // if (imageFile != null) {
    //   print('image picked successfully');
    // } else {
    //   Get.snackbar("Profile image", "image selection cancelled or failed");
    //   pickedFile = Rx<File?>(null);
    // }
    pickedFile = Rx<File?>(File(imageFile!.path));
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    Reference referenceStorage = FirebaseStorage.instance
        .ref()
        .child("Profile Images")
        .child(FirebaseAuth.instance.currentUser!.uid);

    UploadTask task = referenceStorage.putFile(imageFile);
    TaskSnapshot snapshot = await task;

    String downloadUrlofImage = await snapshot.ref.getDownloadURL();

    return downloadUrlofImage;
  }

  createNewUserAccount(
    BuildContext context,
    String? uid,
    File imageProfile,
    String email,
    String password,
    String name,
    String phone,
    String city,
    String state,
    String country,
    String gender,
    String address,
  ) async {
    try {
      // 1. authenticate user and create user with email and password
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2. upload image to storage
      String urlOfDownloadedImage = await uploadImageToStorage(imageProfile);

      // 3. save user to firebase database
      personModel.Person personInstance = personModel.Person(
        uid: FirebaseAuth.instance.currentUser!.uid,
        imageProfile: urlOfDownloadedImage,
        email: email,
        name: name,
        password: password,
        phone: phone,
        city: city,
        state: state,
        country: country,
        gender: gender,
        address: address,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(personInstance.toJson());

      ReusableSnackbar.show(
        context,
        'Congrat\'s, account has been created.',
        'Account Created!',
        const Color.fromARGB(255, 235, 124, 116),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigationBarrr(
          ),
        ),
      );
    } catch (e) {
      ReusableSnackbar.show(
        context,
        'Account Creation Unsuccessfull',
        'Email already exists.',
        const Color.fromARGB(255, 235, 124, 116),
      );
    }
  }

  loginUser(BuildContext context, String emailUser, String passwordUser) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailUser, password: passwordUser);

      ReusableSnackbar.show(
        context,
        'Let\'s go!',
        'Login successful',
        const Color.fromARGB(255, 235, 124, 116),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigationBarrr(
          ),
        ),
      );
    } catch (e) {
      ReusableSnackbar.show(
        context,
        'Wrong email / password entered.',
        'Login failed',
        const Color.fromARGB(255, 235, 124, 116),
      );
    }
  }
}
