class AdminUserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? businessName;

  AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.businessName,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['roles']?['name'] ?? 'user',
      businessName:
          json['business'] != null && (json['business'] as List).isNotEmpty
          ? json['business'][0]['name']
          : null,
    );
  }
}
