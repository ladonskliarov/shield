// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hero.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hero _$HeroFromJson(Map<String, dynamic> json) => Hero(
      id: json['id'] as String,
      name: json['name'] as String,
      energy: (json['energy'] as num).toDouble(),
    );

Map<String, dynamic> _$HeroToJson(Hero instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'energy': instance.energy,
    };
