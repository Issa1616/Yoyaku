import 'package:flutter/material.dart';
import '../../widgets/class_card.dart';
import '../../widgets/header_yoyaku.dart';

class InstructorHome extends StatelessWidget {
  const InstructorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: const [
            YoyakuHeader(),

            SizedBox(height: 30),

            Text(
              "Próximas clases",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),

            SizedBox(height: 20),

            ClassCard(
              title: "Pilates Mat",
              time: "09:00 AM",
              location: "LUMAR",
              dayLabel: "HOY",
              image: "../assets/pilatesmat.jpg",
            ),
            ClassCard(
              title: "Hit and Jump",
              time: "11:00 AM",
              location: "LUMAR",
              dayLabel: "HOY",
              image: "../assets/hitandjump.jpg",
            ),
            ClassCard(
              title: "Upper and Abs",
              time: "5:00 PM",
              location: "LUMAR",
              dayLabel: "HOY",
              image: "../assets/upperandabs.jpg",
            ),
            ClassCard(
              title: "Pilates Flow",
              time: "7:00 PM",
              location: "LUMAR",
              dayLabel: "HOY",
              image: "../assets/pilatesflow.jpg",
            ),
          ],
        ),
      ),
    );
  }
}
