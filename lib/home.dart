import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_forms_clone/accountpage.dart';
import 'package:google_forms_clone/fillformdialogbox.dart';
import 'package:google_forms_clone/viewform.dart';
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
          body: Container(
            width: 100.w,
            padding: EdgeInsets.all(10.sp),
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
                  height: 1.h,
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
                            width: 1,
                            color: const Color.fromARGB(255, 66, 70, 81),
                            style: BorderStyle.solid,
                          ),
                        ),
                        height: 8.5.h,
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
                    return SizedBox(
                      height: heightOfFormViewer(forms.length),
                      child: ListView.builder(
                        itemCount: forms.length,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          final formDocument = forms[index];
                          final formId = formDocument.id;
                          final formTitle = formDocument['formTitle'] as String;
                          final timeStamp =
                              formDocument['timestamp'] as Timestamp;
                          final formTimeStamp = timeStamp.toDate();
                          final currentTimeStamp = DateTime.now();
                          String formattedTimeStamp;
                          if (formTimeStamp.year == currentTimeStamp.year &&
                              formTimeStamp.month == currentTimeStamp.month &&
                              formTimeStamp.day == currentTimeStamp.day) {
                            final formTimeStampTime = DateFormat.Hm()
                                .format(formTimeStamp)
                                .toString();
                            formattedTimeStamp = 'Today, $formTimeStampTime';
                          } else {
                            if (currentTimeStamp
                                    .difference(formTimeStamp)
                                    .inDays <=
                                1) {
                              formattedTimeStamp = 'Yesterday';
                            } else if (currentTimeStamp
                                        .difference(formTimeStamp)
                                        .inDays <
                                    7 &&
                                currentTimeStamp
                                        .difference(formTimeStamp)
                                        .inDays >
                                    1) {
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
                          return SizedBox(
                            width: 70.w,
                            child: Card(
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2.sp,
                                    color:
                                        const Color.fromARGB(255, 66, 70, 81),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  tileColor:
                                      const Color.fromARGB(255, 43, 47, 58),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
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
                                      color: Colors.white30,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                      size: 18.sp,
                                    ),
                                    onPressed: () => _deleteForm(formId),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewForm(
                                          formId: formId,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 65, 105, 225),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FormPage(),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 6.h,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.library_books,
                                  size: 15.sp,
                                ),
                                Text(
                                  'Make form',
                                  style: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 65, 105, 225),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const FillFormDialogBox(),
                          );
                        },
                        child: SizedBox(
                          height: 6.h,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.edit,
                                  size: 15.sp,
                                ),
                                Text(
                                  'Fill form',
                                  style: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
                  Card(
                    color: const Color.fromARGB(255, 43, 47, 58),
                    elevation: 6,
                    shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
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
                  ),
                  Card(
                    color: const Color.fromARGB(255, 43, 47, 58),
                    elevation: 6,
                    shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
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
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const FillFormDialogBox(),
                        );
                      },
                    ),
                  ),
                  Card(
                    color: const Color.fromARGB(255, 43, 47, 58),
                    elevation: 6,
                    shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccountPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    color: const Color.fromARGB(255, 43, 47, 58),
                    elevation: 6,
                    shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
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

  double heightOfFormViewer(int noOfForms) {
    if (noOfForms > 4) {
      return 40.h;
    } else {
      return noOfForms * 9.5.h;
    }
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
