import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hotels/constants/buttons.dart';
import 'package:hotels/constants/colors.dart';
import 'package:hotels/constants/fonts.dart';
import 'package:hotels/constants/snackbar.dart';
import 'package:hotels/constants/textfield.dart';
import 'package:hotels/controllers/auth_controllers.dart';
import 'package:hotels/view/home_screen.dart';
import 'package:image_picker/image_picker.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  // seeking for, kind , type of property controller
  TextEditingController selectedLookingToController = TextEditingController();

  // kind property controller
  TextEditingController selectedKindOfPropertyController =
      TextEditingController();

  // type of property controller
  TextEditingController selectedPropertyTypeController =
      TextEditingController();

  // basic details controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController descController = TextEditingController();

  // no. of bedrooms controllers
  TextEditingController selectedBedController = TextEditingController();

  // no. of bathrooms controllers
  TextEditingController selectedBathController = TextEditingController();

  // no. of balconies controllers
  TextEditingController selectedBalconyController = TextEditingController();

  // furnishing controllers
  TextEditingController selectedFurnishingController = TextEditingController();

  // pet controllers
  TextEditingController selectedPetController = TextEditingController();

  // smoke controllers
  TextEditingController selectedSmokeController = TextEditingController();

  // wifi controllers
  TextEditingController selectedWifiController = TextEditingController();

  // price controllers
  TextEditingController priceController = TextEditingController();

  // parking controllers
  TextEditingController parkingController = TextEditingController();

  // image controllers
  // TextEditingController imagesController = TextEditingController();

  // all indexes for selecting container
  int? selected_Looking_Idx;
  int? selected_kind_property_Idx;
  int? selected_type_property_Idx;

  int? selected_no_bedrooms_Idx;
  int? selected_no_bathrooms_Idx;
  int? selected_no_balconies_Idx;

  int? selected_furnishing_Idx;

  int? selected_pet_allowance_Idx;
  int? selected_smoke_allowance_Idx;
  int? selected_wifi_allowance_Idx;

  var _image;
  var imagePicker;
  final ImagePicker _imagePicker = ImagePicker();

  bool showProgressBar = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = new ImagePicker();
  }

  List<XFile> _selectedImages = [];
  List<String> _uploadedImageUrls = [];

  // pickMultipleImageFileFromGallery() async {
  //   final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
  //   if (selectedImages != null && selectedImages.isNotEmpty) {
  //     setState(() {
  //       this.selectedImages.addAll(selectedImages);
  //       imagesController.text =
  //           selectedImages.map((image) => image.path).join(', ');
  //     });
  //   }
  // }

  // pick multiple images
  Future<void> pickMultipleImageFileFromGallery() async {
    final List<XFile>? selectedImages = await _imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        _selectedImages = selectedImages;
      });
    }
  }

  // uploading image to firebase storage
  Future<void> _uploadImagesToStorage(String userId, String hotelId) async {
    for (final imageFile in _selectedImages!) {
      final ref = FirebaseStorage.instance.ref().child(
          'Hotel_Images/$userId/$hotelId/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(File(imageFile.path));
      final imageUrl = await ref.getDownloadURL();
      _uploadedImageUrls.add(imageUrl);
    }
  }

  // saving data to firebase
  _saveData() async {
    try {
      if (_selectedImages == null ||
          _selectedImages!.isEmpty ||
          selectedLookingToController.text.isEmpty ||
          selectedKindOfPropertyController.text.isEmpty ||
          selectedPropertyTypeController.text.isEmpty ||
          titleController.text.isEmpty ||
          addressController.text.isEmpty ||
          contactController.text.isEmpty ||
          descController.text.isEmpty ||
          selectedBedController.text.isEmpty ||
          selectedBathController.text.isEmpty ||
          selectedBalconyController.text.isEmpty ||
          selectedFurnishingController.text.isEmpty ||
          selectedPetController.text.isEmpty ||
          selectedSmokeController.text.isEmpty ||
          selectedWifiController.text.isEmpty ||
          priceController.text.isEmpty ||
          parkingController.text.isEmpty) {
        ReusableSnackbar.show(
          context,
          'Please fill all fields',
          'Oops!',
          Colors.blue,
        );
        return;
      }

      // Show circular progress indicator
      showDialog(
        context: context,
        barrierDismissible: false, // prevent dialog dismissal
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 54, 214, 246),
            ),
          );
        },
      );

      // Get current user's UID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Generate a unique hotel ID
      String hotelId =
          FirebaseFirestore.instance.collection('HotelsData').doc().id;

      // Upload images to storage
      await _uploadImagesToStorage(userId, hotelId);

      // Save hotel data to its own collection
      await FirebaseFirestore.instance
          .collection('HotelsData')
          .doc(hotelId)
          .set({
        'hotelId': hotelId,
        'user_id': userId,
        'image_urls': _uploadedImageUrls,
        'selectedLookingToController': selectedLookingToController.text,
        'selectedKindOfPropertyController':
            selectedKindOfPropertyController.text,
        'selectedPropertyTypeController': selectedPropertyTypeController.text,
        'titleController': titleController.text,
        'addressController': addressController.text,
        'contactController': contactController.text,
        'descController': descController.text,
        'selectedBedController': selectedBedController.text,
        'selectedBathController': selectedBathController.text,
        'selectedBalconyController': selectedBalconyController.text,
        'selectedFurnishingController': selectedFurnishingController.text,
        'selectedPetController': selectedPetController.text,
        'selectedSmokeController': selectedSmokeController.text,
        'selectedWifiController': selectedWifiController.text,
        'priceController': priceController.text,
        'parkingController': parkingController.text,
        'timestamp': Timestamp.now(),
      });

      // Add reference to the hotel from the user's document
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'postedHotels': FieldValue.arrayUnion([hotelId]),
      });

      // Hide circular progress indicator
      Navigator.pop(context);

      // Show success snackbar
      ReusableSnackbar.show(
        context,
        'Data saved successfully',
        'Congratulations!',
        Colors.blue,
      );

      // Navigate to home screen after posting
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );

      // Clear text fields
      selectedLookingToController.clear();
      selectedKindOfPropertyController.clear();
      selectedPropertyTypeController.clear();
      titleController.clear();
      addressController.clear();
      contactController.clear();
      descController.clear();
      selectedBedController.clear();
      selectedBathController.clear();
      selectedBalconyController.clear();
      selectedFurnishingController.clear();
      selectedPetController.clear();
      selectedSmokeController.clear();
      selectedWifiController.clear();
      priceController.clear();
      parkingController.clear();

      setState(() {
        _selectedImages = [];
        _uploadedImageUrls = [];
      });
    } catch (e) {
      // Hide circular progress indicator
      Navigator.pop(context);

      // Show error snackbar
      ReusableSnackbar.show(
        context,
        'Failed to save data: $e',
        'Oops!',
        Colors.blue,
      );
    }
  }

  // for parking
  int parkingCount = 0;

  var authenticationController = AuthenticationController.authController;

  void increment() {
    setState(() {
      parkingCount++;
      parkingController.text = parkingCount.toString();
    });
  }

  void decrement() {
    if (parkingCount > 0) {
      setState(() {
        parkingCount--;
        parkingController.text = parkingCount.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // add basic details
              Padding(
                padding: const EdgeInsets.only(left: 26.0),
                child: Text(
                  'Add basic details',
                  style: CustomFonts.secondaryTextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  'Your intent, Property type & contact details.',
                  style: CustomFonts.secondaryTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),

              // you're looking to? text
              Padding(
                padding: const EdgeInsets.only(left: 26.0),
                child: Text(
                  'You\'re looking to?',
                  style: CustomFonts.secondaryTextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_Looking_Idx = 0;
                          selectedLookingToController.text = 'Sell';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_Looking_Idx == 0
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 8, bottom: 8),
                          child: Text(
                            'Sell',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_Looking_Idx = 1;
                          selectedLookingToController.text = 'Rent/Lease';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_Looking_Idx == 1
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 8, bottom: 8),
                          child: Text(
                            'Rent/Lease',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // kind of property ? text
              Padding(
                padding: const EdgeInsets.only(left: 26.0),
                child: Text(
                  'What kind of property do you have?',
                  style: CustomFonts.secondaryTextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_kind_property_Idx = 0;
                          selectedKindOfPropertyController.text = 'Residential';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_kind_property_Idx == 0
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 8, bottom: 8),
                          child: Text(
                            'Residential',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_kind_property_Idx = 1;
                          selectedKindOfPropertyController.text = 'Commercial';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_kind_property_Idx == 1
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 8, bottom: 8),
                          child: Text(
                            'Commercial',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),

              // select property type
              Padding(
                padding: const EdgeInsets.only(left: 26.0),
                child: Text(
                  'Select Property type',
                  style: CustomFonts.secondaryTextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selected_type_property_Idx = 0;
                            selectedPropertyTypeController.text = 'Apartment';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selected_type_property_Idx == 0
                                ? CustomColors.postColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 8, bottom: 8),
                            child: Text(
                              'Apartment',
                              style: CustomFonts.secondaryTextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selected_type_property_Idx = 1;
                            selectedPropertyTypeController.text = 'House/Villa';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selected_type_property_Idx == 1
                                ? CustomColors.postColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 8, bottom: 8),
                            child: Text(
                              'House/Villa',
                              style: CustomFonts.secondaryTextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selected_type_property_Idx = 2;
                            selectedPropertyTypeController.text = 'Farmhouse';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selected_type_property_Idx == 2
                                ? CustomColors.postColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 8, bottom: 8),
                            child: Text(
                              'Farmhouse',
                              style: CustomFonts.secondaryTextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              // hotel name
              Padding(
                padding: const EdgeInsets.only(left: 26.0),
                child: Text(
                  'Title',
                  style: CustomFonts.secondaryTextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              PostTextField(
                hintText: 'Hotel name',
                iconData: Icons.hotel,
                controller: titleController,
              ),

              const SizedBox(
                height: 15,
              ),

              // hotel address
              Padding(
                padding: const EdgeInsets.only(left: 26.0),
                child: Text(
                  'Address',
                  style: CustomFonts.secondaryTextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              PostTextField(
                hintText: 'Hotel address',
                iconData: Icons.location_city,
                controller: addressController,
              ),

              const SizedBox(
                height: 15,
              ),

              // hotel contact
              Padding(
                padding: const EdgeInsets.only(left: 26.0),
                child: Text(
                  'Contact Details',
                  style: CustomFonts.secondaryTextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              PostTextField(
                hintText: 'Contact',
                iconData: Icons.phone,
                controller: contactController,
              ),

              const SizedBox(
                height: 15,
              ),

              // hotel description
              Padding(
                padding: const EdgeInsets.only(left: 26.0),
                child: Text(
                  'Description',
                  style: CustomFonts.secondaryTextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              PostTextField(
                hintText: 'Desc.',
                iconData: Icons.description,
                controller: descController,
              ),

              const SizedBox(
                height: 35,
              ),

              // add room details
              Padding(
                padding: const EdgeInsets.only(left: 26.0),
                child: Text(
                  'Add room details',
                  style: CustomFonts.secondaryTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600]!,
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 26.0),
                child: Text(
                  'No. of bedrooms',
                  style: CustomFonts.secondaryTextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              // no of bedrooms
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_no_bedrooms_Idx = 1;
                          selectedBedController.text = '1';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_no_bedrooms_Idx == 1
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 8, bottom: 8),
                          child: Text(
                            '1',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_no_bedrooms_Idx = 2;
                          selectedBedController.text = '2';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_no_bedrooms_Idx == 2
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 8, bottom: 8),
                          child: Text(
                            '2',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_no_bedrooms_Idx = 3;
                          selectedBedController.text = '3';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_no_bedrooms_Idx == 3
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 8, bottom: 8),
                          child: Text(
                            '3',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_no_bedrooms_Idx = 4;
                          selectedBedController.text = '4';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_no_bedrooms_Idx == 4
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 8, bottom: 8),
                          child: Text(
                            '4',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_no_bedrooms_Idx = 5;
                          selectedBedController.text = '5';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_no_bedrooms_Idx == 5
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 8, bottom: 8),
                          child: Text(
                            '5',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              // no. of bathrooms
              Padding(
                padding: const EdgeInsets.only(left: 26.0),
                child: Text(
                  'No. of Bathrooms',
                  style: CustomFonts.secondaryTextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_no_bathrooms_Idx = 1;
                          selectedBathController.text = '1';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_no_bathrooms_Idx == 1
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 8,
                            bottom: 8,
                          ),
                          child: Text(
                            '1',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_no_bathrooms_Idx = 2;
                          selectedBathController.text = '2';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_no_bathrooms_Idx == 2
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 8,
                            bottom: 8,
                          ),
                          child: Text(
                            '2',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_no_bathrooms_Idx = 3;
                          selectedBathController.text = '3';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_no_bathrooms_Idx == 3
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 8,
                            bottom: 8,
                          ),
                          child: Text(
                            '3',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_no_bathrooms_Idx = 4;
                          selectedBathController.text = '4';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_no_bathrooms_Idx == 4
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 8,
                            bottom: 8,
                          ),
                          child: Text(
                            '4',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // no. of balconies
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 26.0),
                child: Text(
                  'No. of Balconies',
                  style: CustomFonts.secondaryTextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_no_balconies_Idx = 1;
                          selectedBalconyController.text = '1';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_no_balconies_Idx == 1
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 8, bottom: 8),
                          child: Text(
                            '1',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_no_balconies_Idx = 2;
                          selectedBalconyController.text = '2';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_no_balconies_Idx == 2
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 8, bottom: 8),
                          child: Text(
                            '2',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_no_balconies_Idx = 3;
                          selectedBalconyController.text = '3';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_no_balconies_Idx == 3
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 8, bottom: 8),
                          child: Text(
                            '3',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // furnishing details
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 26.0),
                child: Text(
                  'Furnishing details',
                  style: CustomFonts.secondaryTextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selected_furnishing_Idx = 1;
                            selectedFurnishingController.text = 'Unfurnished';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selected_furnishing_Idx == 1
                                ? CustomColors.postColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 8,
                              bottom: 8,
                            ),
                            child: Text(
                              'Unfurnished',
                              style: CustomFonts.secondaryTextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selected_furnishing_Idx = 2;
                            selectedFurnishingController.text = 'Furnished';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selected_furnishing_Idx == 2
                                ? CustomColors.postColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 8,
                              bottom: 8,
                            ),
                            child: Text(
                              'Furnished',
                              style: CustomFonts.secondaryTextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selected_furnishing_Idx = 3;
                            selectedFurnishingController.text =
                                'Semi Furnished';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selected_furnishing_Idx == 3
                                ? CustomColors.postColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 8,
                              bottom: 8,
                            ),
                            child: Text(
                              'Semi Furnished',
                              style: CustomFonts.secondaryTextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              // reserved parking
              Padding(
                padding: const EdgeInsets.only(left: 26.0),
                child: Text(
                  'Reserved Parking',
                  style: CustomFonts.secondaryTextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 26.0),
                    child: Image.asset(
                      'lib/assets/car.png',
                      height: 25,
                      width: 25,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    'No. of Parking available',
                    style: CustomFonts.secondaryTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700]!,
                    ),
                  ),
                  const SizedBox(
                    width: 35,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: decrement,
                      ),
                      Text(
                        '$parkingCount',
                        style:
                            CustomFonts.secondaryTextStyle(color: Colors.black),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: increment,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(
                height: 15,
              ),

              // pet allowance
              Padding(
                padding: const EdgeInsets.only(left: 26.0),
                child: Text(
                  'Pet Allowance',
                  style: CustomFonts.secondaryTextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_pet_allowance_Idx = 1;
                          selectedPetController.text = 'Yes';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_pet_allowance_Idx == 1
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 8,
                            bottom: 8,
                          ),
                          child: Text(
                            'Yes',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_pet_allowance_Idx = 2;
                          selectedPetController.text = 'No';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_pet_allowance_Idx == 2
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 8,
                            bottom: 8,
                          ),
                          child: Text(
                            'No',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // smoking allowance
              Padding(
                padding: const EdgeInsets.only(left: 26.0),
                child: Text(
                  'Smoking Allowance',
                  style: CustomFonts.secondaryTextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_smoke_allowance_Idx = 1;
                          selectedSmokeController.text = 'Yes';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_smoke_allowance_Idx == 1
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 8,
                            bottom: 8,
                          ),
                          child: Text(
                            'Yes',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_smoke_allowance_Idx = 2;
                          selectedSmokeController.text = 'No';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_smoke_allowance_Idx == 2
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 8,
                            bottom: 8,
                          ),
                          child: Text(
                            'No',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // wifi allowance
              Padding(
                padding: const EdgeInsets.only(left: 27.0),
                child: Text(
                  'Wi-Fi Allowance',
                  style: CustomFonts.secondaryTextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_wifi_allowance_Idx = 1;
                          selectedWifiController.text = 'Yes';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_wifi_allowance_Idx == 1
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 8,
                            bottom: 8,
                          ),
                          child: Text(
                            'Yes',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_wifi_allowance_Idx = 2;
                          selectedWifiController.text = 'No';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected_wifi_allowance_Idx == 2
                              ? CustomColors.postColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 8,
                            bottom: 8,
                          ),
                          child: Text(
                            'No',
                            style: CustomFonts.secondaryTextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // price
              Padding(
                padding: const EdgeInsets.only(left: 27.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Pricing Details ',
                        style: CustomFonts.secondaryTextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '(per night)',
                        style: CustomFonts.secondaryTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[500]!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              PostTextField(
                hintText: 'per night',
                iconData: Icons.money,
                controller: priceController,
              ),

              const SizedBox(
                height: 15,
              ),

              // // images of rooms
              Padding(
                padding: const EdgeInsets.only(left: 27.0),
                child: Text(
                  'Photos',
                  style: CustomFonts.secondaryTextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: DottedBorder(
                  color: Colors.blue,
                  strokeWidth: 1,
                  dashPattern: const [7, 4],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  child: Container(
                    width: 240,
                    height: 180,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () async {
                            pickMultipleImageFileFromGallery();
                            setState(() {});
                          },
                          child: Image.asset(
                            'lib/assets/uploadd.png',
                            height: 150,
                            width: 150,
                          ),
                        ),
                        Text(
                          'Upload a Photo',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700]!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _selectedImages.map((image) {
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Image.file(
                            File(image.path),
                            height: 120,
                            width: 170,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              showProgressBar == true
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.black,
                      ),
                    )
                  : Container(),

              const SizedBox(
                height: 25,
              ),

              // post button
              Center(
                child: ReusableButton(
                  text: "Post",
                  onPressed: () async {
                    _saveData();
                  },
                  color: const Color.fromARGB(255, 54, 214, 246),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          )
        ],
      ),
    );
  }
}
