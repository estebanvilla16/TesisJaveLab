import 'dart:io';
import 'package:flutter/material.dart';


class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Términos y Condiciones'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Términos y Condiciones de Uso de Javelab',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            buildSectionTitle('1. Introducción'),
            buildSectionText(
              'Bienvenido a Javelab, una aplicación móvil desarrollada para facilitar el estudio y el intercambio de contenido académico entre los estudiantes de la Pontificia Universidad Javeriana. Al acceder y utilizar Javelab, usted acepta estar sujeto a los siguientes términos y condiciones.',
            ),
            buildSectionTitle('2. Uso Permitido'),
            buildSectionText(
              'Usted se compromete a usar Javelab exclusivamente para fines educativos y académicos...',
            ),
            buildSectionTitle('3. Contenido en los Foros'),
            buildSectionText(
              'El contenido creado y compartido en los foros de Javelab debe estar enfocado en temas académicos y cumplir con las normativas académicas de la Pontificia Universidad Javeriana...',
            ),
            buildSectionTitle('4. Derechos de Propiedad Intelectual'),
            buildSectionText(
              'Todo el contenido generado por los usuarios en Javelab sigue siendo propiedad de sus respectivos autores, pero al compartirlo en la aplicación, usted otorga a Javelab una licencia no exclusiva, transferible, sublicenciable, libre de royalties y mundial para usar...',
            ),
            buildSectionTitle('5. Privacidad y Protección de Datos'),
            buildSectionText(
              'Javelab se compromete a proteger la privacidad y los datos personales de los usuarios de acuerdo con la legislación aplicable sobre protección de datos...',
            ),
            buildSectionTitle('6. Modificaciones a los Términos'),
            buildSectionText(
              'Javelab se reserva el derecho de modificar estos términos y condiciones en cualquier momento. Las modificaciones entrarán en vigor inmediatamente después de su publicación en la aplicación...',
            ),
            buildSectionTitle('7. Contacto'),
            buildSectionText(
              'Si tiene preguntas o preocupaciones acerca de estos términos y condiciones, por favor contacte a [Dirección de Contacto de la Universidad o de la Aplicación].',
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget buildSectionText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16),
    );
  }
}