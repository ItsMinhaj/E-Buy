import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/const/app_color.dart';
import 'package:e_commerce/screens/bottom_navigation/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  List gender = ["Select Gender -", "Male", "Female", "Others"];
  var isGenderSelected;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController birthController = TextEditingController();

  TextEditingController ageController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(DateTime.now().year - 50),
        lastDate: DateTime(DateTime.now().year + 5));

    if (newDate != null) {
      setState(() {
        birthController.text =
            "${newDate.day} / ${newDate.month} / ${newDate.year}";
      });
    }
  }

  addUserFormData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users-form-data");
    return collectionReference.doc(currentUser!.email).set({
      "full-name": fullNameController.text,
      "phone": phoneController.text,
      "dob": birthController.text,
      "gender": isGenderSelected,
      "age": ageController.text,
    }).then((value) {
      Fluttertoast.showToast(msg: "Sign up is completed successfully");
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (_) => const BottomNavigationController()));
    }).catchError((error, stackTrace) =>
        Fluttertoast.showToast(msg: "Something went wrong."));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            const SizedBox(height: 40),
            SizedBox(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Submit the form to continue.",
                        style: TextStyle(
                          color: AppColor.secondaryColor,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "We will not share your information with anyone.",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            Form(
              key: _formkey,
              child: Expanded(
                child: ListView(
                  children: [
                    TextFormField(
                      controller: fullNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                      ),
                    ),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                      ),
                    ),
                    TextFormField(
                      controller: birthController,
                      readOnly: true,
                      decoration: InputDecoration(
                          hintText: "Date Of Birth",
                          suffix: IconButton(
                              onPressed: () {
                                pickDate(context);
                              },
                              icon: const Icon(Icons.calendar_today))),
                    ),
                    DropdownButtonFormField(
                        hint: const Text("Gender"),
                        value: isGenderSelected,
                        onChanged: (newValue) {
                          setState(() {
                            isGenderSelected = newValue;
                          });
                        },
                        items: gender.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(
                              value.toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        }).toList()),
                    TextFormField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Age",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                ),
                onPressed: () {
                  addUserFormData();
                },
                child: const Text("Submit")),
            const SizedBox(height: 40),
          ]),
        ),
      ),
    );
  }
}
