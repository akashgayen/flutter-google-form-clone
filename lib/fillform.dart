import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FillForm extends StatefulWidget {
  const FillForm({super.key});

  @override
  State<FillForm> createState() => _FillFormState();
}

class _FillFormState extends State<FillForm> {
  TextEditingController formCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
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
          body: Padding(
            padding: EdgeInsets.all(14.sp),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Fill form',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21.sp,
                      fontFamily: 'Comfortaa',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  'Enter the form code below and click search!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontFamily: 'Comfortaa',
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                TextField(
                  controller: formCodeController,
                  style: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontSize: 13.sp,
                    color: Colors.white,
                  ),
                  cursorColor: const Color.fromARGB(255, 28, 95, 255),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide(
                        width: 2.sp,
                        color: const Color.fromARGB(255, 66, 70, 81),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(17),
                      ),
                      borderSide: BorderSide(
                        width: 2.sp,
                        color: const Color.fromARGB(255, 28, 95, 255),
                      ),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 43, 47, 58),
                    hintText: 'Enter form code',
                    hintStyle: const TextStyle(
                      fontFamily: 'Comfortaa',
                      color: Color.fromARGB(255, 114, 121, 132),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontFamily: 'Comfortaa',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
