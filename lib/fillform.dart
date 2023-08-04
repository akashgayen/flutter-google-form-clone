import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
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
  late String creatorId;
  late String creatorName;
  late String creatorEmail;
  Map<int, dynamic> userResponses = {};
  String? uploadedImageName;
  Map<int, dynamic> _selectedOptionsMap = {};

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
      creatorId = snapshot.data()!['userId'] as String;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(creatorId)
        .get();
  }

  void extractUserDetails(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.exists) {
      creatorName = snapshot.data()!['userName'] as String;
      creatorEmail = snapshot.data()!['email'] as String;
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

          return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: fetchUserDetails(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (userSnapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${userSnapshot.error}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontFamily: 'Comfortaa',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return Center(
                  child: Text(
                    'User not found',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontFamily: 'Comfortaa',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              extractUserDetails(userSnapshot.data!);

              return Container(
                padding: EdgeInsets.all(9.sp),
                child: Column(
                  children: [
                    Text(
                      'Form creator: $creatorName ($creatorEmail)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.5.sp,
                        fontFamily: 'Comfortaa',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 1.h),
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
                        itemBuilder: (context, questionIndex) {
                          final question = questions[questionIndex];
                          final questionText = question['text'] as String;
                          final imageUrl = question['imageUrl'] as String;
                          final isRequired = question['isRequired'] as bool;
                          final options = question['options'] as List;
                          final responseType =
                              question['responseType'] as String;

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
                                tileColor:
                                    const Color.fromARGB(255, 43, 47, 58),
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
                                          setState(() {
                                            userResponses[questionIndex] =
                                                value;
                                          });
                                        },
                                      ),
                                    if (responseType == 'Image')
                                      Center(
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              const Color.fromARGB(
                                                  255, 65, 105, 225),
                                            ),
                                          ),
                                          onPressed: () async {
                                            String downloadURL =
                                                await uploadImageToFirebaseStorage();

                                            setState(() {
                                              userResponses[questionIndex] =
                                                  downloadURL;
                                            });
                                          },
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
                                    if (uploadedImageName != null &&
                                        responseType == 'Image')
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 66, 70, 81),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(5.sp),
                                              child: Text(
                                                'image_$uploadedImageName',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11.sp,
                                                  fontFamily: 'Comfortaa',
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              deleteImageFromFirebaseStorage(
                                                  uploadedImageName!);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                              size: 17.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (responseType ==
                                        'Multiple Choice (Multiple)')
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: options.length,
                                        itemBuilder: (context, index) {
                                          final option = options[index];
                                          final isSelected = _selectedOptionsMap
                                                  .containsKey(questionIndex)
                                              ? _selectedOptionsMap[
                                                      questionIndex]!
                                                  .contains(option)
                                              : false;

                                          return CheckboxListTile(
                                            title: Text(
                                              option,
                                              style: TextStyle(
                                                fontFamily: 'Comfortaa',
                                                fontSize: 14.sp,
                                                color: Colors.white,
                                              ),
                                            ),
                                            value: isSelected,
                                            onChanged: (value) {
                                              setState(() {
                                                if (value == true) {
                                                  _selectedOptionsMap
                                                      .putIfAbsent(
                                                          questionIndex,
                                                          () => [])
                                                      .add(option);
                                                } else {
                                                  _selectedOptionsMap[
                                                          questionIndex]
                                                      ?.remove(option);
                                                }
                                              });
                                            },
                                            activeColor: Colors.white,
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                          );
                                        },
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
                                            toggleable: true,
                                            groupValue:
                                                userResponses[questionIndex],
                                            onChanged: (value) {
                                              setState(() {
                                                userResponses[questionIndex] =
                                                    value;
                                              });
                                            },
                                            activeColor: Colors.white,
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
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
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 65, 105, 225),
                        ),
                      ),
                      onPressed: () {
                        saveResponsesToFirestore();
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Comfortaa',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<String> uploadImageToFirebaseStorage() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedImage =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage?.path == null) {
        Fluttertoast.showToast(msg: 'file not uploaded');
        return '';
      }
      if (pickedImage != null) {
        final storageRef = FirebaseStorage.instance.ref();

        final String imageName =
            DateTime.now().millisecondsSinceEpoch.toString();
        final imageRef = storageRef.child('images/$imageName');

        await imageRef.putFile(File(pickedImage.path));

        final imageUrl = await imageRef.getDownloadURL();
        setState(() {
          uploadedImageName = imageName;
        });
        return imageUrl;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'File not uploaded');
      return '';
    }
    return '';
  }

  void deleteImageFromFirebaseStorage(String imageName) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref('images/$uploadedImageName');
      await storageRef.delete();
      setState(() {
        uploadedImageName = null;
      });
      Fluttertoast.showToast(msg: 'Image deleted');
    } catch (error) {
      Fluttertoast.showToast(msg: 'Failed to delete image');
    }
  }

  Future<void> saveResponsesToFirestore() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      final String docName = DateTime.now().millisecondsSinceEpoch.toString();

      Map<int, dynamic> allResponses = {};

      for (int i = 0; i < questions.length; i++) {
        final question = questions[i];
        final responseType = question['responseType'] as String;
        List<String> options = List.from(question['options'] as List);

        if (responseType == 'Multiple Choice (Multiple)') {
          List<String> selectedOptions = _selectedOptionsMap[i] ?? [];
          allResponses[i] = selectedOptions;
        } else if (responseType == 'Multiple Choice (One)') {
          String? selectedOption = userResponses[i];
          if (options.contains(selectedOption)) {
            allResponses[i] = selectedOption;
          } else {
            allResponses[i] = ''; // Invalid response, set to empty string
          }
        } else {
          // Text Response
          allResponses[i] = userResponses[i];
        }
      }

      Map<String, dynamic> formData = {
        'timestamp': DateTime.now(),
        'user': userId,
        'formId': widget.formCode,
        'responses': allResponses,
      };

      DocumentReference responseDocRef =
          FirebaseFirestore.instance.collection('responses').doc(docName);

      await responseDocRef.set(formData, SetOptions(merge: true));

      Fluttertoast.showToast(msg: 'Form submitted successfully!');
    } catch (error) {
      print(error);
      Fluttertoast.showToast(msg: 'Failed to submit form. Please try again.');
    }
  }
}
