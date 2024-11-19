/// This library lets you communicate with trip advisor content api with flutter
library trip_advisor_api;

import 'find_search/models/api_settings.dart';
import 'find_search/find_search.dart';
import 'find_search/find_search_parameters.dart';

import 'find_search/models/address_object.dart';
import 'find_search/models/languages.dart';


/// The Trip Advisor API is a service that return info from trip advisor
///
/// You can use it to search nearby places, search by text and get location details, photos and reviews
class TripAdvisorApi {
  /// [_settings] settings file for common settings which will probably be the same for all searches
  /// Language can be overridden
  final ApiSettings _settings;

  /// [findSearch]  object to communicate with the find search api
  late FindSearch findSearch;

  TripAdvisorApi(this._settings) {
    findSearch = FindSearch(_settings);
  }
}

// // import 'dart:async';
// import 'dart:convert';

// // import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class Address {
//   final String address;

//   const Address({
//     required this.address,
//   });

//   factory Address.fromJson(Map<String, dynamic> json) {
//     return Address(address: json['address_string']);
//   }
// }

// class Location {
//   final int locationId;
//   final int name;
//   final Address addressObject;

//   const Location({
//     required this.locationId,
//     required this.name,
//     required this.addressObject,
//   });

//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       locationId: json['location_id'],
//       name: json['name'],
//       addressObject: Address.fromJson(json['address_obj'])
//     );
// }
// }

// class LocationCalls {
//   Future<List<Location>> getLocations() async {
//   final response = await http
//       .get(Uri.parse('https://api.content.tripadvisor.com/api/v1/location/search?key=90BF3C202F524AE78E666BEBD6F43CD6&searchQuery=New%2520York&language=en'));

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     final data = jsonDecode(response.body);
//     final List<Location> list = [];
//     for (var i= 0;i < data['data'].length; i++){
//       final entry = data['data'][i];
//       list.add(Location.fromJson(entry));
//     }
//     return list;

//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load location');
//   }
// }
// }
