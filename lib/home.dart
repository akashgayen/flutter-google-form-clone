import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'makeform.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference formsCollection =
      FirebaseFirestore.instance.collection('forms');

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
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
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              child: Column(
                children: [
                  Text(
                    "Hello ${FirebaseAuth.instance.currentUser?.displayName}",
                    style: TextStyle(
                      fontFamily: 'Comfortaa',
                      color: Colors.white,
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    'Forms:',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Comfortaa',
                      fontSize: 10.sp,
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: getFormsStream(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Error');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      final forms = snapshot.data?.docs ?? [];

                      if (forms.isEmpty) {
                        return const Center(child: Text('No forms found.'));
                      }

                      return SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: forms.length,
                          itemBuilder: (BuildContext context, int index) {
                            final formDocument = forms[index];
                            final formId = formDocument.id;
                            final formTitle =
                                formDocument['formTitle'] as String;

                            return ListTile(
                              title: Text(formTitle),
                              onTap: () {
                                // Handle form selection
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          drawer: Drawer(
            child: Container(
              color: const Color.fromARGB(255, 35, 37, 43),
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  SizedBox(
                    height: 15.h,
                    child: DrawerHeader(
                      curve: Curves.bounceInOut,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 66, 70, 81),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Menu',
                            style: TextStyle(
                              fontFamily: 'Comfortaa',
                              color: Colors.white,
                              fontSize: 40.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.library_books,
                      color: Colors.white,
                      size: 17.sp,
                    ),
                    title: Text(
                      'Make form',
                      style: TextStyle(
                        fontFamily: 'Comfortaa',
                        color: Colors.white,
                        fontSize: 17.sp,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FormApp()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.edit,
                      size: 17.sp,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Fill form',
                      style: TextStyle(
                        fontFamily: 'Comfortaa',
                        color: Colors.white,
                        fontSize: 17.sp,
                      ),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.account_circle_sharp,
                      size: 17.sp,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Account",
                      style: TextStyle(
                        fontFamily: 'Comfortaa',
                        fontSize: 17.sp,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Fluttertoast.showToast(
                        msg: 'HHEEHEHEHE',
                      );
                    },
                  ),
                  ListTile(
                    splashColor: Colors.blue,
                    leading: Icon(
                      Icons.logout_rounded,
                      size: 17.sp,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        fontFamily: 'Comfortaa',
                        color: Colors.white,
                        fontSize: 17.sp,
                      ),
                    ),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Fluttertoast.showToast(
                        msg: 'Logged out!',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Stream<QuerySnapshot> getFormsStream() {
    final currentUserID = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserID == null) {
      return const Stream<QuerySnapshot>.empty();
    }

    return formsCollection
        .where('userId', isEqualTo: currentUserID)
        .snapshots();
  }
}
