import 'dart:math';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/attendance/attendance-list/attendance-list.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class LeaveForm extends StatefulWidget {
  const LeaveForm({Key? key}) : super(key: key);

  @override
  _LeaveFormState createState() => _LeaveFormState();
}

class _LeaveFormState extends State<LeaveForm> {
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];
  String? selectedValue;
  late DateTime date;

  final _selectTypeControler = TextEditingController();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final _leaveReasionController = TextEditingController();
  final _RemarkController = TextEditingController();
  final format = DateFormat.yMMMMd('en_US');
  final _LeaveFormKey = GlobalKey<FormState>();
   @override
  Widget build(BuildContext context) {
    return Container(

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
      child: Form(
        key: _LeaveFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              value: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
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
                  return "Field must not be empty...";
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
                  return "Field must not be empty...";
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
                  return "Field must not be empty... ";
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
                  return "Field must not be empty... ";
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
            )


          ],
        ),
      ),
    );
  }

  //apply menthod
  _applyLeaveMethod(){
     if(_LeaveFormKey.currentState!.validate()){
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Processing Data')),
       );
     }
  }

}

