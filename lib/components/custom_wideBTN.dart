import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomWideBTN extends StatelessWidget {
  const CustomWideBTN({required this.text, required this.onPressed, super.key});

  final VoidCallback onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Text(
          text
        ),
      ),
    );
  }
}
