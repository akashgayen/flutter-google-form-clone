import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';

class ViewForm extends StatefulWidget {
  final String formId;

  const ViewForm({required this.formId, Key? key}) : super(key: key);

  @override
  State<ViewForm> createState() => _ViewFormState();
}

class _ViewFormState extends State<ViewForm> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> formFuture;
  late String formTitle;
  late List questions;
  late String questionText;
  String? selectedOption;
  @override
  void initState() {
    super.initState();
    formFuture = fetchFormDetails();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchFormDetails() async {
    return await FirebaseFirestore.instance
        .collection('forms')
        .doc(widget.formId)
        .get();
  }

  void extractFormDetails(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.exists) {
      formTitle = snapshot.data()!['formTitle'] as String;
      questions = snapshot.data()!['questions'] as List;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 37, 43),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 66, 70, 81),
        title: Text(
          'Google Forms Clone',
          style: TextStyle(
            fontSize: 17.sp,
            fontFamily: 'Comfortaa',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              final formId = widget.formId;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: const Color.fromARGB(255, 35, 37, 43),
                    title: Text(
                      'Form Code',
                      style: TextStyle(
                          fontFamily: 'Comfortaa',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'The code for this form is $formId',
                          style: TextStyle(
                            fontFamily: 'Comfortaa',
                            fontSize: 15.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        ElevatedButton(
                          onPressed: () {
                            copyFormIdToClipboard(formId);
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Copy Code',
                                style: TextStyle(
                                  fontFamily: 'Comfortaa',
                                  fontSize: 13.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // actions: [
                    //   ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.of(context).pop();
                    //     },
                    //     child: Text('Close'),
                    //   ),
                    // ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.share_outlined,
            ),
          ),
        ],
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
            padding: EdgeInsets.all(9.sp),
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
                      final isRequired = question['isRequired'] as bool;
                      final options = question['options'] as List;
                      final responseType = question['responseType'] as String;
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
                              child: Row(
                                children: [
                                  Text(
                                    questionText,
                                    style: TextStyle(
                                      fontFamily: 'Comfortaa',
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  isRequired
                                      ? Text(
                                          '*',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 20.sp,
                                            fontFamily: 'Comfortaa',
                                          ),
                                        )
                                      : const Text(
                                          '',
                                        ),
                                ],
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                imageUrl == ''
                                    ? const SizedBox(
                                        height: 0,
                                      )
                                    : Image.network(
                                        imageUrl,
                                      ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                if (responseType == 'Text')
                                  TextField(
                                    onChanged: (value) {
                                      selectedOption = value;
                                    },
                                  ),
                                if (responseType == 'Image')
                                  Center(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          const Color.fromARGB(
                                              255, 65, 105, 225),
                                        ),
                                      ),
                                      onPressed: () async {},
                                      child: SizedBox(
                                        width: 40.w,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Add image',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11.sp,
                                                fontFamily: 'Comfortaa',
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Icon(
                                              Icons.image_rounded,
                                              size: 17.sp,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                if (responseType == 'Multiple Choice (One)')
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: options.length,
                                    itemBuilder: (context, index) {
                                      final option = options[index];
                                      return RadioListTile<String>(
                                        title: Text(
                                          option,
                                          style: TextStyle(
                                            fontFamily: 'Comfortaa',
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                        value: option,
                                        groupValue: selectedOption,
                                        onChanged: (value) {
                                          setState(() {
                                            value = selectedOption;
                                          });
                                        },
                                        activeColor: Colors.white,
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                      );
                                    },
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

  void copyFormIdToClipboard(String formId) {
    Clipboard.setData(ClipboardData(text: formId));
    Fluttertoast.showToast(
      msg: 'Copied to Clipboard',
    );
  }
}
