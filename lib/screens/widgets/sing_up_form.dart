import 'package:e_commerce/const/app_color.dart';
import 'package:e_commerce/screens/components/leading_form_icon.dart';
import 'package:e_commerce/screens/sign_in/sign_in.dart';
import 'package:e_commerce/screens/user_form/user_form.dart';
import 'package:e_commerce/screens/widgets/sign_in_screen_lower.dart';
import 'package:e_commerce/screens/widgets/sing_up_screen_lower.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SingUpForm extends StatefulWidget {
  const SingUpForm({Key? key}) : super(key: key);

  @override
  _SingUpFormState createState() => _SingUpFormState();
}

class _SingUpFormState extends State<SingUpForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  registration() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passController.text);
      var authCredential = userCredential.user;
      if (authCredential!.uid.isNotEmpty) {
        Navigator.push(
            context, CupertinoPageRoute(builder: (_) => const UserForm()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: 'The account already exists for that email.');
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
              controller: passController,
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
                  registration();
                },
                child: const Text("Continue")),
            const SizedBox(height: 20),
            SignUpScreenLower(onPressed: () {
              Get.off(const UserForm());
            }),
          ],
        ),
      ),
    );
  }
}
