import 'dart:convert';
import 'dart:io';
import 'package:HRMS/view/global_widget/no-data.dart';
import 'package:HRMS/view/global_widget/server-error.dart';
import 'package:HRMS/view/global_widget/show-toast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../service/api-service.dart';
import 'global_widget/big_text.dart';
import 'global_widget/mediun_text.dart';
class PaySlip extends StatefulWidget {
  const PaySlip({Key? key}) : super(key: key);

  @override
  _PaySlipState createState() => _PaySlipState();
}

class _PaySlipState extends State<PaySlip> {

  late DateTime date;
  late final monthOfTheYear = DateFormat.yMMM().format(DateTime.now());

  Future<void> getPaySlip() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');
    final response = await http.get(Uri.parse(APIService.paySlip),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    if(response.statusCode == 201){
      var data = jsonDecode(response.body.toString());
      var paySlipeList = data;
      return paySlipeList;

    }else{
      print("error");
      print(response.statusCode);
      throw Exception("Error");
    }

  }
  Future? paySlipList;
  @override
  void initState(){
    paySlipList = getPaySlip();
    _UserInfo();
  }

  String? Name;
  String? Email;
  void _UserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var name = localStorage.getString("name");
    var email = localStorage.getString("email");
    setState(() {
      Name = name!;
      Email = email!;
    });
  }


  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return  Scaffold(
      backgroundColor: appColors.white,
      appBar: AppBar(
        title: MediunText(text: "Pay Slip", color: appColors.white, size: 10.sp,),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xff00315E),
                  Color(0xff580082),
                ],
              )
          ),
        ),
     
      ),
      body:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),

          child:Container(
            width: width,
            height: height,
            child: FutureBuilder(
                future: paySlipList,
                builder: (context, AsyncSnapshot<dynamic> snapshot){

                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    );
                  }if(snapshot.hasData){
                    if( snapshot.data['payslip'].length != 0) {
                      return ListView.builder(
                          itemCount: snapshot.data['payslip'].length,

                          itemBuilder: (context, index) {
                            print(snapshot.data['payslip'][index]);
                                return leaveListItem(
                                  date: snapshot.data['payslip'][index]["salary_month"],
                                  name: "$Name",
                                  slipFunction: () {
                                    ShowToast("Will be updated soon").successToast();

                                    //createPDF(snapshot.data['payslip'][index]["date"].toString(), snapshot.data["designation"], snapshot.data['payslip'][index]);
                                  },
                                    netSalery: "${snapshot
                                        .data['payslip'][index]["gross_salary"]}",
                                    Dg: "${snapshot
                                        .data['designation']["name"]
                                    }",
                                );

                          }
                      );
                    }else{
                      return NoDataFound();
                    }
                  }else{
                    return ServerError();
                  }

                }
            ),

          )
      ),

    );
  }

