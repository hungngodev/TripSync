// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResponse _$SearchResponseFromJson(Map json) => SearchResponse(
      data: (json['data'] as List<dynamic>?)?.map((e) =>
          SearchPlaceResult.fromJson(Map<String, dynamic>.from(e as Map))),
      error: json['error'] == null
          ? null
          : TripAdvisorError.fromJson(
              Map<String, dynamic>.from(json['error'] as Map)),
    );

Map<String, dynamic> _$SearchResponseToJson(SearchResponse instance) =>
    <String, dynamic>{
      'data': instance.data?.map((e) => e.toJson()).toList(),
      'error': instance.error?.toJson(),
    };
