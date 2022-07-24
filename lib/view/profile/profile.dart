import 'dart:convert';
import 'dart:io';
import 'package:HRMS/service/api-service.dart';
import 'package:HRMS/view/global_widget/big_text.dart';
import 'package:HRMS/view/global_widget/show-toast.dart';
import 'package:http/http.dart' as http;
import 'package:HRMS/controller/profile/profile-coltroller.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/attendance/attendance.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:HRMS/view/home_screen/home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
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

  var Name;
  var Email;

  final TextEditingController _name = TextEditingController();

  final TextEditingController _email = TextEditingController();
  TextEditingController _newPass = TextEditingController();

  TextEditingController _reTypePass = TextEditingController();

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

  bool _isChange = false;
  final _changePassKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: appColors.bg,
      body: _isLogout
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: appColors.secondColor,
                    strokeWidth: 3,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MediunText(text: "Logout processing..."),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2.2,
                    decoration:  BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color(0xff00315E),
                        Color(0xff580082)
                      ],
                    )),
                    child: Stack(
                      clipBehavior: Clip.antiAlias,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 6.h, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color: appColors.white,
                                      )),
                                  MediunText(
                                    text: "Employee Profile",
                                    size: 11.sp,
                                    color: appColors.white,
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {
                                    _logout();
                                  },
                                  icon: Icon(
                                    Icons.logout,
                                    color: appColors.white,
                                  ))
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 5.h,
                            width: width,
                            decoration: BoxDecoration(
                                color: appColors.bg,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: width,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    transform: Matrix4.translationValues(0.0, -12.h, 0.0),
                    height: MediaQuery.of(context).size.height / 6,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 3,
                          blurRadius: 20,
                          offset: Offset(0, 7), // changes position of shadow
                        ),
                      ],
                      color: appColors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: FutureBuilder(
                        future: userProfile,
                        builder: (context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Shimmer.fromColors(
                                baseColor: Colors.white,
                                highlightColor: Colors.grey,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(30),
                                      width: 100,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: appColors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: 2, color: appColors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 150,
                                            height: 30,
                                            color: appColors.white,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            width: 100,
                                            height: 15,
                                            color: appColors.white,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () =>
                                                    _shoBottomSheet(context),
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      top: 5,
                                                      bottom: 5),
                                                  width: 60,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          appColors.mainColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 5,
                                                    bottom: 5),
                                                width: 60,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    color:
                                                        appColors.secondColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ));
                          } else if (snapshot.hasData) {
                            var avatar = snapshot.data?.userDetail.avatar;
                            if (avatar != null) {
                              _isProfilePic = true;
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _isProfileUpdate ? Container(
                                  width: 100,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 2, color: appColors.white),
                                  ),
                                  child: Column(
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
                                        child: MediunText(text: "Uploading..."),
                                      ),
                                    ],
                                  ),
                                ): Container(
                                  transform:
                                      Matrix4.translationValues(0.0, -5.h, 0.0),
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  width: 100,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 2, color: appColors.white),
                                  ),
                                  child: imagePickFile != null
                                      ? Image.file(
                                          imagePickFile!,
                                          height: 130,
                                          width: 130,
                                        )
                                      : _isProfilePic
                                          ? Image.network(
                                              "https://asiasolutions.xyz/storage/uploads/avatar/$avatar",
                                              height: 130,
                                              width: 130,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              "assets/images/user.jpg",
                                              height: 130,
                                              width: 130,
                                            ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BigText(
                                        text:
                                            "${snapshot.data?.userDetail.name}",
                                        size: 12.sp,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      MediunText(
                                          text:
                                              "${snapshot.data?.userDetail.email}"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () =>
                                                _shoBottomSheet(context),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5),
                                              decoration: BoxDecoration(
                                                  color: appColors.mainColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: Center(
                                                child: Text(
                                                  "Upload Image",
                                                  style: TextStyle(
                                                      color: appColors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 10.sp),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 5,
                                                bottom: 5),
                                            decoration: BoxDecoration(
                                                color: appColors.secondColor,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Center(
                                              child: Text(
                                                "${snapshot.data?.userDetail.type}",
                                                style: TextStyle(
                                                    color: appColors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 10.sp),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Shimmer.fromColors(
                                baseColor: Colors.white,
                                highlightColor: Colors.grey,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(30),
                                      width: 100,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: appColors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: 2, color: appColors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 150,
                                            height: 30,
                                            color: appColors.white,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            width: 100,
                                            height: 15,
                                            color: appColors.white,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () =>
                                                    _shoBottomSheet(context),
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      top: 5,
                                                      bottom: 5),
                                                  width: 60,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          appColors.mainColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 5,
                                                    bottom: 5),
                                                width: 60,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    color:
                                                        appColors.secondColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )); //mm
                          }
                        }),
                  ),

                  //TODO: body
                  InkWell(
                    onTap: () {
                      setState(() {
                        _name.text = Name;
                        _email.text = Email;
                      });
                      _profileUpdatePopUp(context);
                    },
                    child: Container(
                      transform: Matrix4.translationValues(0.0, -2.h, 0.0),
                      margin: EdgeInsets.only(left: 20, right: 20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 7), // changes position of shadow
                          ),
                        ],
                        color: appColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_circle_rounded,
                            color: appColors.black,
                            size: 20.sp,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          BigText(
                            text: "Change Profile Information",
                            size: 10.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      changepassword();
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 7), // changes position of shadow
                          ),
                        ],
                        color: appColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.list_alt_outlined,
                            color: appColors.black,
                            size: 20.sp,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          BigText(
                            text: "Change Password",
                            size: 10.sp,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.dashboard,
                          color: appColors.mainColor,
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
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Attendance()));
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 0), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(100),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Color(0xff00315E),
                              Color(0xff580082),
                            ],
                          )),
                      child: const Icon(
                        Icons.add,
                        color: appColors.white,
                      ),
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Profile()));
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
    );
  }

  //TODO: Profile Update popup builder
  Future<void> _profileUpdatePopUp(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return _isProfileUpdate
              ? Container(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: appColors.mainColor,
                    ),
                  ))
              : AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  content: Container(
                    height: 220,
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        BigText(
                          text: "Change Information",
                          size: 12,
                        ),
                        Container(
                          width: 80,
                          height: 3,
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: appColors.secondColor),
                        ),
                        Container(
                          width: 60,
                          height: 3,
                          margin: const EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: appColors.secondColor),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: changeInfoForm,
                          child: Column(
                            children: [
                              TextFormField(
                                onChanged: (value) {},
                                controller: _name,
                                decoration: InputDecoration(
                                  hintText: "Enter Your Name",
                                  contentPadding:
                                      EdgeInsets.only(left: 20, right: 20),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      borderSide: BorderSide(
                                        width: 3,
                                        color: appColors.bg,
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _email,
                                decoration: InputDecoration(
                                  hintText: "Enter your email",
                                  contentPadding:
                                      EdgeInsets.only(left: 20, right: 20),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      borderSide: BorderSide(
                                        width: 3,
                                        color: appColors.bg,
                                      )),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _userInfoUpdate();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  width: MediaQuery.of(context).size.width / 3,
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: appColors.secondColor),
                                  child: Center(
                                      child: Text(
                                    "Save Changes",
                                    style: TextStyle(
                                        color: appColors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11.sp),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
        });
  }

  //TODO: Show Show Bottom Sheets builder
  void _shoBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isDismissible: _isProfileUpdate,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (BuildContext Context) {
          return Container(
            padding:
                EdgeInsets.only(left: 1.h, right: 1.h, top: 2.h, bottom: 2.h),
            height: 20.h,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(appColors.white),
                        padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                      ),
                      onPressed: () {
                        _changeProfilePic(ImageSource.camera);
                      },
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: appColors.secondColor,
                      ),
                      label: MediunText(
                        text: "Camera Image",
                        color: appColors.secondColor,
                      )),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(appColors.white),
                        padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                      ),
                      onPressed: () {
                        _changeProfilePic(ImageSource.gallery);
                      },
                      icon: Icon(
                        Icons.image,
                        color: appColors.secondColor,
                      ),
                      label: MediunText(
                        text: "Gallery Image",
                        color: appColors.secondColor,
                      )),
                ),
              ],
            ),
          );
        });
  }

  //TODO: CHANGE PROFILE PICTURE METHOD
  Future<void> _changeProfilePic(ImageSource imageType) async {
    setState(() {
      _isProfileUpdate = true;
      Navigator.pop(context);
    });
    try {
      final XFile? pickPhoto = await _picker.pickImage(source: imageType);
      if (pickPhoto == null) return;

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      //Store Data
      var token = localStorage.getString('token');

      String url = APIService.updateProfileUrl;
      Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
      Map<String, String> body = {
        "name": Name,
        "email": Email,
      };
      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields.addAll(body)
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath(
            'profile', pickPhoto.path.toString()));
      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 201) {
        setState(() {
          _isProfileUpdate = false;
        });
        ShowToast("Profile Picture uploaded").successToast();
      } else {
        print(response.statusCode);
        ShowToast(
                "Sorry. Profile picture uploaded failed. Something went warning with server.")
            .errorToast();
      }
      setState(() {
        imagePickFile = File(pickPhoto.path);
        _isProfileUpdate = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      _isProfileUpdate = false;
    });

  }

  ///TODO: CHANGE PROFILE input METHOD
  void _userInfoUpdate() async {
    if (_name.text.isNotEmpty && _email.text.isNotEmpty) {
      String name;
      String email;
      setState(() {
        _isProfileUpdate = true;
        if (_name.text == null && _email.text == null) {
          check = "check all";
        }
      });
      if (_name.text == null && _email.text == null) {
        name = Name;
        email = Email;
      } else {
        name = _name.text;
        email = _email.text;
      }

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      //Store Data
      var token = localStorage.getString('token');
      final response =
          await http.post(Uri.parse(APIService.updateProfileUrl), body: {
        "name": name,
        "email": email,
      }, headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });
      if (response.statusCode == 201) {
        Navigator.pop(context);
        ShowToast(jsonDecode(response.body)["message"]).successToast();
        localStorage.remove('token');
        localStorage.remove('name');
        localStorage.remove('email');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        ShowToast(
                "${jsonDecode(response.body)["message"]} and Your are logout. Please login again with your new credential")
            .successToast();
      } else {
        _Error(response.statusCode);
      }
    } else {
      ShowToast("Field much not be empty.").errorToast();
    }
    setState(() {
      _isProfileUpdate = false;
    });
  }

  //TODO: change password Method
  Future<void> changepassword() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          content: Container(
            height: 220,
            margin: EdgeInsets.only(top: 25, bottom: 25, left: 3, right: 3),
            child: Form(
                key: _changePassKey,
                child: Column(
                  children: [
                    BigText(
                      text: "Change Password",
                      size: 12,
                    ),
                    Container(
                      width: 80,
                      height: 3,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: appColors.secondColor),
                    ),
                    Container(
                      width: 60,
                      height: 3,
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: appColors.secondColor),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _isChange
                        ? Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 5,
                              color: appColors.secondColor,
                            ),
                          )
                        : Column(
                            children: [
                              TextFormField(
                                controller: _newPass,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      borderSide: BorderSide(
                                        width: 3,
                                        color: appColors.bg,
                                      )),
                                  hintText: "New Password",
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: _reTypePass,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      borderSide: BorderSide(
                                          width: 3, color: appColors.bg)),
                                  hintText: "Retype Password",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _changePass();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 15),
                                  width: MediaQuery.of(context).size.width / 3,
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: appColors.secondColor),
                                  child: Center(
                                      child: Text(
                                    "Save Changes",
                                    style: TextStyle(
                                        color: appColors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9.sp),
                                  )),
                                ),
                              ),
                            ],
                          )
                  ],
                )),
          ),
        );
      },
    );
  }

  void _changePass() async {
    setState(() {
      _isChange = true;
    });
    if (_newPass.text.isNotEmpty && _newPass.text.isNotEmpty) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      //Store Data
      var data = {
        "current_password": _newPass.text,
        "new_password": _newPass.text,
        "confirm_password": _reTypePass.text,
      };
      var token = localStorage.getString('token');
      var url = Uri.parse(APIService.updateChangePassUrl);
      final response = await http.post(
        url,
        body: data,
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      print(jsonEncode(data));
      if (response.statusCode == 201) {
        setState(() {
          _isChange = false;
          _newPass.clear();
          _reTypePass.clear();
          ShowToast("Password Changed Success").successToast();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        });
      } else {
        _Error(response.statusCode);
        setState(() {
          _isChange = false;
        });
      }
    } else {
      setState(() {
        ShowToast("Field much not be empty.").errorToast();
        _isChange = false;
      });
    }
  }

  void _logout() async {
    setState(() {
      _isLogout = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');

    final respons = await http.post(Uri.parse(APIService.logoutUrl),
        body: jsonEncode("object"),
        headers: {"Authorization": "Bearer $token"});
    if (respons.statusCode == 200) {
      localStorage.remove('token');
      localStorage.remove('name');
      localStorage.remove('email');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      _Error(respons.statusCode);
      print("faild");
    }

    setState(() {
      _isLogout = false;
    });
  }

  Future _Error(StatusCode) async {
    return showDialog<void>(
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
                BigText(
                  text: "${StatusCode}",
                  size: 40.sp,
                  color: appColors.secondColor,
                ),
                BigText(
                  text: "Server Error",
                  size: 15.sp,
                  color: appColors.black,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Text(
                      "Access to this resource on the server is denied!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 12.sp),
                    )),
                SizedBox(
                  height: 5.h,
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile()));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
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
                        ]),
                    child: Center(
                        child: MediunText(
                      text: "Try again",
                      size: 12.sp,
                      color: appColors.white,
                    )),
                  ),
                )
              ],
            ),
          )),
    );
  }

}
