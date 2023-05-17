// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  void signUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      if (passwordController == confirmPasswordController) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        showDialog(
          context: context,
          builder: (builder) {
            return const AlertDialog(
              title: Text("Passwords don't match"),
            );
          },
        );
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text(
                "Email already registered!",
              ),
            );
          },
        );
      } else if (error.code == 'invalid-email') {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Email is invalid!"),
            );
          },
        );
      } else if (error.code == 'weak-password') {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Password is too weak!"),
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
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 3.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome\nto Forms!",
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
                          'Sign up',
                          style: TextStyle(
                            fontFamily: 'Comfortaa',
                            fontSize: 17.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
                    child: TextField(
                      controller: emailController,
                      autofocus: true,
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
                        hintText: 'Email',
                        hintStyle: const TextStyle(
                          fontFamily: 'Comfortaa',
                          color: Color.fromARGB(255, 114, 121, 132),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: hidePassword,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: const Color.fromARGB(255, 28, 95, 255),
                      autocorrect: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Comfortaa',
                        fontSize: 12.8.sp,
                      ),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(
                              () {
                                hidePassword = !hidePassword;
                              },
                            );
                          },
                        ),
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
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                          fontFamily: 'Comfortaa',
                          color: Color.fromARGB(255, 114, 121, 132),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
                    child: TextField(
                      controller: confirmPasswordController,
                      obscureText: hideConfirmPassword,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: const Color.fromARGB(255, 28, 95, 255),
                      autocorrect: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Comfortaa',
                        fontSize: 12.8.sp,
                      ),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            hideConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(
                              () {
                                hideConfirmPassword = !hideConfirmPassword;
                              },
                            );
                          },
                        ),
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
                        hintText: 'Confirm password',
                        hintStyle: const TextStyle(
                          fontFamily: 'Comfortaa',
                          color: Color.fromARGB(255, 114, 121, 132),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
                    child: SizedBox(
                      height: 47,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: signUp,
                        style: const ButtonStyle(
                          iconColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 28, 95, 255),
                          ),
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: 'Comfortaa',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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
