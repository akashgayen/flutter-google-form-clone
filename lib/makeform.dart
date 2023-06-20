import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sizer/sizer.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference formsCollection =
      FirebaseFirestore.instance.collection('forms');
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool isRequired = false;
  List<Question> questions = [];
  String? formDocId;
  String? formTitle = 'Untitled form';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 37, 43),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 66, 70, 81),
        title: Text(
          'Create Form',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontFamily: 'Comfortaa',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 3.h, 16, 16),
        children: [
          ListTile(
            title: TextField(
              onEditingComplete: () {
                saveFormToFirestore();
                FocusScope.of(context).unfocus();
              },
              autofocus: false,
              autocorrect: true,
              cursorColor: const Color.fromARGB(255, 28, 95, 255),
              onChanged: (value) {
                formTitle = value.isEmpty ? 'Untitled Form' : value;
              },
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Comfortaa',
                fontSize: 13.sp,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 43, 47, 58),
                hintText: 'Form Title',
                hintStyle: TextStyle(
                  color: Colors.white54,
                  fontSize: 13.sp,
                  fontFamily: 'Comfortaa',
                ),
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
              ),
            ),
            trailing: TextButton(
              onPressed: saveFormToFirestore,
              child: Text(
                'SAVE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Comfortaa',
                  fontSize: 13.sp,
                  color: const Color.fromARGB(255, 28, 95, 255),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          for (int i = 0; i < questions.length; i++)
            ListTile(
              title: Padding(
                padding: EdgeInsets.only(
                  bottom: 0.5.h,
                ),
                child: Text(
                  '${i + 1}. ${questions[i].text}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5.sp,
                    fontFamily: 'Comfortaa',
                  ),
                ),
              ),
              subtitle: Text(
                'Response Type: ${questions[i].responseType}',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11.sp,
                  fontFamily: 'Comfortaa',
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                  size: 18.sp,
                ),
                onPressed: () {
                  _deleteQuestion(i);
                },
              ),
            ),
          SizedBox(
            height: 2.h,
          ),
          ElevatedButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(Size(2.w, 57)),
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 65, 105, 225),
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => QuestionDialog(
                  onQuestionAdded: (question) {
                    setState(
                      () {
                        questions.add(question);
                        saveFormToFirestore();
                      },
                    );
                    Navigator.pop(context);
                  },
                ),
              );
            },
            child: Text(
              'Add Question',
              style: TextStyle(
                fontFamily: 'Comfortaa',
                fontSize: 15.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteQuestion(int index) async {
    final User? user = auth.currentUser;
    if (user == null) {
      Fluttertoast.showToast(
        msg: 'You are not logged in',
      );
      return;
    }

    try {
      if (formDocId == null) {
        Fluttertoast.showToast(
          msg: 'Form not found',
        );
        return;
      }

      await formsCollection.doc(formDocId).update({
        'questions': FieldValue.arrayRemove([questions[index].text]),
      });

      setState(() {
        questions.removeAt(index);
      });

      Fluttertoast.showToast(
        msg: 'Question deleted',
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Question was not deleted',
      );
    }
  }

  Future<void> saveFormToFirestore() async {
    try {
      final User? user = auth.currentUser;
      if (user == null) {
        Fluttertoast.showToast(
          msg: 'You are not logged in!',
        );
        return;
      }

      if (formDocId == null) {
        final formDoc = await formsCollection.add(
          {
            'userId': user.uid,
            'formTitle': formTitle,
            'questions': questions.map((question) => question.toMap()).toList(),
            'timestamp': FieldValue.serverTimestamp(),
          },
        );

        setState(
          () {
            formDocId = formDoc.id;
          },
        );

        Fluttertoast.showToast(
          msg: 'Form saved',
        );
      } else {
        await formsCollection.doc(formDocId).update(
          {
            'questions': questions.map((question) => question.toMap()).toList(),
            'formTitle': formTitle,
          },
        );

        Fluttertoast.showToast(
          msg: 'Form updated',
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Form not saved',
      );
    }
  }
}

class Question {
  final String text;
  final String responseType;
  final bool isRequired;

  Question(
    this.text,
    this.responseType,
    this.isRequired,
  );

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'responseType': responseType,
      'isRequired': isRequired,
    };
  }
}

class QuestionDialog extends StatefulWidget {
  final Function(Question) onQuestionAdded;

  const QuestionDialog({
    Key? key,
    required this.onQuestionAdded,
  }) : super(key: key);

  @override
  State<QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  TextEditingController questionController = TextEditingController();
  String dropdownValue = 'Text';
  bool isRequired = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 35, 37, 43),
      title: Text(
        'Add Question',
        style: TextStyle(
          color: Colors.white,
          fontSize: 19.sp,
          fontFamily: 'Comfortaa',
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: questionController,
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
              hintText: 'Enter question',
              hintStyle: const TextStyle(
                fontFamily: 'Comfortaa',
                color: Color.fromARGB(255, 114, 121, 132),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Select response type',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Comfortaa',
              fontSize: 13.sp,
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Container(
            padding: EdgeInsetsDirectional.only(start: 2.w),
            width: 100.w,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 43, 47, 58),
              border: Border.all(
                color: const Color.fromARGB(255, 66, 70, 81),
                width: 2.5.sp,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<String>(
              dropdownColor: const Color.fromARGB(255, 43, 47, 58),
              isExpanded: true,
              underline: Container(
                height: 0,
              ),
              value: dropdownValue,
              icon: const Icon(
                Icons.arrow_drop_down,
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: 'Comfortaa',
              ),
              onChanged: (String? newValue) {
                setState(
                  () {
                    dropdownValue = newValue!;
                  },
                );
              },
              items: <String>[
                'Text',
                'Image',
                'Multiple Choice (One)',
                'Multiple Choice (Multiple)'
              ].map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            children: [
              Checkbox(
                shape: const CircleBorder(eccentricity: sqrt1_2),
                checkColor: Colors.white,
                activeColor: Colors.red,
                value: isRequired,
                onChanged: (value) {
                  setState(() {
                    isRequired = value ?? true;
                  });
                },
              ),
              Text(
                'Required',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontFamily: 'Comfortaa',
                  color: Colors.white,
                ),
              ),
              Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12.sp,
                  fontFamily: 'Comfortaa',
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'Comfortaa',
              fontWeight: FontWeight.bold,
              fontSize: 11.sp,
              color: const Color.fromARGB(255, 65, 105, 225),
            ),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 65, 105, 225),
            ),
          ),
          onPressed: () {
            final question =
                Question(questionController.text, dropdownValue, isRequired);
            widget.onQuestionAdded(question);

            Future.delayed(const Duration(milliseconds: 300), () {
              Navigator.pop(context);
            });
            Fluttertoast.showToast(
              msg: 'Form updated',
              // toastLength: Toast.LENGTH_SHORT,
              // gravity: ToastGravity.CENTER,
              // timeInSecForIosWeb: 1,
              // backgroundColor: Colors.red,
              // textColor: Colors.white,
              // fontSize: 16.0,
            );
          },
          child: Text(
            'Add',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.sp,
              fontFamily: 'Comfortaa',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
