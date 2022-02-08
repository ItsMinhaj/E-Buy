import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductDetailsScreen({required this.products, Key? key}) : super(key: key);
  var products;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool isFavorite = false;

  Future addToCart() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("add-to-cart");
    return collectionReference
        .doc(_auth.currentUser!.email)
        .collection("cart-items")
        .doc()
        .set({
          "name": widget.products["product-name"],
          "image": widget.products["product-image"],
          "price": widget.products["price"],
        })
        .then((value) => Fluttertoast.showToast(msg: "item added to cart"))
        .catchError((e) {
          debugPrint(e.toString());
        });
  }

  Future addToFavorite() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("add-to-favorite");
    return collectionReference
        .doc(_auth.currentUser!.email)
        .collection("favorite-items")
        .doc()
        .set({
          "name": widget.products["product-name"],
          "image": widget.products["product-image"],
          "price": widget.products["price"],
        })
        .then((value) => Fluttertoast.showToast(msg: "item added to favorite"))
        .catchError((e) {
          debugPrint(e.toString());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
                if (isFavorite == true) {
                  addToFavorite();
                }
              },
              icon: Icon(
                Icons.favorite,
                color: isFavorite ? Colors.red : Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Image.network(widget.products["product-image"][0]),
                  const SizedBox(height: 10),
                  Center(
                    child: ListTile(
                      title: Text(widget.products["product-name"],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      trailing: Text(
                        widget.products["price"],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      widget.products["product-description"],
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(36),
                  ),
                  onPressed: () {
                    addToCart();
                  },
                  child: const Text("Add To Cart")),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
