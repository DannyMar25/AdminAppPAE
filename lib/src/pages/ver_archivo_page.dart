import 'package:aministrador_app_v1/src/models/evidencia_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class VerArchivoEvidenciaPage extends StatefulWidget {
  const VerArchivoEvidenciaPage({Key? key}) : super(key: key);

  @override
  State<VerArchivoEvidenciaPage> createState() =>
      _VerArchivoEvidenciaPageState();
}

class _VerArchivoEvidenciaPageState extends State<VerArchivoEvidenciaPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  EvidenciasModel evidenciaA = new EvidenciasModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Object? evidenciaData = ModalRoute.of(context)!.settings.arguments;
    if (evidenciaData != null) {
      evidenciaA = evidenciaData as EvidenciasModel;
      print(evidenciaA.id);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Archivo"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        evidenciaA.archivoUrl,
        key: _pdfViewerKey,
      ),
    );
  }
}