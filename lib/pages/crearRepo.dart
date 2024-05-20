import 'package:JaveLab/widgets/bottom_menu.dart';
import 'package:JaveLab/widgets/burgermenu.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CreateRepositoryScreen extends StatefulWidget {
  @override
  _CreateRepositoryScreenState createState() => _CreateRepositoryScreenState();
}

class _CreateRepositoryScreenState extends State<CreateRepositoryScreen> {
  String? _selectedSubject;
  String? _selectedFileType;
  String? _filePath;
  final _commentController = TextEditingController();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'mp4', 'png'],
    );
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Repositorio'),
      ),
      bottomNavigationBar: const BottomMenu(),
      endDrawer: const BurgerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              Text('Materia', style: TextStyle(fontSize: 18)),
              DropdownButtonFormField<String>(
                items: [
                  DropdownMenuItem(value: 'Cálculo Diferencial', child: Text('Cálculo Diferencial')),
                  DropdownMenuItem(value: 'Física Mecánica', child: Text('Física Mecánica')),
                  DropdownMenuItem(value: 'Programación 1', child: Text('Programación 1')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text('Tipo de Archivo', style: TextStyle(fontSize: 18)),
              DropdownButtonFormField<String>(
                items: [
                  DropdownMenuItem(value: 'Parcial', child: Text('Parcial')),
                  DropdownMenuItem(value: 'Taller', child: Text('Taller')),
                  DropdownMenuItem(value: 'Proyecto', child: Text('Proyecto')),
                  DropdownMenuItem(value: 'Actividad', child: Text('Actividad')),
                  DropdownMenuItem(value: 'Nota', child: Text('Nota')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedFileType = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text('Comentario', style: TextStyle(fontSize: 18)),
              TextFormField(
                controller: _commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text('Subir Archivo', style: TextStyle(fontSize: 18)),
              ElevatedButton.icon(
                icon: Icon(Icons.upload_file),
                label: Text('Seleccionar Archivo'),
                onPressed: _pickFile,
              ),
              if (_filePath != null) ...[
                SizedBox(height: 8),
                Text('Archivo: ${_filePath!.split('/').last}'),
              ],
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  child: Text('Crear Repositorio'),
                  onPressed: () {
                    // Aquí iría la lógica para guardar el repositorio
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
