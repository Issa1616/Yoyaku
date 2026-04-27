import 'package:flutter/material.dart';
import '../../widgets/class_type_card.dart';
import '../../widgets/header_yoyaku.dart';
import '../../services/class_type_service.dart';
import '../../models/class_type_model.dart';

class OwnerHome extends StatefulWidget {
  const OwnerHome({super.key});

  @override
  State<OwnerHome> createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  final service = ClassTypeService();

  List<ClassTypeModel> list = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadClassTypes();
  }

  Future<void> loadClassTypes() async {
    setState(() => loading = true);

    final data = await service.getClassTypes();

    setState(() {
      list = data;
      loading = false;
    });
  }

  void showAddClassType() {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
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
                "Nuevo tipo de clase",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nombre"),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: "Descripción"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                child: const Text("Guardar"),
                onPressed: () async {
                  await service.createClassType(
                    nameController.text,
                    descController.text,
                  );

                  Navigator.pop(context);

                  await loadClassTypes();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Tipo de clase creado")),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void openEditDialog(ClassTypeModel type) {
    final nameController = TextEditingController(text: type.name);
    final descController = TextEditingController(text: type.description);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
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
                "Editar tipo de clase",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nombre"),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: "Descripción"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                child: const Text("Actualizar"),
                onPressed: () async {
                  await service.updateClassType(
                    type.id,
                    nameController.text,
                    descController.text,
                  );

                  Navigator.pop(context);

                  await loadClassTypes();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Tipo actualizado")),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> confirmarEliminacion(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirmar eliminación"),
            content: const Text("¿Seguro que deseas eliminar este registro?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Eliminar"),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> deleteClass(int id) async {
    await service.deleteClassType(id);

    await loadClassTypes();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Tipo de clase eliminado")));
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
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
                  "Tipos de clase",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 32),
                  onPressed: showAddClassType,
                ),
              ],
            ),

            const SizedBox(height: 20),

            ...list.map(
              (c) => ClassTypeCard(
                classType: c,
                onEdit: () => openEditDialog(c),
                onDelete: () async {
                  final confirmar = await confirmarEliminacion(context);

                  if (confirmar) {
                    await deleteClass(c.id);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
