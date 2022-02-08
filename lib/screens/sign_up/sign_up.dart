import 'package:e_commerce/const/app_color.dart';
import 'package:e_commerce/screens/components/auth_screen_header_text.dart';
import 'package:e_commerce/screens/widgets/sing_up_form.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AuthScreenHeaderText(title: "Sign Up"),
            ),
            SizedBox(height: size.height * .07),
            Expanded(
              child: Container(
                height: size.height * .8,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome Buddy!",
                        style: TextStyle(
                          color: AppColor.secondaryColor,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Glad to see you here my buddy",
                        style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                      ),
                      const SizedBox(height: 40),
                      const SingUpForm(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
