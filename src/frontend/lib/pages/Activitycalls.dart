// import 'dart:async';
import 'dart:convert';

// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Address {
  final String address;

  const Address({
    required this.address,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(address: json['address_string']);
  }
}

class Location {
  final int locationId;
  final int name;
  final Address addressObject;

  const Location({
    required this.locationId,
    required this.name,
    required this.addressObject,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationId: json['location_id'],
      name: json['name'],
      addressObject: Address.fromJson(json['address_obj'])
    );
}
}

class LocationCalls {
  Future<List<Location>> getLocations() async {
  final response = await http
      .get(Uri.parse('https://api.content.tripadvisor.com/api/v1/location/search?key=90BF3C202F524AE78E666BEBD6F43CD6&searchQuery=New%2520York&language=en'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final data = jsonDecode(response.body);
    final List<Location> list = [];
    for (var i= 0;i < data['data'].length; i++){
      final entry = data['data'][i];
      list.add(Location.fromJson(entry));
    }
    return list;

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load location');
  }
}
}


// void main() => runApp(const MyApp());

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late Future<Album> futureAlbum;

//   @override
//   void initState() {
//     super.initState();
//     futureAlbum = fetchAlbum();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Fetch Data Example',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Fetch Data Example'),
//         ),
//         body: Center(
//           child: FutureBuilder<Album>(
//             future: futureAlbum,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return Text(snapshot.data!.title);
//               } else if (snapshot.hasError) {
//                 return Text('${snapshot.error}');
//               }

//               // By default, show a loading spinner.
//               return const CircularProgressIndicator();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }