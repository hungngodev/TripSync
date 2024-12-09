import 'dart:math';
import 'dart:async';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../../bloc/authentication_bloc.dart';
import '../../bloc/authentication_state.dart';
import '../../services/django/api_service.dart';
import '../../util/calendar-popup.dart';

class SearchPage extends StatefulWidget {
  final String calendarId;
  SearchPage({this.calendarId = '', Key? key}) : super(key: key);
  @override
  State<SearchPage> createState() => _Home();
}

class Item {
  Item(this.name, this.id);
  String name;
  String id;
  @override
  String toString() => name;
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
  late final Debounceable<List<Suggestion>?, String> _debouncedSearch;
  late Iterable<Widget> _lastOptions = <Widget>[];
  late List<Item> _items = <Item>[
    Item(
      '1',
      '1',
    )
  ];
  String currentCalendar = '1';

  @override
  void initState() {
    super.initState();
    _debouncedSearch = debounce<List<Suggestion>?, String>(_search);
    fetchInfo();
  }

  Future<List<Suggestion>?> _search(String query) async {
    // In a real application, there should be some error handling here.
    final data = await apiService.getAutoComplete(query);
    final List<Suggestion> options = data
        .map((e) => Suggestion(
              e,
              e,
            ))
        .toList();
    return options;
  }

