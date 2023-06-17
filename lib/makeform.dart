// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sizer/sizer.dart';

class FormApp extends StatefulWidget {
  const FormApp({Key? key}) : super(key: key);

  @override
  State<FormApp> createState() => _FormAppState();
}

class _FormAppState extends State<FormApp> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference formsCollection =
      FirebaseFirestore.instance.collection('forms');
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  List<Question> questions = [];
  String? formDocId;
  String? formTitle;

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
          ListTile(
            title: TextFormField(
              autocorrect: true,
              cursorColor: const Color.fromARGB(255, 28, 95, 255),
              onChanged: (value) {
                formTitle = value;
              },
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Comfortaa',
                fontSize: 13.sp,
              ),
              decoration: InputDecoration(
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
                    width: 2.5.sp,
                    color: const Color.fromARGB(255, 66, 70, 81),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(17),
                  ),
                  borderSide: BorderSide(
                    width: 2.5.sp,
                    color: const Color.fromARGB(255, 28, 95, 255),
                  ),
                ),
              ),
            ),
            trailing: TextButton(
              onPressed: saveFormTitleToFirestore,
              child: Text(
                'SAVE',
                style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 13.sp,
                  color: const Color.fromARGB(255, 28, 95, 255),
                ),
              ),
            ),
          ),
          for (int i = 0; i < questions.length; i++)
            ListTile(
              title: Text(
                '${i + 1}. ${questions[i].text}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontFamily: 'Comfortaa',
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.red,
                  size: 20.sp,
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
      print('User not logged in.');
      return;
    }

    try {
      if (formDocId == null) {
        print('Form document ID not found.');
        return;
      }

      // Remove question from Firestore
      await formsCollection.doc(formDocId).update({
        'questions': FieldValue.arrayRemove([questions[index].text]),
      });

      // Remove question from the app's memory
      setState(() {
        questions.removeAt(index);
      });

      print('Question deleted from Firestore and app.');
    } catch (e) {
      print('Failed to delete question: $e');
    }
  }

  Future<void> saveFormToFirestore() async {
    try {
      final User? user = auth.currentUser;
      if (user == null) {
        print('User not logged in.');
        return;
      }

      if (formDocId == null) {
        final formDoc = await formsCollection.add(
          {
            'userId': user.uid,
            'title': formTitle,
            'questions': questions.map((question) => question.text).toList(),
          },
        );

        setState(
          () {
            formDocId = formDoc.id;
          },
        );

        print('Form saved to Firestore with ID: ${formDoc.id}');
      } else {
        await formsCollection.doc(formDocId).update(
          {
            'title': formTitle,
            'questions': questions.map((question) => question.text).toList(),
          },
        );

        print('Form updated in Firestore with ID: $formDocId');
      }
    } catch (e) {
      print('Failed to save/update form: $e');
    }
  }

  Future<void> saveFormTitleToFirestore() async {
    try {
      final User? user = auth.currentUser;
      if (user == null) {
        print('User not logged in.');
        return;
      }

      if (formDocId == null) {
        final formDoc = await formsCollection.add(
          {
            'userId': user.uid,
            'formTitle': formTitle,
            'questions': [],
          },
        );

        setState(
          () {
            formDocId = formDoc.id;
          },
        );

        print('Form title saved to Firestore with ID: ${formDoc.id}');
      } else {
        await formsCollection.doc(formDocId).update(
          {
            'formTitle': formTitle,
          },
        );

        print('Form title updated in Firestore with ID: $formDocId');
      }
    } catch (e) {
      print('Failed to save/update form title: $e');
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
        decoration: const InputDecoration(
          hintText: 'Enter question',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final question = Question(textEditingController.text);
            widget.onQuestionAdded(question);

            Future.delayed(const Duration(milliseconds: 300), () {
              Navigator.pop(context);
            });
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
