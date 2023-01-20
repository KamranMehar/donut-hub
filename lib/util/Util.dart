
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Util_ {
 static showToast(String text){

    Fluttertoast.showToast(
        msg: text,
        fontSize: 15,
        gravity: ToastGravity.TOP,
        textColor: Colors.white,
        backgroundColor: Colors.pinkAccent.withOpacity(0.8));
  }



 static showErrorDialog(BuildContext context,message,){
   QuickAlert.show(
     customAsset: 'lib/images/donuts/strawbery_donut_gif.gif',
       context: context,
       type: QuickAlertType.error,
       title: 'Oops...',
       borderRadius: 20,
       text: message,
       confirmBtnColor: Colors.pink,
       confirmBtnText: "OK",
   );
 }
 static showConfirmationDialog(BuildContext context,List<String> items,int totalPrice){
   QuickAlert.show(
     customAsset: 'lib/images/donuts/strawbery_donut_gif.gif',
       context: context,
       type: QuickAlertType.custom,
       title: "Order Confirmation",
       borderRadius: 20,
       confirmBtnColor: Colors.pink,
       confirmBtnText: "Confirm",
        cancelBtnText: "Cancel",
        cancelBtnTextStyle:const TextStyle(color: Colors.black),
        widget:
          TextFormField(
            decoration: const InputDecoration(
              alignLabelWithHint: true,
              hintText: 'Enter Your Order Delivery Address',
              prefixIcon: Icon(
                Icons.location_on_sharp,
              ),
            ),),


   onCancelBtnTap: (){},
     onConfirmBtnTap: (){

     },
   );
 }

}