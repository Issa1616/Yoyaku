import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../edit_profile.dart';

class YoyakuHeader extends StatefulWidget {
  const YoyakuHeader({super.key});

  @override
  State<YoyakuHeader> createState() => _YoyakuHeaderState();
}

class _YoyakuHeaderState extends State<YoyakuHeader> {
  final service = UserService();

  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final data = await service.getMyUser();
    setState(() => user = data);
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const SizedBox();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Bienvenido a "),
            Text(
              "Yoyaku",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditProfile()),
            );

            loadUser(); // refrescar header
          },
          child: CircleAvatar(
            radius: 26,
            backgroundImage: user!['image'] != null
                ? NetworkImage(user!['image'])
                : null,
            child: user!['image'] == null ? const Icon(Icons.person) : null,
          ),
        ),
      ],
    );
  }
}
