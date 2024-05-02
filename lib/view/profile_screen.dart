import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotels/constants/buttons.dart';
import 'package:hotels/constants/fonts.dart';
import 'package:hotels/constants/snackbar.dart';
import 'package:hotels/constants/textbox_profile.dart';
import 'package:hotels/view/login.dart';

class ProfileScreen extends StatefulWidget {
  final User? currUser;
  ProfileScreen({Key? key, required this.currUser}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("users");

  // edit all user details
  Future<String?> editField(String field) async {
    String newValue = "";

    return await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Edit $field",
          style: CustomFonts.secondaryTextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Enter new $field',
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          // cancel button
          TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          // save button
          TextButton(
            child: const Text(
              "Save",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(newValue);
            },
          ),
        ],
      ),
    );
  }

  // edit prof imag

  // Future<void> _editProfileImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     final File file = File(pickedFile.path);
  //     try {
  //       // Upload the selected image to Firebase Storage and get the URL
  //       // You can implement this functionality based on your Firebase Storage setup
  //       // For now, let's assume you have a method to upload the image and get its URL
  //       final String imageUrl = await uploadImageToFirebaseStorage(file);
  //       // Update the user's profile image URL in Firestore
  //       await usersCollection.doc(currUser.uid).update({'imageProfile': imageUrl});
  //       setState(() {
  //         imageProfile = imageUrl;
  //       });
  //     } catch (e) {
  //       print("Error updating profile image: $e");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("Error updating profile image: $e"),
  //         ),
  //       );
  //     }
  //   }
  // }

  // log out logic
  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      await Future.delayed(const Duration(seconds: 2));
      ReusableSnackbar.show(
        context,
        'Successfully logged out',
        'Logged-Out!',
        const Color.fromARGB(255, 235, 124, 116),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } catch (e) {
      print('Error logging out: $e');
      ReusableSnackbar.show(
        context,
        'Error logging out',
        'Error 404',
        const Color.fromARGB(255, 235, 124, 116),
      );
    }
  }

  String imageProfile = '';
  String name = '';
  String email = '';
  String gender = '';
  String phone = '';
  String city = '';
  String state = '';
  String country = '';
  String address = '';

  String urlImage1 =
      "https://firebasestorage.googleapis.com/v0/b/apnapg-45f72.appspot.com/o/Profile%20Images%2FXD8CgRlCw3SRVp7RHP7L7VFNOZg1?alt=media&token=a460cb1e-ab76-48fa-be42-5e98e5a4a44c";

  Future<void> retrieveUserInfo() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.currUser!.uid)
        .get();
    if (snapshot.exists) {
      setState(() {
        imageProfile = snapshot.data()!["imageProfile"] ?? urlImage1;
        name = snapshot.data()!["name"];
        email = snapshot.data()!["email"];
        gender = snapshot.data()!["gender"];
        phone = snapshot.data()!["phone"];
        city = snapshot.data()!["city"];
        state = snapshot.data()!["state"];
        country = snapshot.data()!["country"];
        address = snapshot.data()!["address"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    retrieveUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 40,
        title: Text(
          'Profile Page',
          style: CustomFonts.secondaryTextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.grey[300],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 30,
              ),

              // profile image
              Stack(
                children: [
                  // Profile image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 80,
                        backgroundImage: NetworkImage(imageProfile),
                      ),
                    ],
                  ),
                  // Edit icon
                  Positioned(
                    right: 105,
                    bottom: 5,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 26,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),

              // name
              Text(
                name,
                style: CustomFonts.secondaryTextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900]!,
                ),
              ),
              const SizedBox(
                height: 1,
              ),

              // email
              Text(
                email,
                style: CustomFonts.secondaryTextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500]!,
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // divider
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(),
              ),

              const SizedBox(
                height: 10,
              ),

              // my details text
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Text(
                      'My details',
                      style: CustomFonts.secondaryTextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600]!,
                      ),
                    ),
                  ],
                ),
              ),

              // all textboxes data
              MyTextBox(
                text: name,
                sectionName: 'name',
                onPressed: () => _handleFieldUpdate('name'),
              ),
              MyTextBox(
                text: email,
                sectionName: 'email',
                onPressed: () => _handleFieldUpdate('email'),
              ),
              MyTextBox(
                text: gender,
                sectionName: 'gender',
                onPressed: () => _handleFieldUpdate('gender'),
              ),
              MyTextBox(
                text: phone,
                sectionName: 'phone',
                onPressed: () => _handleFieldUpdate('phone'),
              ),
              MyTextBox(
                text: city,
                sectionName: 'city',
                onPressed: () => _handleFieldUpdate('city'),
              ),
              MyTextBox(
                text: state,
                sectionName: 'state',
                onPressed: () => _handleFieldUpdate('state'),
              ),
              MyTextBox(
                text: country,
                sectionName: 'country',
                onPressed: () => _handleFieldUpdate('country'),
              ),
              MyTextBox(
                text: address,
                sectionName: 'address',
                onPressed: () => _handleFieldUpdate('address'),
              ),
              const SizedBox(
                height: 60,
              ),
              ReusableButton(
                text: 'Log Out',
                onPressed: _handleLogout,
                color: const Color.fromARGB(255, 250, 109, 99),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // update data value
  Future<void> _handleFieldUpdate(String field) async {
    final newValue = await editField(field);
    if (newValue != null && newValue.isNotEmpty) {
      try {
        // Show circular progress indicator while updating
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        // Update user data in Firestore
        await usersCollection.doc(currUser.uid).update({field: newValue});

        // Delay for 2 seconds
        await Future.delayed(const Duration(seconds: 2));

        // Dismiss the circular progress indicator dialog
        Navigator.pop(context);

        // Show snackbar upon successful update
        ReusableSnackbar.show(
          context,
          '$field updated successfully',
          'Congrats!',
          // const Color.fromARGB(255, 235, 124, 116),
          const Color.fromARGB(255, 54, 214, 246),
        );

        setState(() {
          switch (field) {
            case 'name':
              name = newValue;
              break;
            case 'email':
              email = newValue;
              break;
            case 'gender':
              gender = newValue;
              break;
            case 'phone':
              phone = newValue;
              break;
            case 'city':
              city = newValue;
              break;
            case 'state':
              state = newValue;
              break;
            case 'country':
              country = newValue;
              break;
            case 'address':
              address = newValue;
              break;
            default:
              break;
          }
        });
      } catch (e) {
        print("Error updating $field: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error updating $field: $e"),
        ));
      }
    }
  }
}
