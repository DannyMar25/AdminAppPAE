import 'dart:io';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:aministrador_app_v1/src/models/formulario_datosPersonales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_domicilio_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_principal_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_relacionAnimal_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_situacionFam_model.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
import 'package:aministrador_app_v1/src/providers/formularios_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class SolicitudesMainPage extends StatefulWidget {
  const SolicitudesMainPage({Key? key}) : super(key: key);

  @override
  State<SolicitudesMainPage> createState() => _SolicitudesMainPageState();
}

class _SolicitudesMainPageState extends State<SolicitudesMainPage> {
  FormulariosProvider formulariosProvider = new FormulariosProvider();
  FormulariosModel formularios = new FormulariosModel();
  DatosPersonalesModel datosC = new DatosPersonalesModel();
  SitFamiliarModel situacionF = new SitFamiliarModel();
  DomicilioModel domicilio = new DomicilioModel();
  RelacionAnimalesModel relacionA = new RelacionAnimalesModel();
  final userProvider = new UsuarioProvider();
  File? foto;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Object? formulariosData = ModalRoute.of(context)!.settings.arguments;
    if (formulariosData != null) {
      formularios = formulariosData as FormulariosModel;
      print(formularios.id);
    }
    cargarInfo();
    return Scaffold(
      backgroundColor: Color.fromARGB(248, 234, 235, 233),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Datos de la solicitud"),
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              icon: Icon(Icons.account_circle),
              itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      child: Text("Soporte"),
                      value: 0,
                    ),
                    PopupMenuItem<int>(
                      child: Text("Cerrar Sesión"),
                      value: 1,
                    )
                  ]),
        ],
      ),
      drawer: MenuWidget(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Posible adoptante para:",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Padding(padding: EdgeInsets.only(bottom: 7.0)),
                _mostrarFoto(),
                _mostrarNombreAn(),
                _mostrarFecha(),
                Divider(
                  color: Colors.transparent,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.0),
                              child: _botonDatosPer(),
                            ),
                            Text('Datos\nPersonales'),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.0),
                              child: _botonSituacionFam(),
                            ),
                            Text('Situación\nFamiliar')
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.0),
                              child: _botonDomicilio(),
                            ),
                            Text('Domicilio\n')
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.0),
                              child: _botonRelacionAnim(),
                            ),
                            Text('Relación con\nlos animales')
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                //_botonPDF(),
                Divider(
                  color: Colors.transparent,
                ),
                Padding(padding: EdgeInsets.only(bottom: 12.0)),

                _crearBotonPDF(),
                Divider(
                  color: Colors.transparent,
                ),
                Padding(padding: EdgeInsets.only(bottom: 12.0)),
                _crearBotonObservaciones()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.pushNamed(context, 'soporte');
        break;
      case 1:
        userProvider.signOut();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
      //Navigator.pushNamed(context, 'login');
    }
  }

  showCitas1() async {
    datosC = await formulariosProvider.cargarDPId(
        formularios.id, formularios.idDatosPersonales);
    //setState(() {
    return datosC;
  }

  cargarInfo() async {
    datosC = await formulariosProvider.cargarDPId(
        formularios.id, formularios.idDatosPersonales);
    situacionF = await formulariosProvider.cargarSFId(
        formularios.id, formularios.idSituacionFam);
    domicilio = await formulariosProvider.cargarDomId(
        formularios.id, formularios.idDomicilio);
    relacionA = await formulariosProvider.cargarRAId(
        formularios.id, formularios.idRelacionAn);
  }

  Widget _mostrarFecha() {
    DateTime fechaIngresoT = DateTime.parse(formularios.fechaIngreso);
    String fechaIn = fechaIngresoT.year.toString() +
        '-' +
        fechaIngresoT.month.toString() +
        '-' +
        fechaIngresoT.day.toString();
    // ' ' +
    // fechaIngresoT.hour.toString() +
    // ':' +
    // fechaIngresoT.minute.toString();
    return TextFormField(
      readOnly: true,
      initialValue: fechaIn,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Fecha de solicitud:',
        //labelStyle: ,
        //border: BorderRadius(BorderRadius.circular(2.0)),
        icon: Icon(
          Icons.date_range_outlined,
          color: Colors.purple,
        ),
      ),
      //onSaved: (value) => animal.nombre = value!,
      //},
    );
  }

  // Widget _crearNombreClient() {
  //   return TextFormField(
  //     readOnly: true,
  //     initialValue: formularios.nombreClient,
  //     textCapitalization: TextCapitalization.sentences,
  //     decoration: InputDecoration(
  //       labelText: 'Nombre',
  //       //labelStyle: ,
  //       //border: BorderRadius(BorderRadius.circular(2.0)),
  //       icon: Icon(
  //         Icons.person,
  //         color: Colors.purple,
  //       ),
  //     ),
  //     //onSaved: (value) => animal.nombre = value!,
  //     //},
  //   );
  // }

  Widget _mostrarNombreAn() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        textAlign: TextAlign.center,
        readOnly: true,
        initialValue: formularios.animal!.nombre,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _mostrarFoto() {
    if (formularios.animal!.fotoUrl != '') {
      return FadeInImage(
        image: NetworkImage(formularios.animal!.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 270.0, //300
        width: 270.0,
        fit: BoxFit.contain,
      );
    } else {
      if (foto != null) {
        return Image.file(
          foto!,
          fit: BoxFit.cover,
          height: 270.0,
          width: 270.0,
        );
      }
      return Image.asset(foto?.path ?? 'assets/no-image.png');
    }
  }

  Widget _botonDatosPer() {
    return Ink(
        decoration: BoxDecoration(
            //backgroundBlendMode: ,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Colors.purple[600],
            boxShadow: [
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          icon: Icon(
            Icons.person,
          ),
          iconSize: 65,
          color: Colors.purple[300],
          onPressed: () async {
            datosC = await formulariosProvider.cargarDPId(
                formularios.id, formularios.idDatosPersonales);
            situacionF = await formulariosProvider.cargarSFId(
                formularios.id, formularios.idSituacionFam);
            domicilio = await formulariosProvider.cargarDomId(
                formularios.id, formularios.idDomicilio);
            relacionA = await formulariosProvider.cargarRAId(
                formularios.id, formularios.idRelacionAn);
            Navigator.pushNamed(context, 'datosPersonales', arguments: {
              'datosper': datosC,
              'sitfam': situacionF,
              'domicilio': domicilio,
              'formulario': formularios,
              'relacionAn': relacionA
            });
          },
        ));
  }

  Widget _botonSituacionFam() {
    return Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Color.fromARGB(255, 92, 216, 97),
            boxShadow: [
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          icon: Icon(
            Icons.people,
          ),
          iconSize: 65,
          color: Colors.orange[300],
          onPressed: () async {
            situacionF = await formulariosProvider.cargarSFId(
                formularios.id, formularios.idSituacionFam);
            domicilio = await formulariosProvider.cargarDomId(
                formularios.id, formularios.idDomicilio);
            relacionA = await formulariosProvider.cargarRAId(
                formularios.id, formularios.idRelacionAn);

            Navigator.pushNamed(context, 'situacionFam', arguments: {
              'datosper': datosC,
              'situacionF': situacionF,
              'domicilio': domicilio,
              'relacionAn': relacionA,
              'formulario': formularios
            });
          },
        ));
  }

  Widget _botonDomicilio() {
    return Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Colors.blueGrey[200],
            boxShadow: [
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          icon: Icon(
            Icons.house,
          ),
          iconSize: 65,
          color: Colors.blueGrey[700],
          onPressed: () async {
            domicilio = await formulariosProvider.cargarDomId(
                formularios.id, formularios.idDomicilio);
            relacionA = await formulariosProvider.cargarRAId(
                formularios.id, formularios.idRelacionAn);

            Navigator.pushNamed(context, 'domicilio', arguments: {
              'domicilio': domicilio,
              'relacionAn': relacionA,
              'formulario': formularios
            });
          },
        ));
  }

  Widget _botonRelacionAnim() {
    return Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Colors.lightBlue[300],
            boxShadow: [
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          icon: Icon(
            Icons.pets,
          ),
          iconSize: 65,
          color: Colors.blueAccent,
          onPressed: () async {
            relacionA = await formulariosProvider.cargarRAId(
                formularios.id, formularios.idRelacionAn);

            Navigator.pushNamed(context, 'relacionAnim', arguments: {
              'relacionAn': relacionA,
              'formulario': formularios
            });
          },
        ));
  }

  Widget _botonPDF() {
    return Ink(
        decoration: BoxDecoration(
            //backgroundBlendMode: ,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Colors.purple[600],
            boxShadow: [
              BoxShadow(
                  color: Colors.purple,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          icon: Icon(
            Icons.picture_as_pdf,
          ),
          iconSize: 100,
          color: Colors.purple[300],
          onPressed: () async {
            // Navigator.pushNamed(context, 'datosPersonales',
            //     arguments: [idForm, idD]);
            datosC = await formulariosProvider.cargarDPId(
                formularios.id, formularios.idDatosPersonales);
            situacionF = await formulariosProvider.cargarSFId(
                formularios.id, formularios.idSituacionFam);
            domicilio = await formulariosProvider.cargarDomId(
                formularios.id, formularios.idDomicilio);
            relacionA = await formulariosProvider.cargarRAId(
                formularios.id, formularios.idRelacionAn);
            Navigator.pushNamed(context, 'crearPDF', arguments: {
              'datosper': datosC,
              'sitfam': situacionF,
              'domicilio': domicilio,
              'formulario': formularios,
              'relacionAn': relacionA
            });
          },
        ));
  }

  Widget _crearBotonPDF() {
    return ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            return Colors.green;
          }),
        ),
        label: Text(
          'Generar PDF',
          style: TextStyle(fontSize: 17),
        ),
        icon: Icon(
          Icons.picture_as_pdf,
          size: 40,
        ),
        autofocus: true,
        onPressed: () async {
          _createPDF();

          // Navigator.pushNamed(context, 'crearPDF', arguments: {
          //   'datosper': datosC,
          //   'sitfam': situacionF,
          //   'domicilio': domicilio,
          //   'formulario': formularios,
          //   'relacionAn': relacionA
          // });
        });
  }

  Widget _crearBotonObservaciones() {
    return ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            return Colors.green;
          }),
        ),
        label: Text(
          'Respuesta y observaciones',
          style: TextStyle(fontSize: 17),
        ),
        icon: Icon(
          Icons.question_answer,
          size: 40,
        ),
        autofocus: true,
        onPressed: () async {
          // datosC = await formulariosProvider.cargarDPId(
          //     formularios.id, formularios.idDatosPersonales);
          // situacionF = await formulariosProvider.cargarSFId(
          //     formularios.id, formularios.idSituacionFam);
          // domicilio = await formulariosProvider.cargarDomId(
          //     formularios.id, formularios.idDomicilio);
          // relacionA = await formulariosProvider.cargarRAId(
          //     formularios.id, formularios.idRelacionAn);
          Navigator.pushNamed(context, 'observacionSolicitud',
              arguments: formularios
              //'datosper': datosC,
              // 'sitfam': situacionF,
              //'domicilio': domicilio,
              //'formulario': formularios,
              //'relacionAn': relacionA
              );
        });
  }

  Future<void> _createPDF() async {
//Create a new PDF document
    PdfDocument document = PdfDocument();

    //document.pageSettings.margins.all = 100;

//Add a page to the document
    PdfPage page = document.pages.add();
    PdfPage page1 = document.pages.add();
    PdfPage page2 = document.pages.add();

//Draw image on the page in the specified location and with required size
    page.graphics.drawImage(PdfBitmap(await _readImageData('pet-care.png')),
        Rect.fromLTWH(180, 15, 120, 100));

//Load the paragraph text into PdfTextElement with standard font
    PdfTextElement textElement = PdfTextElement(
        text:
            'El objetivo de la Fundación, es que nuestros animales vayan a casas permanentes donde sean felices y bien cuidados por el resto de sus vidas. Los animales son nuestra responsabilidad y su adopción esta a nuestra discreción. La fundación puede rechazar una solicitud de adopción sin tener necesariamente que dar una explicación. No se responsabiliza por el comportamiento adquirido por el animal luego de su adopción.',
        font: PdfStandardFont(PdfFontFamily.helvetica, 12));

//Draw the paragraph text on page and maintain the position in PdfLayoutResult
    PdfLayoutResult layoutResult = textElement.draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, 130, page.getClientSize().width, page.getClientSize().height))!;

