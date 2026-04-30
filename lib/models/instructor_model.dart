class InstructorModel {
  final String id;
  final String name;
  final String email;

  InstructorModel({required this.id, required this.name, required this.email});

  factory InstructorModel.fromMap(Map<String, dynamic> map) {
    return InstructorModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
}
