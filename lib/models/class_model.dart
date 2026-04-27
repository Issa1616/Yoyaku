class ClassModel {
  final int id;
  final String name;
  final String date;
  final String time;
  final String instructor;

  ClassModel({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.instructor,
  });

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'],
      name: map['class_type']['name'],
      date: map['date'],
      time: map['time'],
      instructor: map['users']?['name'] ?? "Sin instructor",
    );
  }
}