//Assign header text to PdfTextElement
    textElement.text = 'DATOS PERSONALES';

//Assign standard font to PdfTextElement
    textElement.font =
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);

//Draw the header text on page, below the paragraph text with a height gap of 20 and maintain the position in PdfLayoutResult
    layoutResult = textElement.draw(
        page: page,
        bounds: Rect.fromLTWH(0, layoutResult.bounds.bottom + 15, 0, 0))!;

//Initialize PdfGrid for drawing the table
    //Create a PdfGrid
    PdfGrid grid = PdfGrid();

//Add the columns to the grid
    grid.columns.add(count: 2);
    grid.headers.add(1);
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = '  ';
    header.cells[1].value = 'RESPUESTA';
    header.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      //textBrush: PdfBrushes.white,
      textPen: PdfPens.black,
    );
    header.cells[1].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 90, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      //textBrush: PdfBrushes.white,
      textPen: PdfPens.black,
    );

//Add rows to grid
    PdfGridRow row1 = grid.rows.add();
    row1.cells[0].value = 'Nombre completo:';
    row1.cells[1].value = datosC.nombreCom;
    PdfGridRow row2 = grid.rows.add();
    row2.cells[0].value = 'Cédula:';
    row2.cells[1].value = datosC.cedula;
    PdfGridRow row3 = grid.rows.add();
    row3.cells[0].value = 'Dirección exacta donde estará la mascota:';
    row3.cells[1].value = datosC.direccion;
    PdfGridRow row4 = grid.rows.add();
    row4.cells[0].value = 'Ocupación:';
    row4.cells[1].value = datosC.ocupacion;
    PdfGridRow row5 = grid.rows.add();
    row5.cells[0].value = 'Fecha de nacimiento:';
    row5.cells[1].value = datosC.fechaNacimiento;
    PdfGridRow row6 = grid.rows.add();
    row6.cells[0].value = 'E-mail:';
    row6.cells[1].value = datosC.email;
    PdfGridRow row7 = grid.rows.add();
    row7.cells[0].value = 'Intrucción:';
    row7.cells[1].value = datosC.nivelInst;
    PdfGridRow row8 = grid.rows.add();
    row8.cells[0].value = 'TELÉFONOS DE CONTACTO';
    row8.cells[1].value = '';
    PdfGridRow row9 = grid.rows.add();
    row9.cells[0].value = 'Celular:';
    row9.cells[1].value = datosC.telfCel;
    PdfGridRow row10 = grid.rows.add();
    row10.cells[0].value = 'Casa:';
    row10.cells[1].value = datosC.telfDomi;
    PdfGridRow row11 = grid.rows.add();
    row11.cells[0].value = 'Trabajo:';
    row11.cells[1].value = datosC.telfTrab;
    PdfGridRow row12 = grid.rows.add();
    row12.cells[0].value = 'REFERENCIAS PERSONALES';
    row12.cells[1].value = '';
    PdfGridRow row13 = grid.rows.add();
    row13.cells[0].value = 'Nombre:';
    row13.cells[1].value = datosC.nombreRef;
    PdfGridRow row14 = grid.rows.add();
    row14.cells[0].value = 'Parentesco:';
    row14.cells[1].value = datosC.parentescoRef;
    PdfGridRow row15 = grid.rows.add();
    row15.cells[0].value = 'Teléfono:';
    row15.cells[1].value = datosC.telfRef;

    //Estilo de celdas titulo
    row1.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      //textBrush: PdfBrushes.white,
      textPen: PdfPens.black,
    );
    row2.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      //textBrush: PdfBrushes.white,
      textPen: PdfPens.black,
    );
    row3.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      //textBrush: PdfBrushes.white,
      textPen: PdfPens.black,
    );
    row4.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      //textBrush: PdfBrushes.white,
      textPen: PdfPens.black,
    );
    row5.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      //textBrush: PdfBrushes.white,
      textPen: PdfPens.black,
    );
    row6.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      //textBrush: PdfBrushes.white,
      textPen: PdfPens.black,
    );
    row7.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      //textBrush: PdfBrushes.white,
      textPen: PdfPens.black,
    );
    row8.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      //textBrush: PdfBrushes.white,
      textPen: PdfPens.black,
    );
    row9.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      //textBrush: PdfBrushes.white,
      textPen: PdfPens.black,
    );
    row10.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      //textBrush: PdfBrushes.white,
      textPen: PdfPens.black,
    );
    row11.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      //textBrush: PdfBrushes.white,
      textPen: PdfPens.black,
    );
    row12.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      //textBrush: PdfBrushes.white,
      textPen: PdfPens.black,
    );
    row13.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      //textBrush: PdfBrushes.white,
      textPen: PdfPens.black,
    );
    row14.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      //textBrush: PdfBrushes.white,
      textPen: PdfPens.black,
    );
    row15.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      //textBrush: PdfBrushes.white,
      textPen: PdfPens.black,
    );
    row1.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row2.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row3.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row4.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row5.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row6.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row7.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row8.cells[1].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row9.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row10.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row11.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row12.cells[1].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row13.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row14.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row15.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );

