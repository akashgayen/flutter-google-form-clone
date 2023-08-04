import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';

class ResponsePage extends StatefulWidget {
  final String formId;
  const ResponsePage({required this.formId, Key? key}) : super(key: key);

  @override
  State<ResponsePage> createState() => _ResponsePageState();
}

class _ResponsePageState extends State<ResponsePage> {
  bool _loading = true;
  bool _hasResponses = false;
  List<String> _userIds = [];
  String _selectedUserId = '';
  Map<String, String> _userNames = {};

  @override
  void initState() {
    super.initState();
    fetchResponses();
  }

  void fetchResponses() async {
    // Fetch responses from Firestore where the 'formId' field matches the provided 'formId'
    QuerySnapshot<Map<String, dynamic>> responseSnapshot =
        await FirebaseFirestore.instance
            .collection('responses')
            .where('formId', isEqualTo: widget.formId)
            .get();

    // Check if any responses are available
    if (responseSnapshot.size > 0) {
      setState(() {
        _hasResponses = true;
        // Extract user IDs from the responses
        _userIds = responseSnapshot.docs
            .map((doc) => doc.data()['user'] as String)
            .toList();
      });
    }

    // Fetch user names for the extracted user IDs from the 'users' collection
    await fetchUserNames();

    setState(() {
      _loading = false;
    });
  }

  Future<void> fetchUserNames() async {
    // Fetch user names from Firestore where the user ID matches the extracted IDs
    QuerySnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: _userIds)
        .get();
    // Map user IDs to their names
    _userNames = {
      for (var doc in userSnapshot.docs)
        doc.id: doc.data()['userName'] as String
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 37, 43),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 66, 70, 81),
        title: Text(
          'Responses',
          style: TextStyle(
            fontFamily: 'Comfortaa',
            fontSize: 17.sp,
          ),
        ),
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : _hasResponses
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Select user:',
                        style: TextStyle(
                          fontFamily: 'Comfortaa',
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                      DropdownButton<String>(
                        value: _selectedUserId,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedUserId = newValue!;
                          });
                        },
                        items: _userNames.entries
                            .map((entry) => DropdownMenuItem<String>(
                                  value: entry.key,
                                  child: Text(
                                    entry.value,
                                    style: TextStyle(
                                      fontFamily: 'Comfortaa',
                                      fontSize: 16.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  )
                : Text(
                    'No responses yet.',
                    style: TextStyle(
                      fontFamily: 'Comfortaa',
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
      ),
    );
  }
}
