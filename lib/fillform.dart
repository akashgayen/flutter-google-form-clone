import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';

class FillForm extends StatefulWidget {
  final String formCode;

  const FillForm({Key? key, required this.formCode}) : super(key: key);

  @override
  State<FillForm> createState() => _FillFormState();
}

class _FillFormState extends State<FillForm> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> formFuture;
  late String formTitle;
  late List questions;
  late String questionText;

  @override
  void initState() {
    super.initState();
    formFuture = fetchFormDetails();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchFormDetails() async {
    return await FirebaseFirestore.instance
        .collection('forms')
        .doc(widget.formCode)
        .get();
  }

  void extractFormDetails(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.exists) {
      formTitle = snapshot.data()!['formTitle'] as String;
      questions = snapshot.data()!['questions'] as List;
      // Extract and assign other fields as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 37, 43),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 66, 70, 81),
        title: Text(
          'Fill Form',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontFamily: 'Comfortaa',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: formFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontFamily: 'Comfortaa',
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text(
                'Form not found',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontFamily: 'Comfortaa',
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          extractFormDetails(snapshot.data!);

          return Container(
            padding: EdgeInsets.all(
              9.sp,
            ),
            child: Column(
              children: [
                Text(
                  formTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontFamily: 'Comfortaa',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      final questionText = question['text'] as String;
                      final imageUrl = question['imageUrl'] as String;
                      return Card(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2.sp,
                              color: const Color.fromARGB(255, 66, 70, 81),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            tileColor: const Color.fromARGB(255, 43, 47, 58),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 1.h,
                              ),
                              child: Text(
                                questionText,
                                style: TextStyle(
                                  fontFamily: 'Comfortaa',
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (imageUrl != '')
                                  Image.network(
                                    imageUrl,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
