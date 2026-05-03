import 'package:flutter/material.dart';
import '../../services/class_service.dart';
import 'create_class_screen.dart';
import '../../widgets/header_yoyaku.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final service = ClassService();

  List classes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadClasses();
  }

  Future<void> loadClasses() async {
    final data = await service.getClasses();

    setState(() {
      classes = data;
      loading = false;
    });
  }

  Future<void> openCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateClassScreen()),
    );

    if (result == true) {
      loadClasses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openCreate,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const YoyakuHeader(),

                  const SizedBox(height: 20),

                  const Text(
                    "Clases",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  ...classes.map((c) {
                    return Card(
                      child: ListTile(
                        title: Text(c['class_types']?['name'] ?? "Sin tipo"),
                        subtitle: Text(
                          "Instructor: ${c['users']?['name'] ?? ''}",
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await service.deleteClass(c['id']);
                            loadClasses();
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ),
      ),
    );
  }
}