//Draw grid on the page of PDF document and store the grid position in PdfLayoutResult
    grid.draw(
        //page: document.pages.add(),
        page: page,
        bounds: Rect.fromLTWH(0, layoutResult.bounds.bottom + 5, 500, 500));

    textElement.text = 'SITUACIÓN FAMILIAR';
    textElement.font =
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    layoutResult = textElement.draw(
        page: page,
        bounds: Rect.fromLTWH(0, layoutResult.bounds.bottom + 280, 0, 0))!;
    textElement.text = 'Mencione las personas con las que vive:';
    textElement.font =
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    layoutResult = textElement.draw(
        page: page,
        bounds: Rect.fromLTWH(0, layoutResult.bounds.bottom + 5, 0, 0))!;

//Create a second PdfGrid in the same page
    PdfGrid grid2 = PdfGrid();

//Add columns to second grid
    grid2.columns.add(count: 3);
    grid2.headers.add(1);
    PdfGridRow header1 = grid2.headers[0];
    header1.cells[0].value = 'Nombre';
    header1.cells[1].value = 'Edad';
    header1.cells[2].value = 'Parentesco';
    header1.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    header1.cells[1].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    header1.cells[2].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );

//Add rows to grid
    PdfGridRow row21 = grid2.rows.add();
    row21.cells[0].value = situacionF.nombreFam1;
    row21.cells[1].value = situacionF.edadFam1.toString();
    row21.cells[2].value = situacionF.parentescoFam1;
    PdfGridRow row22 = grid2.rows.add();
    row22.cells[0].value = situacionF.nombreFam2;
    row22.cells[1].value = situacionF.edadFam2.toString();
    row22.cells[2].value = situacionF.parentescoFam2;
    PdfGridRow row23 = grid2.rows.add();
    row23.cells[0].value = situacionF.nombreFam3;
    row23.cells[1].value = situacionF.edadFam3.toString();
    row23.cells[2].value = situacionF.parentescoFam3;
    PdfGridRow row24 = grid2.rows.add();
    row24.cells[0].value = situacionF.nombreFam4;
    row24.cells[1].value = situacionF.edadFam4.toString();
    row24.cells[2].value = situacionF.parentescoFam4;

    //Estilo celdas
    row21.cells[0].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row21.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row21.cells[2].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row22.cells[0].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row22.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row22.cells[2].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row23.cells[0].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row23.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row23.cells[2].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row24.cells[0].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row24.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row24.cells[2].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );

