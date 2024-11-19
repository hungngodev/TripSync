// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_place_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchPlaceResult _$SearchPlaceResultFromJson(Map json) => SearchPlaceResult(
      json['location_id'] as String,
      json['name'] as String,
      json['distance'] as String?,
      json['rating'] as String?,
      json['bearing'] as String?,
      ExtendedAddressObject.fromJson(
          Map<String, dynamic>.from(json['address_obj'] as Map)),
    );

Map<String, dynamic> _$SearchPlaceResultToJson(SearchPlaceResult instance) =>
    <String, dynamic>{
      'location_id': instance.locationId,
      'name': instance.name,
      'distance': instance.distance,
      'rating': instance.rating,
      'bearing': instance.bearing,
      'address_obj': instance.addressObj.toJson(),
    };
