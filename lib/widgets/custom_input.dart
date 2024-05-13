import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;

  const CustomInput({
    Key? key,
    required this.icon,
    required this.placeholder,
    required this.textController,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 5),
      margin: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: textController,
        autocorrect: false,
        keyboardType: keyboardType,
        obscureText: isPassword, // Esta línea ocultará el texto si isPassword es true
        // Condicional para mostrar el texto como puntos solo si isPassword es true
        // Si isPassword es false, mostrará el texto normalmente
        onChanged: (text) {
          if (isPassword) {
            textController.value = textController.value.copyWith(
              text: text,
              selection: TextSelection.collapsed(offset: text.length),
            );
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: placeholder,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
