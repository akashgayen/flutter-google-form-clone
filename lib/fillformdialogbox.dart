import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_forms_clone/fillform.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FillFormDialogBox extends StatefulWidget {
  const FillFormDialogBox({super.key});

  @override
  State<FillFormDialogBox> createState() => _FillFormDialogBoxState();
}

class _FillFormDialogBoxState extends State<FillFormDialogBox> {
  TextEditingController formCodeController = TextEditingController();
  String? formTitle = '';
  String? errorMsg = '';
  void searchForm() async {
    String formCode = formCodeController.text;
    if (formCode == '') {
      Fluttertoast.showToast(msg: 'CODE NOT GIVEN');
    } else {
      DocumentSnapshot<Map<String, dynamic>> formDoc = await FirebaseFirestore
          .instance
          .collection('forms')
          .doc(formCode)
          .get();
      if (formDoc.exists) {
        Future.microtask(() {
          Fluttertoast.showToast(msg: 'FORM FOUND');
        });
      } else {
        Future.microtask(() {
          Fluttertoast.showToast(msg: 'FORM NOT FOUND');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Enter Form Code',
        style: TextStyle(
          color: Colors.white,
          fontSize: 19.sp,
          fontFamily: 'Comfortaa',
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 35, 37, 43),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enter the form code below and click search',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontFamily: 'Comfortaa',
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: formCodeController,
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
                    hintText: 'Form code',
                    hintStyle: const TextStyle(
                      fontFamily: 'Comfortaa',
                      color: Color.fromARGB(255, 114, 121, 132),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  ClipboardData? clipboardData =
                      await Clipboard.getData(Clipboard.kTextPlain);
                  if (clipboardData != null && clipboardData.text != null) {
                    setState(
                      () {
                        formCodeController.text = clipboardData.text!;
                      },
                    );
                  }
                },
                child: Text(
                  'PASTE',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 65, 105, 225),
                    fontFamily: 'Comfortaa',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          ElevatedButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(
                Size(100.w, 6.h),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 65, 105, 225),
              ),
            ),
            onPressed: () {
              searchForm();
              if (formTitle != null && formTitle != 'Form not found') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FillForm(
                      formCode: formCodeController.text,
                    ),
                  ),
                );
              }
            },
            child: Text(
              'Search',
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
}
