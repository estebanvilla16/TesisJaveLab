//Trabajo Realizado para proyecto de grado - JaveLab.
//Pantalla de registro de usuario

import 'dart:convert';
import 'package:JaveLab/global/enviroment.dart';
import 'package:JaveLab/helpers/mostrar_alerta.dart';
import 'package:JaveLab/models/contenido.dart';
import 'package:JaveLab/models/ruta.dart';
import 'package:JaveLab/models/syllabus.dart';
import 'package:JaveLab/models/userxmateria.dart';
import 'package:JaveLab/services/auth_service.dart';
import 'package:JaveLab/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:provider/provider.dart';
import 'package:JaveLab/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'terms_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool fisicaMecanica = false;
  bool calculoDiferencial = false;
  bool pensamientoAlgoritmico = false;

  //Temrinos y condiciones
  bool _isChecked = false;

  final gmailStmp = gmail(Environment.correoJave, Environment.passJave);

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
    final socketService = Provider.of<SocketService>( context );

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
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                      ),
                      const Text(
                        'Acepto los ',
                        style: TextStyle(fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TermsPage()));
                        },
                        child: const Text(
                          'Términos y Condiciones',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff2c5697),
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),

                  ElevatedButton(
                    onPressed: authService.autenticando
                        ? null
                        : () async {
                            if (validateForm()) {

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
                                //socketService.connect();
                                Usuario user = authService.usuario;
                                crearRuta(user);
                                sendEmail(destino: nombre, email: correo);
                                Navigator.pushReplacementNamed(
                                    context, 'login');
                                //mostrarAlerta(context, 'BIENVENIDO!', 'Registro completado con éxito. Recibirás un correo electrónico.');
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

  void crearRuta(Usuario user) async {
    String id = user.uid;
    final String urlRelacion =
        ('${Environment.academicUrl}/userxmateria/agregar');
    final String urlRuta = ('${Environment.academicUrl}/ruta/agregar');
    final String urlTema = ('${Environment.academicUrl}/tema/agregar');
    if (user.calculoDiferencial = true) {
      Map<String, dynamic> dataRel = {
        "materia": 3,
        "usuario": id,
      };
      final response = await http.post(Uri.parse(urlRelacion),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(dataRel));

      if (response.statusCode == 201) {
        UserxMateria rel = UserxMateria.fromJson(jsonDecode(response.body));
        Map<String, dynamic> dataRuta = {
          "id_user_mat": rel.id_user_mat,
        };
        final responseRutaCal = await http.post(Uri.parse(urlRuta),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(dataRuta));

        if (responseRutaCal.statusCode == 201) {
          Ruta rutaCal = Ruta.fromJson(jsonDecode(responseRutaCal.body));
          final int three = 3;
          final String sylCal =
              ('${Environment.academicUrl}/syllabus/syl/$three');
          final responseGetSyl = await http.get(Uri.parse(sylCal));
          if (responseGetSyl.statusCode == 200) {
            Syllabus sylCalculo =
                Syllabus.fromJson(jsonDecode(responseGetSyl.body));
            int sylc = sylCalculo.id_syllabus;
            final String contentCal =
                ('${Environment.academicUrl}/contenido/lista-contenidos/$sylc');
            final responseListCal = await http.get(Uri.parse(contentCal));
            if (responseListCal.statusCode == 200) {
              final List<dynamic> listData1 = jsonDecode(responseListCal.body);
              final List<Contenido> listCal =
                  listData1.map((data) => Contenido.fromJson(data)).toList();
              for (final contenido in listCal) {
                Map<String, dynamic> dataTema = {
                  "ruta": rutaCal.id_ruta,
                  "contenido": contenido.id_contenido,
                  "titulo": contenido.titulo,
                  "foto": contenido.titulo,
                  "estado": "No visto"
                };
                await http.post(Uri.parse(urlTema),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode(dataTema));
              }
            } else {
              print(
                  'Error al sacar la lista de contenidos. Código de estado: ${response.statusCode}');
              return;
            }
          } else {
            print(
                'Error al sacar el syllabus de la materia. Código de estado: ${response.statusCode}');
            return;
          }
        } else {
          print(
              'Error al crear la ruta. Código de estado: ${response.statusCode}');
          return;
        }
      } else {
        print(
            'Error al crear la relacion entre materia y estudiante. Código de estado: ${response.statusCode}');
        return;
      }
    }
    if (user.fisicaMecanica = true) {
      Map<String, dynamic> dataRel = {
        "materia": 2,
        "usuario": id,
      };
      final response = await http.post(Uri.parse(urlRelacion),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(dataRel));

      if (response.statusCode == 201) {
        UserxMateria rel1 = UserxMateria.fromJson(jsonDecode(response.body));
        Map<String, dynamic> dataRuta1 = {
          "id_user_mat": rel1.id_user_mat,
        };
        final responseRutaFis = await http.post(Uri.parse(urlRuta),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(dataRuta1));

        if (responseRutaFis.statusCode == 201) {
          Ruta rutaFis = Ruta.fromJson(jsonDecode(responseRutaFis.body));
          final int two = 2;
          final String sylFis =
              ('${Environment.academicUrl}/syllabus/syl/$two');
          final responseGetSyl = await http.get(Uri.parse(sylFis));
          if (responseGetSyl.statusCode == 200) {
            Syllabus sylFisica =
                Syllabus.fromJson(jsonDecode(responseGetSyl.body));
            int sylc = sylFisica.id_syllabus;
            final String contentFis =
                ('${Environment.academicUrl}/contenido/lista-contenidos/$sylc');
            final responseListFis = await http.get(Uri.parse(contentFis));
            if (responseListFis.statusCode == 200) {
              final List<dynamic> listData1 = jsonDecode(responseListFis.body);
              final List<Contenido> listFis =
                  listData1.map((data) => Contenido.fromJson(data)).toList();
              for (final contenido in listFis) {
                Map<String, dynamic> dataTema = {
                  "ruta": rutaFis.id_ruta,
                  "contenido": contenido.id_contenido,
                  "titulo": contenido.titulo,
                  "foto": contenido.titulo,
                  "estado": "No visto"
                };
                await http.post(Uri.parse(urlTema),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode(dataTema));
              }
            } else {
              print(
                  'Error al sacar la lista de contenidos. Código de estado: ${response.statusCode}');
              return;
            }
          } else {
            print(
                'Error al sacar el syllabus de la materia. Código de estado: ${response.statusCode}');
            return;
          }
        } else {
          print(
              'Error al crear la ruta. Código de estado: ${response.statusCode}');
          return;
        }
      } else {
        print(
            'Error al crear la relacion entre materia y estudiante. Código de estado: ${response.statusCode}');
        return;
      }
    }
    if (user.pensamientoAlgoritmico = true) {
      Map<String, dynamic> dataRel = {
        "materia": 1,
        "usuario": id,
      };
      final response = await http.post(Uri.parse(urlRelacion),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(dataRel));

      if (response.statusCode == 201) {
        UserxMateria rel = UserxMateria.fromJson(jsonDecode(response.body));
        Map<String, dynamic> dataRuta = {
          "id_user_mat": rel.id_user_mat,
        };
        final responseRutaCal = await http.post(Uri.parse(urlRuta),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(dataRuta));

        if (responseRutaCal.statusCode == 201) {
          Ruta rutaCal = Ruta.fromJson(jsonDecode(responseRutaCal.body));
          final int one = 1;
          final String sylCal =
              ('${Environment.academicUrl}/syllabus/syl/$one');
          final responseGetSyl = await http.get(Uri.parse(sylCal));
          if (responseGetSyl.statusCode == 200) {
            Syllabus sylCalculo =
                Syllabus.fromJson(jsonDecode(responseGetSyl.body));
            int sylc = sylCalculo.id_syllabus;
            final String contentCal =
                ('${Environment.academicUrl}/contenido/lista-contenidos/$sylc');
            final responseListCal = await http.get(Uri.parse(contentCal));
            if (responseListCal.statusCode == 200) {
              final List<dynamic> listData1 = jsonDecode(responseListCal.body);
              final List<Contenido> listCal =
                  listData1.map((data) => Contenido.fromJson(data)).toList();
              for (final contenido in listCal) {
                Map<String, dynamic> dataTema = {
                  "ruta": rutaCal.id_ruta,
                  "contenido": contenido.id_contenido,
                  "titulo": contenido.titulo,
                  "foto": contenido.titulo,
                  "estado": "No visto"
                };
                await http.post(Uri.parse(urlTema),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode(dataTema));
              }
            } else {
              print(
                  'Error al sacar la lista de contenidos. Código de estado: ${response.statusCode}');
              return;
            }
          } else {
            print(
                'Error al sacar el syllabus de la materia. Código de estado: ${response.statusCode}');
            return;
          }
        } else {
          print(
              'Error al crear la ruta. Código de estado: ${response.statusCode}');
          return;
        }
      } else {
        print(
            'Error al crear la relacion entre materia y estudiante. Código de estado: ${response.statusCode}');
        return;
      }
    }
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

  Future sendEmail({required String destino, required String email}) async {
    /*const serviceId = 'service_sp715lw';
    const templateId = 'template_00jlyo9';
    const userId = 'yRF6EWiTIlwKHjAGg';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'htto://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'from_name': 'Javelab',
          'to_name': destino,
          'destino': email,
          'reply_to': 'javelab2024@gmail.com',
        }
      }),
    );
    /Map<String, dynamic> templateParams = {
      'from_name': 'Javelab',
      'to_name': destino,
      'destino': email,
      'reply_to': 'javelab2024@gmail.com',
    };*/

    final message = Message()
      ..from = Address(Environment.correoJave, 'Javelab')
      ..recipients.add(email)
      ..subject = 'Registro de usuario exitoso!'
      ..text =
          'Hola ${destino}! \n Bienvenido a la plataforma Javelab. Por favor recuerda que este es un ambiente académico seguro, por lo que pedimos tu cooperación en mantener este ambiente un lugar educativo para todos. \n Disfruta de una mejor experiencia en tus estudios! ';


    try {
      final sendReport = await send(message, gmailStmp);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
    /*try {
      await EmailJS.send(
        serviceId,
        templateId,
        templateParams,
        const Options(
          publicKey: userId,
          privateKey: 'kCElAj-Rq57zCEpqhRlc2',
        ),
      );
      print('SUCCESS!');
    } catch (error) {
      print(error.toString());
    }*/
  }

}