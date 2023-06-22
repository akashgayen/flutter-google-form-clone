import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import 'makeform.dart';

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
  String imageUrl = '';
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
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 65, 105, 225),
              ),
            ),
            onPressed: () {
              uploadImageToFirebaseStorage();
            },
            child: SizedBox(
              width: 40.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add an image',
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
          Row(
            children: [
              Checkbox(
                shape: const CircleBorder(eccentricity: sqrt1_2),
                overlayColor: const MaterialStatePropertyAll<Color?>(
                  Colors.white,
                ),
                checkColor: Colors.white,
                activeColor: Colors.red,
                value: isRequired,
                onChanged: (value) {
                  setState(() {
                    isRequired = value ?? false;
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
            final question = Question(
                questionController.text, dropdownValue, isRequired, imageUrl);
            widget.onQuestionAdded(question);

            Future.delayed(const Duration(milliseconds: 300), () {
              Navigator.pop(context);
            });
            Fluttertoast.showToast(
              msg: 'Form updated',
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

  Future<void> uploadImageToFirebaseStorage() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedImage =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage?.path == null) {
        Fluttertoast.showToast(msg: 'file not uploaded');
      }
      if (pickedImage != null) {
        final storageRef = firebase_storage.FirebaseStorage.instance.ref();

        final String imageName =
            DateTime.now().millisecondsSinceEpoch.toString();
        final imageRef = storageRef.child('images/$imageName');

        await imageRef.putFile(File(pickedImage.path));

        imageUrl = await imageRef.getDownloadURL();
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'File not uploaded');
    }
  }
}
