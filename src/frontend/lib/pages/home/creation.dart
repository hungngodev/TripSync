import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'dart:math';
import 'package:lottie/lottie.dart';

import '../../services/django/api_service.dart';
import '../../util/day_card.dart';
import '../../util/mainColors.dart';
import '../../util/view_all.dart';

class CreationScreen extends StatefulWidget {
  final calendarNav;
  CreationScreen({this.calendarNav, Key? key}) : super(key: key);
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
  late List<dynamic> calendars = [];

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
    final calendarList = await apiService.getCalendars();

    setState(() {
      calendars = calendarList;
    });
  }

  Future<void> create() async {
    setState(() {
      isLoading = true;
    });
    String id = await apiService.createCalendar(_controller.text);

    const snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Let Go!',
        message: 'Your trip has been created successfully!',
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);

    setState(() {
      isLoading = false;
      calendars.insert(0, {
        'name': _controller.text,
        'created_at': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'id': id,
      });
      _controller.clear();
    });
    this.widget.calendarNav(id, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 147, 139, 174),
        title: Text(
          'Home',
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 24),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
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
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewAllPage(
                                  onBack: () {
                                    Navigator.pop(context);
                                  },
                                  navigateToCalendar: (id, index) {
                                    this.widget.calendarNav(id, index);
                                  },
                                ),
                              ),
                            )
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
                    child: calendars.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: calendars.length,
                            itemBuilder: (context, index) {
                              final calendar = calendars[index];
                              return DayCard(
                                name: calendar['name'],
                                selectedDate:
                                    DateTime.parse(calendar['created_at']),
                                cardColor:
                                    myCardColors[index % myCardColors.length]
                                        .withOpacity(1),
                                dividerColor:
                                    dividerColors[index % dividerColors.length]
                                        .withOpacity(0.2),
                                listOfEvent: generateRandomSchedule(),
                                navigate: () {
                                  this.widget.calendarNav(calendar['id'], 2);
                                },
                              );
                            },
                          )
                        : Center(
                            child: Column(
                            children: [
                              const Text(
                                "No trips yet",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Lottie.asset(
                                'assets/animations/plane.json',
                                width:
                                    MediaQuery.of(context).size.height * 0.32,
                                height:
                                    MediaQuery.of(context).size.height * 0.32,
                                fit: BoxFit.fill,
                              )
                            ],
                          )))
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
Map<String, Map<String, dynamic>> generateRandomSchedule() {
  // Define all available icons
  final icons = [
    Icons.flight_takeoff,
    Icons.hotel,
    Icons.restaurant,
    Icons.local_taxi,
    Icons.coffee,
    Icons.shopping_cart,
    Icons.beach_access,
    Icons.fitness_center,
    Icons.music_note,
    Icons.local_movies,
    Icons.work,
    Icons.school,
    Icons.home,
  ];

  // Define time slots (24 hours with intervals of 1 hour)
  final timeSlots =
      List.generate(24, (index) => '${index.toString().padLeft(2, '0')}:00');

  final random = Random();
  final schedule = <String, Map<String, dynamic>>{};

  for (var time in timeSlots) {
    // Randomly choose one or more icons for this slot
    final iconCount = random.nextInt(3) + 1; // 1 to 3 icons
    final randomIcons =
        List.generate(iconCount, (_) => icons[random.nextInt(icons.length)]);

    schedule[time] = {
      'icons': randomIcons,
      'hasEvent': random.nextBool(), // Randomly decide if an event exists
    };
  }

  return schedule;
}
