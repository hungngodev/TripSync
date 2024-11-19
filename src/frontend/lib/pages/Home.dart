// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// // import '../services/openai/gpt_service.dart';
// import '../services/django/api_service.dart';
// import '../util/keyword.dart';
// import './/util/location.dart';
// import '../bloc/authentication_bloc.dart';
// import '../bloc/authentication_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _Home();
// }

// class _Home extends State<Home> {
//   TextEditingController locationController = TextEditingController();
//   TextEditingController stateController = TextEditingController();
//   TextEditingController keywordController = TextEditingController();
//   final ApiService apiService = ApiService();
//   List<dynamic> data = [];

//   List<Map<String, dynamic>> selectedActivities = [];
//   List<String> locations = [];
//   List<String> keywords = ["outdoor", "museum"];

//   void addLocation() {
//     String location = locationController.text;
//     String state = stateController.text;
//     if (location.isNotEmpty &&
//         state.isNotEmpty &&
//         !locations.contains(location)) {
//       setState(() {
//         // locations.add("$location, $state");
//         locations = [location];
//       });
//     }
//   }

//   void deleteLocation(int index) {
//     setState(() {
//       locations.removeAt(index);
//     });
//   }

//   void addKeyword() {
//     String keyword = keywordController.text;
//     if (keyword.isNotEmpty) {
//       setState(() {
//         keywords.add(keyword);
//       });
//     }
//   }

//   void deleteKeyword(int index) {
//     setState(() {
//       keywords.removeAt(index);
//     });
//   }

