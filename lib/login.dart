// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sizer/sizer.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class GoogleAuth {
  googleSignin() async {
    final GoogleSignInAccount? user = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication auth = await user!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    return FirebaseAuth.instance.signInWithCredential(credential);
  }
}

class _MyLoginState extends State<MyLogin> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color.fromARGB(255, 35, 37, 43),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 9.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome\nto Forms!",
                        style: TextStyle(
                          fontFamily: 'ComfortaaBold',
                          color: Colors.white,
                          fontSize: 50.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Image.asset(
                    'assets/images/gformlogo.png',
                    width: 50.w,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Authenticate with Google",
                        style: TextStyle(
                          fontFamily: 'Comfortaa',
                          color: Colors.white,
                          fontSize: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  GestureDetector(
                    onTap: () => GoogleAuth().googleSignin(),
                    child: Container(
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 43, 47, 58),
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                      ),
                      child: Image.asset('assets/images/google-logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
