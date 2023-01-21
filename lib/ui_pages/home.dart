import 'dart:async';

import 'package:badges/badges.dart';
import 'package:donut_hub/admin%20pages/add_item.dart';
import 'package:donut_hub/authentication%20pages/login_page.dart';
import 'package:donut_hub/ui_pages/profile.dart';
import 'package:donut_hub/util/Util.dart';
import 'package:donut_hub/util/roundI_icon_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../notification_service/local_notification_service.dart';
import '../tab/burger_tab.dart';
import '../tab/donut_tab.dart';
import '../tab/pancake_tab.dart';
import '../tab/pizza_tab.dart';
import '../tab/smoothie_tab.dart';
import '../util/check_internet_connection_widget.dart';
import '../util/constents.dart';
import '../util/my_tab.dart';
import 'cart.dart';


class Home extends StatefulWidget {
  static String id = "home_screen";
  static bool showCartBadge = false;
 static int counterCartBadge = 0;
  static StreamController<String> imageStreamController = StreamController<String>.broadcast();
  static StreamController<String> phoneStreamController = StreamController<String>.broadcast();
  static StreamController<String> emailStreamController = StreamController<String>.broadcast();
  static StreamController<String> nameStreamController = StreamController<String>.broadcast();
  static StreamController<int> cartBadgeStreamCn = StreamController<int>.broadcast();
  const Home({Key? key}) : super(key: key);

