// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sizer/sizer.dart';

class FormApp extends StatefulWidget {
  const FormApp({super.key, Key? key1});

  @override
  State<FormApp> createState() => _FormAppState();
}

class _FormAppState extends State<FormApp> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference formsCollection =
      FirebaseFirestore.instance.collection('forms');
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  List<Question> questions = []; // List to store questions
  String? formDocId; // Store the form document ID

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
        padding: const EdgeInsets.all(16.0),
        children: [
          ElevatedButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(Size(2.w, 6.h)),
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 65, 105, 225),
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => QuestionDialog(
                  onQuestionAdded: (question) {
                    setState(() {
                      questions.add(question);
                    });
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
          SizedBox(height: 2.h),
          for (int i = 0; i < questions.length; i++)
            ListTile(
              title: Text('Question ${i + 1}'),
              subtitle: Text(questions[i].text),
            ),
          ElevatedButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(Size(2.w, 6.h)),
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 65, 105, 225),
              ),
            ),
            onPressed:
                formDocId != null ? updateFormInFirestore : saveFormToFirestore,
            child: Text(
              'Save Form',
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

  Future<void> saveFormToFirestore() async {
    try {
      final User? user = auth.currentUser;
      if (user == null) {
        print('User not logged in.');
        return;
      }

      final formDoc = await formsCollection.add({
        'userId': user.uid,
        'questions': questions.map((question) => question.text).toList(),
      });

      setState(() {
        formDocId = formDoc.id;
      });

      print('Form saved to Firestore with ID: ${formDoc.id}');
    } catch (e) {
      print('Failed to save form: $e');
    }
  }

  Future<void> updateFormInFirestore() async {
    try {
      if (formDocId == null) {
        print('Form document ID not found.');
        return;
      }

      await formsCollection.doc(formDocId).update({
        'questions': questions.map((question) => question.text).toList(),
      });

      print('Form updated in Firestore with ID: $formDocId');
    } catch (e) {
      print('Failed to update form: $e');
    }
  }
}

class Question {
  final String text;

  Question(this.text);
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
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Question'),
      content: TextField(
        controller: textEditingController,
        decoration: const InputDecoration(hintText: 'Enter question'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final question = Question(textEditingController.text);
            widget.onQuestionAdded(question);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
