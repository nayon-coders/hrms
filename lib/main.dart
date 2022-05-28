import 'package:HRMS/view/flash_screen/flash-screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: "Roboto",
            ),
            home: FlashScreen(),
            localizationsDelegates: [
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              MonthYearPickerLocalizations.delegate,
            ],
          );

        }
    );

  }
}