  @override
  void dispose() {
    // Dispose the controller to avoid memory leaks
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchInfo() async {
    final List<dynamic> calendarNames = await apiService.getCalendars();
    setState(() {
      _items = calendarNames
          .map((event) => Item(event['name'], event['id']))
          .toList();
      currentCalendar =
          widget.calendarId != '' ? widget.calendarId : _items.first.id;
    });
    await fetchSelectedActivities();
  }

  Future<void> fetchSelectedActivities() async {
    try {
      // Fetch the list of chosen activities from the API
      List<Map<String, dynamic>> activities =
          await apiService.getChosenList(currentCalendar);

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
      const materialBanner = MaterialBanner(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        backgroundColor: Colors.transparent,
        forceActionsBelow: true,
        content: AwesomeSnackbarContent(
          title: 'Oh No!!',
          message: 'Please enter a keyword to add to your holiday search!',

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.warning,
          // to configure for material banner
          inMaterialBanner: true,
        ),
        actions: const [SizedBox.shrink()],
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentMaterialBanner()
        ..showMaterialBanner(materialBanner);
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
        'calendar': int.parse(currentCalendar),
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
      const snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Great!',
          message: 'The activity has been added to your list successfully!',

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else {
      // Optionally show a message that the activity is already added
      const snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Snap!',
          message: 'The activity is already in your list!',

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.help,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
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
    final categories = _filters.where((e) => original.contains(e)).toList();
    final category = categories.isNotEmpty ? categories[0] : '';
    print("Category: $category");
    final search = _searchController.text;
    print("Search: $search");
    final query =
        _filters.where((e) => !original.contains(e)).toList().join(',');
    print("Query: $query");
    final String filter =
        _filters.map((e) => e.toString().split('.').last).join(',');
    print("Filter by: $filter");
    try {
      List<dynamic> fetchData = await apiService.getData(
        queryParameters: {
          'location': _selectedItem,
          'category': category,
          'search': search,
          'query': query,
        },
      );
      print(fetchData);
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
          'Search Page',
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
                                        title: Text(
                                          ' Details',
                                          style: GoogleFonts.getFont('Roboto',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Title
                                              Row(
                                                children: [
                                                  const Icon(Icons.title,
                                                      color: Colors.blue),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: Text(
                                                      activity['title']!,
                                                      style:
                                                          GoogleFonts.getFont(
                                                        'Playfair Display',
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Divider(height: 20),

                                              // Location
                                              Row(
                                                children: [
                                                  const Icon(Icons.location_on,
                                                      color: Colors.red),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: Text(
                                                      "${activity['location']}",
                                                      style:
                                                          GoogleFonts.getFont(
                                                        'Lora',
                                                        fontSize: 16,
                                                        color: Colors.grey[800],
                                                      ),
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),

                                              // Address
                                              Row(
                                                children: [
                                                  const Icon(Icons.home,
                                                      color: Colors.green),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: Text(
                                                      "${activity['address']}",
                                                      style:
                                                          GoogleFonts.getFont(
                                                        'Lora',
                                                        fontSize: 16,
                                                        color: Colors.grey[800],
                                                      ),
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),

                                              Row(
                                                children: [
                                                  Icon(
                                                      activity['category'] ==
                                                              'restaurant'
                                                          ? Icons.restaurant
                                                          : activity['category'] ==
                                                                  'hotel'
                                                              ? Icons.hotel
                                                              : Icons
                                                                  .local_activity,
                                                      color: Colors.black),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                      "${activity['category']}",
                                                      style:
                                                          GoogleFonts.getFont(
                                                        'Lora',
                                                        fontSize: 16,
                                                        color: Colors.grey[800],
                                                      ),
                                                      softWrap: true,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ],
                                              ),
                                              const SizedBox(height: 10),

                                              // Source Link
                                              Row(
                                                children: [
                                                  const Icon(Icons.link,
                                                      color: Colors.blue),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: GestureDetector(
                                                      onTap: () => _launchURL(
                                                          activity[
                                                              'source_link']!),
                                                      child: Text(
                                                        activity[
                                                            'source_link']!,
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontSize: 14,
                                                          color: Colors.blue,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        ),
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Divider(height: 20),
                                              // Description
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Icon(Icons.description,
                                                      color: Colors.amber),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: Text(
                                                      "${activity['description']}",
                                                      style: GoogleFonts.nunito(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                      ),
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                ],
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
                                            child: Text(
                                              'Close',
                                              style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
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
            }),
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
                  CustomDropdown<Item>(
                    hintText: 'Select job role',
                    items: _items,
                    initialItem: _items.firstWhere(
                      (item) => item.id == currentCalendar,
                      orElse: () => _items[
                          0], // Optionally, handle the case where no item is found
                    ),
                    onChanged: (value) {
                      setState(() {
                        currentCalendar = value!.id;
                      });
                      fetchSelectedActivities();
                    },
                  ),
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
                        onChanged: (String value) {
                          print("Changed: $value");
                        },
                        leading: const Icon(Icons.search),
                        trailing: <Widget>[
                          Tooltip(
                            message: 'Search',
                            child: IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {
                                setState(() {
                                  _selectedItem = controller
                                      .text; // Treat the current text as selected
                                });
                                search();
                              },
                            ),
                          )
                        ],
                      );
                    },
                    suggestionsBuilder: (BuildContext context,
                        SearchController controller) async {
                      // final List<Suggestion>? options =
                      //     (await _debouncedSearch(controller.text))?.toList();
                      // if (options == null) {
                      //   return _lastOptions;
                      // }
                      final options = [];
                      _lastOptions =
                          List<Widget>.generate(options.length, (int index) {
                        return ListTile(
                          title: Text(options[index].description),
                          onTap: () {
                            setState(() {
                              _selectedItem = options[index]
                                  .description; // Update state when an item is selected
                            });
                            controller.closeView(options[index].description);
                            search();
                          },
                        );
                      });
                      return _lastOptions;
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
                              if (selected && original.contains(exercise)) {
                                final index = _filters.where((e) {
                                  return original.contains(e);
                                }).toList();
                                if (index.isNotEmpty) _filters.remove(index[0]);
                              }
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

typedef Debounceable<S, T> = Future<S?> Function(T parameter);
// Adjust the delay here
const Duration debounceDuration = Duration(milliseconds: 500);
Debounceable<S, T> debounce<S, T>(Debounceable<S?, T> function) {
  _DebounceTimer? debounceTimer;
  return (T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = _DebounceTimer();
    try {
      await debounceTimer!.future;
    } catch (error) {
      if (error is _CancelException) {
        return null;
      }
      rethrow;
    }
    return function(parameter);
  };
}

class _DebounceTimer {
  _DebounceTimer() {
    _timer = Timer(debounceDuration, _onComplete);
  }
  late final Timer _timer;
  final Completer<void> _completer = Completer<void>();
  void _onComplete() {
    _completer.complete();
  }

  Future<void> get future => _completer.future;
  bool get isCompleted => _completer.isCompleted;
  void cancel() {
    _timer.cancel();
    _completer.completeError(const _CancelException());
  }
}

class _CancelException implements Exception {
  const _CancelException();
}

class Suggestion {
  final String placeId;
  final String description;
  const Suggestion(this.placeId, this.description);
}
