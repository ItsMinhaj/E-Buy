import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  TextEditingController? nameController;

  TextEditingController? genderController;

  TextEditingController? ageController;

  TextEditingController? phoneController;

  updateUserProfile() {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users-form-data");

    return collectionReference
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({
      "full-name": nameController!.text,
      "gender": genderController!.text,
      "age": ageController!.text,
      "phone": phoneController!.text
    }).then((value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully"))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("User Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users-form-data")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot?> snapshot) {
              var data = snapshot.data;
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController =
                          TextEditingController(text: data!["full-name"]),
                    ),
                    TextFormField(
                      controller: genderController =
                          TextEditingController(text: data["gender"]),
                    ),
                    TextFormField(
                      controller: ageController =
                          TextEditingController(text: data["age"]),
                    ),
                    TextFormField(
                      controller: phoneController =
                          TextEditingController(text: data["phone"]),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          updateUserProfile();
                        },
                        child: const Text("Update"))
                  ],
                ),
              );
            }),
      ),
    );
  }
}
