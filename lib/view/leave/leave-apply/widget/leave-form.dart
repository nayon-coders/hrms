import 'dart:convert';
import 'package:HRMS/service/api-service.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:HRMS/view/global_widget/show-toast.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../global_widget/big_text.dart';
import '../../../home_screen/home.dart';
import '../leave-apply.dart';
class LeaveForm extends StatefulWidget {
  const LeaveForm({Key? key}) : super(key: key);

  @override
  _LeaveFormState createState() => _LeaveFormState();
}

class _LeaveFormState extends State<LeaveForm> {
  var difference;

  final List<String> items = [];
  String? selectedLeaveTypeValue;
  late DateTime date;
late dynamic formatingDate =  DateFormat("yyyy-MM");
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final _leaveReasionController = TextEditingController();
  final _RemarkController = TextEditingController();
  final format = DateFormat("yyyy-MM-dd");
  final _LeaveFormKey = GlobalKey<FormState>();

  bool _isLeaveApply = false;
  bool _isDataLogin = false;

  Future? leaveList;
  dynamic? reminingDate;
  Future<void> getLiveList() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');
    final response = await http.get(Uri.parse(APIService.leaveCount),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    if(response.statusCode == 201){
      var data = jsonDecode(response.body.toString());
      setState((){
        _isDataLogin = true;
        reminingDate = data["remaining"];
        items.add("CASUAL LEAVE (${data["remaining"]})");
      });
      return data;

    }else{
      _errorServer(response.statusCode);
      print(response.statusCode);
      throw Exception("Error");
    }

  }

  @override
  void initState() {
    super.initState();
    ///whatever you want to run on page build
    leaveList = getLiveList();
  }

