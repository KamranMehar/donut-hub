
import 'package:donut_hub/authentication%20pages/login_with_phonenumber.dart';
import 'package:donut_hub/authentication%20pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui_pages/home.dart';
import '../util/Util.dart';
import '../util/custom_button.dart';

///Login page
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool loading=false;
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  bool visiblePas=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: RadialGradient(colors: [
            Colors.pink.shade100,
            Colors.pink.shade700,
          ],
            radius:1.5,)
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:  [
                ///greeting text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child:  Text("Hello Again",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.white),),
                ),
                const SizedBox(height: 10,),
                const  Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Welcome Back, you've been missed!",style: TextStyle(fontSize: 18,color: Colors.white60),),
                ),
                const SizedBox(height: 5,),
                Form(
                  key: _formKey,
                    child:Column(children: [
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
                              hintStyle: TextStyle(color: Colors.grey)
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
                              return "Password is Empty";
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
                    text: 'Login', click: () {
                    if(_formKey.currentState!.validate()){
                      setState(() {
                        loading=true;
                      });
                      loginUser(emailController.text, passwordController.text, context);
                    }
                  },)
                ),
                const SizedBox(height: 5,),
                ///Login with phone
                InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                         const LoginWithPhone()
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Hero(
                        tag: 'phone',
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              border: Border.all(color: Colors.pink,width: 1),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Login with phone number ",style: TextStyle(fontSize: 15,color:Colors.white,fontWeight: FontWeight.bold),),
                              Icon(Icons.phone,color: Colors.white,)
                            ],),
                        ),
                      ),)),
                const SizedBox(height: 8,),
                ///Not a member
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Sign_up()));
                  },
                  child: Padding(padding: const EdgeInsets.all(0.8),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Not a member?",style: TextStyle(fontSize: 15,color:Colors.white70,),),
                        Text(" Register Now!",style: TextStyle(fontSize: 15,color:Colors.white,fontWeight: FontWeight.bold),),
                      ],),
                  ),
                ),
              ],
            ),
          
          ],)
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
  
  void loginUser(String email, String password,BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    FirebaseAuth auth=FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(email: email, password:password).then((value)
      =>{
        Util_.showToast("Login Successfully"),
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