import 'package:flutter/material.dart';
import '../services/openai/gpt_service.dart';
import '../util/keyword.dart';
import './/util/location.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  TextEditingController locationController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController keywordController = TextEditingController();

  String? response;

  List locations = ["Amherst, MA", "Los Angeles, CA"];
  List keywords = ["outdoor","museum"];

  void addLocation(){
    String location = locationController.text;
    String state = stateController.text;
    if(location.isNotEmpty && state.isNotEmpty){
      setState(() {
        locations.add(location + ", " + state);
      });
    }
  }

  void deleteLocation(int index){
    setState(() {
      locations.removeAt(index);
    });
  }

  void addKeyword(){
    String keyword = keywordController.text;
    if (keyword.isNotEmpty){
      setState(() {
        keywords.add(keyword);
      });
    }
  }

  void deleteKeyword(int index){
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
        title : const Text(
          'Traveling Suggestion',
          style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child:
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  return Location(location : locations[index], deleteFunction: (context) => deleteLocation(index));
                },
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: EdgeInsets.all(24),
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
                  )
                )
              ),

              Padding(
                padding : const EdgeInsets.all(20.0),
                child : ElevatedButton(
                  style: ButtonStyle(padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 40, vertical: 20)), backgroundColor:MaterialStateProperty.all(Colors.black)),
                  onPressed: addLocation,
                  child: const Text(
                    'Add Location',
                    style: TextStyle(color: Colors.white),
                )),
              ),
              
              SizedBox(
                height: 110,
                child : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: keywords.length,
                  itemBuilder: (context, index) {
                    return Keyword(keyword: keywords[index], deleteFunction: () => deleteKeyword(index));
                  }
                )
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: EdgeInsets.all(24),
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
                  )
                )
              ),

              ElevatedButton(
                style: ButtonStyle(padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 40, vertical: 20)), backgroundColor:MaterialStateProperty.all(Colors.black)),
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
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )
              ),  

              Padding(
                padding :const EdgeInsets.all(20.0),
                child : ElevatedButton(
                    style: ButtonStyle(padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 70, vertical: 20)), backgroundColor: MaterialStateProperty.all(Colors.black)),
                    onPressed: () async {
                      String places = locations.join(',');
                      String keys = keywords.join(',');
                      String message = "Could you suggest a place that is in the middle of these locations: " + places + " to go on a holiday for a group of friends, taking into account these keywords: " + keys + " ?" +  "Also include some destinations to visit at the suggested place.";
                      response = await GPTService().request(message);
                      setState(() {});
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                ),
              )

            ],
          ),
      )
    );
  }
}