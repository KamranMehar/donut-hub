import 'package:donut_hub/util/constents.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingOrderScreen extends StatefulWidget {
  const PendingOrderScreen({Key? key}) : super(key: key);

  @override
  State<PendingOrderScreen> createState() => _PendingOrderScreenState();
}

class _PendingOrderScreenState extends State<PendingOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          //changing the colors of status bar icons to white (light) /for Android
          statusBarIconBrightness: Brightness.light,
            //changing the colors of status bar icons to white (light) /for IOS
          statusBarBrightness: Brightness.light
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          SizedBox(height: 35,width: 35,
          child: Image.asset("lib/icons/donut.png",color: Colors.white,),),
            const SizedBox(width: 5,),
            HeadingText(text: "Donut Hub", color: Colors.white,size: 21,)
        ],),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body:
      Column(
        children:[
          Center(child: HeadingText(text: "Your order is on its way !", color: Colors.black,size: 21,)),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 250,
                width: 250,
                child: Image.asset('lib/images/rider.gif',)),
          ),
          Center(child: HeadingText(text: "Here\'s your receipt", color: Colors.black,size: 18,),)
        ],
      ),
    );
  }
}
