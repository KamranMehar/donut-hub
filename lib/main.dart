import 'package:donut_hub/authentication%20pages/login_page.dart';
import 'package:donut_hub/ui_pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
bool? isLogin;
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  ///If user already login to the app then open Home page else open login page
  if(FirebaseAuth.instance.currentUser!=null && pref.getBool("isLogin")==true){
    isLogin=true;
  }
  if(FirebaseAuth.instance.currentUser==null && pref.getBool("isLogin")==false){
    isLogin=false;
  }
  if(FirebaseAuth.instance.currentUser==null && pref.getBool("isLogin")==null){
    isLogin=false;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: isLogin==false ? "first" : "/",
      routes: {
        '/': (context)=>const Home(),
        'first': (context)=>const LoginPage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
    );
  }
}
