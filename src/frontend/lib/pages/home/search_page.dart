import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/authentication_bloc.dart';
import '../../bloc/authentication_state.dart';
import '../../services/django/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../util/calendar-popup.dart';

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
  String _selectedItem = '';
  final SearchController _searchController = SearchController();
  final Set<dynamic> _filters = {};
  Set<String> options = {'hotel', 'restaurant', 'entertainments'};
  final Set<String> original = {'hotel', 'restaurant', 'entertainments'};
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  String currentTrip = '';

  @override
  void initState() {
    super.initState();
    // Fetch selected activities
    _fetchSelectedActivities();
  }

  Future<void> _fetchSelectedActivities() async {
    try {
      // Fetch the list of chosen activities from the API
      List<Map<String, dynamic>> activities = await apiService.getChosenList();

      setState(() {
        selectedActivities = activities;
      });
    } catch (e) {
      print("Error fetching selected activities: $e");
    }
  }

  void addKeyword() {
    print("Adding keyword");
    String keyword = keywordController.text;
    if (keyword.isNotEmpty) {
      setState(() {
        options.add(keyword);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a keyword!'),
        ),
      );
    }
  }

  void deleteKeyword(String val) {
    setState(() {
      options.remove(val);
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
      if (chosenId == '') {
        return;
      }

      setState(() {
        selectedActivities.add({
          'id': activity['id'],
          'location': activity['location'],
          'description': activity['description'],
          'category': activity['category'],
          'source_link': activity['source_link'],
          'title': activity['title'],
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

  void search() async {
    print("Searching for $_selectedItem");
    final String filter =
        _filters.map((e) => e.toString().split('.').last).join(',');
    print("Filter by: $filter");
    try {
      List<dynamic> fetchData = await apiService.getData(
        queryParameters: {
          'location': _selectedItem,
          'category':
              _filters.map((e) => e.toString().split('.').last).join(','),
        },
      );
      setState(() {
        data = fetchData;
      });
    } catch (e) {
      print(e);
    }
  }

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
        backgroundColor: const Color.fromARGB(255, 147, 139, 174),
        title: Text(
          currentTrip != '' ? 'Search for $currentTrip' : 'Your First Trip',
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 24),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 147, 139, 174),
              ),
              child: Text(
                "Selected Activity",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Clear'),
                      content: const Text(
                          'Are you sure you want to clear this list?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Perform delete action
                            clearActivities();
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text(
                'Clear',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),
            ...selectedActivities.map((activity) {
              print(activity);
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                activity['title']!.substring(
                                  0,
                                  activity['title']!.length > 20
                                      ? 20
                                      : activity['title']!.length,
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Show a dialog before performing the delete action
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Activity Details'),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Title
                                              Text(
                                                activity['title']!,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 10),

                                              // Location
                                              Text(
                                                "Location: ${activity['location']}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 10),

                                              // Address
                                              Text(
                                                "Address: ${activity['address'] ?? 'N/A'}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 10),

                                              // Category
                                              Text(
                                                "Category: ${activity['category']}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.blueGrey,
                                                ),
                                              ),
                                              const SizedBox(height: 10),

                                              // Description
                                              Text(
                                                "Description: ${activity['description']}",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 10),

                                              // Source Link
                                              GestureDetector(
                                                onTap: () => _launchURL(
                                                    activity['source_link']!),
                                                child: Text(
                                                  "Source: ${activity['source_link']}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.blue,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            child: const Text('Close'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.info),
                                color: Colors.blue,
                              ),
                            ]),
                        IconButton(
                          onPressed: () {
                            // Show a dialog before performing the delete action
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text(
                                      'Are you sure you want to delete this activity?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Perform delete action
                                        deleteActivity(selectedActivities
                                            .indexOf(activity));
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
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
          ],
        ),
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  SearchAnchor(
                    searchController: _searchController,
                    builder:
                        (BuildContext context, SearchController controller) {
                      return SearchBar(
                        controller: controller,
                        padding: const WidgetStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 20.0)),
                        onTap: () {
                          controller.openView();
                        },
                        leading: const Icon(Icons.search),
                        trailing: <Widget>[
                          Tooltip(
                            message: 'Search',
                            child: IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {
                                print('Searching for ');
                                setState(() {
                                  _selectedItem = controller
                                      .text; // Treat the current text as selected
                                });
                              },
                            ),
                          )
                        ],
                      );
                    },
                    suggestionsBuilder:
                        (BuildContext context, SearchController controller) {
                      return List<Widget>.generate(suggestions.length,
                          (int index) {
                        if (suggestions[index].contains(controller.text)) {
                          return ListTile(
                            title: Text(suggestions[index]),
                            onTap: () {
                              setState(() {
                                _selectedItem = suggestions[
                                    index]; // Update state when an item is selected
                              });
                              controller.closeView(suggestions[index]);
                              search();
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      });
                    },
                    viewOnSubmitted: (value) {
                      print("Submitted: $value");
                      setState(() {
                        _selectedItem = value;
                      });
                      _searchController.closeView(value);
                      search();
                    },
                  ),
                  const SizedBox(height: 10),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.grey.withOpacity(0.2),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        showDemoDialog(context: context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 4, bottom: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Choose date',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey.withOpacity(0.8)),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              '${DateFormat("dd, MMM").format(startDate)} - ${DateFormat("dd, MMM").format(endDate)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Row(
                  //     children: <Widget>[
                  //       Material(
                  //         color: Colors.transparent,
                  //         child: InkWell(
                  //           focusColor: Colors.transparent,
                  //           highlightColor: Colors.transparent,
                  //           hoverColor: Colors.transparent,
                  //           splashColor: Colors.grey.withOpacity(0.2),
                  //           borderRadius: const BorderRadius.all(
                  //             Radius.circular(4.0),
                  //           ),
                  //           onTap: () {
                  //             FocusScope.of(context).requestFocus(FocusNode());
                  //             // setState(() {
                  //             //   isDatePopupOpen = true;
                  //             // });
                  //             showDemoDialog(context: context);
                  //           },
                  //           child: Padding(
                  //             padding: const EdgeInsets.only(
                  //                 left: 8, right: 8, top: 4, bottom: 4),
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: <Widget>[
                  //                 Text(
                  //                   'Choose date',
                  //                   style: TextStyle(
                  //                       fontWeight: FontWeight.w100,
                  //                       fontSize: 16,
                  //                       color: Colors.grey.withOpacity(0.8)),
                  //                 ),
                  //                 const SizedBox(
                  //                   height: 8,
                  //                 ),
                  //                 Text(
                  //                   '${DateFormat("dd, MMM").format(startDate)} - ${DateFormat("dd, MMM").format(endDate)}',
                  //                   style: const TextStyle(
                  //                     fontWeight: FontWeight.w100,
                  //                     fontSize: 16,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 5.0,
                    children: options.map((String exercise) {
                      return FilterChip(
                        label: Text(exercise),
                        selected: _filters.contains(exercise),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _filters.add(exercise);
                            } else {
                              _filters.remove(exercise);
                            }
                          });
                          search();
                        },
                        deleteIcon: original.contains(exercise)
                            ? null
                            : const Icon(Icons
                                .close), // Show delete icon only if the condition is met
                        onDeleted: original.contains(exercise)
                            ? null
                            : () {
                                setState(() {
                                  options.remove(
                                      exercise); // Perform the delete action
                                });
                                search();
                              }, //
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: keywordController,
                              maxLines: 1,
                              decoration: InputDecoration(
                                labelText: "Keyword",
                                hintText: "Enter a keyword for your holiday.",
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    addKeyword(); // Call the addKeyword function when the icon is pressed
                                  },
                                ),
                              ),
                              onFieldSubmitted: (String value) {
                                addKeyword(); // Call the addKeyword function when Enter is pressed
                              },
                            ),
                          ),
                        ],
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

  void showDemoDialog({BuildContext? context}) {
    showDialog<dynamic>(
      context: context!,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            startDate = startData;
            endDate = endData;
          });
        },
        onCancelClick: () {},
      ),
    );
  }
}

final suggestions = [
  "Los Angeles",
  "Aspen",
  "Austin",
  "Manhattan",
  "Miami",
  "Phoenix",
  "Chicago",
  "Seattle",
  "Las Vegas",
  "Burlington",
  "Boston",
  "Atlanta",
  "Amherst",
  "Cambridge",
  "Worcester",
  "Springfield",
  "Lowell",
  "Brockton",
  "Quincy",
  "Newton",
  "Lynn",
  "Somerville",
  "Framingham",
  "Peabody",
  "Revere",
  "Malden",
  "Taunton",
  "Chelsea",
  "Pittsfield",
  "Medford",
  "Weymouth",
  "Haverhill",
  "Marlborough",
  "Beverly",
  "Fitchburg",
  "Danvers",
  "Northampton",
  "Westfield",
  "Westborough",
  "Andover",
  "New York",
  "San Francisco",
  "Houston",
  "Dallas",
  "San Diego",
  "Denver",
  "Orlando",
  "Detroit",
  "Tampa",
  "Indianapolis",
  "Salt Lake City",
  "Sacramento",
  "Kansas City",
  "Pittsburgh",
  "Anchorage",
  "Richmond",
  "New Orleans",
  "Baltimore",
  "Columbus",
  "St. Louis",
  "Milwaukee",
  "Louisville",
  "Cleveland",
  "Minneapolis",
  "Raleigh",
  "Charlotte",
  "Portland",
  "Nashville",
  "Birmingham",
  "Madison",
  "Tucson",
  "Fort Worth",
  "Boulder",
  "Grand Rapids",
  "Little Rock",
  "Shreveport",
  "Montgomery",
  "Boise",
  "Jacksonville",
  "Lincoln",
  "Toledo",
  "Tulsa",
  "Fargo",
  "Des Moines",
  "Billings",
  "Macon",
  "Wichita",
  "Davenport",
  "Bakersfield",
  "Lexington",
  "Huntsville",
  "Sioux Falls",
  "Duluth",
  "Evansville",
  "Fort Wayne",
  "Chattanooga",
  "Spokane",
  "Lafayette",
  "Augusta",
  "Jackson",
  "Rockford",
  "Omaha",
  "Charleston",
  "Vancouver",
  "Fort Collins",
  "Charleston",
  "Albuquerque",
  "Rochester",
  "Bismarck",
  "Asheville",
  "Boise",
  "Myrtle Beach",
  "Salem",
  "Santa Fe",
  "Pocatello",
  "Flagstaff",
  "Joplin",
  "Cedar Rapids",
  "Evansville",
  "Rapid City",
  "Montpelier",
  "Hartford",
  "Pueblo",
  "Muskogee",
  "Bloomington",
  "Champaign",
  "Ithaca",
  "Lexington",
  "Cincinnati",
  "Chico",
  "Ann Arbor",
  "Traverse City",
  "Plymouth",
  "Tallahassee",
  "Medford",
  "Waterloo",
  "Abilene",
  "Burlington",
  "Frankfort",
  "Peoria",
  "Carmel",
  "Indianapolis",
  "Lafayette",
  "Augusta",
  "Manchester",
  "St. Paul",
  "Davenport",
  "Rapid City",
  "Bowling Green",
  "Abington",
  "Adams",
  "Amesbury",
  "Amherst",
  "Andover",
  "Arlington",
  "Athol",
  "Attleboro",
  "Barnstable",
  "Bedford",
  "Beverly",
  "Boston",
  "Bourne",
  "Braintree",
  "Brockton",
  "Brookline",
  "Cambridge",
  "Canton",
  "Charlestown",
  "Chelmsford",
  "Chelsea",
  "Chicopee",
  "Clinton",
  "Cohasset",
  "Concord",
  "Danvers",
  "Dartmouth",
  "Dedham",
  "Dennis",
  "Duxbury",
  "Eastham",
  "Edgartown",
  "Everett",
  "Fairhaven",
  "Fall River",
  "Falmouth",
  "Fitchburg",
  "Framingham",
  "Gloucester",
  "Great Barrington",
  "Greenfield",
  "Groton",
  "Harwich",
  "Haverhill",
  "Hingham",
  "Holyoke",
  "Hyannis",
  "Ipswich",
  "Lawrence",
  "Lenox",
  "Leominster",
  "Lexington",
  "Lowell",
  "Ludlow",
  "Lynn",
  "Malden",
  "Marblehead",
  "Marlborough",
  "Medford",
  "Milton",
  "Nahant",
  "Natick",
  "New Bedford",
  "Newburyport",
  "Newton",
  "North Adams",
  "Northampton",
  "Norton",
  "Norwood",
  "Peabody",
  "Pittsfield",
  "Plymouth",
  "Provincetown",
  "Quincy",
  "Randolph",
  "Revere",
  "Salem",
  "Sandwich",
  "Saugus",
  "Somerville",
  "South Hadley",
  "Springfield",
  "Stockbridge",
  "Stoughton",
  "Sturbridge",
  "Sudbury",
  "Taunton",
  "Tewksbury",
  "Truro",
  "Watertown",
  "Webster",
  "Wellesley",
  "Wellfleet",
  "West Bridgewater",
  "West Springfield",
  "Westfield",
  "Weymouth",
  "Whitman",
  "Williamstown",
  "Woburn",
  "Woods Hole",
  "Worcester",
  "Alabama",
  "Alaska",
  "Arizona",
  "Arkansas",
  "California",
  "Colorado",
  "Connecticut",
  "Delaware",
  "Florida",
  "Georgia",
  "Hawaii",
  "Idaho",
  "Illinois",
  "Indiana",
  "Iowa",
  "Kansas",
  "Kentucky",
  "Louisiana",
  "Maine",
  "Maryland",
  "Massachusetts",
  "Michigan",
  "Minnesota",
  "Mississippi",
  "Missouri",
  "Montana",
  "Nebraska",
  "Nevada",
  "New Hampshire",
  "New Jersey",
  "New Mexico",
  "New York",
  "North Carolina",
  "North Dakota",
  "Ohio",
  "Oklahoma",
  "Oregon",
  "Pennsylvania",
  "Rhode Island",
  "South Carolina",
  "South Dakota",
  "Tennessee",
  "Texas",
  "Utah",
  "Vermont",
  "Virginia",
  "Washington",
  "West Virginia",
  "Wisconsin",
  "Wyoming",
  "District of Columbia"
];
