import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  
  final String text;
  final Function()? onPressed;

  const BotonAzul({
    super.key, 
    required this.text, 
    required this.onPressed
  });



  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0), // Bordes rectos
          ), backgroundColor: const Color(0xff2c5697),
        ),
      child:  Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );//Boton de inicio de sesion
  }
}