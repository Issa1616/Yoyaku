import 'package:flutter/material.dart';
import '../models/instructor_model.dart';

class InstructorCard extends StatelessWidget {
  final InstructorModel instructor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const InstructorCard({
    super.key,
    required this.instructor,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(instructor.name),
        subtitle: Text(instructor.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
