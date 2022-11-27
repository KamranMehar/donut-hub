import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Util_ {
 static showToast(String text){

    Fluttertoast.showToast(
        msg: text,
        fontSize: 15,
        gravity: ToastGravity.TOP,
        textColor: Colors.white,
        backgroundColor: Colors.pinkAccent.withOpacity(0.8));
  }

 static addToCart(String itemName,String price,String pathImage) async{
   SharedPreferences pref=await SharedPreferences.getInstance();
    var itemData=
     [itemName,price,pathImage];

   pref.setStringList("cart",itemData).whenComplete(() => Util_.showToast("$itemName is Added To cart"));
 }

 static deleteFromCart(String key)async{
   SharedPreferences pref=await SharedPreferences.getInstance();
   pref.remove(key).whenComplete(() => Util_.showToast('Deleted Successfully'));
 }

 static showErrorDialog(BuildContext context,message){
   QuickAlert.show(
       context: context,
       type: QuickAlertType.error,
       title: 'Oops...',
       borderRadius: 15,
       text: message,
       confirmBtnColor: Colors.pink,
       confirmBtnText: "OK",
   );
 }

}