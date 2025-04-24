// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mission _$MissionFromJson(Map<String, dynamic> json) => Mission(
      id: json['id'] as String,
      name: json['name'] as String,
      threatLevel: json['threatLevel'] as String,
      status: json['status'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$MissionToJson(Mission instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'threatLevel': instance.threatLevel,
      'status': instance.status,
      'imageUrl': instance.imageUrl,
    };
