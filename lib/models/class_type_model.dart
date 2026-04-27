class ClassTypeModel {
  final int id;
  final String name;
  final String description;

  ClassTypeModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory ClassTypeModel.fromMap(Map<String, dynamic> map) {
    return ClassTypeModel(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? '',
    );
  }
}
