import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'makeform.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference formsCollection =
      FirebaseFirestore.instance.collection('forms');
  String? formDocId;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Question> questions = [];

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
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
            padding: EdgeInsets.all(14.sp),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    height: 1.h,
                  ),
                  Text(
                    'Your forms are listed here',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Comfortaa',
                      fontSize: 17.sp,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
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
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 43, 47, 58),
                            border: Border.all(
                              width: 2.sp,
                              color: const Color.fromARGB(255, 66, 70, 81),
                              style: BorderStyle.solid,
                            ),
                          ),
                          height: 40.h,
                          width: double.maxFinite,
                          child: Center(
                            child: Text(
                              'No forms found',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: 'Comfortaa',
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        );
                      }
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 43, 47, 58),
                            border: Border.all(
                              width: 2.sp,
                              color: const Color.fromARGB(255, 66, 70, 81),
                              style: BorderStyle.solid,
                            ),
                          ),
                          height: 40.h,
                          child: ListView.builder(
                            itemCount: forms.length,
                            itemBuilder: (BuildContext context, int index) {
                              final formDocument = forms[index];
                              final formId = formDocument.id;
                              final formTitle =
                                  formDocument['formTitle'] as String;
                              final timeStamp =
                                  formDocument['timestamp'] as Timestamp;
                              final formTimeStamp = timeStamp.toDate();
                              final currentTimeStamp = DateTime.now();
                              String formattedTimeStamp;
                              if (formTimeStamp.year == currentTimeStamp.year &&
                                  formTimeStamp.month ==
                                      currentTimeStamp.month &&
                                  formTimeStamp.day == currentTimeStamp.day) {
                                final formTimeStampTime = DateFormat.Hm()
                                    .format(formTimeStamp)
                                    .toString();
                                formattedTimeStamp =
                                    'Today, $formTimeStampTime';
                              } else {
                                if (currentTimeStamp
                                        .difference(formTimeStamp)
                                        .inDays ==
                                    1) {
                                  formattedTimeStamp = 'Yesterday';
                                } else if (currentTimeStamp
                                        .difference(formTimeStamp)
                                        .inDays <
                                    7) {
                                  final daysAgo = currentTimeStamp
                                      .difference(formTimeStamp)
                                      .inDays;
                                  formattedTimeStamp = '$daysAgo days ago';
                                } else {
                                  final formatter = DateFormat('dd MMM yyyy');
                                  formattedTimeStamp =
                                      formatter.format(formTimeStamp);
                                }
                              }
                              return ListTile(
                                title: Padding(
                                  padding: EdgeInsets.only(bottom: 0.75.h),
                                  child: Text(
                                    formTitle,
                                    style: TextStyle(
                                      fontFamily: 'Comfortaa',
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  formattedTimeStamp,
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      fontFamily: 'Comfortaa',
                                      color: Colors.white30),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.red,
                                    size: 18.sp,
                                  ),
                                  onPressed: () => _deleteForm(formId),
                                ),
                                onTap: () {},
                              );
                            },
                          ),
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
                          builder: (context) => const FormPage(),
                        ),
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
                    onTap: () {},
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
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> _deleteForm(String formDocId) async {
    if (auth.currentUser == null) {
      Fluttertoast.showToast(msg: 'You are not logged in');
    } else {
      try {
        await formsCollection.doc(formDocId).delete();
        setState(() {
          questions.removeWhere((questions) => formsCollection.id == formDocId);
        });
        Fluttertoast.showToast(msg: 'Form deleted');
      } catch (e) {
        Fluttertoast.showToast(msg: 'Could not delete form\n ERROR: $e');
      }
    }
  }
}
