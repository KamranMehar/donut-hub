

import 'package:donut_hub/admin%20pages/orders_screen.dart';
import 'package:donut_hub/authentication%20pages/login_page.dart';
import 'package:donut_hub/notification_service/local_notification_service.dart';
import 'package:donut_hub/provider/credit_card_selection_provider.dart';
import 'package:donut_hub/ui_pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> backgroundHandler(RemoteMessage message)async{
  print(message.data.toString());
  print(message.notification!.title);
}
bool? isLogin;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
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
  runApp(
      const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>CardSelectProvider()),
      ],
      child: MaterialApp(
        initialRoute: isLogin==false ? "first" : "/",
        routes: {
          '/': (context)=> Home(),
          'first': (context)=>const LoginPage(),
          OrdersScreen.id: (context)=>OrdersScreen(),
        },
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        ///Generally set the them data _StatusBar Color etc
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  //for Android devices
                  statusBarIconBrightness: Brightness.dark,
                  //for IOS Devices
                  statusBarBrightness: Brightness.light
              )
          ),
          primarySwatch: Colors.pink,
        ),
        navigatorKey: navigatorKey,
      ),
    );
  }
}