//Draw the grid in PDF document page
    grid2.draw(
        //page: result.page,
        page: page,
        bounds: Rect.fromLTWH(0, layoutResult.bounds.bottom + 5, 0, 0));

    //Create a second PdfGrid in the same page
    PdfGrid grid3 = PdfGrid();

//Add columns to second grid
    grid3.columns.add(count: 2);
    grid3.headers.add(1);
    PdfGridRow header2 = grid3.headers[0];
    header2.cells[0].value = '  ';
    header2.cells[1].value = 'RESPUESTA';
    header2.cells[1].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    header2.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
//Add rows to grid
    PdfGridRow row25 = grid3.rows.add();
    row25.cells[0].value = '¿Algún familiar espera un bebe?';
    row25.cells[1].value = situacionF.esperaBebe;
    PdfGridRow row26 = grid3.rows.add();
    row26.cells[0].value =
        'Si la respuesta es "SI", ingrese fecha apróximada de parto:';
    row26.cells[1].value = 'fecha';
    PdfGridRow row27 = grid3.rows.add();
    row27.cells[0].value =
        '¿Alguien que viva con usted es alérgicco a los animales o sufre de asma?';
    row27.cells[1].value = situacionF.alergiaAnimal;
    //Estilo celdas
    row25.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row25.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row26.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row26.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row27.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row27.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );

