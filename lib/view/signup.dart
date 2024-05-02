import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hotels/controllers/auth_controllers.dart';
import 'package:hotels/constants/buttons.dart';
import 'package:hotels/constants/fonts.dart';
import 'package:hotels/constants/snackbar.dart';
import 'package:hotels/constants/textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController gender = TextEditingController();

  var authenticationController = AuthenticationController.authController;

  bool showProgressBar = false;
  bool _showAddress = false;

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
      this.gender.text = gender;
    });
  }

  File? _selectedImage;
  String? _selectedGender;

  bool _showProgressBar = false;

  String _currentAddress = 'Fetching address...';
  bool _isLocationFetched = false;

  late StreamSubscription<Position> streamSubscription;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  void dispose() {
    // Cancel the stream subscription to prevent memory leaks
    streamSubscription.cancel();
    super.dispose();
  }

  getLocation() async {
    bool serviceEnabled;

    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions');
    }
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentAddress =
            'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
      });
      getAddressFromLatLang(position);
    });
  }

  Future<void> getAddressFromLatLang(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    setState(() {
      _currentAddress =
          '${place.street}, ${place.subLocality} - ${place.locality} ${place.postalCode} ${place.administrativeArea}, ${place.country}';
      address.text = _currentAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Signup',
          style: CustomFonts.secondaryTextStyle(
            fontSize: 31,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            "lib/assets/x.png",
            height: 20,
            width: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 100,
                backgroundImage: authenticationController.imageFile == null
                    ? AssetImage('lib/assets/user.png')
                    : FileImage(File(authenticationController.imageFile!.path))
                        as ImageProvider<Object>,
                backgroundColor: Colors.grey[200],
              ),
              IconButton(
                onPressed: () async {
                  await authenticationController.pickImageFileFromGallery();
                  setState(() {});
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue[300],
                  size: 30,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'We need some Bio info',
                style: CustomFonts.secondaryTextStyle(
                  color: Colors.black,
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ReusableTextField(
                controller: name,
                hintText: "Enter your Full Name",
                iconData: Icons.person,
              ),
              ReusableTextField(
                controller: email,
                hintText: "Enter your Email",
                iconData: Icons.email,
              ),
              ReusableTextField(
                controller: password,
                hintText: "Enter your Password",
                iconData: Icons.password,
                isPassword: true,
              ),
              ReusableTextField(
                controller: phone,
                hintText: "Enter your Phone",
                iconData: Icons.phone,
              ),
              ReusableTextField(
                controller: city,
                hintText: "Enter your City",
                iconData: Icons.location_city,
              ),
              ReusableTextField(
                controller: state,
                hintText: "Enter your State",
                iconData: Icons.location_city,
              ),
              ReusableTextField(
                controller: country,
                hintText: "Enter your Country",
                iconData: Icons.location_city,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _selectGender('male');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedGender == 'male'
                            ? Colors.blue[200]
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          'lib/assets/male.png',
                          height: 42,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectGender('female');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedGender == 'female'
                            ? Colors.pink[200]
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 9,
                          horizontal: 12,
                        ),
                        child: Image.asset(
                          'lib/assets/female.png',
                          height: 47,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 35,
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _showAddress = !_showAddress;
                              if (_showAddress) {
                                _showProgressBar = true; // Show progress bar
                              }
                            });
                            if (_showAddress) {
                              // Fetch address
                              _currentAddress;
                            }
                          },
                          child: _showAddress
                              ? Container(
                                  width: 260,
                                  child: Text(
                                    _currentAddress,
                                    style: CustomFonts.secondaryTextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              : Row(
                                  children: [
                                    if (_showProgressBar)
                                      CircularProgressIndicator(),
                                    if (_showProgressBar) SizedBox(width: 10),
                                    Text(
                                      _showProgressBar
                                          ? 'Fetching location...'
                                          : 'My location',
                                      style: CustomFonts.secondaryTextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              showProgressBar == true
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.black,
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 15,
              ),
              ReusableButton(
                text: "Signup",
                onPressed: () async {
                  if (authenticationController.profileImage != null) {
                    if (name.text.trim().isNotEmpty &&
                        email.text.trim().isNotEmpty &&
                        password.text.trim().isNotEmpty &&
                        phone.text.trim().isNotEmpty &&
                        city.text.trim().isNotEmpty &&
                        state.text.trim().isNotEmpty &&
                        country.text.trim().isNotEmpty &&
                        gender.text.trim().isNotEmpty &&
                        _currentAddress.isNotEmpty) {
                      setState(() {
                        showProgressBar = true;
                      });

                      await authenticationController.createNewUserAccount(
                        // personal info 
                        context,
                        FirebaseAuth.instance.currentUser?.uid,
                        authenticationController.profileImage!,
                        email.text.trim(),
                        password.text.trim(),
                        name.text.trim(),
                        phone.text.trim(),
                        city.text.trim(),
                        state.text.trim(),
                        country.text.trim(),
                        gender.text.trim(),
                        address.text.trim(),
                      );

                      setState(() {
                        showProgressBar = false;
                        authenticationController.imageFile = null;
                      });
                    } else {
                      ReusableSnackbar.show(
                        context,
                        'Please fill all the details',
                        'Field is Empty',
                        Colors.red,
                      );
                    }
                  } else {
                    ReusableSnackbar.show(
                      context,
                      'Please pick an image file from the gallery.',
                      'Image File Missing',
                      Colors.red,
                    );
                  }
                },
                color: const Color.fromARGB(255, 47, 43, 43),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: CustomFonts.secondaryTextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Login',
                      style: CustomFonts.secondaryTextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Placemark>> fetchUserLocation() async {
    await Geolocator.requestPermission().then((value) {}).catchError((error) {
      print("Error: " + error.toString());
    });

    Position position = await Geolocator.getCurrentPosition();

    return placemarkFromCoordinates(position.latitude, position.longitude);
  }
}
