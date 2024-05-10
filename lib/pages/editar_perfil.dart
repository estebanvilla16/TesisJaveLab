//Trabajo Realizado para proyecto de grado - JaveLab.
//Pantalla de registro de usuario

import 'dart:convert';
import 'package:JaveLab/global/enviroment.dart';
import 'package:JaveLab/helpers/mostrar_alerta.dart';
import 'package:JaveLab/services/auth_service.dart';
import 'package:JaveLab/services/socket_service.dart';
import 'package:JaveLab/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:JaveLab/models/usuario.dart';
import 'package:http/http.dart' as http;


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool fisicaMecanica = false;
  bool calculoDiferencial = false;
  bool pensamientoAlgoritmico = false;

  String nombre = '';
  String apellido = '';
  int? semestre;
  String nombreError = '';
  String apellidoError = '';
  String semestreError = '';

  @override
  Widget build(BuildContext context) {
    final usuariosService = UsuariosService();
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20.0),
              color: const Color(0xff2c5697),
              child: const Text(
                'Pontificia Universidad Javeriana',
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              color: Colors.yellow,
              child: const Text(
                'Javelab Ingenieria de sistemas',
                style: TextStyle(color: Color(0xff2c5697), fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 40), // Margen superior más grande
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              'perfil'); // Navega a la pantalla de inicio de sesión
                        },
                      ),
                      const SizedBox(
                          width: 10), // Espacio entre la flecha y el texto
                      const Text(
                        'Editar Perfil',
                        style: TextStyle(
                            fontSize: 30,
                            color: Color(0xff2c5697),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  //Datos necesarios para el registro
                  const SizedBox(height: 10),
                  buildTextField(
                      'Nombre', 'Ingrese su nombre', (value) => nombre = value,
                      errorText: nombreError),
                  const SizedBox(height: 10),
                  buildTextField('Apellido', 'Ingrese su apellido',
                      (value) => apellido = value,
                      errorText: apellidoError),
                  const SizedBox(height: 10),
                  buildDropdownField('Semestre', semestre,
                      errorText: semestreError),
                  const SizedBox(height: 10),
                  const Text('Materias de interés',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff2c5697),
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  buildCheckbox('Física Mecánica', fisicaMecanica,
                      (bool? newValue) {
                    setState(() {
                      fisicaMecanica = newValue!;
                    });
                  }),
                  buildCheckbox('Cálculo Diferencial', calculoDiferencial,
                      (bool? newValue) {
                    setState(() {
                      calculoDiferencial = newValue!;
                    });
                  }),
                  buildCheckbox(
                      'Pensamiento Algoritmico', pensamientoAlgoritmico,
                      (bool? newValue) {
                    setState(() {
                      pensamientoAlgoritmico = newValue!;
                    });
                  }),
                  const SizedBox(height: 100),

                  ElevatedButton(
                    onPressed: () async {
                      if (validateForm()) {
                        final uid =  authService.usuario.uid;
                        final resp = await usuariosService.updateUser(
                            uid,
                            nombre,
                            apellido,
                            semestre!,
                            fisicaMecanica,
                            calculoDiferencial,
                            pensamientoAlgoritmico,
                            );

                        if (resp) {
                          mostrarAlerta(context, 'Usuario actualizado',
                              'Los datos del usuario se han actualizado correctamente. \n Por favor, inicie sesión nuevamente para ver los cambios.');
                        } else {
                          mostrarAlerta(context, 'Error',
                              'No se pudo actualizar la información del usuario');
                        }
                      }
                      
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xff2c5697),
                      minimumSize: const Size(120, 40),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    //Valida que una vez este la solicitud correcta envia la informaciona  la bd y genera el registro
                    child: const Text('Confirmar edición',
                        style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, String hint, Function(String) onChanged,
      {bool obscureText = false, String? errorText}) {
    bool showError = errorText != null && errorText.isNotEmpty;
    bool isFieldNotEmpty = errorText == null || errorText.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 16, color: Colors.black)), // Black text
            const Text('*',
                style:
                    TextStyle(fontSize: 16, color: Colors.red)), // Red asterisk
          ],
        ),
        TextFormField(
          onChanged: (value) {
            setState(() {
              errorText = isFieldNotEmpty ? '' : errorText;
              onChanged(value);
            });
          },
          obscureText: obscureText,
          style: TextStyle(
              color: isFieldNotEmpty
                  ? Colors.black
                  : Colors.red), // Conditional text color
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            errorText:
                showError ? errorText : null, // Show error text conditionally
            errorStyle: const TextStyle(color: Colors.red), // Error text color
            enabledBorder: OutlineInputBorder(
              // Black border
              borderSide: BorderSide(
                  color: isFieldNotEmpty ? Colors.black : Colors.red),
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedBorder: OutlineInputBorder(
              // Black border when focused
              borderSide: BorderSide(
                  color: isFieldNotEmpty ? Colors.black : Colors.red),
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              // Red border when error
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(20.0),
            ),
            border: OutlineInputBorder(
              // Black border by default
              borderSide: BorderSide(
                  color: isFieldNotEmpty ? Colors.black : Colors.red),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ],
    );
  }


  Widget buildDropdownField(String label, int? value, {String? errorText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 16, color: Colors.black)), // Black text
            const Text('*',
                style: TextStyle(
                    fontSize: 16, color: Colors.red)), // Asterisco rojo
          ],
        ),
        DropdownButton<int>(
          value: value,
          onChanged: (value) {
            setState(() {
              semestre = value;
            });
          },
          items: List.generate(
            10,
            (index) => DropdownMenuItem<int>(
              value: index + 1,
              child: Text('Semestre ${index + 1}'),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  Widget buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Text(label,
            style: const TextStyle(
                fontSize: 16, color: Colors.black)), // Black text
      ],
    );
  }

  bool validateForm() {
    if (nombre.isEmpty ||
        apellido.isEmpty ||
        semestre == null ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Todos los campos deben estar llenos y la contraseña debe cumplir con los requisitos para registrarse en Javelab.'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        if (nombre.isEmpty) nombreError = 'Campo obligatorio';
        if (apellido.isEmpty) apellidoError = 'Campo obligatorio';
        if (semestre == null) semestreError = 'Campo obligatorio';
      });
      return false;
    }

    return true;
  }

  
}