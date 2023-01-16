import 'package:donut_hub/util/Util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../ui_pages/home.dart';
import '../util/custom_button.dart';

class VerifyCode extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
   const VerifyCode({Key? key,
  required this.verificationId,
  required this.phoneNumber,
  }) : super(key: key);

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode>{
  final auth=FirebaseAuth.instance;
  final codeController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading=false;



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: RadialGradient(colors: [
            Colors.grey.shade200,
            Colors.grey,
          ],radius: 1)
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: true,),
          body: Column(children: [
            ///Upper text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Verification",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23,color: Colors.black),),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Enter 6 digit code sent to phone number ",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15,color: Colors.white60),),
            ),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(widget.phoneNumber.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            const SizedBox(height: 50,),
            ///TextFormField
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      border: Border.all(color: Colors.pink,width: 1),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  width: MediaQuery.of(context).size.width*3/5,
                  child: TextFormField(
                    style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),
                    minLines: 1,
                    maxLength: 6,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Code Field Is Empty';
                      }else if(value.length<6){
                        return "Number Should be 6 digit!";
                      }
                    },
                    controller: codeController,
                    keyboardType: TextInputType.number,
                    decoration:  InputDecoration(
                        hintText: 'Enter 6 Digit Code here',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey[400])
                    ),
                  ),
                ),
              ),
            ],),
            //const SizedBox(height: 20,),
           const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:20,vertical: 60),
              child: CustomButton(
                isLoading: loading,
                 text: "Verify",
                  click: ()async{
                  if(_formKey.currentState!.validate()){
                    setState(() {
                      loading=true;
                    });
                    final credential=PhoneAuthProvider.credential(
                        verificationId: widget.verificationId, smsCode: codeController.text);
                    try{
                    await auth.signInWithCredential(credential).then((value) async {
                      DatabaseReference databaseReference= FirebaseDatabase.instance.ref("Users/${auth.currentUser!.uid}/phoneNumber/");
                      databaseReference.set(widget.phoneNumber,).then((value) {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                      }).onError((error, stackTrace) {
                        setState(() {
                          loading=false;
                        });
                        Util_.showErrorDialog(context, error.toString());
                      });

                    }
                        )
                        .onError((error, stackTrace) {
                      Util_.showToast(error.toString());
                      setState(() {
                        loading=false;
                      });
                    });

                    }catch(e){
                      setState(() {
                        loading=false;
                      });
                      Util_.showToast( e.toString());
                    }
                  }
                  }),
            ),

          ],),
        ),
      ),
    );
  }
}
