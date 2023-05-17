// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gform/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sizer/sizer.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class GoogleAuth {
  googleSignin() async {
    final GoogleSignInAccount? user = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication auth = await user!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
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
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: confirmPasswordController.text,
        );
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (builder) {
            return const AlertDialog(
              title: Text("Passwords don't match"),
            );
          },
        );
      }
    } on FirebaseAuthException catch (error) {
      Navigator.pop(context);
      if (error.code == 'email-already-in-use') {
        showDialog(
          context: context,
          builder: (builder) {
            return const AlertDialog(
              title: Text("Email is already registered!"),
            );
          },
        );
      } else if (error.code == 'invalid-email') {
        showDialog(
          context: context,
          builder: (builder) {
            return const AlertDialog(
              title: Text("Email is invalid!"),
            );
          },
        );
      } else if (error.code == 'weak-password') {
        showDialog(
          context: context,
          builder: (builder) {
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
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: 'Comfortaa',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.5.w,
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Color.fromARGB(255, 28, 95, 255),
                            thickness: 2,
                          ),
                        ),
                        Text(
                          "  Or continue with  ",
                          style: TextStyle(
                            fontFamily: 'Comfortaa',
                            fontSize: 10.sp,
                            color: Colors.white,
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Color.fromARGB(255, 28, 95, 255),
                            thickness: 2,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () => GoogleAuth().googleSignin(),
                    child: Container(
                      height: 9.h,
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
                  const SizedBox(
                    height: double.minPositive,
                  ),
                  SizedBox(
                    height: 7.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontFamily: 'Comfortaa',
                          ),
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
                            textWidthBasis: TextWidthBasis.longestLine,
                            style: TextStyle(
                              fontFamily: 'Comfortaa',
                              fontSize: 12.sp,
                              color: const Color.fromARGB(255, 28, 95, 255),
                            ),
                          ),
                        ),
                      ],
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
