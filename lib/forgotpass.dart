// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gform/login.dart';
import 'package:gform/signup.dart';
import 'package:sizer/sizer.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  void resetPassword() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (builder) {
          return const AlertDialog(
            title: Text('Email has been sent!'),
          );
        },
      );
    } on FirebaseAuthException catch (error) {
      Navigator.pop(context);
      if (error.code == 'auth/invalid-email') {
        showDialog(
          context: context,
          builder: (builder) {
            return const AlertDialog(
              title: Text(
                "Email provided was invalid!",
              ),
            );
          },
        );
      } else if (error.code == 'auth/user-not-found') {
        showDialog(
          context: context,
          builder: (builder) {
            return const AlertDialog(
              title: Text(
                "Email not registered!",
              ),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (builder) {
            return const AlertDialog(
              title: Text("Unknown error!"),
            );
          },
        );
      }
    }
  }

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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 3.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome\n to Forms!",
                        style: TextStyle(
                          fontFamily: 'ComfortaaBold',
                          color: Colors.white,
                          fontSize: 40.sp,
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
                    height: 2.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Reset password',
                          style: TextStyle(
                            fontFamily: 'Comfortaa',
                            fontSize: 24.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 1.6.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: AutoSizeText(
                      "Upon enetering your registered email, you will recieve an email with a link to reset your password!",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Comfortaa',
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.6.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
                    child: TextField(
                      controller: emailController,
                      enableSuggestions: true,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: const Color.fromARGB(255, 28, 95, 255),
                      autocorrect: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Comfortaa',
                        fontSize: 12.8.sp,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(
                            width: 2.5.sp,
                            color: const Color.fromARGB(255, 66, 70, 81),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(17),
                          ),
                          borderSide: BorderSide(
                            width: 2.5.sp,
                            color: const Color.fromARGB(255, 28, 95, 255),
                          ),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 43, 47, 58),
                        hintText: 'Registered email',
                        hintStyle: const TextStyle(
                          fontFamily: 'Comfortaa',
                          color: Color.fromARGB(255, 114, 121, 132),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.6.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
                    child: SizedBox(
                      height: 47,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: resetPassword,
                        style: const ButtonStyle(
                          iconColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 28, 95, 255),
                          ),
                        ),
                        child: Text(
                          "Request email",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: 'Comfortaa',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Remember your password!",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Comfortaa',
                            fontSize: 14.sp),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyLogin(),
                            ),
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontFamily: 'Comfortaa',
                            fontSize: 14.sp,
                            color: const Color.fromARGB(255, 28, 95, 255),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account yet?",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Comfortaa',
                            fontSize: 13.sp),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUp(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            fontFamily: 'Comfortaa',
                            fontSize: 13.sp,
                            color: const Color.fromARGB(255, 28, 95, 255),
                          ),
                        ),
                      ),
                    ],
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
