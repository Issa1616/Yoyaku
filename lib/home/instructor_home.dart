import 'package:flutter/material.dart';
import '../widgets/header_yoyaku.dart';
import '../widgets/class_card.dart';
import '../services/class_service.dart';

class InstructorHome extends StatefulWidget {
  const InstructorHome({super.key});

  @override
  State<InstructorHome> createState() => _InstructorHomeState();
}

class _InstructorHomeState extends State<InstructorHome> {
  final service = ClassService();

  List<Map<String, dynamic>> sessions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSessions();
  }

  Future<void> loadSessions() async {
    setState(() => loading = true);

    sessions = await service.getInstructorUpcomingSessions();

    setState(() => loading = false);
  }

  String formatDate(String date) {
    final d = DateTime.tryParse(date);
    if (d == null) return "";

    const days = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"];
    return days[d.weekday - 1];
  }

  String formatTime(String time) {
    if (time.isEmpty) return "";
    final parts = time.split(":");
    return "${parts[0]}:${parts[1]}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const YoyakuHeader(),

          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Próximas sesiones",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : sessions.isEmpty
                ? const Center(child: Text("No tienes sesiones próximas"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: sessions.length,
                    itemBuilder: (context, i) {
                      final s = sessions[i];

                      final classInfo = s['classes'];

                      final title =
                          classInfo?['class_types']?['name'] ?? 'Clase';

                      final location = classInfo?['business']?['name'] ?? '';

                      final image =
                          classInfo?['image'] ?? "assets/default_class.jpg";

                      final date = s['session_date'];
                      final start = s['start_time'];
                      final end = s['end_time'];

                      return ClassCard(
                        title: title,
                        time: "${formatTime(start)} - ${formatTime(end)}",
                        location: location,
                        dayLabel: formatDate(date),
                        image: image,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
