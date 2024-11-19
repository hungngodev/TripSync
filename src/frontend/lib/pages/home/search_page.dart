import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/django/api_service.dart';
import '../../util/keyword.dart';
import '../../../util/location.dart';
import '../../bloc/authentication_bloc.dart';
import '../../bloc/authentication_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _Home();
}

class _Home extends State<SearchPage> {
  TextEditingController locationController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController keywordController = TextEditingController();
  final ApiService apiService = ApiService();
  List<dynamic> data = [];

  List<Map<String, dynamic>> selectedActivities = [];
  List<String> locations = [];
  List<String> keywords = [];

  @override
  void initState() {
    super.initState();
    // Call the function to get the data
    // fetchData();
  }

  void addLocation() {
    String location = locationController.text;
    String state = stateController.text;
    if (location.isNotEmpty &&
        state.isNotEmpty &&
        !locations.contains(location)) {
      setState(() {
        // locations.add("$location, $state");
        locations = [location];
      });
    }
  }

  void deleteLocation(int index) {
    setState(() {
      locations.removeAt(index);
    });
  }

  void addKeyword() {
    String keyword = keywordController.text;
    if (keyword.isNotEmpty) {
      setState(() {
        keywords.add(keyword);
      });
    }
  }

  void deleteKeyword(int index) {
    setState(() {
      keywords.removeAt(index);
    });
  }

// Update addActivity function
  void addActivity(Map<String, dynamic> activity) async {
    // Check for duplication using the ID (assuming 'id' is the key for the unique identifier)
    if (!selectedActivities
        .any((selected) => selected['id'] == activity['id'])) {
      final chosenId = await apiService.addChosenActivity({
        'activity': activity['id'],
      });
      setState(() {
        selectedActivities.add({
          'id': activity['id'],
          'location': activity['location'],
          'description': activity['description'],
          'chosenId': chosenId,
        });
      });
    } else {
      // Optionally show a message that the activity is already added
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Activity "${activity['description']}" is already added!')),
      );
    }
  }

  void deleteActivity(int index) async {
    final chosenId = selectedActivities[index]['chosenId'];
    setState(() {
      selectedActivities.removeAt(index);
    });
    await apiService.deleteChosenActivity(chosenId); // Call the delete function
  }

  void clearActivities() {
    setState(() {
      selectedActivities.clear();
    });
  }

  // void saveActivities() async {
  //   // print(selectedActivities);
  //   final chosenList = selectedActivities.map((activity) {
  //     return {
  //       'activity': activity['id'],
  //     };
  //   }).toList();

  //   try {
  //     await apiService.createChosenList(chosenList);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Activities saved successfully!'),
  //       ),
  //     );
  //   } catch (e) {
  //     print(e);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Failed to save activities!'),
  //       ),
  //     );
  //   }
  // }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('MA Traveling Suggestion',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Your Selected Activities',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ...selectedActivities.map((activity) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          activity['id'].toString() +
                              ' ' +
                              activity['location'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () => deleteActivity(
                              selectedActivities.indexOf(activity)),
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                ),
              );
            }).toList(),
            // Save Button at the bottom of the drawer
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: ElevatedButton(
            //     onPressed:
            //         saveActivities, // Call the save function when pressed
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blue, // Button color
            //       padding: EdgeInsets.symmetric(vertical: 14.0),
            //     ),
            //     child: const Text(
            //       'Save',
            //       style: TextStyle(fontSize: 18, color: Colors.white),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            final userId = state.userId; // Access the userId
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
                      return Location(
                        location: locations[index],
                        deleteFunction: (context) => deleteLocation(index),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: locationController,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                labelText: "Location",
                                hintText: "Enter your Location here",
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: stateController,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                labelText: "State",
                                hintText: "Enter your State here",
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: addLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        'Set Location',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: keywords.length,
                      itemBuilder: (context, index) {
                        return Keyword(
                          keyword: keywords[index],
                          deleteFunction: () => deleteKeyword(index),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: keywordController,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                labelText: "Keyword",
                                hintText: "Enter a keyword for your holiday.",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: addKeyword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      'Add Keywords',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        String places = locations.join(',');
                        String keys = keywords.join(',');
                        try {
                          List<dynamic> fetchData = await apiService.getData(
                            queryParameters: {
                              'location': places,
                              'keywords': keys,
                            },
                          );
                          setState(() {
                            data = fetchData;
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final item = data[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['category'].toString().toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      item['description'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Location: ${item['location']}',
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              _launchURL(item['source_link']),
                                          child: const Text(
                                            'Visit Source',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    // Add button to the Card
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Call the function to add the item to the cart
                                          addActivity(item);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.deepPurple,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('Add'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(
              child: CircularProgressIndicator()); // Handle other states
        },
      ),
    );
  }
}
