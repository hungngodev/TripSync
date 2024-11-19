import 'package:json_annotation/json_annotation.dart';
import './extended_address_object.dart';

part 'search_place_result.g.dart';

@JsonSerializable()
class SearchPlaceResult {
  @JsonKey(name: "location_id")
  final String locationId;
  final String name;
  final String? distance;
  final String? rating;
  final String? bearing;
  @JsonKey(name: "address_obj")
  final ExtendedAddressObject addressObj;

  SearchPlaceResult(this.locationId, this.name, this.distance, this.rating,
      this.bearing, this.addressObj);

  factory SearchPlaceResult.fromJson(Map<String, dynamic> json) =>
      _$SearchPlaceResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchPlaceResultToJson(this);
}