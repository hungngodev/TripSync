import 'package:json_annotation/json_annotation.dart';
import './trip_advisor_error.dart';

import 'search_place_result.dart';

part 'search_response.g.dart';

@JsonSerializable()
class SearchResponse {
  final Iterable<SearchPlaceResult>? data;
  final TripAdvisorError? error;

  SearchResponse({this.data, this.error});

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseToJson(this);
}