//Trabajo Realizado para proyecto de grado - JaveLab.
//Pantalla de registro de usuario

import 'package:JaveLab/helpers/mostrar_alerta.dart';
import 'package:JaveLab/services/auth_service.dart';
import 'package:JaveLab/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool fisicaMecanica = false;
  bool calculoDiferencial = false;
  bool pensamientoAlgoritmico = false;

  String nombre = '';
  String apellido = '';
  String correo = '';
  String contrasena = '';
  String validarContrasena = '';
  int? semestre;
  String correoError = '';
  String contrasenaError = '';
  String confirmarContrasenaError = '';
  bool contrasenaValida = false;
  bool contrasenaMinLength = false;
  bool contrasenaUppercase = false;
  bool contrasenaDigit = false;
  String nombreError = '';
  String apellidoError = '';
  String semestreError = '';

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

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
                              'login'); // Navega a la pantalla de inicio de sesión
                        },
                      ),
                      const SizedBox(
                          width: 10), // Espacio entre la flecha y el texto
                      const Text(
                        'Crear Cuenta',
                        style: TextStyle(
                            fontSize: 30,
                            color: Color(0xff2c5697),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Center(
                    child: Text(
                      '¿Ya está registrado? Inicie sesión',
                      style: TextStyle(fontSize: 16, color: Color(0xff2c5697)),
                      textAlign: TextAlign.center,
                    ),
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
                  buildEmailField(),
                  const SizedBox(height: 10),
                  buildPasswordField(),
                  buildPasswordFieldValidation(),
                  buildTextField(
                      'Validar Contraseña',
                      'Vuelva a ingresar su contraseña',
                      (value) => validarContrasena = value,
                      obscureText: true,
                      errorText: confirmarContrasenaError),
                  buildConfirmarContrasenaValidation(),
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: authService.autenticando
                        ? null
                        : () async {
                            if (validateForm()) {
                              print(nombre);
                              print(apellido);
                              print(correo);
                              print(contrasena);
                              print(semestre);
                              print(fisicaMecanica);
                              print(calculoDiferencial);
                              print(pensamientoAlgoritmico);

                              final registroOk = await authService.register(
                                  nombre,
                                  apellido,
                                  correo,
                                  contrasena,
                                  semestre!,
                                  fisicaMecanica,
                                  calculoDiferencial,
                                  pensamientoAlgoritmico);

                              if (registroOk == true) {
                                socketService.connect();

                                //mostrarAlerta(context, 'BIENVENIDO!', 'Registro completado con éxito. Recibirás un correo electrónico.');
                                Navigator.pushReplacementNamed(
                                    context, 'inicio');
                              } else {
                                mostrarAlerta(
                                    context, 'Registro Incorrecto', registroOk);
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
                    child: const Text('Registrarse',
                        style: TextStyle(fontSize: 18)),
                  ),
                  if (correoError.isNotEmpty ||
                      contrasenaError.isNotEmpty ||
                      confirmarContrasenaError.isNotEmpty ||
                      semestreError.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        //mensaje de validacion de datos
                        'Todos los campos deben estar llenos para registrarse en Javelab.',
                        style: TextStyle(color: Colors.red),
                      ),
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

  Widget buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Correo Electrónico*',
            style: TextStyle(fontSize: 16, color: Colors.black)),
        TextFormField(
          onChanged: (value) {
            setState(() {
              correo = value;
              validateEmail(); //funcion que valida que contenga @javeriana.edu.co
            });
          },
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            hintText: 'ejemplo@javeriana.edu.co',
            hintStyle: const TextStyle(color: Colors.grey),
            errorText: correoError.isNotEmpty ? correoError : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          children: [
            Text('Contraseña',
                style:
                    TextStyle(fontSize: 16, color: Colors.black)), // Black text
            Text('*',
                style: TextStyle(
                    fontSize: 16, color: Colors.red)), // Asterisco rojo
          ],
        ),
        TextFormField(
          onChanged: (value) {
            setState(() {
              contrasena = value;
              validatePassword();
            });
          },
          obscureText: true,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            hintText: 'Ingresa contraseña',
            hintStyle: const TextStyle(color: Colors.grey),
            errorText: contrasenaError.isNotEmpty ? contrasenaError : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPasswordFieldValidation() {
    if (contrasena.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(
                    contrasenaMinLength
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: contrasenaMinLength ? Colors.green : Colors.red),
                const SizedBox(width: 5),
                Text(
                  'Mínimo 8 caracteres',
                  style: TextStyle(
                      color: contrasenaMinLength ? Colors.green : Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(
                    contrasenaUppercase
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: contrasenaUppercase ? Colors.green : Colors.red),
                const SizedBox(width: 5),
                Text(
                  'Al menos 1 mayúscula',
                  style: TextStyle(
                      color: contrasenaUppercase ? Colors.green : Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(
                    contrasenaDigit
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: contrasenaDigit ? Colors.green : Colors.red),
                const SizedBox(width: 5),
                Text(
                  'Al menos 1 número',
                  style: TextStyle(
                      color: contrasenaDigit ? Colors.green : Colors.red),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildConfirmarContrasenaValidation() {
    if (validarContrasena.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(
                    contrasena == validarContrasena
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: contrasena == validarContrasena
                        ? Colors.green
                        : Colors.red),
                const SizedBox(width: 5),
                Text(
                  contrasena == validarContrasena
                      ? 'Contraseña válida'
                      : 'Las contraseñas no coinciden',
                  style: TextStyle(
                      color: contrasena == validarContrasena
                          ? Colors.green
                          : Colors.red),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
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
        correo.isEmpty ||
        contrasena.isEmpty ||
        validarContrasena.isEmpty ||
        semestre == null ||
        !contrasenaValida) {
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
        if (correo.isEmpty) correoError = 'Campo obligatorio';
        if (contrasena.isEmpty) contrasenaError = 'Campo obligatorio';
        if (validarContrasena.isEmpty)
          confirmarContrasenaError = 'Campo obligatorio';
        if (semestre == null) semestreError = 'Campo obligatorio';
      });
      return false;
    }

    return true;
  }

  void validateEmail() {
    if (!correo.contains('@javeriana.edu.co')) {
      setState(() {
        correoError = 'Indique que el correo debe contener @javeriana.edu.co';
      });
    } else {
      setState(() {
        correoError = '';
      });
    }
  }

  void validatePassword() {
    contrasenaMinLength = contrasena.length >= 8;
    contrasenaUppercase = contrasena.contains(RegExp(r'[A-Z]'));
    contrasenaDigit = contrasena.contains(RegExp(r'[0-9]'));

    if (contrasenaMinLength && contrasenaUppercase && contrasenaDigit) {
      setState(() {
        contrasenaValida = true;
        contrasenaError = '';
      });
    } else {
      setState(() {
        contrasenaValida = false;
        contrasenaError = 'Contraseña no cumple con los requisitos';
      });
    }
  }
}
