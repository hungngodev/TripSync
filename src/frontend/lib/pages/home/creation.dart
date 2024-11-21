import 'package:flutter/material.dart';

class CreationScreen extends StatefulWidget {
  const CreationScreen({super.key});

  @override
  State<CreationScreen> createState() => _CreationState();
}

const catgories = [
  "All",
  "Breakfast",
  "Lunch",
  "Dinner",
];

class _CreationState extends State<CreationScreen> {
  String currentCat = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text(
                    "What will be your\n next journey?",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.white,
                      fixedSize: const Size(55, 55),
                    ),
                    icon: const Icon(Icons.notifications_none_outlined),
                  ),
                ]),
                const SizedBox(height: 20),
                // Container(
                //   width: double.infinity,
                //   height: 200,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(15),
                //     image: const DecorationImage(
                //       fit: BoxFit.fill,
                //       image: AssetImage("assets/images/4.jpg"),
                //     ),
                //   ),
                // ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      activities.length,
                      (index) => GestureDetector(
                        onTap: () => {
                          //   Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => RecipeScreen(food: activities[index]),
                          //   ),
                          // )
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 200,
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image:
                                            AssetImage(activities[index].image),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    activities[index].name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star_border_purple500_rounded,
                                        size: 30,
                                        color: const Color.fromARGB(
                                            255, 147, 139, 174),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          "${activities[index].description}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Positioned(
                                top: 1,
                                right: 1,
                                child: IconButton(
                                  onPressed: () {},
                                  style: IconButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 147, 139, 174),
                                    fixedSize: const Size(30, 30),
                                  ),
                                  color: Colors.white,
                                  iconSize: 20,
                                  icon: const Icon(Icons.navigation_outlined),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Create your new Trip",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Review your previous journeys",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () => {
                            //   Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const QuickFoodsScreen(),
                            //   ),
                            // )
                          },
                          child: const Text("View all"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Activity {
  String name;
  String image;
  double cal;
  String description;
  double rate;
  int reviews;
  bool isLiked;

  Activity({
    required this.name,
    required this.image,
    required this.cal,
    required this.description,
    required this.rate,
    required this.reviews,
    required this.isLiked,
  });
}

final List<Activity> activities = [
  Activity(
    name: "Famous Cuisine",
    image: "assets/images/1.jpg",
    cal: 120,
    description: "Try these spicy ramen noodles!",
    rate: 4.4,
    reviews: 23,
    isLiked: false,
  ),
  Activity(
    name: "Plane Trip",
    image: "assets/images/2.jpg",
    cal: 140,
    description: "Choose from the best routes now.",
    rate: 4.4,
    reviews: 23,
    isLiked: true,
  ),
  Activity(
    name: "Popular Places",
    image: "assets/images/3.jpg",
    cal: 130,
    description: "Visit amazing popular places.",
    rate: 4.2,
    reviews: 10,
    isLiked: false,
  ),
  Activity(
    name: "Travel with Pet",
    image: "assets/images/5.jpg",
    cal: 110,
    description: "Travel anywhere with your pet.",
    rate: 4.6,
    reviews: 90,
    isLiked: true,
  ),
  Activity(
    name: "Transportation",
    image: "assets/images/6.jpg",
    cal: 150,
    description: "Find the best transportation now.",
    rate: 4.0,
    reviews: 76,
    isLiked: false,
  ),
  Activity(
    name: "Checkout Hotel",
    image: "assets/images/7.jpg",
    cal: 140,
    description: "Book a room in the best hotels.",
    rate: 4.4,
    reviews: 23,
    isLiked: false,
  ),
];
