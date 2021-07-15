import 'dart:convert';

class PeopleModel{
  final String name, height, mass, hairColor, skinColor, gender;
  PeopleModel({
    required this.name,
    required this.height,
    required this.mass,
    required this.hairColor,
    required this.skinColor,
    required this.gender
  });

  List<PeopleModel> dataFromJson(String str) =>
      List<PeopleModel>.from(json.decode(str).map((x) => PeopleModel.fromMap(x)));

  factory PeopleModel.fromMap(Map<String, dynamic> json) => PeopleModel(
    name: json["name"],
    height: json["height"],
    mass: json["mass"],
    hairColor: json["hair_color"],
    skinColor: json["skin_color"],
    gender: json["gender"],
  );
}