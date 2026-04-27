import 'package:flutter/material.dart';
import '../models/business_model.dart';

class BusinessCard extends StatelessWidget {
  final BusinessModel business;
  final VoidCallback onDelete;

  const BusinessCard({
    super.key,
    required this.business,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        leading: business.photo != null
            ? CircleAvatar(backgroundImage: NetworkImage(business.photo!))
            : const CircleAvatar(child: Icon(Icons.store)),
        title: Text(business.name),
        subtitle: Text(business.ubicacion ?? "Sin ubicación"),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