// // Update addActivity function
//   void addActivity(Map<String, dynamic> activity) {
//     // Check for duplication using the ID (assuming 'id' is the key for the unique identifier)
//     if (!selectedActivities
//         .any((selected) => selected['id'] == activity['id'])) {
//       setState(() {
//         selectedActivities.add(activity);
//       });
//     } else {
//       // Optionally show a message that the activity is already added
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text(
//                 'Activity "${activity['description']}" is already added!')),
//       );
//     }
//   }

//   void deleteActivity(int index) {
//     setState(() {
//       selectedActivities.removeAt(index);
//     });
//   }

//   void clearActivities() {
//     setState(() {
//       selectedActivities.clear();
//     });
//   }

//   Future<void> _launchURL(String url) async {
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url));
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text('MA Traveling Suggestion',
//             style: TextStyle(color: Colors.white)),
//         iconTheme: const IconThemeData(color: Colors.white),
//         elevation: 0,
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.black,
//               ),
//               child: Text(
//                 'Your Selected Activities',
//                 style: TextStyle(color: Colors.white, fontSize: 24),
//               ),
//             ),
//             ...selectedActivities.map((activity) {
//               return Padding(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 4.0, horizontal: 16.0),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             activity['id'].toString() +
//                                 ' ' +
//                                 activity['location'],
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () => deleteActivity(
//                                 selectedActivities.indexOf(activity)),
//                             icon: const Icon(Icons.delete),
//                             color: Colors.red,
//                           ),
//                         ],
//                       ),
//                       const Divider(),
//                     ],
//                   )

//                   // ElevatedButton(
//                   //   onPressed: () {
//                   //     print("Selected activity: $activity");
//                   //   },
//                   //   style: ElevatedButton.styleFrom(
//                   //       backgroundColor: Colors.grey[800],
//                   //       foregroundColor: Colors.white),
//                   //   child: Text('${activity['id']} ' + activity['location'],
//                   //       style: const TextStyle(color: Colors.white)),
//                   // ),
//                   );
//             }),
//           ],
//         ),
//       ),
//       body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
//         builder: (context, state) {
//           if (state is AuthenticationAuthenticated) {
//             final userId = state.userId; // Access the userId
//             return SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ListView.builder(
//                     scrollDirection: Axis.vertical,
//                     shrinkWrap: true,
//                     itemCount: locations.length,
//                     itemBuilder: (context, index) {
//                       return Location(
//                         location: locations[index],
//                         deleteFunction: (context) => deleteLocation(index),
//                       );
//                     },
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Container(
//                       padding: const EdgeInsets.all(24),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               controller: locationController,
//                               maxLines: 1,
//                               decoration: const InputDecoration(
//                                 labelText: "Location",
//                                 hintText: "Enter your Location here",
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: TextFormField(
//                               controller: stateController,
//                               maxLines: 1,
//                               decoration: const InputDecoration(
//                                 labelText: "State",
//                                 hintText: "Enter your State here",
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: ElevatedButton(
//                       onPressed: addLocation,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.black,
//                       ),
//                       child: const Text(
//                         'Set Location',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 110,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       shrinkWrap: true,
//                       itemCount: keywords.length,
//                       itemBuilder: (context, index) {
//                         return Keyword(
//                           keyword: keywords[index],
//                           deleteFunction: () => deleteKeyword(index),
//                         );
//                       },
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Container(
//                       padding: const EdgeInsets.all(24),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               controller: keywordController,
//                               maxLines: 1,
//                               decoration: const InputDecoration(
//                                 labelText: "Keyword",
//                                 hintText: "Enter a keyword for your holiday.",
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: addKeyword,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                     ),
//                     child: const Text(
//                       'Add Keywords',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         String places = locations.join(',');
//                         String keys = keywords.join(',');
//                         try {
//                           List<dynamic> fetchData = await apiService.getData(
//                             'activities',
//                             queryParameters: {
//                               'location': places,
//                               'keywords': keys,
//                             },
//                           );
//                           setState(() {
//                             data = fetchData;
//                           });
//                         } catch (e) {
//                           print(e);
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.black,
//                       ),
//                       child: const Text(
//                         "Submit",
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       children: [
//                         ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: data.length,
//                           itemBuilder: (context, index) {
//                             final item = data[index];
//                             return Card(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               elevation: 5,
//                               margin: const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(15.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       item['category'].toString().toUpperCase(),
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18,
//                                         color: Colors.deepPurple,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 5),
//                                     Text(
//                                       item['description'],
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.grey[800],
//                                       ),
//                                     ),
//                                     const SizedBox(height: 10),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           'Location: ${item['location']}',
//                                           style: TextStyle(
//                                             fontStyle: FontStyle.italic,
//                                             color: Colors.grey[600],
//                                           ),
//                                         ),
//                                         GestureDetector(
//                                           onTap: () =>
//                                               _launchURL(item['source_link']),
//                                           child: const Text(
//                                             'Visit Source',
//                                             style: TextStyle(
//                                               color: Colors.blue,
//                                               decoration:
//                                                   TextDecoration.underline,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 10),
//                                     // Add button to the Card
//                                     Align(
//                                       alignment: Alignment.centerRight,
//                                       child: ElevatedButton(
//                                         onPressed: () {
//                                           // Call the function to add the item to the cart
//                                           addActivity(item);
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: Colors.deepPurple,
//                                           foregroundColor: Colors.white,
//                                         ),
//                                         child: const Text('Add'),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//           return const Center(
//               child: CircularProgressIndicator()); // Handle other states
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/authentication_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home | Home Hub'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(34.0, 20.0, 0.0, 0.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.width * 0.16,
                child: ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(LoggedOut());
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(
                      side: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20)),
                      backgroundColor: WidgetStateProperty.all(Colors.black)),
                  onPressed: () => openCalendarPage(context),
                  child: const Text(
                    'Calendars',
                    style: TextStyle(color: Colors.white),
                  )),
                  FutureBuilder<SearchResponse>(
                  future: incomingLocations,
                  builder: (context, AsyncSnapshot<SearchResponse> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      final results = snapshot.data!.data; // Assuming `results` is the list
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: results!.length,
                        separatorBuilder: (context, index) => const Divider(color: Colors.black),
                        itemBuilder: (context, index) {
                          final location = results;
                          return ListTile(
                            title: Text(location as String), // Ensure `name` exists
                            // subtitle: Text(location.addressObject?.address ?? "No address available"),
                            // trailing: ElevatedButton.icon(
                            //   onPressed: () {},
                            //   icon: const Icon(Icons.favorite),
                            //   label: const Text('Save'),
                            // ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text("No data available"));
                    }
                  },
                ),

                  // FutureBuilder<SearchResponse>(
                  //   future: incomingLocations, 
                  //   builder: ((context, AsyncSnapshot snapshot) {
                  //   if (snapshot.hasData){
                  //     return ListView.separated(
                  //       itemBuilder: (context, index){
                  //       SearchResponse location = snapshot.data?[index];
                  //       return Text(location as String);
                  //       // return ListTile(
                  //       //   title:  Text(location.name as String),
                  //       //   subtitle: Text(location.addressObject as String),
                  //       //   //onTap: () => openPge(context), code for function to call when activityclicked
                  //       //   trailing: ElevatedButton.icon(
                  //       //     onPressed: (){}, // replace this by saving activity
                  //       //     icon: const Icon(Icons.favorite),
                  //       //     label: const Text('Save'),)
                          
                  //       // );
                  //     },
                  //     separatorBuilder: (context, index){
                  //       return const Divider(color: Colors.black,);
                  //     }, itemCount: snapshot.data!.length);

                  //   } else if (snapshot.hasError){
                  //     return const Text("Error loading locations");
                  //   }
                  //   return const CircularProgressIndicator();

                  // }),) 
            ],
          ),
        ));
        // ListView.builder(
        //         scrollDirection: Axis.vertical,
        //         shrinkWrap: true,
        //         itemCount: activities.length,
        //         itemBuilder: (context, index) {
        //           final activity = activities[index];
        //           return ListTile(
        //             title: const Text('Placeholder'),
        //             subtitle: const Text('Placeholder'),
        //             //onTap: () => openPge(context), code for function to call when activityclicked
        //             trailing: ElevatedButton.icon(
        //               onPressed: (){}, // replace this by saving activity
        //               icon: const Icon(Icons.favorite),
        //               label: const Text('Save'),)
        //           );
        //         },
        //       ),
  }
}
