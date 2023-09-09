import 'makeformdialogbox.dart';
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
  bool setDueDate = false;
  List<Question> questions = [];
  String? formDocId;
  String? formTitle = 'Untitled form';
  DateTime dueDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
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
          drawer: Drawer(
              backgroundColor: const Color.fromARGB(255, 35, 37, 43),
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
                              'Form settings',
                              style: TextStyle(
                                fontFamily: 'Comfortaa',
                                color: Colors.white,
                                fontSize: 30.sp,
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
                        title: Text(
                          'Set due date',
                          style: TextStyle(
                            fontFamily: 'Comfortaa',
                            color: Colors.white,
                            fontSize: 17.sp,
                          ),
                        ),
                        subtitle: setDueDate
                            ? Text(
                                'Current due date: ${dueDate.day}/${dueDate.month}/${dueDate.year} ${dueDate.hour}:${dueDate.minute}',
                                style: TextStyle(
                                  fontFamily: 'Comfortaa',
                                  fontSize: 12.sp,
                                  color: Colors.white30,
                                ),
                              )
                            : Text(
                                'No due date set',
                                style: TextStyle(
                                  fontFamily: 'Comfortaa',
                                  fontSize: 12.sp,
                                  color: Colors.white30,
                                ),
                              ),
                        trailing: Switch(
                          activeColor: const Color.fromARGB(255, 28, 95, 255),
                          activeTrackColor: Colors.blue,
                          inactiveThumbColor: Colors.blueGrey.shade600,
                          inactiveTrackColor: Colors.grey.shade400,
                          splashRadius: 50.0,
                          value: setDueDate,
                          onChanged: (value) {
                            setState(() => setDueDate = value);
                            if (setDueDate == true) {
                              pickDueDate();
                            }
                            if (setDueDate == false) {
                              dueDate = DateTime.now();
                            }
                          },
                        ),
                        onTap: () {
                          setState(() {
                            setDueDate = !setDueDate;
                          });
                          if (setDueDate == true) {
                            pickDueDate();
                          }
                          if (setDueDate == false) {
                            dueDate = DateTime.now();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )),
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
                  fixedSize:
                      MaterialStateProperty.all<Size>(Size(100.w, 6.5.h)),
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
      },
    );
  }

  Future pickDueDate() async {
    DateTime? date = await pickDate();
    if (date == null) {
      dueDate = DateTime.now();
      return;
    } else {
      setState(() {
        dueDate = date;
      });
    }
    final time = await pickTime();
    if (time == null) {
      dueDate = DateTime.now();
      return;
    }
    final newDueDate = DateTime(
        dueDate.year, dueDate.month, dueDate.day, time.hour, time.minute);
    setState(() {
      dueDate = newDueDate;
    });
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dueDate,
        firstDate: dueDate,
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: dueDate.hour, minute: dueDate.minute),
      );

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

      if (formDocId == null && setDueDate == true) {
        final formDoc = await formsCollection.add(
          {
            'userId': user.uid,
            'formTitle': formTitle,
            'questions': questions.map((question) => question.toMap()).toList(),
            'timestamp': FieldValue.serverTimestamp(),
            'dueDate': dueDate,
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
      } else if (formDocId != null && setDueDate == true) {
        await formsCollection.doc(formDocId).update(
          {
            'questions': questions.map((question) => question.toMap()).toList(),
            'formTitle': formTitle,
            'dueDate': dueDate,
          },
        );

        Fluttertoast.showToast(
          msg: 'Form updated',
        );
      } else if (formDocId == null && setDueDate == false) {
        final formDoc = await formsCollection.add(
          {
            'userId': user.uid,
            'formTitle': formTitle,
            'questions': questions.map((question) => question.toMap()).toList(),
            'timestamp': FieldValue.serverTimestamp(),
            'dueDate': null,
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
            'dueDate': null,
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
  final String? imageUrl;
  final List<String> options;

  Question(
    this.text,
    this.responseType,
    this.isRequired,
    this.imageUrl,
    this.options,
  );

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'responseType': responseType,
      'isRequired': isRequired,
      'imageUrl': imageUrl,
      'options': options,
    };
  }
}
