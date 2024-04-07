import 'package:JaveLab/models/contenido.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ContenidoDetailScreen extends StatelessWidget {
  final Contenido contenido;
  final String pdfUrl;

  const ContenidoDetailScreen(
      {Key? key, required this.contenido, required this.pdfUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Contenido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID del Contenido: ${contenido.id_contenido}'),
            Text('Título: ${contenido.titulo}'),
            Text('ID del Syllabus: ${contenido.id_syl}'),
            Text('Descripción: ${contenido.descripcion}'),
            Text('Video: ${contenido.video}'),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(maxHeight: 500),
                  child: PDFView(
                    filePath: pdfUrl,
                    enableSwipe: true,
                    swipeHorizontal: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
