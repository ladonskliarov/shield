import 'package:json_annotation/json_annotation.dart';

part 'hero.g.dart';

@JsonSerializable(explicitToJson: true)
class Hero {
  final String id;
  final String name;
  final double energy;

  Hero({
    required this.id,
    required this.name,
    required this.energy,
  });

  factory Hero.fromJson(Map<String, dynamic> json) => _$HeroFromJson(json);
  Map<String, dynamic> toJson() => _$HeroToJson(this);
}
