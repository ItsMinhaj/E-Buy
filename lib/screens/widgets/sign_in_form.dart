import 'package:e_commerce/screens/bottom_navigation/bottom_nav.dart';
import 'package:e_commerce/screens/components/leading_form_icon.dart';
import 'package:e_commerce/screens/sign_up/sign_up.dart';
import 'package:e_commerce/screens/widgets/sign_in_screen_lower.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInForm> createState() => _BuildFormState();
}

class _BuildFormState extends State<SignInForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var userId;

  signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      var authCredential = userCredential.user;

      if (authCredential!.uid.isNotEmpty) {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (_) => const BottomNavigationController()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Wrong password provided for that user.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Expanded(
        child: ListView(
          children: [
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                icon: LeadingFormIcon(icon: Icons.mail),
                labelText: "Email",
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                icon: LeadingFormIcon(icon: Icons.lock),
                labelText: "Passowrd",
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
                onPressed: () {
                  signIn();
                },
                child: const Text("SIGN IN")),
            const SizedBox(height: 20),
            SignInScreenLower(onPressed: () {
              Get.off(const SignUpScreen());
            }),
          ],
        ),
      ),
    );
  }
}