//Draw the grid in PDF document page
    grid3.draw(
        //page: result.page,
        page: page,
        bounds: Rect.fromLTWH(0, layoutResult.bounds.bottom + 100, 0, 0));

    PdfTextElement textElement1 = PdfTextElement(
        //text:
        //    'El objetivo en la Fundación Protección Animal Ecuador, PAE, es que nuestros animales vayan a casas permanentes donde sean felices y bien cuidados por el resto de sus vidas. Los animales son responsabilidad de PAE y su adopcion esta a nuestra discreción. PAE puede rechazar una solicitud de adopción sin tener necesariamente que dar una explicación. PAE no se responsabiliza por el comportamiento adquirido por el animal luego de su adopción.',
        font: PdfStandardFont(PdfFontFamily.helvetica, 12));

    PdfLayoutResult layoutResult1 = textElement1.draw(
        page: page1,
        bounds: Rect.fromLTWH(
            0, 5, page1.getClientSize().width, page1.getClientSize().height))!;

    textElement1.text = 'DOMICILIO';
    textElement1.font =
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    layoutResult1 =
        textElement1.draw(page: page1, bounds: Rect.fromLTWH(0, 0, 0, 0))!;

    //Create a second PdfGrid in the same page
    PdfGrid grid4 = PdfGrid();

//Add columns to second grid
    grid4.columns.add(count: 2);
    grid4.headers.add(1);
    PdfGridRow header3 = grid4.headers[0];
    header3.cells[0].value = '  ';
    header3.cells[1].value = 'RESPUESTA';
    header3.cells[1].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    header3.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
