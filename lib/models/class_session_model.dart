class ClassSessionModel {
  final int? id;
  final int classId;
  final String instructorId;
  final DateTime sessionDate;
  final String startTime;
  final String endTime;
  final int cupoMax;

  ClassSessionModel({
    this.id,
    required this.classId,
    required this.instructorId,
    required this.sessionDate,
    required this.startTime,
    required this.endTime,
    required this.cupoMax,
  });

  Map<String, dynamic> toMap() {
    return {
      'class_id': classId,
      'instructor_id': instructorId,
      'session_date': sessionDate.toIso8601String().split('T')[0],
      'start_time': startTime,
      'end_time': endTime,
      'cupo_max': cupoMax,
    };
  }

  factory ClassSessionModel.fromMap(Map<String, dynamic> json) {
    return ClassSessionModel(
      id: json['id'],
      classId: json['class_id'],
      instructorId: json['instructor_id'],
      sessionDate: DateTime.parse(json['session_date']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      cupoMax: json['cupo_max'] ?? 0,
    );
  }
}
