import 'package:donut_hub/authentication%20pages/verify_code_page.dart';
import 'package:donut_hub/util/Util.dart';
import 'package:donut_hub/util/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({Key? key}) : super(key: key);

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  final auth=FirebaseAuth.instance;
  bool loading=false;
  final _formKey = GlobalKey<FormState>();
  final phoneController=TextEditingController();
  final nameController=TextEditingController();
  final countryPicker = const FlCountryCodePicker();
  CountryCode? countryCode;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'phone',
      child: Container(
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
                child: Text("A Verification Code Will be send to your number",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white60),),
              ),
             const Spacer(flex: 1,),
           Form(
               key: _formKey,
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   ///Country Code picker
                   InkWell(
                     onTap: ()async{
                       final code = await countryPicker.showPicker(context: context);
                       setState(() {
                         countryCode=code;
                       });
                     },
                     child: Container(
                       padding: const EdgeInsets.all(15),
                       decoration: BoxDecoration(
                           color: Colors.white.withOpacity(0.3),
                           border: Border.all(color: Colors.pink,width: 1),
                           borderRadius: BorderRadius.circular(15)
                       ),
                       child: Row(
                         children: [
                           Container(
                             child: countryCode!=null? countryCode!.flagImage: const Icon(Icons.flag,color: Colors.white,),
                           ),
                           Text(countryCode!=null?countryCode!.dialCode.toString():"",style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)
                         ],
                       ),
                     ),
                   ),
                   const SizedBox(width: 10,),
                   Container(
                     padding: const EdgeInsets.all(5),
                     decoration: BoxDecoration(
                         color: Colors.white.withOpacity(0.3),
                         border: Border.all(color: Colors.pink,width: 1),
                         borderRadius: BorderRadius.circular(15)
                     ),
                     width: MediaQuery.of(context).size.width*3/5,
                     child: TextFormField(
                       style: const TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
                       minLines: 1,
                       validator: (value){
                         if(value!.isEmpty){
                           return 'Phone Number Is Empty';
                         }else if(value.length<10){
                           return "Number Should be 10 digit!";
                         }
                       },
                       controller: phoneController,
                       keyboardType: TextInputType.number,
                       decoration:  InputDecoration(

                           hintText: 'Enter Phone number',
                           border: InputBorder.none,
                           hintStyle: TextStyle(color: Colors.grey[400])
                       ),
                     ),
                   ),
                 ],
               )),
              const Spacer(flex: 1,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:10),
                child: CustomButton(
                isLoading: loading,text: "send SMS",
                    click: (){
                      if(_formKey.currentState!.validate()){
                        setState(() {
                            loading=true;
                        });
                        if(countryCode==null){
                          Util_.showToast('Country Not Selected');
                          setState(() {
                            loading=false;
                          });
                        }else{
                        String number=countryCode!.dialCode;
                        number=number+phoneController.text.toString();
                        auth.verifyPhoneNumber(
                          phoneNumber: number,
                            verificationCompleted: (context){
                              setState(() {
                                loading=false;
                              });

                            },
                            verificationFailed: (FirebaseAuthException e){
                              setState(() {
                                loading=false;
                              });
                            Util_.showErrorDialog(context, e.message);
                            },
                            codeSent: (String verificationId,int? token){
                              setState(() {
                                loading=false;
                              });
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>
                                VerifyCode(verificationId: verificationId,phoneNumber: number,)));
                            },
                            codeAutoRetrievalTimeout: (e){
                              setState(() {
                                loading=false;
                              });
                            Util_.showToast(e.toString());
                            });
                        }
                      }
                    }),
              ),
             const Spacer(flex: 4,)
            ],),
          ),
        ),
      ),
    );
  }
}
