import 'dart:io';
import 'dart:typed_data';

import 'package:HRMS/view/salary-item.dart';
import 'package:flutter/services.dart';
import 'package:open_document/open_document.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;



class Payslip1 {
  String grossSalary;
  String netPayble;
  String basicPay;
  String medicalAllowance;
  String cityAllowance;
  String specialAllowance;

  Payslip1(
      this.grossSalary,
      this.netPayble,
      this.basicPay,
      this.medicalAllowance,
      this.cityAllowance,
      this.specialAllowance,
      );
}


class PdfInvoiceService {



  Future<Uint8List> createInvoice(List<Payslip> soldProducts) async {
    final pdf = pw.Document();

    final List<Payslip1> elements = [
      Payslip1("Gross Salary", "Net Salary", "Basic Pay", "Medical Allowance", "City Allowance", "Spacial Allowance", ),
      for (var payslip in soldProducts)
        Payslip1(
          payslip.grossSalary,
          payslip.netPayble,
          payslip.basicPay,
          payslip.medicalAllowance,
          payslip.cityAllowance,
          payslip.specialAllowance,

        ),
      Payslip1(
        "", "","","","Net Pay", "${soldProducts.fold(0.0,(double prev, next) => prev + double.parse(next.netPayble),).toStringAsFixed(2)}",
      ),

    ];
    final image = (await rootBundle.load("assets/images/logopdf.png")).buffer.asUint8List();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Image(pw.MemoryImage(image), width: 200, height: 80, fit: pw.BoxFit.cover),
              pw.SizedBox(height: 40),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("${soldProducts.map((e) => e.name)}"),
                      pw.Text("${soldProducts.map((e) => e.dg)}"),

                    ],
                  ),
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text("AB Tower, 3rd Floor, 131/2/GA,", ),
                      pw.Text(" Middle Badda", ),
                      pw.Text("Rogati Sharani , Dhaka-1212"),
                    ],
                  )
                ],
              ),
              pw.SizedBox(height: 50),

              pw.SizedBox(height: 25),
              itemColumn(elements),
              pw.SizedBox(height: 25),
              pw.Text("** This is a computer generated payslip and does not require signature or seal."),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  pw.Expanded itemColumn(List<Payslip1> elements) {
    return pw.Expanded(
      child: pw.Column(
        children: [
          for (var element in elements)
           pw.Container(
             padding: pw.EdgeInsets.all(5),
             decoration: pw.BoxDecoration(
               color: PdfColor.fromInt(0xffffffff),
               border:  pw.Border.all(width: 1, color: PdfColors.grey200),
             ),
              child:  pw.Row(
                children: [
                  pw.Expanded(child: pw.Text(element.grossSalary, textAlign: pw.TextAlign.left)),
                  pw.Expanded(child: pw.Text(element.netPayble, textAlign: pw.TextAlign.left)),
                  pw.Expanded(child: pw.Text(element.basicPay, textAlign: pw.TextAlign.left)),
                  pw.Expanded(child: pw.Text(element.medicalAllowance, textAlign: pw.TextAlign.left)),
                  pw.Expanded(child: pw.Text(element.cityAllowance, textAlign: pw.TextAlign.left)),
                  pw.Expanded(child: pw.Text(element.specialAllowance, textAlign: pw.TextAlign.left)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenDocument.openDocument(filePath: filePath);
  }



  String netPay(List<Payslip1> products) {
    return products
        .fold(
      0.0,
          (double prev, next) => prev + double.parse(next.netPayble),
    )
        .toStringAsFixed(2);
  }
}
