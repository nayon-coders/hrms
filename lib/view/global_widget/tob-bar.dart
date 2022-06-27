import 'package:HRMS/utility/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'mediun_text.dart';
class TopBar extends StatelessWidget {
  String text;
  VoidCallback goToBack;
  VoidCallback? iconNavigate;
  bool isIcon;
  IconData icon;
  Color? bottomRoundedColor;
  TopBar({Key? key, this.bottomRoundedColor = appColors.white, required this.icon, this.isIcon = true,  required this.text, required this.goToBack, this.iconNavigate}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return   Container(
      width: double.infinity,
      height: 170,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xff00315E),
              Color(0xff580082),
            ],
          )),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 6.h, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    isIcon ? IconButton(
                        onPressed: goToBack,
                          icon: Icon(
                          icon,
                          color: appColors.white,
                        )
                    ): Center(),
                    MediunText(text: "$text", size: 11.sp, color: appColors.white,),
                  ],
                ),
                IconButton(
                    onPressed: iconNavigate,
                    icon: Icon(
                      Icons.info_outline,
                      color: appColors.white,
                    )
                )

              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child:Container(
              height: 5.h,
              width: MediaQuery.of(context).size.width,
              decoration:  BoxDecoration(
                  color: bottomRoundedColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )
              ),

            ),
          )
        ],
      ),
    );
  }
}
