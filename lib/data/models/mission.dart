import 'package:json_annotation/json_annotation.dart';

part 'mission.g.dart';

@JsonSerializable()
class Mission {
  final String id;
  final String name;
  final String threatLevel;
  final String status;
  final String imageUrl;

  Mission({
    required this.id,
    required this.name,
    required this.threatLevel,
    required this.status,
    required this.imageUrl,
  });

  factory Mission.fromJson(Map<String, dynamic> json) => _$MissionFromJson(json);
  Map<String, dynamic> toJson() => _$MissionToJson(this);
}
