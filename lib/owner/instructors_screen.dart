import 'package:flutter/material.dart';
import '../../widgets/header_yoyaku.dart';
import '../../widgets/instructor_card.dart';
import '../../services/instructor_service.dart';
import '../../services/business_service.dart';
import '../../models/instructor_model.dart';

class Instructors extends StatefulWidget {
  const Instructors({super.key});

  @override
  State<Instructors> createState() => _InstructorsState();
}

class _InstructorsState extends State<Instructors> {
  final service = InstructorService();
  final businessService = BusinessService();

  List<InstructorModel> list = [];
  bool loading = true;

  int? businessId;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setState(() => loading = true);

    businessId = await businessService.getMyBusinessId();

    if (!mounted) return;

    if (businessId == null) {
      setState(() => loading = false);
      return;
    }

    await loadInstructors();
  }

  Future<void> loadInstructors() async {
    if (businessId == null) return;

    setState(() => loading = true);

    try {
      final data = await service.getInstructors(businessId!);

      if (!mounted) return;

      setState(() {
        list = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cargando instructores: $e")),
      );
    }
  }

  void showInviteInstructor() {
    final email = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Invitar Instructor",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            TextField(
              controller: email,
              decoration: const InputDecoration(
                labelText: "Correo del usuario",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              child: const Text("Invitar"),
              onPressed: () async {
                if (businessId == null) return;

                try {
                  await service.inviteInstructor(email.text, businessId!);

                  if (!mounted) return;
                  Navigator.pop(context);

                  await loadInstructors();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invitación enviada")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteInstructor(String id) async {
    if (businessId == null) return;

    await service.removeInstructor(id, businessId!);
    await loadInstructors();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (businessId == null) {
      return const Scaffold(
        body: Center(child: Text("No tienes un negocio creado")),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const YoyakuHeader(),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Instructores",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 32),
                  onPressed: showInviteInstructor,
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (list.isEmpty)
              const Center(child: Text("No hay instructores aceptados aún")),

            ...list.map(
              (i) => InstructorCard(
                instructor: i,
                onEdit: () {},
                onDelete: () => deleteInstructor(i.id),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
