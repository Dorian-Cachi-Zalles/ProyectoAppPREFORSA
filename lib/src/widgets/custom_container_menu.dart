import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final double fontSize;
  final VoidCallback onTap;

  const CustomContainer({
    super.key,
    required this.color,
    required this.icon,
    required this.text,
    required this.fontSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Maneja la acción al hacer clic
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
