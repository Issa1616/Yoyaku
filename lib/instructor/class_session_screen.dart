import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/class_service.dart';
import '../services/class_session_service.dart';
import '../models/class_session_model.dart';

class ClassSessionScreen extends StatefulWidget {
  final String instructorId;

  const ClassSessionScreen({super.key, required this.instructorId});

  @override
  State<ClassSessionScreen> createState() => _ClassSessionScreenState();
}

class _ClassSessionScreenState extends State<ClassSessionScreen> {
  final classService = ClassService();
  final sessionService = ClassSessionService(Supabase.instance.client);

  List<Map<String, dynamic>> classes = [];
  Map<int, List<ClassSessionModel>> sessionsByClass = {};

  int? selectedClassId;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);

    classes = await classService.getInstructorClasses(widget.instructorId);

    sessionsByClass.clear();

    for (final c in classes) {
      final sessions = await sessionService.getSessionsByClass(c['id']);

      sessionsByClass[c['id']] = sessions;
    }

    setState(() => loading = false);
  }

  Future<void> createSession(int classId) async {
    final session = ClassSessionModel(
      classId: classId,
      instructorId: widget.instructorId,
      sessionDate: DateTime.now(),
      startTime: "10:00",
      endTime: "11:00",
      cupoMax: 20,
    );

    await sessionService.createSession(session);
    await loadData();
  }

  Future<void> deleteSession(int id) async {
    await sessionService.deleteSession(id);
    await loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Sesiones"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Mis clases",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                ...classes.map((c) {
                  final isOpen = selectedClassId == c['id'];
                  final sessions = sessionsByClass[c['id']] ?? [];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        // HEADER
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.fitness_center,
                                  color: Colors.blue,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c['class_types']['name'] ?? 'Clase',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      c['description'] ?? '',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedClassId = isOpen ? null : c['id'];
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    isOpen
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // CONTENT
                        if (isOpen) ...[
                          const Divider(height: 1),

                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // BOTÓN CREAR
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => createSession(c['id']),
                                    icon: const Icon(Icons.add),
                                    label: const Text("Crear sesión"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // SESIONES
                                if (sessions.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      "No hay sesiones aún",
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  )
                                else
                                  ...sessions.map((s) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF9FAFB),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.event,
                                            color: Colors.blue,
                                          ),

                                          const SizedBox(width: 10),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  s.sessionDate
                                                      .toString()
                                                      .split(" ")[0],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "${s.startTime} - ${s.endTime}",
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap: () => deleteSession(s.id!),
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
