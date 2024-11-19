import 'package:json_annotation/json_annotation.dart';
import './models/languages.dart';

part 'find_search_parameters.g.dart';

/// parameters for the find search api
@JsonSerializable()
class FindSearchParameters {
  /// [searchQuery] - required
  /// Text to use for searching based on the name of the location
  final String searchQuery;

  /// [phone] - optional
  /// Phone number to filter the search results by (this can be in any format with spaces and dashes but without the "+" sign at the beginning)
  final String? phone;

  /// [address] - optional
  /// Address to filter the search results by
  final String? address;

  /// [language] - optional
  /// The language in which to return results (e.g. "en" for English or "es" for Spanish) from the list of our Supported Languages.
  final Languages? language;

  /// [searchQuery] - required -
  /// Text to use for searching based on the name of the location
  ///
  /// [category] - optional -
  /// Filters result set based on property type. Valid options are "hotels", "attractions", "restaurants", and "geos"
  ///
  /// [phone] - optional -
  /// Phone number to filter the search results by (this can be in any format with spaces and dashes but without the "+" sign at the beginning)
  ///
  /// [address] - optional -
  /// Address to filter the search results by
  ///
  /// [latLong] - optional -
  /// Latitude/Longitude pair to scope down the search around a specific point - eg. "42.3455,-71.10767"
  ///
  /// [radius] - optional -
  /// Length of the radius from the provided latitude/longitude pair to filter results.
  ///
  /// [radiusUnit] - optional -
  /// Unit for length of the radius. Valid options are "km", "mi", "m" (km=kilometers, mi=miles, m=meters)
  ///
  /// [language] - optional -
  /// The language in which to return results (e.g. "en" for English or "es" for Spanish) from the list of our Supported Languages.
  FindSearchParameters(
      {required this.searchQuery,
      this.phone,
      this.address,
      this.language});

  factory FindSearchParameters.fromJson(Map<String, dynamic> json) =>
      _$FindSearchParametersFromJson(json);

  Map<String, dynamic> toJson() => _$FindSearchParametersToJson(this);
}