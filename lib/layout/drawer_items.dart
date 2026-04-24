import 'package:flutter/material.dart';

class DrawerItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  DrawerItem({required this.title, required this.icon, required this.onTap});
}
