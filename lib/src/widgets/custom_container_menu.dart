import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Color color1;
  final Color color2;
  final IconData icon;
  final String text;
  final double fontSize;
  final VoidCallback onTap;

  const CustomContainer({
    super.key,
    required this.color1,
    required this.icon,
    required this.text,
    required this.fontSize,
    required this.onTap, required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Maneja la acción al hacer clic
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1,color2 ],
          ),
          borderRadius: BorderRadius.circular(
                                  10.0),
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
