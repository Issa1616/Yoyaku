class OwnerModel {
  final String id;
  final String name;
  final String email;

  OwnerModel({required this.id, required this.name, required this.email});

  factory OwnerModel.fromMap(Map data) {
    return OwnerModel(
      id: data['id'],
      name: data['name'] ?? '',
      email: data['email'] ?? '',
    );
  }
}
