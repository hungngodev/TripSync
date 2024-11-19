// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiSettings _$ApiSettingsFromJson(Map json) => ApiSettings(
      apiKey: json['apiKey'] as String,
      language: $enumDecodeNullable(_$LanguagesEnumMap, json['language']),
    );

Map<String, dynamic> _$ApiSettingsToJson(ApiSettings instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey,
      'language': _$LanguagesEnumMap[instance.language],
    };

const _$LanguagesEnumMap = {
  Languages.en: 'en',
};
