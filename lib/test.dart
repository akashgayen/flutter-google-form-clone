import 'package:flutter/material.dart';

void main() {
  runApp(const RunMyApp());
}

class RunMyApp extends StatefulWidget {
  const RunMyApp({super.key});

  @override
  State<RunMyApp> createState() => _RunMyAppState();
}

class _RunMyAppState extends State<RunMyApp> {
  bool hidePassword = false;

  @override
  void initState() {
    super.initState();
    hidePassword = true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Show or Hide Password in TextField'),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            obscureText: hidePassword,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              hintText: "Password",
              labelText: "Password",
              helperText: "Password must contain special character",
              helperStyle: const TextStyle(color: Colors.green),
              suffixIcon: IconButton(
                icon: Icon(
                    hidePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(
                    () {
                      hidePassword = !hidePassword;
                    },
                  );
                },
              ),
              alignLabelWithHint: false,
              filled: true,
            ),
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
          ),
        ),
      ),
    );
  }
}
