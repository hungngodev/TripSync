import 'package:flutter/material.dart';
import 'package:flutter_application/find_search/models/search_response.dart';
import 'package:flutter_application/pages/Calendars.dart';
import 'package:flutter_application/pages/createcalendar.dart';
import '../find_search/models/api_settings.dart';
import '../trip_advisor_api.dart';
import 'package:flutter_application/ui_components/input_form.dart';
import '../find_search/find_search_parameters.dart';
import '../services/openai/gpt_service.dart';
import '../util/keyword.dart';
//

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
  
}

class _Home extends State<Home> {
  TextEditingController locationController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController keywordController = TextEditingController();

  late Future<SearchResponse> incomingLocations;

  @override
  void initState(){
    super.initState();

    ApiSettings settingsAPI = ApiSettings(apiKey: "90BF3C202F524AE78E666BEBD6F43CD6");
    TripAdvisorApi tripAdvisorApi = TripAdvisorApi(settingsAPI);
    FindSearchParameters findSearchParameters = FindSearchParameters(searchQuery: "Massachusetts");
    incomingLocations = tripAdvisorApi.findSearch.get(findSearchParameters);
  }

  String? response;

  List locations = ["Amherst, MA", "Los Angeles, CA"];
  List keywords = ["outdoor", "museum"];
  final activities = List.generate(50, (i)=> i);

  void addLocation() {
    String location = locationController.text;
    String state = stateController.text;
    if (location.isNotEmpty && state.isNotEmpty) {
      setState(() {
        locations.add("$location, $state");
      });
    }
  }

  void deleteLocation(int index) {
    setState(() {
      locations.removeAt(index);
    });
  }

  openCalendarPage(context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const Calendars()));
  }

  openCreateCalendarPage(context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const Createcalendar()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Traveling Suggestion',
              style: TextStyle(color: Colors.white)),
          elevation: 0,
        ),
        body: 
          SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(onPressed: (){
                openCreateCalendarPage(context);
              }, backgroundColor: Colors.blue, child: const Icon(Icons.add, color: Colors.white,)),
              // ListView.builder(
              //   scrollDirection: Axis.vertical,
              //   shrinkWrap: true,
              //   itemCount: locations.length,
              //   itemBuilder: (context, index) {
              //     return Location(
              //         location: locations[index],
              //         deleteFunction: (context) => deleteLocation(index));
              //   },
              // ),
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
                      ))),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20)),
                        backgroundColor: WidgetStateProperty.all(Colors.black)),
                    onPressed: addLocation,
                    child: const Text(
                      'Add Location',
                      style: TextStyle(color: Colors.white),
                    )),
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
                            deleteFunction: () => deleteKeyword(index));
                      })),
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
                      ))),
              ElevatedButton(
                  style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20)),
                      backgroundColor: WidgetStateProperty.all(Colors.black)),
                  onPressed: addKeyword,
                  child: const Text(
                    'Add Keywords',
                    style: TextStyle(color: Colors.white),
                  )),
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child: Text(
                      response ?? "",
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 70, vertical: 20)),
                        backgroundColor: WidgetStateProperty.all(Colors.black)),
                    onPressed: () async {
                      String places = locations.join(',');
                      String keys = keywords.join(',');
                      String message =
                          "Could you suggest a place that is in the middle of these locations: $places to go on a holiday for a group of friends, taking into account these keywords: $keys ?Also include some destinations to visit at the suggested place.";
                      response = await GPTService().request(message);
                      setState(() {});
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
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
