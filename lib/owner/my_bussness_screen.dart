import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/header_yoyaku.dart';
import '../../services/my_business_service.dart';

class MyBusiness extends StatefulWidget {
  const MyBusiness({super.key});

  @override
  State<MyBusiness> createState() => _MyBusinessState();
}

class _MyBusinessState extends State<MyBusiness> {
  final service = BusinessService();

  Map<String, dynamic>? business;
  bool loading = true;
  bool editing = false;

  final name = TextEditingController();
  final location = TextEditingController();

  File? imageFile;
  String? photoUrl;

  @override
  void initState() {
    super.initState();
    loadBusiness();
  }

  Future<void> loadBusiness() async {
    setState(() => loading = true);

    final data = await service.getMyBusiness();

    name.text = data['name'] ?? '';
    location.text = data['ubicacion'] ?? '';
    photoUrl = data['photo'];

    setState(() {
      business = data;
      loading = false;
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    setState(() {
      imageFile = File(picked.path);
    });
  }

  Future<void> save() async {
    String? photo = photoUrl;

    if (imageFile != null) {
      photo = await service.uploadBusinessPhoto(imageFile!);
    }

    await service.updateBusiness(name.text, location.text, photo);

    setState(() => editing = false);

    await loadBusiness();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Negocio actualizado")));
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
                  "Mi Negocio",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                IconButton(
                  icon: Icon(editing ? Icons.close : Icons.edit),
                  onPressed: () {
                    setState(() => editing = !editing);
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            Center(
              child: GestureDetector(
                onTap: editing ? pickImage : null,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: imageFile != null
                      ? FileImage(imageFile!)
                      : (photoUrl != null ? NetworkImage(photoUrl!) : null),
                  child: (photoUrl == null && imageFile == null)
                      ? const Icon(Icons.store, size: 50)
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: name,
              enabled: editing,
              decoration: const InputDecoration(
                labelText: "Nombre del negocio",
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: location,
              enabled: editing,
              decoration: const InputDecoration(labelText: "Ubicación"),
            ),

            const SizedBox(height: 30),

            if (editing)
              ElevatedButton(
                onPressed: save,
                child: const Text("Guardar cambios"),
              ),
          ],
        ),
      ),
    );
  }
}
