import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 37, 43),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 66, 70, 81),
        title: Text(
          'Your Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontFamily: 'Comfortaa',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final currentUser = snapshot.data;
            if (currentUser != null) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40.sp,
                        backgroundImage:
                            NetworkImage(currentUser.photoURL ?? ''),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      Text(
                        currentUser.displayName ?? '',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Comfortaa',
                        ),
                      ),
                      SizedBox(
                        height: 8.sp,
                      ),
                      Text(
                        currentUser.email ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Comfortaa',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('Not logged in'),
              );
            }
          }
        },
      ),
    );
  }
}
