// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PlaceModel _$$_PlaceModelFromJson(Map<String, dynamic> json) =>
    _$_PlaceModel(
      lat: (json['lat'] as num?)?.toDouble() ?? 0,
      long: (json['long'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$_PlaceModelToJson(_$_PlaceModel instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'long': instance.long,
    };
