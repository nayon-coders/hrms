import 'package:flutter/cupertino.dart';

import 'mediun_text.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(margin:EdgeInsets.only(top: 20, bottom: 20), child: Image.asset("assets/images/nodata.png", width: 100, height: 100, fit: BoxFit.cover,)),
          MediunText(text: "No Data Found"),
        ],
      ),
    );
  }
}
