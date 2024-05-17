import 'package:flutter/material.dart';

class ForumOnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 60),
            const Text(
              'Bienvenido al Foro Académico',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            const Text(
                'Pontificia Universidad Javeriana',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

             

            SizedBox(height: 5),
            const Text(
              'El Foro es un módulo de Javelab diseñado para facilitar el estudio colaborativo, permitiendo que toda la comunidad comparta conocimientos, dudas y materiales necesarios de manera efectiva.',
              style: TextStyle(
                fontSize: 15,
               
              ),
            ),

            const SizedBox(height: 40),
            _buildStep(
              icon: Icons.chat_bubble_outline,
              title: 'Participa en Discusiones',
              description: 'Únete a discusiones sobre temas académicos y comparte tus opiniones.',
            ),
            _buildStep(
              icon: Icons.attach_file,
              title: 'Comparte Material',
              description: 'Sube y descarga materiales de estudio relevantes para tus cursos.',
            ),
            _buildStep(
              icon: Icons.question_answer,
              title: 'Resuelve Dudas',
              description: 'Haz preguntas y recibe respuestas de tus compañeros y profesores.',
            ),
            _buildStep(
              icon: Icons.group,
              title: 'Crea Comunidad',
              description: 'Conéctate con otros estudiantes y profesores para aprender juntos.',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'foro');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text('Entendido'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                
              },
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Omitir',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ),

            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({required IconData icon, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
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
