import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/user_service.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final service = UserService();
  final name = TextEditingController();

  final supabase = Supabase.instance.client;

  String? imageUrl;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  /// =============================
  /// CARGAR USUARIO
  /// =============================
  Future<void> loadUser() async {
    final user = await service.getMyUser();

    if (!mounted) return;

    name.text = user['name'] ?? '';
    imageUrl = user['image'];

    setState(() => loading = false);
  }

  /// =============================
  /// PICK IMAGE
  /// =============================
  Future<void> pickImage() async {
    final user = supabase.auth.currentUser;

    /// 🔥 evita crash si ya hizo logout
    if (user == null) return;

    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    final bytes = await File(file.path).readAsBytes();

    final fileName = '${user.id}.jpg';

    await supabase.storage
        .from('avatars')
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );

    final url = supabase.storage.from('avatars').getPublicUrl(fileName);

    await service.updateImage(url);

    if (!mounted) return;

    setState(() => imageUrl = url);
  }

  /// =============================
  /// GUARDAR PERFIL
  /// =============================
  Future<void> save() async {
    await service.updateUser(name.text);

    if (mounted) Navigator.pop(context);
  }

  /// =============================
  /// LOGOUT (FORMA CORRECTA)
  /// =============================
  Future<void> logout() async {
    await supabase.auth.signOut();

    /// ❌ NO navegues manualmente
    /// AuthGate detecta el cambio solo
  }

  /// =============================
  /// UI
  /// =============================
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Editar perfil")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl!)
                    : null,
                child: imageUrl == null
                    ? const Icon(Icons.camera_alt, size: 30)
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: save, child: const Text("Guardar")),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text("Cerrar sesión"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: logout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
