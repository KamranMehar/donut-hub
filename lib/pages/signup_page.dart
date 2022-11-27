

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/Util.dart';
import '../util/custom_button.dart';
import 'home.dart';
import 'login_page.dart';


class Sign_up extends StatefulWidget {
   Sign_up({Key? key}) : super(key: key);

  @override
  State<Sign_up> createState() => _Sign_upState();
}

class _Sign_upState extends State<Sign_up> {
  final _formKey = GlobalKey<FormState>();
  bool loading=false;

  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
 // TextEditingController nameTextController=TextEditingController();
  bool visiblePas=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: RadialGradient(colors: [
            Colors.pink.shade700,
            Colors.pink.shade100,
          ],
            radius:1.5,)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:  [
              ///greeting text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child:  Text("Welcome!",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.white),),
              ),
              const SizedBox(height: 10,),
              const  Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Hope you will love this service!",style: TextStyle(fontSize: 18,color: Colors.white70),),
              ),
              const SizedBox(height: 5,),
              ///Name
             /* Container(
                padding:const EdgeInsets.symmetric(horizontal: 5),
                margin: const EdgeInsets.all( 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.white,width: 1)
                ),
                child:   TextField(
                  controller: nameTextController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name',
                      hintStyle: TextStyle(color: Colors.grey)
                  ),
                ),
              ),*/
           Form(
             key: _formKey,
               child: Column(children: [
             ///Email
             Container(
               padding:const EdgeInsets.symmetric(horizontal: 5),
               margin: const EdgeInsets.all( 12),
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(15),
                   color: Colors.grey[100],
                   border: Border.all(color: Colors.white,width: 1)
               ),
               child:   TextFormField(
                 validator: (value){
                   if(value!.isEmpty){
                     return "Email is Empty";
                   }
                 },
                 controller: emailController,
                 keyboardType: TextInputType.emailAddress,
                 decoration: const InputDecoration(
                     border: InputBorder.none,
                     hintText: 'Email',
                     hintStyle: TextStyle(color: Colors.grey),
                 ),
               ),
             ),
             ///Password
             Container(
               padding:const EdgeInsets.symmetric(horizontal: 5),
               margin: const EdgeInsets.all( 12),
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(15),
                   color: Colors.grey[100],
                   border: Border.all(color: Colors.white,width: 1)
               ),
               child:   TextFormField(
                 validator: (value){
                   if(value!.isEmpty){
                     return "password is Empty";
                   }
                 },
                 obscureText: visiblePas? false:true,
                 controller: passwordController,
                 keyboardType: TextInputType.visiblePassword,
                 decoration:  InputDecoration(
                     border: InputBorder.none,
                     hintText: 'Password',
                     hintStyle: const TextStyle(color: Colors.grey),
                     suffixIcon: IconButton(
                         color: Colors.grey,
                         onPressed: (){
                           if(!visiblePas){
                             visiblePas=true;
                           }else{
                             visiblePas=false;
                           }
                           setState(() {});
                         }, icon: visiblePas?const Icon(Icons.visibility_off): const Icon(Icons.visibility))
                 ),
               ),
             ),
           ],)),
              ///LoginBtn
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  isLoading: loading,
                  text: 'Signup', click: () {
                  if(_formKey.currentState!.validate()){
                    setState(() {
                      loading=true;
                    });
                    signupUser(emailController.text, passwordController.text, context);
                  }
                },),
              ),
              const SizedBox(height: 5,),
              Padding(padding: EdgeInsets.all(0.8),
                child: InkWell(
                  onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Already a member?",style: TextStyle(fontSize: 15,color:Colors.white70,),),
                      Text(" Login Now!",style: TextStyle(fontSize: 15,color:Colors.white,fontWeight: FontWeight.bold),),
                    ],),
                ),)
            ],
          ),
          ///If User Open this app first time then this icon should not show!!!
          SafeArea(
            child: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back_ios_new,color: Colors.white,size: 30,)),
          ),
        ],),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  ///Signup User and catch localized error msg
  void signupUser(String email, String password,BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    FirebaseAuth auth=FirebaseAuth.instance;
    try {
      await auth.createUserWithEmailAndPassword(email: email, password:password).then((value)
      =>{
        Util_.showToast("user Created Successfully"),
        pref.setBool("isLogin", true),
      setState(() {
      loading=false;
      }),
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Home())),
      } );
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading=false;
      });
      Util_.showErrorDialog(context, e.message);
      // Your logic for Firebase related exceptions
    } catch (e) {
      Util_.showToast(e.toString());
      setState(() {
        loading=false;
      });
      // your logic for other exceptions!
    }

  }
}