// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extended_address_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExtendedAddressObject _$ExtendedAddressObjectFromJson(Map json) =>
    ExtendedAddressObject(
      json['phone'] as String?,
      json['latitude'] as num?,
      json['longitude'] as num?,
      json['street1'] as String?,
      json['street2'] as String?,
      json['city'] as String?,
      json['state'] as String?,
      json['country'] as String?,
      json['postalcode'] as String?,
      json['address_string'] as String?,
    );

Map<String, dynamic> _$ExtendedAddressObjectToJson(
        ExtendedAddressObject instance) =>
    <String, dynamic>{
      'street1': instance.street1,
      'street2': instance.street2,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'postalcode': instance.postalcode,
      'address_string': instance.addressString,
      'phone': instance.phone,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
