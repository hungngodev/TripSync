import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/django/api_service.dart';
import '../../util/day_card.dart';
import '../../util/mainColors.dart';

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
  bool isLoading = false;
  late Map<String, Map<String, Map<String, dynamic>>> events = {};
  final TextEditingController _controller = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  void dispose() {
    // Always dispose of the controller when it's no longer needed
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getEvents();
    super.initState();
  }

  Future<T> fakeAsync<T>(T result,
          [Duration delay = const Duration(milliseconds: 500)]) =>
      Future.delayed(delay, () => result);

  Future<void> getEvents() async {
    await fakeAsync(null);
    DateTime dayOnly = DateTime.now()
        .toLocal()
        .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
    DateTime nextDay = DateTime.now()
        .toLocal()
        .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0)
        .add(const Duration(days: 1));

    setState(() {
      events = {
        DateFormat('yyyy-MM-dd').format(dayOnly): {
          '09:00': {
            'icons': [Icons.flight_takeoff],
            'hasEvent': true,
          },
          '10:00': {
            'icons': [Icons.hotel],
            'hasEvent': true,
          },
          '12:00': {
            'icons': [Icons.restaurant],
            'hasEvent': true,
          },
          '14:00': {
            'icons': [Icons.local_taxi],
            'hasEvent': true,
          },
          '16:00': {
            'icons': [Icons.flight_takeoff],
            'hasEvent': true,
          },
          '18:00': {
            'icons': [Icons.hotel],
            'hasEvent': true,
          },
          '20:00': {
            'icons': [Icons.restaurant],
            'hasEvent': true,
          },
          '22:00': {
            'icons': [Icons.local_taxi],
            'hasEvent': true,
          },
        },
        DateFormat('yyyy-MM-dd').format(nextDay): {
          '09:00': {
            'icons': [Icons.flight_takeoff],
            'hasEvent': true,
          },
          '10:00': {
            'icons': [Icons.hotel],
            'hasEvent': true,
          },
          '12:00': {
            'icons': [Icons.restaurant],
            'hasEvent': true,
          },
          '14:00': {
            'icons': [Icons.local_taxi],
            'hasEvent': true,
          },
          '16:00': {
            'icons': [Icons.flight_takeoff],
            'hasEvent': true,
          },
          '18:00': {
            'icons': [Icons.hotel],
            'hasEvent': true,
          },
          '20:00': {
            'icons': [Icons.restaurant],
            'hasEvent': true,
          },
          '22:00': {
            'icons': [Icons.local_taxi],
            'hasEvent': true,
          },
        },
      };
    });
  }

  Future<void> create() async {
    String id = await apiService.createCalendar(_controller.text);
    setState(() {
      isLoading = true;
    });
  }

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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      activities.length,
                      (index) => GestureDetector(
                        onTap: () => {},
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
                                        color:
                                            Color.fromARGB(255, 147, 139, 174),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          activities[index].description,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Create your new Trip",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      style: const TextStyle(fontSize: 20),
                      controller: _controller, //
                      decoration: InputDecoration(
                        hintText: "Enter the name",
                        hintStyle: const TextStyle(fontSize: 20),
                        prefixIcon: const Icon(Icons.create),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(
                              10.0), // Adjust the padding as needed
                          child: FloatingActionButton(
                            onPressed: isLoading ? null : create,
                            backgroundColor:
                                const Color.fromARGB(255, 147, 139, 174),
                            child: isLoading
                                ? Container(
                                    width: 24,
                                    height: 24,
                                    padding: const EdgeInsets.all(2.0),
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Icon(Icons.add,
                                    size: 35, color: Colors.white),
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Your Past Trips",
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
                          child: const Text("View all",
                              style: TextStyle(
                                fontSize: 15,
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                SizedBox(
                    height: 320,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return DayCard(
                          name: "Boston Trip",
                          selectedDate:
                              DateTime.now().subtract(Duration(days: index)),
                          cardColor: myCardColors[index % myCardColors.length]
                              .withOpacity(1),
                          dividerColor:
                              dividerColors[index % dividerColors.length]
                                  .withOpacity(0.2),
                          listOfEvent: events[DateFormat('yyyy-MM-dd').format(
                                  DateTime.now()
                                      .subtract(Duration(days: index)))] ??
                              {},
                        );
                      },
                    ))
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

List<Color> myCardColors = [
  maincolors.color2,
  const Color(0x006d7988).withOpacity(0.8),
  const Color(0x00a698ae).withOpacity(0.8),
];
List<Color> dividerColors = [
  maincolors.color2Dark,
  const Color(0x006d7988),
  const Color(0x00a698ae),
];

const List<Color> iconColors = [
  Color(0x0000f5d4),
  Color(0x0000bbf9),
  Color(0x00fee440),
  Color(0x00f15bb5),
  Color(0x009b5de5),
  Color(0x00ff0054),
  Color(0x008ac926),
];