   @override
  Widget build(BuildContext context) {

     return _isDataLogin ? Container(

      padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child:_isLeaveApply ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          SizedBox(height: 10,),
          Center(
            child: MediunText(text: "Applying for leave..."),
          ),
        ],
      ): Form(
        key: _LeaveFormKey,
        child: ListView(
          children: [
            MediunText(text: "Apply for leave", size: 10.sp, color: appColors.black,),
            const SizedBox(height: 20,),
            CustomDropdownButton2(
              hint: 'Select Type',
               buttonHeight: 55,
              buttonWidth: MediaQuery.of(context).size.width,
              buttonPadding: EdgeInsets.all(10),
              dropdownWidth: MediaQuery.of(context).size.width/1.1,
              buttonDecoration: BoxDecoration(
                border: Border.all(width: 1, color: appColors.gray),
                borderRadius: BorderRadius.circular(5),
              ),
              dropdownItems: items,
              value: selectedLeaveTypeValue,
              onChanged: (value) {
                setState(() {
                  selectedLeaveTypeValue = value;
                });
              },
            ),

            const SizedBox(height: 20,),
            DateTimeField(
              format: format,
              controller: _fromDateController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                  labelText: "From Date",
                  labelStyle: TextStyle(
                    fontSize: 10.sp,
                  ),
                  hintText: "Select Form Date",
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: appColors.gray200)
                  ),
                  suffixIcon: const Icon(
                    Icons.date_range,
                  ),
              ),
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100)
                );
              },
              validator: (value){
                if(value == null){
                  return "From Date field must not be empty.";
                }else{
                  return null;
                }
              },
            ),
            const SizedBox(height: 20,),
            DateTimeField(
              format: format,
              controller: _toDateController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                labelText: "To Date",
                labelStyle: TextStyle(
                  fontSize: 10.sp,
                ),
                hintText: "Select To Date",
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: appColors.gray200)
                ),
                suffixIcon: Icon(
                  Icons.date_range,
                ),
              ),

              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100)
                );
              },
              validator: (value){
                if(value == null){
                  return "To Date field must not be empty.";
                }else{
                  return null;
                }
              },
            ),
            const SizedBox(height: 20,),
            TextFormField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              minLines: 2,
              maxLines: 10,
              controller: _leaveReasionController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                labelText: "Leave Reason",
                labelStyle: TextStyle(
                  fontSize: 10.sp,
                ),
                hintText: "Leave Reason",

                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: appColors.gray200)
                ),

              ),
              validator: (value){
                if(value == null || value.isEmpty ){
                  return "Leave Reason field must not be empty.";
                }else{
                  return null;
                }

              },
            ),
            const SizedBox(height: 20,),
            TextFormField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              minLines: 2,
              maxLines: 10,
              controller: _RemarkController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                labelText: "Remark",
                labelStyle: TextStyle(
                  fontSize: 10.sp,
                ),
                hintText: "Remark",

                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: appColors.gray200)
                ),

              ),
              validator: (value){
                if(value == null || value.isEmpty ){
                  return "Remark field must not be empty.";
                }else{
                  return null;
                }

              },
            ),
            const SizedBox(height: 30,),
            GestureDetector(
              onTap: (){
                  _applyLeaveMethod();

              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 15, bottom: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: appColors.secondColor
                ),
                child: Center(child: Text("Apply",
                  style: TextStyle(
                      color: appColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp
                  ),
                )),
              ),
            ),


          ],
        ),
      ),
    )
     : Column(
       crossAxisAlignment: CrossAxisAlignment.center,
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Center(
           child: CircularProgressIndicator(
             strokeWidth: 2,
           ),
         ),
         SizedBox(height: 10,),
         Center(
           child: MediunText(text: "Loading..."),
         ),
       ],
     );
  }

  //apply menthod
  _applyLeaveMethod()async{

     if(_LeaveFormKey.currentState!.validate()){

       setState(() {
           _isLeaveApply = true;
        difference = "${DateTime.parse(_toDateController.text).difference(DateTime.parse(_fromDateController.text)).inDays}";
        print(difference); 
       });
       if(reminingDate >= int.parse(difference)){
         SharedPreferences localStorage = await SharedPreferences.getInstance();
         //Store Data
         var token = localStorage.getString('token');

         var response = await http.post(Uri.parse(APIService.leaveRequestUrl),
             body: {
               "leave_type_id" : "2",
               "start_date" : _fromDateController.text,
               "end_date" : _toDateController.text,
               "leave_reason" : _leaveReasionController.text,
               "remark" : _RemarkController.text,
             },
             headers: {
               "Authorization" : "Bearer $token",

             }
         );

         if(response.statusCode == 201){
           ShowToast("Successfully you leave application submitted").successToast();
         }else{
           ShowToast("Something want wearing. Please try after sometimes.").successToast();
         }
       }else{
         showDialog<void>(
           context: context,
           barrierDismissible: false, // user must tap button!
           builder: (BuildContext context) => AlertDialog(
               shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.all(Radius.circular(32.0))),
               contentPadding: EdgeInsets.only(top: 30.0),
               content: Container(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(30),

                 ),
                 height: 320,
                 child: Column(
                   children: [
                     ClipOval(
                       child: Image.asset("assets/images/notoffice.png",width: 100,height: 100,),
                     ),
                     SizedBox(height: 5.h,),
                     Padding(
                         padding: const EdgeInsets.only(left: 40, right: 40),
                         child: Text("😒 Oops! You are selecting $difference days that more than your leave days. You have Remaining: $reminingDate Days only",
                           textAlign: TextAlign.center,
                           style: TextStyle(
                               fontWeight: FontWeight.w600,
                               fontSize: 12.sp
                           ),
                         )
                     ),
                     SizedBox(height: 5.h,),
                     MaterialButton(
                       onPressed: (){
                         Navigator.pop(context);

                       },
                       child: Container(
                         padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(100),
                             color: appColors.mainColor,
                             boxShadow: [
                               BoxShadow(
                                 color: Colors.grey.withOpacity(0.8),
                                 spreadRadius: 2,
                                 blurRadius: 20,
                                 offset: Offset(0, 7), // changes position of shadow
                               ),
                             ]
                         ),
                         child: Center(child: MediunText(text: "Try again", size: 12.sp, color: appColors.white,)),
                       ),
                     )
                   ],
                 ),
               )
           ),
         );
       }
       setState((){
         _isLeaveApply = false;
       });

     }
  }


  _errorServer(response)async{
    return  showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 30.0),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),

            ),
            height: 320,
            child: Column(
              children: [
                BigText(text: "${response}", size: 40.sp, color: appColors.secondColor,),
                BigText(text: "Server Error", size: 18.sp, color: appColors.black,),
                SizedBox(height: 5.h,),
                Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Text("Access to this resource on the server is denied!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp
                      ),
                    )
                ),
                SizedBox(height: 5.h,),
                MaterialButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: appColors.mainColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 2,
                            blurRadius: 20,
                            offset: Offset(0, 7), // changes position of shadow
                          ),
                        ]
                    ),
                    child: Center(child: MediunText(text: "Try again", size: 12.sp, color: appColors.white,)),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }


}