  static updateCartBadge()async{
    DatabaseReference ref=FirebaseDatabase.instance
        .ref("Users/"+FirebaseAuth.instance.currentUser!.uid+"/Cart");
    final snapshot = await ref.get();
    if(snapshot.exists){
      Map<dynamic, dynamic> mapList = snapshot.value as dynamic;

      if(mapList!=null){
        showCartBadge=true;
        cartBadgeStreamCn.sink.add(mapList.length);
      }else{
        showCartBadge=false;
      }
    }

  }
  static getUserData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      var userId = FirebaseAuth.instance.currentUser!.uid;
      var ref = FirebaseDatabase.instance.ref("Users/$userId");
      final snapshot = await ref.get();
      if (snapshot.exists) {
        if (snapshot.value != null) {
          Map<dynamic, dynamic> mapList = snapshot.value as dynamic;
          if (mapList['userImage'] != null) {
            Home.imageStreamController.sink.add(mapList['userImage']);
          }
          if (mapList['email'] != null) {
            emailStreamController.sink.add(mapList['email']);
          }
          if (mapList['name'] != null) {
            nameStreamController.sink.add(mapList['name']);
          }
          if (mapList['phoneNumber'] != null) {
            phoneStreamController.sink.add( mapList['phoneNumber']);
          }
        }
      }
    }
  }

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DatabaseReference userDataRef = FirebaseDatabase.instance
      .ref("Users/${FirebaseAuth.instance.currentUser!.uid}/");

  /// my tabs
  List<Widget> myTabs = [
    // donut tab
    MyTab(
      iconPath: 'lib/icons/donut.png',
      label: 'Donut', fontSize: 10,
    ),

    // burger tab
    MyTab(
      iconPath: 'lib/icons/burger.png',
      label: 'Burger', fontSize: 10,
    ),

    // smoothie tab
    MyTab(
      fontSize: 10,
      iconPath: 'lib/icons/smoothie.png',
      label: 'Smoothie',
    ),

    // pancake tab
    MyTab(
      iconPath: 'lib/icons/pancakes.png',
      label: 'PanCakes', fontSize: 10,
    ),

    // pizza tab
    MyTab(
      fontSize: 10,
      iconPath: 'lib/icons/pizza.png',
      label: 'Pizza',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    bool isAdmin = (FirebaseAuth.instance.currentUser!.uid ==
            '9IHNNPnvYZYCgQMJzJswYhVo7pl2') ? true : false;
    return Scaffold(
      body: DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,

            ///Drawer Icon,
            leading: Padding(
                padding: const EdgeInsets.all(8),
                child: RoundIconButton(
                    hight: 60,
                    widgh: 60,
                    iconPath: 'lib/icons/menu.png',
                    onTap: () {
                      setState(() {
                        _scaffoldKey.currentState?.openDrawer();
                      });
                    })),
            //Account
            actions: [
              ///Profile Icon
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Hero(
                      tag: 'profile',
                      child: StreamBuilder<String>(
                          stream: Home.imageStreamController.stream,
                          builder: (context, snapshot) {
                            Home.getUserData();
                            if (!snapshot.hasData) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ProfilePage()));
                                },
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade500,
                                            spreadRadius: 2,
                                            blurRadius: 5.0,
                                            offset: const Offset(2, 2)),
                                        const BoxShadow(
                                            color: Colors.white,
                                            spreadRadius: 2,
                                            blurRadius: 5.0,
                                            offset: Offset(-2, -2))
                                      ]),
                                  child: SizedBox(
                                      height: 35,
                                      width: 35,
                                      child: Image.asset(
                                        'lib/images/user.png',
                                        fit: BoxFit.fitHeight,
                                      )),
                                ),
                              );
                            } else {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfilePage()));
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                snapshot.data.toString()),
                                            fit: BoxFit.contain),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade500,
                                              spreadRadius: 2,
                                              blurRadius: 5.0,
                                              offset: const Offset(2, 2)),
                                          const BoxShadow(
                                              color: Colors.white,
                                              spreadRadius: 2,
                                              blurRadius: 5.0,
                                              offset: Offset(-2, -2))
                                        ]),
                                  ));
                            }
                          }))
              ),

              ///Cart Icon
              Padding(
                padding: const EdgeInsets.all(8),
                child: Hero(
                  tag: 'cart',
                  child: StreamBuilder<int>(
                    stream: Home.cartBadgeStreamCn.stream,
                    builder: (context,snap) {

                      return Badge(
                        position: BadgePosition.topEnd(top: -6,end: -5),
                        showBadge:snap.hasData,
                        badgeContent:  Text(snap.data!=null? snap.data.toString():"",style:const TextStyle(color: Colors.white),),
                        badgeColor: Colors.pink,
                        child: RoundIconButton(
                            hight: 50,
                            widgh: 50,
                            iconPath: 'lib/icons/cart.png',
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Cart()));
                              setState(() {});
                            }),
                      );
                    }
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: isAdmin
              ? FloatingActionButton(
                  heroTag: 'addItem',
                  onPressed: ()async {


                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddItem()));
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),

          ///Drawer
          drawer: Drawer(
            width: 250,
            backgroundColor: Colors.pink.withOpacity(0.5),
            child: const MyDrawer(),
          ),

          body: Column(
            children: [
              ///I want to EAT
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Text(
                      'I want to ',
                      style: GoogleFonts.xanhMono(
                          textStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w100,
                      )),
                    ),
                    Text('EAT',
                        style: GoogleFonts.oswald(
                            textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ))),
                  ],
                ),
              ),

              ///TabBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TabBar(
                  tabs: myTabs,
                  indicator: BoxDecoration(
                      border: Border.all(color: Colors.pink, width: 2),
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),

              ///TabView
              Expanded(
                child: TabBarView(
                  physics:const BouncingScrollPhysics(),
                  children: [
                    // donut page
                    DonutTab(),

                    // burger page
                    BurgerTab(),

                    // smoothie page
                    SmoothieTab(),

                    // pancake page
                    PancakeTab(),

                    // pizza page
                    PizzaTab(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
  // Timer.periodic(const Duration(seconds: 3), (timer) {Home.updateCartBadge(); });
     Home. getUserData();
    ///Lock orientations on Mobile Devices
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    }

     // 1. This method call when app in terminated state and you get a notification
     // when you click on notification app open from terminated state and you can get notification data in this method
     FirebaseMessaging.instance.getInitialMessage().then(
           (message) {
         print("FirebaseMessaging.instance.getInitialMessage");
         if (message != null) {
           print("New Notification");
           if (message.data['_id'] != null) {
             Navigator.of(context).push(
               MaterialPageRoute(
                 builder: (context) =>const Cart(),
               ),
             );
           }
         }

       },
     );

     // 2. This method only call when App in forground it mean app must be opened
     FirebaseMessaging.onMessage.listen(
           (message) {
         print("FirebaseMessaging.onMessage.listen");
         if (message.notification != null) {
           print(message.notification!.title);
           print(message.notification!.body);
           print("message.data11 ${message.data}");
           LocalNotificationService.createanddisplaynotification(message);
         }
       },
     );

     // 3. This method only call when App in background and not terminated(not closed)
     FirebaseMessaging.onMessageOpenedApp.listen(
           (message) {
         print("FirebaseMessaging.onMessageOpenedApp.listen");
         if (message.notification != null) {
           print(message.notification!.title);
           print(message.notification!.body);
           print("message.data22 ${message.data['_id']}");
         }
       },
     );
    super.initState();
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
            UserAccountsDrawerHeader(
                //  margin: const EdgeInsets.all(15),
                decoration: const BoxDecoration(color: Colors.pink),
                //  currentAccountPictureSize:const Size(80, 80),
                currentAccountPicture:  StreamBuilder<String>(
                    stream: Home.imageStreamController.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          height: 35,
                          width: 35,
                          decoration:const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              ),
                          child: SizedBox(
                              height: 35,
                              width: 35,
                              child: Image.asset(
                                'lib/images/user.png',
                                fit: BoxFit.fitHeight,
                              )),
                        );
                      } else {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const ProfilePage()));
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          snapshot.data.toString()),
                                      fit: BoxFit.contain),
                              ),
                            ));
                      }
                    }),
                ///Name
                accountName: StreamBuilder<String>(
                  stream: Home.nameStreamController.stream,
                  builder: (context,snap) {
                    if(!snap.hasData) {
                      return HeadingText(
                          text: "",
                          size: 18,
                          color: Colors.white,
                          isUnderline: false);
                    }else{
                      return HeadingText(
                          text: snap.data.toString(),
                          size: 18,
                          color: Colors.white,
                          isUnderline: false);
                    }
                  }
                ),
                ///Email and phone
                accountEmail: StreamBuilder<String>(
                  stream: Home.emailStreamController.stream,
                  builder: (context,snap) {
                    if(!snap.hasData){
                      return StreamBuilder<String>(
                          stream: Home.phoneStreamController.stream,
                          builder: (context,snap) {
                            if(!snap.hasData) {
                             return NormalText(
                                  text: "Complete Your Detail", size: 15, color: Colors.grey.shade400);
                            }else{
                              return NormalText(
                                  text: snap.data.toString(), size: 15, color: Colors.grey.shade400);
                            }
                          });
                    }else{
                      return NormalText(
                          text: snap.data.toString(), size: 15, color: Colors.grey.shade400);
                    }

                  }
                )),
          ListTile(
            leading: Lottie.asset(
              'lib/icons/heart.json',
            ),
            title: const Text(
              'Favourites',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          ListTile(
            leading: Lottie.asset('lib/icons/settings.json'),
            title: const Text(
              'Settings',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          InkWell(
            onTap: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              try {
                FirebaseAuth.instance.signOut().then((value) => {
                      pref.setBool("isLogin", false),
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()))
                    });
              } on FirebaseAuthException catch (e) {
                Util_.showErrorDialog(context, e.message);
              }
            },
            child: ListTile(
              leading: Lottie.asset('lib/icons/logout.json'),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
  @override
  void initState() {
    Home.getUserData();
    Home.updateCartBadge();

    // TODO: implement initState
    super.initState();
  }
}
