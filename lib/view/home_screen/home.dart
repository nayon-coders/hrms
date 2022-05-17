import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/global_widget/big_text.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
               Container(
                  width: double.infinity,
                  height: 220,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Color(0xff00315E),
                          Color(0xff580082),
                        ],
                      )),
                  ),

               Padding(
                   padding: EdgeInsets.only(left: 20, right: 20, top: 90, bottom: 10),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Row(
                       children: [
                         ClipRRect(
                             borderRadius: BorderRadius.circular(100),
                             child: Image.asset("assets/images/user.jpg",
                               fit: BoxFit.cover,
                               height: 60,
                               width: 60,
                             )

                         ),
                         const SizedBox(width: 10,),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             BigText(text: "Hi, Good Morning", ),
                             SizedBox(height: 5,),
                             MediunText(text: "Nayon Talukder", size: 15,),
                           ],
                         ),
                       ],
                     ),
                     Icon(
                       Icons.menu,
                       color: appColors.white,
                       size: 40,
                     )

                   ],
                 ),
               ),

               Padding(
                 padding: const EdgeInsets.only(top: 180),
                 child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: appColors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          )
                      ),
                  ),
               ),
            ],
          ),

          Container(
            color: appColors.white,
            child: Column(
              children: [

              ],
            ),
          ),


        ],
      ),
    );
  }
}

