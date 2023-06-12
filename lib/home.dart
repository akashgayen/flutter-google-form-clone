import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 35, 37, 43),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 66, 70, 81),
          title: Center(
            child: Text(
              'Google Forms Clone',
              style: TextStyle(
                fontFamily: 'Comfortaa',
                fontSize: 17.sp,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: FirebaseAuth.instance.signOut,
              icon: const Icon(
                Icons.logout,
              ),
            ),
          ],
        ),
        body:  Center(
          child: Column(
            children: const [
              Text(
                "USER LOGGED IN",
              ),
            ],
          ),
        ),
      );
    });
  }
}
