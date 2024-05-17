import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zefyrka/zefyrka.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:JaveLab/models/usuario.dart';
import 'package:JaveLab/services/auth_service.dart';
import 'package:JaveLab/pages/foro.dart';
import '../global/enviroment.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class Cara8 extends StatefulWidget {
  const Cara8({Key? key}) : super(key: key);

  @override
  _Cara8State createState() => _Cara8State();
}

class _Cara8State extends State<Cara8> {
  TextEditingController tituloController = TextEditingController();
  TextEditingController etiquetasController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  ZefyrController _zefyrController = ZefyrController(NotusDocument());
  FocusNode _focusNode = FocusNode();
  File? _file;
  String categoriaSeleccionada = "Programación";
  bool _isPublishing = false;
  late Usuario user;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    user = authService.usuario;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nuevo Post'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                children: [
                  Text(
                    'Título',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' *',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Material(
                child: TextField(
                  controller: tituloController,
                  decoration: const InputDecoration(
                    hintText: 'Título de tu Post',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Row(
                children: [
                  Text(
                    'Categoria',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' *',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: categoriaSeleccionada,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Programación',
                    child: Text('Programación'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Física Mecánica',
                    child: Text('Física Mecánica'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Cálculo Diferencial',
                    child: Text('Cálculo Diferencial'),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    categoriaSeleccionada = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Etiquetas',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Material(
                child: TextField(
                  controller: etiquetasController,
                  decoration: const InputDecoration(
                    hintText: 'Agrega etiquetas (separadas por comas)',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Row(
                children: [
                  Text(
                    'Contenido del post',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' *',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Container(
                height: 200,
                child: ZefyrEditor(
                  controller: _zefyrController,
                  focusNode: _focusNode,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 100),
              ZefyrToolbar.basic(controller: _zefyrController),
              const SizedBox(height: 24.0),
              const Row(
                children: [
                  Text(
                    'Adjunte un URL de un video si desea.',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' *',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Material(
                child: TextField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    hintText: 'URL de youtube',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    String? filePath = result.files.single.path;
                    if (filePath != null) {
                      setState(() {
                        _file = File(filePath);
                      });
                    }
                  }
                },
                child: const Text('Adjuntar Archivo'),
              ),
              if (_file != null)
                ListTile(
                  title: Text('Archivo Adjunto: ${_file!.path}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _file = null;
                      });
                    },
                  ),
                ),
              if (_isPublishing)
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Publicando...', style: TextStyle(fontSize: 16)),
                  ],
                )
              else
                const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _publicarPost(
                          tituloController,
                          etiquetasController,
                          _zefyrController,
                          categoriaSeleccionada,
                          user,
                          _file,
                          urlController);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2c5697),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                    child: const Text(
                      'Publicar',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'foro');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF2c5697)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Color(0xFF2c5697),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getFileNameWithId(String filePath, int id) {
    String fileName =
        path.basename(filePath); // Obtiene el nombre del archivo con extensión
    String extension =
        path.extension(fileName); // Obtiene la extensión del archivo
    String fileNameWithoutExtension = path.basenameWithoutExtension(
        fileName); // Obtiene el nombre del archivo sin extensión

    // Concatena el nombre del archivo sin extensión, el ID y la extensión
    return '$fileNameWithoutExtension - $id$extension';
  }

  Future<void> _uploadFile(File file, int id) async {
    try {
      String fileName = getFileNameWithId(file.path, id);
      final url = '${Environment.blobUrl}/api/blob/upload/foro';
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Crea un nuevo archivo con el nombre modificado
      var modifiedFile = http.MultipartFile(
        'file',
        file.openRead(),
        file.lengthSync(),
        filename: fileName, // Usa el nuevo nombre del archivo
      );

      // Agrega el archivo modificado a la solicitud
      request.files.add(modifiedFile);

      // Envía la solicitud y espera la respuesta
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Archivo subido exitosamente');
        _modificarPost(fileName, id);
        // Aquí puedes manejar la lógica después de subir el archivo
      } else {
        print(
            'Error al subir el archivo. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _modificarPost(String nuevoMaterial, int id) async {
    final String url = ('${Environment.foroUrl}/post/actualizar/$id');

    Map<String, dynamic> data = {
      "material": nuevoMaterial,
    };

    print(data);

    final response = await http.put(Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));

    if (response.statusCode == 200) {
      print('Post modificado: ${response.body}');
    } else {
      print(
          'Error al modificar el post. Código de estado: ${response.statusCode}');
    }
  }

  void _publicarPost(
      TextEditingController tituloController,
      TextEditingController etiquetasController,
      ZefyrController _zefyrController,
      String categoriaSeleccionada,
      Usuario user,
      File? file,
      TextEditingController urlController) async {
    setState(() {
      _isPublishing = true;
    });

    String userId = user.uid;
    String nombreCompleto = '${user.nombre} ${user.apellido}';
    final String url = ('${Environment.foroUrl}/post/agregar');

    String formattedDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());
    int etiqueta = _asignarValorCategoria(categoriaSeleccionada);

    Map<String, dynamic> data = {
      "id_op": userId,
      "etiqueta": etiqueta,
      "titulo": tituloController.text,
      "contenido": jsonEncode(_zefyrController.document.toPlainText()),
      "material": 'null',
      "video": urlController.text,
      "valoracion": 0,
      "fecha": formattedDate,
      "nombre": nombreCompleto,
      "tags": etiquetasController.text
    };

    await Future.delayed(const Duration(seconds: 3));
    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));

    if (response.statusCode == 201) {
      print('Post publicado: ${response.body}');
      int postId = jsonDecode(response.body)['id_post'];
      if (_file != null) {
        await _uploadFile(_file!, postId);
      }
      // Mostrar la notificación
      _mostrarNotificacion('Post creado');
      // Redirigir a la pantalla Cara6 después de mostrar la notificación
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Cara6()),
      );
    } else {
      print(
          'Error al publicar el post. Código de estado: ${response.statusCode}');
    }

    setState(() {
      _isPublishing = false;
    });
  }

  void _mostrarNotificacion(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  int _asignarValorCategoria(String? categoria) {
    switch (categoria) {
      case 'Programación':
        return 1;
      case 'Física Mecánica':
        return 3;
      case 'Cálculo Diferencial':
        return 2;
      default:
        return 0;
    }
  }
}