//Add rows to grid
    PdfGridRow row28 = grid4.rows.add();
    row28.cells[0].value = '';
    row28.cells[1].value = '¿Qué tipo de inmueble posee?';
    PdfGridRow row29 = grid4.rows.add();
    row29.cells[0].value = 'Tipo de inmueble:';
    row29.cells[1].value = domicilio.tipoInmueble;
    PdfGridRow row30 = grid4.rows.add();
    row30.cells[0].value = 'm²';
    row30.cells[1].value = domicilio.m2.toString();
    PdfGridRow row31 = grid4.rows.add();
    row31.cells[0].value = 'El inmueble es:';
    row31.cells[1].value = domicilio.inmueble;
    PdfGridRow row32 = grid4.rows.add();
    row32.cells[0].value = '¿Planea mudarse próximamente?';
    row32.cells[1].value = domicilio.planMudanza;
    PdfGridRow row33 = grid4.rows.add();
    row33.cells[0].value =
        '¿El lugar donde pasara la mascota, tiene cerramiento?';
    row33.cells[1].value = domicilio.cerramiento;
    PdfGridRow row34 = grid4.rows.add();
    row34.cells[0].value = 'Altura en m2';
    row34.cells[1].value = domicilio.alturaC.toString();
    PdfGridRow row35 = grid4.rows.add();
    row35.cells[0].value = 'Material';
    row35.cells[1].value = domicilio.materialC;
    PdfGridRow row36 = grid4.rows.add();
    row36.cells[0].value = '';
    row36.cells[1].value =
        '¿Cuál piensa que es la mascota más adecuada para Ud.?';
    PdfGridRow row37 = grid4.rows.add();
    row37.cells[0].value = 'Sexo:';
    row37.cells[1].value = domicilio.sexoAd;
    PdfGridRow row38 = grid4.rows.add();
    row38.cells[0].value = 'Edad:';
    row38.cells[1].value = domicilio.edadAd;
    PdfGridRow row39 = grid4.rows.add();
    row39.cells[0].value = 'Tamaño:';
    row39.cells[1].value = domicilio.inmueble;

    //Estilo celdas
    row28.cells[1].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row29.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row30.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row31.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row32.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row33.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row34.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row35.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row36.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row36.cells[1].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row37.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row38.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row39.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row28.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row29.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row30.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row31.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row32.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row33.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row34.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row35.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row36.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row37.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row38.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );
    row39.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 3, right: 0, top: 2, bottom: 0),
    );

//Draw the grid in PDF document page
    grid4.draw(
        //page: result.page,
        page: page1,
        bounds: Rect.fromLTWH(0, layoutResult1.bounds.bottom + 5, 0, 0));

    textElement1.text = 'RELACIÓN CON LOS ANIMALES';
    textElement1.font =
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    layoutResult1 = textElement1.draw(
        page: page1,
        bounds: Rect.fromLTWH(0, layoutResult1.bounds.bottom + 240, 0, 0))!;
    textElement1.text = 'Liste sus dos últimas mascotas:';
    textElement1.font =
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    layoutResult1 = textElement1.draw(
        page: page1,
        bounds: Rect.fromLTWH(0, layoutResult1.bounds.bottom + 5, 0, 0))!;

    PdfGrid grid5 = PdfGrid();

//Add columns to second grid
    grid5.columns.add(count: 5);
    grid5.headers.add(1);
    PdfGridRow header4 = grid5.headers[0];
    header4.cells[0].value = 'Canino/Felino/Otro';
    header4.cells[1].value = 'Nombre mascota';
    header4.cells[2].value = 'Sexo';
    header4.cells[3].value = 'Esterilizado';
    header4.cells[4].value =
        '¿Dónde esta ahora? Si fallecio, perdio o esta en otro lugar, indique la causa';
    header4.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    header4.cells[1].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    header4.cells[2].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    header4.cells[3].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    header4.cells[4].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
