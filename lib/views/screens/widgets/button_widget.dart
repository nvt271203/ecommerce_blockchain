import 'package:flutter/material.dart';
class ButtonWidget extends StatelessWidget {
  const ButtonWidget({super.key, required this.onClick, required this.title, required this.icon, required this.colorTitle, required this.colorBackground,});
  final VoidCallback onClick;
  final String title;
  final IconData icon;
  final Color colorTitle;
  final Color colorBackground;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onClick();
      },
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding xung quanh text và icon
        decoration: BoxDecoration(
          color: colorBackground, // Màu nền
          borderRadius: BorderRadius.circular(30), // Bo tròn góc
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(title,
                style: TextStyle(color: colorTitle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
