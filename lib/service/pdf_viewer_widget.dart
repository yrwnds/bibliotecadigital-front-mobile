import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class LocalPdfViewer extends StatelessWidget {

  final String targetPath;

  const LocalPdfViewer({Key? key, required this.targetPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Viewer"),
      ),
      body: PDFView(
        filePath: targetPath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onError: (error) {
          debugPrint("Erro renderizando PDF: ${error.toString()}");
        },
        onPageError: (page, error) {
          debugPrint("Erro na pág. $page: ${error.toString()}");
        },
      ),
    );
  }
}