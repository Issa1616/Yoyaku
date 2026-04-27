import 'package:flutter/material.dart';

class OwnerRequestCard extends StatelessWidget {
  final Map request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const OwnerRequestCard({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              request['business_name'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(request['ubicacion'] ?? ""),

            const SizedBox(height: 15),

            Row(
              children: [
                ElevatedButton(
                  onPressed: onApprove,
                  child: const Text("Aprobar"),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: onReject,
                  child: const Text("Rechazar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
