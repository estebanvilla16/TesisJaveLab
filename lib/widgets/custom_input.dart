import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
   

   final IconData icon;
   final String placeholder;
   final TextEditingController textController;
   final TextInputType keyboardType;
   final bool isPassword;

  const CustomInput({
    super.key, 
    required this.icon, 
    required this.placeholder, 
    required this.textController, 
    this.keyboardType = TextInputType.text, 
    this.isPassword = false
    });

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 5),
      margin: const EdgeInsets.only(bottom: 20),
      
      child:  TextField(
        controller: textController,
        autocorrect: false,
        keyboardType: keyboardType,

        decoration: InputDecoration(
          prefixIcon:  Icon (icon),
          hintText: placeholder,
          contentPadding:  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0), 
          ),
        ),
      )


    );
  }
}