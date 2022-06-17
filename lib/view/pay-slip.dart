import 'dart:convert';
import 'dart:io';
import 'package:HRMS/view/global_widget/no-data.dart';
import 'package:HRMS/view/global_widget/show-toast.dart';
import 'package:HRMS/view/leave/leave-apply/widget/leave-form.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:HRMS/model/leave-list-model.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../service/api-service.dart';
import 'global_widget/big_text.dart';
import 'global_widget/mediun_text.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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

  final pdf = pw.Document();

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
                                return leaveListItem(
                                  date: snapshot.data['payslip'][index]["salary_month"],
                                  name: "$Name",
                                  slipFunction: () async{

                                    pdf.addPage(
                                      pw.Page(
                                        build: (pw.Context context) => pw.Center(
                                          child: pw.Text('Hello World!'),
                                        ),
                                      ),
                                    );
                                    final file = File('example.pdf');
                                    await file.writeAsBytes(await pdf.save());
                                  },
                                  netSalery: "${snapshot
                                      .data['payslip'][index]["gross_salary"]}",
                                  salery: "${snapshot
                                      .data['payslip'][index]["net_payble"]}",
                                );

                          }
                      );
                    }else{
                      return NoDataFound();
                    }
                  }else{
                    return Text("some think is warng");
                  }

                }
            ),

          )
      ),

    );
  }

}



class leaveListItem extends StatelessWidget {
  final String date;
  final VoidCallback slipFunction;
  final String netSalery;
  final String salery;
  final String name;
  leaveListItem({
    required this.date,
    required this.slipFunction,
    required this.salery,
    required this.netSalery,
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
                  BigText(text: "Net Salary	", color: appColors.gray, size: 8.sp,),
                  MediunText(text: netSalery, color: appColors.black, size: 8.sp,)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "Salary	", color: appColors.gray, size: 8.sp,),
                  MediunText(text: salery, color: appColors.black, size: 8.sp,)
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

