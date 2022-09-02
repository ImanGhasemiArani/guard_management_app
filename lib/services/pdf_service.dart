import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as ppw;
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as image;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../lang/strs.dart';
import '../model/exchange_request.dart';

class PdfService {
  PdfService._();

  static Future<void> createExchangeReqPdf(ExchangeRequest req) async {
    final fontReg =
        pw.Font.ttf(await rootBundle.load("fonts/Peyda-Regular.ttf"));
    final fontBold = pw.Font.ttf(await rootBundle.load("fonts/Peyda-Bold.ttf"));
    final style = pw.TextStyle(font: fontReg, fontBold: fontBold);

    final pdf = pw.Document();

    final logo = await getAssetImageAsUint8List('assets/logo_org.png');
    final changerSign = await changeSignatureColorToBlack(req.changerSignature);
    final supplierSign =
        await changeSignatureColorToBlack(req.supplierSignature);

    pdf.addPage(
      pw.Page(
        pageFormat: ppw.PdfPageFormat.a5,
        textDirection: pw.TextDirection.rtl,
        margin: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Align(
                alignment: pw.Alignment.topRight,
                child: pw.Image(
                  pw.MemoryImage(logo),
                  height: 70,
                  width: 70,
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.topCenter,
                child: pw.Text(
                  Strs.inTheNameOfGodStr.tr,
                  style: style,
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.topCenter,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 50),
                  child: pw.Text(
                    Strs.titleP1Str.tr,
                    style: style,
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 80),
                child: pw.Align(
                  alignment: pw.Alignment.topCenter,
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                    child: pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          Strs.titleP2Str.tr,
                          style: style,
                        ),
                        pw.SizedBox(height: 20),
                        pw.Text(
                          Strs.wHelloStr.tr,
                          style: style,
                        ),
                        pw.SizedBox(height: 10),
                        pw.RichText(
                          textDirection: pw.TextDirection.rtl,
                          text: pw.TextSpan(
                            style: style,
                            children: [
                              pw.TextSpan(
                                text: Strs.bodyP1Str.tr,
                              ),
                              pw.TextSpan(
                                text:
                                    "  ${req.supplierName ?? '..............'}  ",
                                style: style.copyWith(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.TextSpan(
                                text: Strs.bodyP2Str.tr,
                              ),
                              pw.TextSpan(
                                text: "  ${req.changerOrganPos ?? '..............'}  ",
                                style: style.copyWith(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.TextSpan(
                                text: Strs.bodyP3Str.tr,
                              ),
                              pw.TextSpan(
                                text:
                                    "  ${req.changerShiftDescriptionString ?? '..............'}  ",
                                style: style.copyWith(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.TextSpan(
                                text: Strs.bodyP4Str.tr,
                              ),
                              pw.TextSpan(
                                text:
                                    "  ${req.changerShiftDateString ?? '..............'}  ",
                                style: style.copyWith(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.TextSpan(
                                text: Strs.bodyP5Str.tr,
                              ),
                              pw.TextSpan(
                                text:
                                    "  ${req.changerName ?? '..............'}  ",
                                style: style.copyWith(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.TextSpan(
                                text: Strs.bodyP6Str.tr,
                              ),
                            ],
                          ),
                        ),
                        pw.SizedBox(height: 20),
                        pw.Padding(
                          padding:
                              const pw.EdgeInsets.symmetric(horizontal: 20),
                          child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Column(
                                mainAxisSize: pw.MainAxisSize.min,
                                children: [
                                  pw.Text(
                                    Strs.supplierSignStr.tr,
                                    style: style,
                                  ),
                                  if (supplierSign != null)
                                    pw.Image(
                                      pw.MemoryImage(supplierSign),
                                      fit: pw.BoxFit.scaleDown,
                                      height: 100,
                                      width: 100,
                                    ),
                                  if (supplierSign == null)
                                    pw.SizedBox(
                                      height: 100,
                                      width: 100,
                                    ),
                                ],
                              ),
                              pw.Column(
                                mainAxisSize: pw.MainAxisSize.min,
                                children: [
                                  pw.Text(
                                    Strs.changerSignStr.tr,
                                    style: style,
                                  ),
                                  if (changerSign != null)
                                    pw.Image(
                                      pw.MemoryImage(changerSign),
                                      fit: pw.BoxFit.scaleDown,
                                      height: 100,
                                      width: 100,
                                    ),
                                  if (changerSign == null)
                                    pw.SizedBox(
                                      height: 100,
                                      width: 100,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        pw.Padding(
                          padding:
                              const pw.EdgeInsets.symmetric(horizontal: 20),
                          child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Column(
                                mainAxisSize: pw.MainAxisSize.min,
                                children: [
                                  pw.Text(
                                    Strs.adminUserSignStr.tr,
                                    style: style,
                                  ),
                                  if (changerSign != null)
                                    pw.Image(
                                      pw.MemoryImage(changerSign),
                                      fit: pw.BoxFit.scaleDown,
                                      height: 100,
                                      width: 100,
                                    ),
                                  if (changerSign == null)
                                    pw.SizedBox(
                                      height: 100,
                                      width: 100,
                                    ),
                                ],
                              ),
                              pw.Column(
                                mainAxisSize: pw.MainAxisSize.min,
                                children: [
                                  pw.Text(
                                    Strs.headerUserSignStr.tr,
                                    style: style,
                                  ),
                                  if (changerSign != null)
                                    pw.Image(
                                      pw.MemoryImage(changerSign),
                                      fit: pw.BoxFit.scaleDown,
                                      height: 100,
                                      width: 100,
                                    ),
                                  if (changerSign == null)
                                    pw.SizedBox(
                                      height: 100,
                                      width: 100,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    savePdfToDevice(await pdf.save(), Strs.exReqPdfFileNameStr.tr);
  }

  static Future<void> createShiftSchedulePdf(
      GlobalKey<SfDataGridState> dataGridKey) async {
    var document = PdfDocument();
    var font = PdfTrueTypeFont(
        (await rootBundle.load("fonts/Peyda-Regular.ttf")).buffer.asUint8List(),
        12);
    document.pageSettings.orientation = PdfPageOrientation.landscape;
    document.pageSettings.size = PdfPageSize.a2;
    var pdfPage = document.pages.add();
    var pdfGrid = dataGridKey.currentState!.exportToPdfGrid(
      fitAllColumnsInOnePage: true,
      canRepeatHeaders: false,
      //   autoColumnWidth: false,
      cellExport: (details) {
        details.pdfCell.style.font = font;
        details.pdfCell.stringFormat = PdfStringFormat(
          textDirection: PdfTextDirection.rightToLeft,
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle,
        );
      },
    );
    pdfGrid.draw(
      page: pdfPage,
      bounds: Rect.zero,
    );
    final List<int> bytes = document.saveSync();
    savePdfToDevice(bytes, Strs.shiftSchedulePdfFileNameStr.tr);
  }

  static Future<void> savePdfToDevice(
    List<int> byteCodes, [
    String fileName = "temp",
  ]) async {
    final path = (await getApplicationDocumentsDirectory()).path;
    final file = File("$path/$fileName.pdf");
    await file.writeAsBytes(byteCodes);
    OpenFile.open("$path/$fileName.pdf");
  }

  static Future<Uint8List?> changeSignatureColorToBlack(
      Uint8List? signature) async {
    if (signature == null) return null;
    var img = image.decodeImage(signature)!;
    img = image.adjustColor(img, whites: Colors.black.value);
    final resultImg = (await (await instantiateImageCodec(
                Uint8List.fromList(image.encodePng(img))))
            .getNextFrame())
        .image;

    return (await resultImg.toByteData(format: ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  static Future<Uint8List> getAssetImageAsUint8List(String imgAssetPath) async {
    return (await rootBundle.load(imgAssetPath)).buffer.asUint8List();
  }
}
