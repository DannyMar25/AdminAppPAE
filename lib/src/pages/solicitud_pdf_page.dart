import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:aministrador_app_v1/src/models/formulario_datosPersonales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_domicilio_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_principal_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_relacionAnimal_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_situacionFam_model.dart';

class CrearSolicitudPdfPage extends StatefulWidget {
  const CrearSolicitudPdfPage({Key? key}) : super(key: key);

  @override
  State<CrearSolicitudPdfPage> createState() => _CrearSolicitudPdfPageState();
}

class _CrearSolicitudPdfPageState extends State<CrearSolicitudPdfPage> {
  FormulariosModel formularios = new FormulariosModel();
  DatosPersonalesModel datosA = new DatosPersonalesModel();
  SitFamiliarModel situacionF = new SitFamiliarModel();
  DomicilioModel domicilio = new DomicilioModel();
  RelacionAnimalesModel relacionAn = new RelacionAnimalesModel();

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    datosA = arg['datosper'] as DatosPersonalesModel;
    print(datosA.id);
    situacionF = arg['sitfam'] as SitFamiliarModel;
    domicilio = arg['domicilio'] as DomicilioModel;
    relacionAn = arg['relacionAn'] as RelacionAnimalesModel;
    formularios = arg['formulario'] as FormulariosModel;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
        ),
        body: Center(
            child:
                TextButton(onPressed: _createPDF, child: Text('Crear PDF'))));
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
            'El objetivo en la Fundación Protección Animal Ecuador, PAE, es que nuestros animales vayan a casas permanentes donde sean felices y bien cuidados por el resto de sus vidas. Los animales son responsabilidad de PAE y su adopcion esta a nuestra discreción. PAE puede rechazar una solicitud de adopción sin tener necesariamente que dar una explicación. PAE no se responsabiliza por el comportamiento adquirido por el animal luego de su adopción.',
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
    row1.cells[1].value = datosA.nombreCom;
    PdfGridRow row2 = grid.rows.add();
    row2.cells[0].value = 'Cédula:';
    row2.cells[1].value = datosA.cedula;
    PdfGridRow row3 = grid.rows.add();
    row3.cells[0].value = 'Dirección exacta donde estará la mascota:';
    row3.cells[1].value = datosA.direccion;
    PdfGridRow row4 = grid.rows.add();
    row4.cells[0].value = 'Ocupación:';
    row4.cells[1].value = datosA.ocupacion;
    PdfGridRow row5 = grid.rows.add();
    row5.cells[0].value = 'Fecha de nacimiento:';
    row5.cells[1].value = datosA.fechaNacimiento;
    PdfGridRow row6 = grid.rows.add();
    row6.cells[0].value = 'E-mail:';
    row6.cells[1].value = datosA.email;
    PdfGridRow row7 = grid.rows.add();
    row7.cells[0].value = 'Intrucción:';
    row7.cells[1].value = datosA.nivelInst;
    PdfGridRow row8 = grid.rows.add();
    row8.cells[0].value = 'TELÉFONOS DE CONTACTO';
    row8.cells[1].value = '';
    PdfGridRow row9 = grid.rows.add();
    row9.cells[0].value = 'Celular:';
    row9.cells[1].value = datosA.telfCel;
    PdfGridRow row10 = grid.rows.add();
    row10.cells[0].value = 'Casa:';
    row10.cells[1].value = datosA.telfDomi;
    PdfGridRow row11 = grid.rows.add();
    row11.cells[0].value = 'Trabajo:';
    row11.cells[1].value = datosA.telfTrab;
    PdfGridRow row12 = grid.rows.add();
    row12.cells[0].value = 'REFERENCIAS PERSONALES';
    row12.cells[1].value = '';
    PdfGridRow row13 = grid.rows.add();
    row13.cells[0].value = 'Nombre:';
    row13.cells[1].value = datosA.nombreRef;
    PdfGridRow row14 = grid.rows.add();
    row14.cells[0].value = 'Parentesco:';
    row14.cells[1].value = datosA.parentescoRef;
    PdfGridRow row15 = grid.rows.add();
    row15.cells[0].value = 'Teléfono:';
    row15.cells[1].value = datosA.telfRef;

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
    row40.cells[0].value = relacionAn.tipoMs1;
    row40.cells[1].value = relacionAn.nombreMs1;
    row40.cells[2].value = relacionAn.sexoMs1;
    row40.cells[3].value = relacionAn.estMs1;
    row40.cells[4].value = '';
    PdfGridRow row41 = grid5.rows.add();
    row41.cells[0].value = relacionAn.tipoMs2;
    row41.cells[1].value = relacionAn.nombreMs2;
    row41.cells[2].value = relacionAn.sexoMs2;
    row41.cells[3].value = relacionAn.estMs2;
    row41.cells[4].value = relacionAn.ubicMascota;

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
    row42.cells[1].value = relacionAn.deseoAdop;
    PdfGridRow row43 = grid6.rows.add();
    row43.cells[0].value =
        'Si por algún motivo tuviera que cambiar de domicilio, ¿Qué pasaría con su mascota?';
    row43.cells[1].value = relacionAn.cambioDomi;
    PdfGridRow row44 = grid6.rows.add();
    row44.cells[0].value =
        'Con ralación a la anterior pregunta, ¿Qué pasaría si los dueños de la nueva casa no aceptacen mascotas?';
    row44.cells[1].value = relacionAn.relNuevaCasa;
    PdfGridRow row45 = grid6.rows.add();
    row45.cells[0].value =
        'Si Ud. debe salir de viaje más de un día, la mascota:';
    row45.cells[1].value = relacionAn.viajeMascota;
    PdfGridRow row46 = grid6.rows.add();
    row46.cells[0].value = '¿Cuánto tiempo en el día pasará sola la mascota?';
    row46.cells[1].value = relacionAn.tiempoSolaMas;
    PdfGridRow row47 = grid6.rows.add();
    row47.cells[0].value = '¿Dónde pasará durante el día y la noche?';
    row47.cells[1].value = relacionAn.diaNocheMas;
    PdfGridRow row48 = grid6.rows.add();
    row48.cells[0].value = '¿Dónde dormirá la mascota?';
    row48.cells[1].value = relacionAn.duermeMas;
    PdfGridRow row49 = grid6.rows.add();
    row49.cells[0].value = '¿Dónde hará sus necesidades?';
    row49.cells[1].value = relacionAn.necesidadMas;
    PdfGridRow row50 = grid6.rows.add();
    row50.cells[0].value = '¿Que comerá habitualmente la mascota?';
    row50.cells[1].value = relacionAn.comidaMas;
    PdfGridRow row51 = grid6.rows.add();
    row51.cells[0].value = '¿Cuántos años cree que vive un perro promedio?';
    row51.cells[1].value = relacionAn.promedVida;

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
    row52.cells[1].value = relacionAn.enfermedadMas;
    PdfGridRow row53 = grid7.rows.add();
    row53.cells[0].value =
        '¿Quién será el responsable y se hará cargo de cubrir los gastos de la mascota?';
    row53.cells[1].value = relacionAn.responGastos;
    PdfGridRow row54 = grid7.rows.add();
    row54.cells[0].value =
        'Estime cuánto dinero podría gastar en su mascota mensualmente:';
    row54.cells[1].value = relacionAn.dineroMas;
    PdfGridRow row55 = grid7.rows.add();
    row55.cells[0].value =
        '¿Cuenta con los recursos para cubrir los gastos veterinarios del animal de compañía?';
    row55.cells[1].value = relacionAn.recursoVet;
    PdfGridRow row56 = grid7.rows.add();
    row56.cells[0].value =
        '¿Está de acuerdo en que se haga una visita periódica a su domicilio para ver como se encuentra el adoptado?';
    row56.cells[1].value = relacionAn.visitaPer;
    PdfGridRow row57 = grid7.rows.add();
    row57.cells[0].value = '¿Por qué?';
    row57.cells[1].value = relacionAn.justificacion1;
    PdfGridRow row58 = grid7.rows.add();
    row58.cells[0].value =
        '¿Esta de acuerdo en que la mascota sea esterilizada?';
    row58.cells[1].value = relacionAn.acuerdoEst;
    PdfGridRow row59 = grid7.rows.add();
    row59.cells[0].value = '¿Por qué?';
    row59.cells[1].value = relacionAn.justificacion2;
    PdfGridRow row60 = grid7.rows.add();
    row60.cells[0].value = '¿Conoce usted los beneficios de la esterilización?';
    row60.cells[1].value = relacionAn.benefEst;
    PdfGridRow row61 = grid7.rows.add();
    row61.cells[0].value = 'Segun usted, ¿Qué es tenecia responsable?';
    row61.cells[1].value = relacionAn.tenenciaResp;
    PdfGridRow row62 = grid7.rows.add();
    row62.cells[0].value =
        'Está Ud. informado y conciente sobre la ordenanza municipal sobre la tenencia responsable de mascotas?';
    row62.cells[1].value = relacionAn.ordenMuni;
    PdfGridRow row63 = grid7.rows.add();
    row63.cells[0].value = '¿La adopción fue compartida con su familia?';
    row63.cells[1].value = relacionAn.adCompart;
    PdfGridRow row64 = grid7.rows.add();
    row64.cells[0].value = 'Su familia esta:';
    row64.cells[1].value = relacionAn.famAcuerdo;

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

    final List<int> bytes = document.save() as List<int>;
    //Dispose the document
    document.dispose();

    //Get external storage directory
    Directory directory = (await getApplicationDocumentsDirectory());
    //Get directory path
    String path = directory.path;
    //Create an empty file to write PDF data
    File file = File('$path/${'Solicitud' + '-' + datosA.nombreCom}.pdf');
    //Write PDF data
    await file.writeAsBytes(bytes, flush: true);
    //Open the PDF document in mobile
    OpenFile.open('$path/${'Solicitud' + '-' + datosA.nombreCom}.pdf');
  }

  Future<List<int>> _readImageData(String name) async {
    final ByteData data = await rootBundle.load('assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
