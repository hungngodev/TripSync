// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_search_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindSearchParameters _$FindSearchParametersFromJson(Map json) =>
    FindSearchParameters(
      searchQuery: json['searchQuery'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      language: $enumDecodeNullable(_$LanguagesEnumMap, json['language']),
    );

Map<String, dynamic> _$FindSearchParametersToJson(
        FindSearchParameters instance) =>
    <String, dynamic>{
      'searchQuery': instance.searchQuery,
      'phone': instance.phone,
      'address': instance.address,
      'language': _$LanguagesEnumMap[instance.language],
    };

const _$LanguagesEnumMap = {
  Languages.en: 'en',
};
