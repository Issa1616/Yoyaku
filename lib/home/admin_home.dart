import 'package:flutter/material.dart';
import '../../widgets/header_yoyaku.dart';
import '../../widgets/business_card.dart';
import '../../services/business_service.dart';
import '../../models/business_model.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final service = BusinessService();

  List<BusinessModel> list = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadBusinesses();
  }

  Future<void> loadBusinesses() async {
    setState(() => loading = true);

    final data = await service.getAllBusinesses();

    setState(() {
      list = data;
      loading = false;
    });
  }

  Future<bool> confirmarEliminacion(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Eliminar negocio"),
            content: const Text("¿Seguro que deseas eliminar este negocio?"),
            actions: [
              TextButton(
                child: const Text("Cancelar"),
                onPressed: () => Navigator.pop(context, false),
              ),
              ElevatedButton(
                child: const Text("Eliminar"),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> deleteBusiness(int id) async {
    await service.deleteBusiness(id);

    await loadBusinesses();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Negocio eliminado")));
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
              children: const [
                Text(
                  "Negocios",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (list.isEmpty)
              const Center(child: Text("No hay negocios registrados")),

            ...list.map(
              (b) => BusinessCard(
                business: b,
                onDelete: () async {
                  final confirmar = await confirmarEliminacion(context);

                  if (confirmar) {
                    await deleteBusiness(b.id);
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
