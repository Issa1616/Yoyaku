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
  final classService = ClassService();

  List<Map<String, dynamic>> classes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadClasses();
  }

  Future<void> loadClasses() async {
    setState(() => loading = true);

    classes = await classService.getInstructorUpcomingClasses();

    setState(() => loading = false);
  }

  String formatDay(String date) {
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
                "Próximas clases",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : classes.isEmpty
                ? const Center(child: Text("No tienes clases próximas"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: classes.length,
                    itemBuilder: (context, i) {
                      final c = classes[i];

                      return Dismissible(
                        key: Key(c['id'].toString()),

                        direction: DismissDirection.endToStart,

                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),

                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Cancelar clase"),
                              content: const Text(
                                "¿Seguro que quieres cancelar esta clase?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Sí"),
                                ),
                              ],
                            ),
                          );
                        },

                        onDismissed: (direction) async {
                          await classService.cancelClass(c['id']);

                          setState(() {
                            classes.removeAt(i);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Clase cancelada")),
                          );
                        },

                        child: ClassCard(
                          title: c['class_types']?['name'] ?? 'Clase',
                          time: formatTime(c['time'] ?? ''),
                          location: c['business']?['name'] ?? 'Sin ubicación',
                          dayLabel: formatDay(c['date']),
                          image: "assets/default_class.jpg",
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
