import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    'Bienvenido a la Ruta Académica',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pontificia Universidad Javeriana',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'La Ruta Académica es un módulo de aprendizaje que permite acceder a contenido de estudio alineados con los syllabus universitarios.',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildStep(
                    icon: Icons.calculate,
                    title: 'Cálculo Diferencial',
                    description: 'Explora los fundamentos del cálculo diferencial, desde límites hasta derivadas.',
                    syllabusLink: 'assets/Syllabus Cálculo Diferencial.pdf',
                  ),
                  _buildStep(
                    icon: Icons.science,
                    title: 'Física Mecánica',
                    description: 'Comprende los principios de la mecánica clásica y sus aplicaciones prácticas.',
                    syllabusLink: 'assets/Syllabus Física Mecánica.pdf',
                  ),
                  _buildStep(
                    icon: Icons.code,
                    title: 'Programación I',
                    description: 'Aprende las bases de la programación con ejercicios prácticos y proyectos.',
                    syllabusLink: 'assets/Syllabus Introducción a la Programación.pdf',
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'ruta');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Entendido'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Omitir',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    children: [
                      LinkButton(
                        text: 'Cálculo',
                        filePath: 'assets/Syllabus Cálculo Diferencial.pdf',
                      ),
                      LinkButton(
                        text: 'Física',
                        filePath: 'assets/Syllabus Física Mecánica.pdf',
                      ),
                      LinkButton(
                        text: 'Programación',
                        filePath: 'assets/Syllabus Introducción a la Programación.pdf',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({required IconData icon, required String title, required String description, required String syllabusLink}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LinkButton extends StatelessWidget {
  final String text;
  final String filePath;

  const LinkButton({required this.text, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFScreen(filePath: filePath),
          ),
        );
      },
      icon: const Icon(Icons.picture_as_pdf, color: Colors.blue),
      label: Text(
        text,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class PDFScreen extends StatelessWidget {
  final String filePath;

  const PDFScreen({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: filePath,
      ),
    );
  }
}