//   //TODO: Crete PDF
// Future createPDF(date, designation, index)async{
//
//     PdfDocument documents = PdfDocument();
//     final page = documents.pages.add();
//
//   drowTable(designation, page, index);
//
//
//     List<int> bytes = documents.save();
//     documents.dispose();
//
//     saveAndLounch(bytes, "$date SalaryReports.pdf");
//
// }
//
// Future<void> saveAndLounch(List<int> bytes, String FileName)async{
//     final path = (await getExternalStorageDirectory())?.path;
//     final file = File("$path/$FileName");
//     await file.writeAsBytes(bytes, flush: true);
//
//     OpenFile.open("$path/$FileName");
// }
//
//   void drowTable(designation, PdfPage page, PayBill) {
//     print(PayBill);
//     // if(data["payslip"][index]);
//
//     final grid = PdfGrid();
//
//     page.graphics.drawString("Invoice",
//         PdfStandardFont(PdfFontFamily.helvetica, 30,
//             style: PdfFontStyle.bold),
//         bounds: Rect.fromLTWH(0, 0, 200, 50),
//         brush: PdfBrushes.red,
//         pen: PdfPens.blue,
//         format: PdfStringFormat(alignment: PdfTextAlignment.left));
//     page.graphics.drawString("Name: Nayon Talukder",
//         PdfStandardFont(PdfFontFamily.helvetica, 30,
//             style: PdfFontStyle.bold),
//         bounds: Rect.fromLTWH(0, 30, 200, 100),
//         brush: PdfBrushes.red,
//         pen: PdfPens.blue,
//         format: PdfStringFormat(alignment: PdfTextAlignment.left));
//
//
//     //Add the columns to the grid
//     grid.columns.add(count: 2);
//   //Add header to the grid
//       grid.headers.add(1);
//       //Add the rows to the grid
//     //   PdfGridRow header = grid.headers[0];
//     // header.cells[0].value = 'Employee ID';
//     // header.cells[1].value = 'Employee Name';
//
//     PdfGridRow row = grid.rows.add();
//     row.cells[0].value = 'Net Payable';
//     row.cells[1].value = ': ${PayBill["net_payble"]}';
//     row = grid.rows.add();
//     row.cells[0].value = 'Gross Salary';
//     row.cells[1].value = ': ${PayBill["gross_salary"]}';
//     row = grid.rows.add();
//     row.cells[0].value = 'Salary Month';
//     row.cells[1].value = ': ${PayBill["salary_month"]}';
//     row = grid.rows.add();
//     row.cells[0].value = 'Basic pay';
//     row.cells[1].value = ': ${PayBill["basic_pay"]}';
//     if(PayBill["hra"] !=null){
//       row = grid.rows.add();
//       row.cells[0].value = 'HRA';
//       row.cells[1].value = ': ${PayBill["hra"]}';
//     }
//
//     if(PayBill["da"] !=null){
//       row = grid.rows.add();
//       row.cells[0].value = 'DA Bill';
//       row.cells[1].value = ': ${PayBill["da"]}';
//     }
//
//     if(PayBill["ta"] !=null){
//       row = grid.rows.add();
//       row.cells[0].value = 'TA Bill';
//       row.cells[1].value = ': ${PayBill["ta"]}';
//     }
//
//     if(PayBill["medical_allowance"] !=null){
//       row = grid.rows.add();
//       row.cells[0].value = 'Medical Allowance';
//       row.cells[1].value = ': ${PayBill["medical_allowance"]}';
//     }
//     if(PayBill["medical_allowance"] !=null){
//       row = grid.rows.add();
//       row.cells[0].value = 'Medical Allowance';
//       row.cells[1].value = ': ${PayBill["medical_allowance"]}';
//     }
//     if(PayBill["special_allowance"] !=null){
//       row = grid.rows.add();
//       row.cells[0].value = 'Special Allowance';
//       row.cells[1].value = ': ${PayBill["special_allowance"]}';
//     }
//     if(PayBill["ait"] !=null){
//       row = grid.rows.add();
//       row.cells[0].value = 'AIT';
//       row.cells[1].value = ': ${PayBill["ait"]}';
//     }
//     if(PayBill["provident_fund"] !=null){
//       row = grid.rows.add();
//       row.cells[0].value = 'Provident Fund';
//       row.cells[1].value = ': ${PayBill["provident_fund"]}';
//     }
//     if(PayBill["advance_salary"] !=null){
//       row = grid.rows.add();
//       row.cells[0].value = 'Advance Salary';
//       row.cells[1].value = ': ${PayBill["advance_salary"]}';
//     }
//     if(PayBill["gratuity"] !=null){
//       row = grid.rows.add();
//       row.cells[0].value = 'Gratuity';
//       row.cells[1].value = ': ${PayBill["gratuity"]}';
//     }
//
//
//
//
//     grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable1LightAccent2);
//     grid.style = PdfGridStyle(
//         cellPadding: PdfPaddings(left: 10, right: 10, top: 7, bottom: 7),
//         backgroundBrush: PdfBrushes.white,
//         textBrush: PdfBrushes.black,
//         font: PdfStandardFont(PdfFontFamily.timesRoman, 25));
//     grid.draw(
//       page: page,
//       bounds:Rect.fromLTWH(0, 40, 0, 0),
//     );
//
//     //Create a new PDF document
//     PdfDocument document = PdfDocument();
//     grid.columns[1].width = 50;
// //Set the column text format
//     grid.columns[0].format = PdfStringFormat(
//         alignment: PdfTextAlignment.center,
//         lineAlignment: PdfVerticalAlignment.bottom);
// //Draw the grid in PDF document page
//     grid.draw(
//         page: document.pages.add(), bounds: Rect.zero);
//
//
//
// //Add rows to grid
// //
// // //Set the grid style
// //     grid.style = PdfGridStyle(
// //         cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
// //         backgroundBrush: PdfBrushes.blue,
// //         textBrush: PdfBrushes.white,
// //         font: PdfStandardFont(PdfFontFamily.timesRoman, 25));
// // // //Draw the grid
// // //     grid.draw(
// // //         page: document.pages.add(), bounds: Rect.zero);
// // //Save the document.
// //     List  bytes = document.save();
// // //Dispose the document.
// //     document.dispose();
// //
// //
//
//
//
//   }
//
//

}



class leaveListItem extends StatelessWidget {
  final String date;
  final VoidCallback slipFunction;
  final String netSalery;
  final String Dg;
  final String name;
  leaveListItem({
    required this.date,
    required this.slipFunction,
    required this.netSalery,
    required this.Dg,
    required this.name
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 10),
      margin: EdgeInsets.only(bottom: 30),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: appColors.white,
        border: Border(
          left: BorderSide(width: 10.0, color: appColors.mainColor),
        ),
        //borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              BigText(text: "$date", size: 9.sp, color: appColors.gray,),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "Name", color: appColors.gray, size: 8.sp,),
                  MediunText(text: name, color: appColors.black, size: 8.sp,)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "Designation", color: appColors.gray, size: 8.sp,),
                  MediunText(text: Dg, color: appColors.black, size: 8.sp,)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "Net Salary	", color: appColors.gray, size: 8.sp,),
                  MediunText(text: netSalery, color: appColors.black, size: 8.sp,)
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: slipFunction,
                      icon: Icon(
                        Icons.file_copy,
                        color: Colors.amber,
                      )
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }
}

