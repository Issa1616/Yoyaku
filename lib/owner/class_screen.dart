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

  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final title = TextEditingController();
  final description = TextEditingController();
  final cupo = TextEditingController();

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

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (date != null) setState(() => selectedDate = date);
  }

  Future<void> pickStartTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (t != null) setState(() => startTime = t);
  }

  Future<void> pickEndTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (t != null) setState(() => endTime = t);
  }

  String formatTime(TimeOfDay? t) {
    if (t == null) return "";
    return "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00";
  }

  Future<void> saveClass() async {
    if (selectedType == null ||
        selectedInstructor == null ||
        selectedDate == null ||
        startTime == null ||
        endTime == null)
      return;

    await service.createClass(
      classTypeId: selectedType!,
      instructorId: selectedInstructor!,
      title: title.text,
      description: description.text,
      date: selectedDate!,
      time: formatTime(startTime),
      endTime: formatTime(endTime),
      cupo: int.parse(cupo.text),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Clase creada")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const YoyakuHeader(),

            const SizedBox(height: 30),

            const Text(
              "Nueva Clase",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: "Título"),
            ),

            TextField(
              controller: description,
              decoration: const InputDecoration(labelText: "Descripción"),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField(
              hint: const Text("Tipo de Clase"),
              value: selectedType,
              items: classTypes.map<DropdownMenuItem<int>>((t) {
                return DropdownMenuItem(value: t['id'], child: Text(t['name']));
              }).toList(),
              onChanged: (v) => setState(() => selectedType = v),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField(
              hint: const Text("Instructor"),
              value: selectedInstructor,
              items: instructors.map<DropdownMenuItem<String>>((i) {
                return DropdownMenuItem(value: i['id'], child: Text(i['name']));
              }).toList(),
              onChanged: (v) => setState(() => selectedInstructor = v),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: pickDate,
              child: Text(
                selectedDate == null
                    ? "Seleccionar Fecha"
                    : selectedDate.toString().split(" ")[0],
              ),
            ),

            ElevatedButton(
              onPressed: pickStartTime,
              child: Text(
                startTime == null ? "Hora inicio" : startTime!.format(context),
              ),
            ),

            ElevatedButton(
              onPressed: pickEndTime,
              child: Text(
                endTime == null ? "Hora fin" : endTime!.format(context),
              ),
            ),

            TextField(
              controller: cupo,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Cupo máximo"),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: saveClass,
              child: const Text("Guardar Clase"),
            ),
          ],
        ),
      ),
    );
  }
}
