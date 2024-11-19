// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressObject _$AddressObjectFromJson(Map json) => AddressObject(
      json['street1'] as String?,
      json['street2'] as String?,
      json['city'] as String?,
      json['state'] as String?,
      json['country'] as String?,
      json['postalcode'] as String?,
      json['address_string'] as String?,
    );

Map<String, dynamic> _$AddressObjectToJson(AddressObject instance) =>
    <String, dynamic>{
      'street1': instance.street1,
      'street2': instance.street2,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'postalcode': instance.postalcode,
      'address_string': instance.addressString,
    };
