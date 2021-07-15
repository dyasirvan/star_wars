final String tablePeople = 'people';

class PeopleFields{
  static final String id = '_id';
  static final String name = 'name';
  static final String gender = 'gender';
}

class DbModel{
  final int? id;
  final String name, gender;

  const DbModel({
    this.id,
    required this.name,
    required this.gender
  });

  static DbModel fromJson(Map<String, Object?> json) => DbModel(
      id: json[PeopleFields.id] as int?,
      name: json[PeopleFields.name] as String,
      gender: json[PeopleFields.gender] as String,
  );

  Map<String, Object?> toJson() => {
    PeopleFields.id: id,
    PeopleFields.name: name,
    PeopleFields.gender: gender,
  };

  DbModel copy({
    int? id,
    String? name,
    String? gender,
  }) => DbModel(
    id: id ?? this.id,
    name: name ?? this.name,
    gender: gender ?? this.gender,
  );
}