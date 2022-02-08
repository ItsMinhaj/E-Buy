import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritScreen extends StatelessWidget {
  const FavoritScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Favorite Items"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("add-to-favorite")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection("favorite-items")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                return ListTile(
                  leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(documentSnapshot["image"][0])),
                  title: Text(documentSnapshot["name"]),
                  subtitle: Text(documentSnapshot["price"]),
                  trailing: IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("add-to-favorite")
                            .doc(FirebaseAuth.instance.currentUser!.email)
                            .collection("favorite-items")
                            .doc(documentSnapshot.id)
                            .delete();
                      },
                      icon: const Icon(Icons.delete)),
                );
              });
        },
      ),
    );
  }
}
