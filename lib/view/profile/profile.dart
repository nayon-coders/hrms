import 'dart:convert';
import 'dart:io';
import 'package:HRMS/service/api-service.dart';
import 'package:HRMS/view/global_widget/big_text.dart';
import 'package:HRMS/view/global_widget/notify.dart';
import 'package:HRMS/view/global_widget/show-toast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:HRMS/controller/profile/profile-coltroller.dart';
import 'package:HRMS/model/user-info-model.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/attendance/attendance.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:HRMS/view/home_screen/home.dart';
import 'package:HRMS/view/profile/widget/cheange-pass.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../global_widget/tob-bar.dart';
import '../login_screen/login.dart';
class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ImagePicker _picker = ImagePicker();
  File? imagePickFile;

  bool _isProfilePic = false;
  bool _isLogout = false;


  final changeInfoForm = GlobalKey<FormState>();

  var Name="";
  var Email="";

  final TextEditingController _name = TextEditingController();

  final TextEditingController _email = TextEditingController();


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
  void initState() {
    // TODO: implement initState
    super.initState();
    _UserInfo();
    UserProfileController _userProfileControllor = UserProfileController();
    userProfile = _userProfileControllor.getUserProfile();
  }
  bool _isProfileUpdate = false;
String check = '';

Future? userProfile;

  @override
  Widget build(BuildContext context) {
    return _isLogout ? Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: appColors.secondColor,
            strokeWidth: 3,
          ),
          const SizedBox(height: 10,),
          MediunText(text: "Logout processing..."),
        ],
      ),
    ): DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: appColors.bg,
        body: Column(
          children: [
            TopBar(
                text: "Employee Profile",
                goToBack: (){
                  Navigator.pop(context);
                },

                iconNavigate: (){
                  _profileUpdatePopUp(context);
                },
                icon:Icons.edit,
                
                bottomRoundedColor: appColors.bg,

            ),

            Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width/1.5,
                          padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: appColors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: appColors.mainColor.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          child:Expanded(
                                  child: FutureBuilder(
                                    future: userProfile,
                                    builder: (context, AsyncSnapshot snapshot){
                                      if(snapshot.connectionState == ConnectionState.waiting){
                                        return Column(
                                          children: [
                                            Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                                backgroundColor: appColors.secondColor,
                                              ),
                                            ),
                                            const SizedBox(height: 10,),
                                            MediunText(text: "Checking Update...", color: appColors.gray, size: 8.sp,),
                                          ],
                                        );
                                      }else if(snapshot.hasData){
                                        var avatar = snapshot.data?.userDetail.avatar;
                                        if(avatar != null){
                                           _isProfilePic = true;
                                        }
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Stack(
                                              children: [
                                                ClipOval(
                                                child:imagePickFile !=null ? Image.file(imagePickFile!,
                                                  height: 130,
                                                  width: 130,

                                                ):  _isProfilePic ? Image.network("https://asia.net.in/storage/uploads/avatar/$avatar",
                                                height: 130,
                                                width: 130,

                                                ): Image.asset("assets/images/user.jpg",
                                                  height: 130,
                                                  width: 130,
                                                ),
                                              ),
                                               Positioned(
                                                 bottom: 0,
                                                 right: 0,
                                                 child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(100),
                                                      color: appColors.white
                                                    ),
                                                   child: IconButton(
                                                         onPressed: (){
                                                           _shoBottomSheet(context);
                                                         },
                                                         icon: Icon(
                                                           Icons.add_a_photo,
                                                           color: appColors.gray,
                                                           size: 25,
                                                         )
                                                     ),
                                                 ),
                                               ),
                                              ],
                                            ),

                                            const SizedBox(height: 10,),
                                            Center(
                                              child: BigText(text: "${snapshot.data?.userDetail.name}",
                                                color: appColors.mainColor,
                                                size: 10.sp,
                                              ),
                                            ),
                                            const SizedBox(height: 5,),
                                            Container(
                                              padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100),
                                                  color: appColors.secondColor
                                              ),
                                              child: MediunText(
                                                text: "${snapshot.data?.userDetail.type}",
                                                color: appColors.white,
                                                size: 8,
                                              ),
                                            ),
                                            const SizedBox(height: 10,),
                                            Center(
                                              child: MediunText(
                                                text: "${snapshot.data?.userDetail.email}",
                                                color: appColors.gray,
                                                size: 8,
                                              ),
                                            ),

                                          ],
                                        );
                                      }else{
                                        return Center(child: Text("Server Error"));
                                      }
                                    }
                                  )
                              ),
                        ),

                        const SizedBox(height: 10,),

                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 2. h),
                          child: Column(
                            children: [
                              const SizedBox(height: 20,),

                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: appColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: appColors.mainColor.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: ChangePass(),

                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                )
            ),

          ],
        ),




        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),

          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            Icons.dashboard,
                            color:  appColors.mainColor,
                          ),
                          Text(
                            'Home',
                            style: TextStyle(
                              color: appColors.mainColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Attendance()));
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                        decoration:  BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 5,
                                offset: Offset(0, 0), // changes position of shadow
                              ),
                            ],

                            borderRadius: BorderRadius.circular(100),
                            gradient:
                            LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xff00315E),
                                Color(0xff580082),
                              ],
                            )
                        ),
                        child: const Icon(Icons.add, color: appColors.white,),
                      ),
                    ),
                  ],
                ),

                // Right Tab bar icons

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.supervised_user_circle,
                            color: appColors.secondColor,
                          ),
                          Text(
                            'Profile',
                            style: TextStyle(
                              color: appColors.secondColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _profileUpdatePopUp(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: MediunText(text: "Change Profile", size: 15,),
            content: Container(
              height: 200,
              margin: EdgeInsets.only(top: 10),
              child: Form(
                key: changeInfoForm,
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (value) {
                      },
                      controller: _name,
                      decoration: InputDecoration(
                          hintText: "Enter Your Name"
                      ),
                      validator: (value){
                        if(value != null){
                          return "Name field much not be empty";
                        }else{
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                          hintText: "Enter your email"
                      ),
                      validator: (value){
                        if(value != null){
                          return "Email field much not be empty";
                        }else{
                          return null;
                        }
                      },
                    ),

                    GestureDetector(
                      onTap: (){
                        _userInfoUpdate();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 15),
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
                ),
              ),
            )

          );
        });
  }



  void _shoBottomSheet(BuildContext context){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (BuildContext Context){
          return Container(
            padding: EdgeInsets.only(left: 1.h, right: 1.h, top: 2.h, bottom: 2.h),
            height: 18.h,
            child: Column(

              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(appColors.white),
                      padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                    ),
                      onPressed: (){
                        _changeProfilePic(ImageSource.camera);
                      },
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: appColors.secondColor,
                      ),
                      label: MediunText(text: "Camera Image", color: appColors.secondColor,)
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(appColors.white),
                        padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                      ),
                      onPressed: (){
                        _changeProfilePic(ImageSource.gallery);
                      },
                      icon: Icon(
                        Icons.image,
                        color: appColors.secondColor,
                      ),
                      label: MediunText(text: "Gallery Image", color: appColors.secondColor,)
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  //CHANGE PROFILE PICTURE METHOD
  Future<void> _changeProfilePic(ImageSource imageType) async{
     try{

       final XFile? pickPhoto = await _picker.pickImage(source: imageType);
       if(pickPhoto == null) return;

       SharedPreferences localStorage = await SharedPreferences.getInstance();
       //Store Data
       var token = localStorage.getString('token');

       String url = APIService.updateProfileUrl;
       Map<String, String> headers = {
         "Accept" : "application/json",
         "Authorization" : "Bearer $token",
       };
       Map<String, String> body = {
         "name":Name,
         "email" :Email,
       };
       var request = http.MultipartRequest('POST', Uri.parse(url))
       ..fields.addAll(body)
         ..headers.addAll(headers)
         ..files.add(await http.MultipartFile.fromPath('profile', pickPhoto.path.toString()));
       var response = await request.send();
       print(response.statusCode);
       if (response.statusCode == 201) {
         Navigator.pop(context);
        ShowToast("Profile Picture uploaded").successToast();
       } else {
         print(response.statusCode);
         ShowToast("Profile uploaded Faild").errorToast();
       }
       setState((){
         imagePickFile = File(pickPhoto.path);
         print(imagePickFile);

       });

     }catch(e){
       debugPrint(e.toString());
     }
  }


//CHANGE PROFILE input METHOD
  void _userInfoUpdate() async{

      String name;
      String email;
      setState(() {
        _isProfileUpdate = true;
        if(_name.text == null && _email.text == null ){
          check = "check all";
        }
      });
      if(_name.text == null && _email.text == null ){
        name = Name;
        email = Email;
      }else{
        name = _name.text;
        email = _email.text;
      }

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      //Store Data
      var token = localStorage.getString('token');
      final response = await http.post(Uri.parse(APIService.updateProfileUrl),
          body: {
            "name":name,
            "email" : email,
          },
          headers: {
            "Authorization" : "Bearer $token",
            "Accept" : "application/json",
          }
      );
      if(response.statusCode == 201){
        Navigator.pop(context);
        ShowToast('Profile Information Updated').successToast();
      }else{
        ShowToast("Field must not be empty").errorToast();
      }
      setState(() {
        _isProfileUpdate = false;
      });
    }



}

