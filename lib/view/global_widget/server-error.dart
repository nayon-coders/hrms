import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:flutter/cupertino.dart';



class ServerError extends StatelessWidget {
  const ServerError({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(margin:EdgeInsets.only(top: 20, bottom: 20), child: Image.asset("assets/images/server.png", width: 80, height: 80, fit: BoxFit.cover,)),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: MediunText(text: "Access to this resource on the server is denied!", size: 12, ),
          )
        ],
      ),
    );
  }
}
