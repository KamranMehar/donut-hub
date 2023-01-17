import 'dart:async';

import 'package:donut_hub/util/constents.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class OrderConfirmationScreen extends StatefulWidget {
   OrderConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {

TextEditingController addressController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Container(
      decoration:  const BoxDecoration(
        image: DecorationImage(image: AssetImage('lib/images/donuts/purple_donut.gif'),fit: BoxFit.fitHeight,
            opacity: 1),
      /*  gradient: RadialGradient(colors: [
          Color(0xff7ba7c2),
          Color(0xff517396),
        ], radius: 1
        ),*/
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: HeadingText(text: "Confirmation", color: Colors.white),
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.transparent,
        body:
        Column(
          children: [
            NormalText(text: "Enter Your Order Delivery Address", color: Colors.white,size: 18,),
            Form(
                key: _formKey,
                child:
                Container(
                  padding:const EdgeInsets.symmetric(horizontal: 5),
                  margin: const EdgeInsets.all( 12),
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[400],
                      border: Border.all(color: Colors.white,width: 1)
                  ),
                  child:   TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return "Address is Empty";
                      }
                    },
                    controller: addressController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.location_on,color: Colors.black26,),
                        border: InputBorder.none,
                        hintText: 'Address',
                        hintStyle: TextStyle(color: Colors.black26)
                    ),
                  ),
                ),),
          ],
        ),
      ),
    );
  }
}
