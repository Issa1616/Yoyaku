import 'package:flutter/material.dart';
import '../../services/class_service.dart';
import '../../widgets/header_yoyaku.dart';

class CreateClassScreen extends StatefulWidget {
  const CreateClassScreen({super.key});

  @override
  State<CreateClassScreen> createState() => _CreateClassScreenState();
}

class _CreateClassScreenState extends State<CreateClassScreen> {
  final service = ClassService();

  List classTypes = [];
  List instructors = [];

  int? selectedType;
  String? selectedInstructor;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final types = await service.getClassTypes();
    final inst = await service.getInstructors();

    setState(() {
      classTypes = types;
      instructors = inst;
      loading = false;
    });
  }

  Future<void> saveClass() async {
    if (selectedType == null || selectedInstructor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona tipo e instructor")),
      );
      return;
    }

    await service.createClass(
      classTypeId: selectedType!,
      instructorId: selectedInstructor!,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Clase creada")));

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const YoyakuHeader(),

            const SizedBox(height: 20),

            const Text(
              "Crear Clase",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<int>(
              hint: const Text("Tipo Clase"),
              value: selectedType,
              items: classTypes
                  .map<DropdownMenuItem<int>>(
                    (t) => DropdownMenuItem(
                      value: t['id'],
                      child: Text(t['name']),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => selectedType = v),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              hint: const Text("Instructor"),
              value: selectedInstructor,
              items: instructors
                  .map<DropdownMenuItem<String>>(
                    (i) => DropdownMenuItem(
                      value: i['id'],
                      child: Text(i['name']),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => selectedInstructor = v),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: saveClass,
              child: const Text("Crear Clase"),
            ),
          ],
        ),
      ),
    );
  }
}