//Add rows to grid
    PdfGridRow row40 = grid5.rows.add();
    row40.cells[0].value = relacionA.tipoMs1;
    row40.cells[1].value = relacionA.nombreMs1;
    row40.cells[2].value = relacionA.sexoMs1;
    row40.cells[3].value = relacionA.estMs1;
    row40.cells[4].value = '';
    PdfGridRow row41 = grid5.rows.add();
    row41.cells[0].value = relacionA.tipoMs2;
    row41.cells[1].value = relacionA.nombreMs2;
    row41.cells[2].value = relacionA.sexoMs2;
    row41.cells[3].value = relacionA.estMs2;
    row41.cells[4].value = relacionA.ubicMascota;

    //Estilo celdas
    row40.cells[0].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row40.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row40.cells[2].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row40.cells[3].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row40.cells[4].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row41.cells[0].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row41.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row41.cells[2].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row41.cells[3].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row41.cells[4].style = PdfGridCellStyle(
      //backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );

//Draw the grid in PDF document page
    grid5.draw(
        //page: result.page,
        page: page1,
        bounds: Rect.fromLTWH(0, layoutResult1.bounds.bottom + 5, 0, 0));

    PdfGrid grid6 = PdfGrid();

//Add columns to second grid
    grid6.columns.add(count: 2);
    grid6.headers.add(1);
    PdfGridRow header5 = grid6.headers[0];
    header5.cells[0].value = '';
    header5.cells[1].value = 'RESPUESTA';

    header5.cells[1].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
//Add rows to grid
    PdfGridRow row42 = grid6.rows.add();
    row42.cells[0].value = '¿Por qué desea adoptar una mascota?';
    row42.cells[1].value = relacionA.deseoAdop;
    PdfGridRow row43 = grid6.rows.add();
    row43.cells[0].value =
        'Si por algún motivo tuviera que cambiar de domicilio, ¿Qué pasaría con su mascota?';
    row43.cells[1].value = relacionA.cambioDomi;
    PdfGridRow row44 = grid6.rows.add();
    row44.cells[0].value =
        'Con ralación a la anterior pregunta, ¿Qué pasaría si los dueños de la nueva casa no aceptacen mascotas?';
    row44.cells[1].value = relacionA.relNuevaCasa;
    PdfGridRow row45 = grid6.rows.add();
    row45.cells[0].value =
        'Si Ud. debe salir de viaje más de un día, la mascota:';
    row45.cells[1].value = relacionA.viajeMascota;
    PdfGridRow row46 = grid6.rows.add();
    row46.cells[0].value = '¿Cuánto tiempo en el día pasará sola la mascota?';
    row46.cells[1].value = relacionA.tiempoSolaMas;
    PdfGridRow row47 = grid6.rows.add();
    row47.cells[0].value = '¿Dónde pasará durante el día y la noche?';
    row47.cells[1].value = relacionA.diaNocheMas;
    PdfGridRow row48 = grid6.rows.add();
    row48.cells[0].value = '¿Dónde dormirá la mascota?';
    row48.cells[1].value = relacionA.duermeMas;
    PdfGridRow row49 = grid6.rows.add();
    row49.cells[0].value = '¿Dónde hará sus necesidades?';
    row49.cells[1].value = relacionA.necesidadMas;
    PdfGridRow row50 = grid6.rows.add();
    row50.cells[0].value = '¿Que comerá habitualmente la mascota?';
    row50.cells[1].value = relacionA.comidaMas;
    PdfGridRow row51 = grid6.rows.add();
    row51.cells[0].value = '¿Cuántos años cree que vive un perro promedio?';
    row51.cells[1].value = relacionA.promedVida;

    //Estilo celdas
    row42.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row43.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row44.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row45.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row46.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row47.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row48.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row49.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row50.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row51.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );

    row42.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row43.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row44.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row45.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row46.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row47.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row48.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row49.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row50.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row51.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );

//Draw the grid in PDF document page
    grid6.draw(
        //page: result.page,
        page: page1,
        bounds: Rect.fromLTWH(0, layoutResult1.bounds.bottom + 115, 0, 0));

    PdfTextElement textElement2 = PdfTextElement(
        //text:
        //    'El objetivo en la Fundación Protección Animal Ecuador, PAE, es que nuestros animales vayan a casas permanentes donde sean felices y bien cuidados por el resto de sus vidas. Los animales son responsabilidad de PAE y su adopcion esta a nuestra discreción. PAE puede rechazar una solicitud de adopción sin tener necesariamente que dar una explicación. PAE no se responsabiliza por el comportamiento adquirido por el animal luego de su adopción.',
        font: PdfStandardFont(PdfFontFamily.helvetica, 12));

    PdfLayoutResult layoutResult2 = textElement2.draw(
        page: page2,
        bounds: Rect.fromLTWH(
            0, 5, page2.getClientSize().width, page2.getClientSize().height))!;

    textElement2.text = 'RELACIÓN CON LOS ANIMALES 2';
    textElement2.font =
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    layoutResult2 =
        textElement2.draw(page: page2, bounds: Rect.fromLTWH(0, 0, 0, 0))!;

    PdfGrid grid7 = PdfGrid();

//Add columns to second grid
    grid7.columns.add(count: 2);
    grid7.headers.add(1);
    PdfGridRow header6 = grid7.headers[0];
    header6.cells[0].value = '';
    header6.cells[1].value = 'RESPUESTA';

    header6.cells[1].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
