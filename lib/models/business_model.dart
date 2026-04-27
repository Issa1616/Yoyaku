class BusinessModel {
  final int id;
  final String name;
  final String? ubicacion;
  final String? photo;
  final String? ownerId;

  BusinessModel({
    required this.id,
    required this.name,
    this.ubicacion,
    this.photo,
    this.ownerId,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'],
      name: json['name'],
      ubicacion: json['ubicacion'],
      photo: json['photo'],
      ownerId: json['owner_id'],
    );
  }
}
