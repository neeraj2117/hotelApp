import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hotels/constants/buttons.dart';
import 'package:hotels/constants/clipPath.dart';
import 'package:hotels/constants/fonts.dart';
import 'package:hotels/constants/snackbar.dart';
import 'package:hotels/constants/textfield.dart';
import 'package:hotels/controllers/auth_controllers.dart';
import 'package:hotels/view/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool showProgressBar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: MyCustomClipper(),
                child: Container(
                  color: Color.fromARGB(255, 37, 34, 34),
                  height: 300,
                ),
              ),
              Positioned(
                top: 75,
                left: 40,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'lib/assets/x.png',
                    height: 25,
                    width: 25,
                    color: Colors.white,
                  ),
                ),
              ),
              const Positioned(
                top: 150,
                left: 40,
                right: 20,
                child: Text(
                  'Enter your login credentials \nand login.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            'Enter your email / password',
            style: CustomFonts.secondaryTextStyle(
              color: Colors.grey[700]!,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 70,
          ),
          ReusableTextField(
            controller: email,
            hintText: "Email Address",
            iconData: Icons.email,
          ),
          ReusableTextField(
            controller: password,
            hintText: "Password",
            iconData: Icons.lock,
            isPassword: true,
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
            height: 30,
          ),
          ReusableButton(
            onPressed: () async {
              if (email.text.trim().isNotEmpty &&
                  password.text.trim().isNotEmpty) {
                setState(() {
                  showProgressBar = true;
                });

                await AuthenticationController.authController
                    .loginUser(context, email.text.trim(), password.text);

                setState(() {
                  showProgressBar = false;
                });
              } else {
                ReusableSnackbar.show(
                  context,
                  'Email/Password is Missing',
                  'Please fill all the fields.',
                  const Color.fromARGB(255, 235, 124, 116),
                );
              }
            },
            text: "Login",
            color: Color.fromARGB(255, 47, 43, 43),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account?',
                style: CustomFonts.secondaryTextStyle(
                  fontSize: 14,
                  color: Colors.grey[600]!,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SignUpScreen(),
                    ),
                  );
                },
                child: Text(
                  'SignUp',
                  style: CustomFonts.secondaryTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
