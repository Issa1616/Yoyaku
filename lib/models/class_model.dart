class ClassModel {
  final int id;
  final int classtypeId;
  final String instructorId;
  final int businessId;
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final String? endTime;
  final int cupoMax;
  final String? image;

  ClassModel({
    required this.id,
    required this.classtypeId,
    required this.instructorId,
    required this.businessId,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.endTime,
    required this.cupoMax,
    this.image,
  });

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'],
      classtypeId: map['classtype_id'],
      instructorId: map['instructor_id'],
      businessId: map['business_id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: DateTime.parse(map['date']),
      time: map['time'],
      endTime: map['end_time'],
      cupoMax: map['cupo_max'] ?? 0,
      image: map['image'],
    );
  }
}
