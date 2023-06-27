import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';

class ViewForm extends StatelessWidget {
  final String formId;

  const ViewForm({required this.formId, Key? key}) : super(key: key);

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
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('The form ID is $formId'),
          ElevatedButton(
            onPressed: () {
              copyFormIdToClipboard(formId);
            },
            child: const Text(
              'COPY',
            ),
          ),
        ],
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
