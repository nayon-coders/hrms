import 'package:HRMS/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../global_widget/mediun_text.dart';
class ProfileDetails extends StatelessWidget {
  final changeInfoForm = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25, bottom: 25, left: 10, right: 10),
      child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                      width: 3,
                      color: appColors.bg,
                    )
                  ),
                  hintText: "Nayon Talukder"
                ),
              ),
              const SizedBox(height: 15,),
              TextFormField(

                controller: _email,
                decoration: const InputDecoration(
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