//Add rows to grid
    PdfGridRow row52 = grid7.rows.add();
    row52.cells[0].value = 'Si su mascota se enferma, usted:';
    row52.cells[1].value = relacionA.enfermedadMas;
    PdfGridRow row53 = grid7.rows.add();
    row53.cells[0].value =
        '¿Quién será el responsable y se hará cargo de cubrir los gastos de la mascota?';
    row53.cells[1].value = relacionA.responGastos;
    PdfGridRow row54 = grid7.rows.add();
    row54.cells[0].value =
        'Estime cuánto dinero podría gastar en su mascota mensualmente:';
    row54.cells[1].value = relacionA.dineroMas;
    PdfGridRow row55 = grid7.rows.add();
    row55.cells[0].value =
        '¿Cuenta con los recursos para cubrir los gastos veterinarios del animal de compañía?';
    row55.cells[1].value = relacionA.recursoVet;
    PdfGridRow row56 = grid7.rows.add();
    row56.cells[0].value =
        '¿Está de acuerdo en que se haga una visita periódica a su domicilio para ver como se encuentra el adoptado?';
    row56.cells[1].value = relacionA.visitaPer;
    PdfGridRow row57 = grid7.rows.add();
    row57.cells[0].value = '¿Por qué?';
    row57.cells[1].value = relacionA.justificacion1;
    PdfGridRow row58 = grid7.rows.add();
    row58.cells[0].value =
        '¿Esta de acuerdo en que la mascota sea esterilizada?';
    row58.cells[1].value = relacionA.acuerdoEst;
    PdfGridRow row59 = grid7.rows.add();
    row59.cells[0].value = '¿Por qué?';
    row59.cells[1].value = relacionA.justificacion2;
    PdfGridRow row60 = grid7.rows.add();
    row60.cells[0].value = '¿Conoce usted los beneficios de la esterilización?';
    row60.cells[1].value = relacionA.benefEst;
    PdfGridRow row61 = grid7.rows.add();
    row61.cells[0].value = 'Segun usted, ¿Qué es tenecia responsable?';
    row61.cells[1].value = relacionA.tenenciaResp;
    PdfGridRow row62 = grid7.rows.add();
    row62.cells[0].value =
        'Está Ud. informado y conciente sobre la ordenanza municipal sobre la tenencia responsable de mascotas?';
    row62.cells[1].value = relacionA.ordenMuni;
    PdfGridRow row63 = grid7.rows.add();
    row63.cells[0].value = '¿La adopción fue compartida con su familia?';
    row63.cells[1].value = relacionA.adCompart;
    PdfGridRow row64 = grid7.rows.add();
    row64.cells[0].value = 'Su familia esta:';
    row64.cells[1].value = relacionA.famAcuerdo;

    //Estilo celdas
    row52.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row53.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row54.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row55.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row56.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row57.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row58.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row59.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row60.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row61.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row62.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row63.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
    row64.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );

    row52.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row53.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row54.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row55.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row56.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row57.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row58.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row59.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row60.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row61.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row62.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row63.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row64.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );

//Draw the grid in PDF document page
    grid7.draw(
        //page: result.page,
        page: page2,
        bounds: Rect.fromLTWH(0, layoutResult2.bounds.bottom + 5, 0, 0));

    textElement2.text = 'Uso Interno PAE';
    textElement2.font =
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    layoutResult2 = textElement2.draw(
        page: page2,
        bounds: Rect.fromLTWH(0, layoutResult2.bounds.bottom + 400, 0, 0))!;

    PdfGrid grid8 = PdfGrid();

//Add columns to second grid
    grid8.columns.add(count: 2);
    grid8.headers.add(1);
    PdfGridRow header7 = grid8.headers[0];
    header7.cells[0].value = '';
    header7.cells[1].value = 'RESPUESTA';

    header6.cells[1].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );
//Add rows to grid
    PdfGridRow row65 = grid8.rows.add();
    row65.cells[0].value = 'Observaciones:';
    row65.cells[1].value = '';
    PdfGridRow row66 = grid8.rows.add();
    row66.cells[0].value = 'Fecha respuesta:';
    row66.cells[1].value = '';

    row65.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );

    row65.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );
    row66.cells[0].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightSteelBlue,
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 9),
      textPen: PdfPens.black,
    );

    row66.cells[1].style = PdfGridCellStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 2, bottom: 0),
    );

    grid8.draw(
        //page: result.page,
        page: page2,
        bounds: Rect.fromLTWH(0, layoutResult2.bounds.bottom + 5, 0, 0));

    //final List<int> bytes = document.save() as List<int>;
    final List<int> bytes = document.saveSync();
    //Dispose the document
    document.dispose();

    //Get external storage directory
    Directory directory = (await getApplicationDocumentsDirectory());
    //Get directory path
    String path = directory.path;
    //Create an empty file to write PDF data
    File file = File('$path/${'Solicitud' + '-' + datosC.nombreCom}.pdf');
    //Write PDF data
    await file.writeAsBytes(bytes, flush: true);
    //Open the PDF document in mobile
    OpenFile.open('$path/${'Solicitud' + '-' + datosC.nombreCom}.pdf');
  }

  Future<List<int>> _readImageData(String name) async {
    final ByteData data = await rootBundle.load('assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
