import 'package:HRMS/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../global_widget/mediun_text.dart';
class ChangePass extends StatelessWidget {

  final changePassForm = GlobalKey<FormState>();

  final _newPass = TextEditingController();
  final _reTypePass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25, bottom: 25, left: 10, right: 10),
      child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _newPass,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          width: 3,
                          color: appColors.bg,
                        )
                    ),
                    hintText: "Enter New Password",
                    labelText: "New Password"
                ),
                validator: (value){
                  if(value != null && value.isNotEmpty){
                    return "Enter New Password";
                  }
                },
              ),
              const SizedBox(height: 15,),
              TextFormField(
                controller: _reTypePass,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                            width: 3,
                            color: appColors.bg
                        )
                    ),
                    hintText: "Nayon Talukder"
                ),
                validator: (value){
                  if(value != null && value.isNotEmpty){
                    return "Retype Password";
                  }
                },
              ),

              GestureDetector(
                onTap: (){
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context)=>HomeScreen())
                  // );
                },
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  width: MediaQuery.of(context).size.width/3,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: appColors.secondColor
                  ),
                  child: Center(child: Text("Save Changes",
                    style: TextStyle(
                        color: appColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp
                    ),
                  )),
                ),
              ),
            ],
          )
      ),
    );
  }
}
