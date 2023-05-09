import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gform/signup.dart';
import 'package:gform/forgotpass.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  bool hidePassword = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text(
                "Email not registered!",
              ),
            );
          },
        );
      } else if (error.code == 'wrong-password') {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Wrong password!"),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 35, 37, 43),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Welcome\nto Forms!",
                  style: TextStyle(
                    fontFamily: 'Comfortaa',
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Row(
                children: const [
                  Text(
                    "Sign in",
                    style: TextStyle(
                      fontFamily: 'Comfortaa',
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: const Color.fromARGB(255, 28, 95, 255),
                cursorHeight: 25,
                autocorrect: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Comfortaa',
                  fontSize: 19,
                ),
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(
                      width: 3,
                      color: Color.fromARGB(255, 66, 70, 81),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(17),
                    ),
                    borderSide: BorderSide(
                      width: 3,
                      color: Color.fromARGB(255, 28, 95, 255),
                    ),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 43, 47, 58),
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    fontFamily: 'Comfortaa',
                    color: Color.fromARGB(255, 114, 121, 132),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: TextField(
                controller: passwordController,
                obscureText: hidePassword,
                keyboardType: TextInputType.visiblePassword,
                cursorColor: const Color.fromARGB(255, 28, 95, 255),
                cursorHeight: 25,
                autocorrect: false,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Comfortaa',
                  fontSize: 19,
                ),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(
                        () {
                          hidePassword = !hidePassword;
                        },
                      );
                    },
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(
                      width: 3,
                      color: Color.fromARGB(255, 66, 70, 81),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(17),
                    ),
                    borderSide: BorderSide(
                      width: 3,
                      color: Color.fromARGB(255, 28, 95, 255),
                    ),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 43, 47, 58),
                  hintText: 'Password',
                  hintStyle: const TextStyle(
                    fontFamily: 'Comfortaa',
                    color: Color.fromARGB(255, 114, 121, 132),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPass(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(
                        fontFamily: 'Comfortaa',
                        fontSize: 15,
                        color: Color.fromARGB(255, 28, 95, 255),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: signIn,
                  style: const ButtonStyle(
                    iconColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 28, 95, 255),
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Comfortaa',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "First time here?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'Comfortaa',
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUp(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign up",
                      textWidthBasis: TextWidthBasis.longestLine,
                      style: TextStyle(
                        fontFamily: 'Comfortaa',
                        fontSize: 17,
                        color: Color.fromARGB(255, 28, 95, 255),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
