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
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
