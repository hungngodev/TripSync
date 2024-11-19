import 'package:flutter/material.dart';

class CustomInputForm extends StatelessWidget {
  final TextEditingController? controller;
  final IconData icon;
  final String label;
  final String hint;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final VoidCallback? onTap;
  final bool? readOnly;
  const CustomInputForm(
      {super.key,
      required this.icon,
      required this.label,
      required this.hint,
      this.obscureText,
      this.keyboardType,
      this.maxLines,
      this.onTap,
      this.readOnly,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly ?? false,
      onTap: onTap,
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
      maxLines: maxLines ?? 1,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey[500],
          fontWeight: FontWeight.w600,
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey[500],
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.black,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
    );
  }
}