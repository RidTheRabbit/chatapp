import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({required this.text, required this.validate, required this.onChanged, super.key});

  final String text;
  final Function(String) onChanged;
  final String? Function(String?) validate;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(8)),
      ),
      onChanged: onChanged,
      validator: validate,
    );
  }
}
