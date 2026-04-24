import 'package:flutter/material.dart';

class YoyakuHeader extends StatelessWidget {
  const YoyakuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "YOYAKU",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Bienvenido",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),

        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Color.fromARGB(255, 110, 179, 147),
              width: 2,
            ),
          ),
          child: const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage("assets/user.jpg"),
          ),
        ),
      ],
    );
  }
}
