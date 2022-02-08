import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:e_commerce/const/app_color.dart';
import 'package:e_commerce/screens/product_details/details_screen.dart';
import 'package:e_commerce/screens/search/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _sliderImages = [];
  final _products = [];
  var _dotsPosition = 0;

  fetchSliderImages() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('slider-images').get();

    setState(() {
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        _sliderImages.add(
          querySnapshot.docs[i]["img-path"],
        );
      }
    });
    return querySnapshot.docs;
  }

  fetchSliderProducts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();

    setState(() {
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        _products.add({
          "product-name": querySnapshot.docs[i]["product-name"],
          "product-description": querySnapshot.docs[i]["product-description"],
          "price": querySnapshot.docs[i]["price"],
          "product-image": querySnapshot.docs[i]["product-image"],
        });
      }
    });
    return querySnapshot.docs;
  }

  @override
  void initState() {
    fetchSliderImages();
    fetchSliderProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[50],
        //  backgroundColor: const Color(0xffF9FBE7),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("E-Buy", style: TextStyle(fontSize: 32)),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          readOnly: true,
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (_) => const SearchScreen()));
                          },
                          decoration: const InputDecoration(
                            hintText: "Search",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      color: AppColor.secondaryColor,
                      child: IconButton(
                          onPressed: () {}, icon: const Icon(Icons.search)),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              AspectRatio(
                aspectRatio: 3,
                child: CarouselSlider(
                  items: _sliderImages.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(item),
                                    fit: BoxFit.fitWidth)),
                          ),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    onPageChanged: (index, pageChangedReason) {
                      setState(() {
                        _dotsPosition = index;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DotsIndicator(
                dotsCount: _sliderImages.isEmpty ? 1 : _sliderImages.length,
                position: _dotsPosition.toDouble(),
                decorator: const DotsDecorator(
                  activeColor: AppColor.secondaryColor,
                  color: Colors.black54,
                  activeSize: Size(8, 8),
                  size: Size(6, 6),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                  child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 1),
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => ProductDetailsScreen(
                                        products: _products[index],
                                      ))),
                          child: Card(
                            elevation: 4,
                            child: Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 1.7,
                                  child: Image.network(
                                    _products[index]["product-image"][0],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  _products[index]["product-name"],
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _products[index]["price"],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      }))
            ],
          ),
        ));
  }
}
