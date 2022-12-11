
import 'package:donut_hub/admin%20pages/add_item.dart';
import 'package:donut_hub/authentication%20pages/login_page.dart';
import 'package:donut_hub/ui_pages/profile.dart';
import 'package:donut_hub/util/Util.dart';
import 'package:donut_hub/util/roundI_icon_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../tab/burger_tab.dart';
import '../tab/donut_tab.dart';
import '../tab/pancake_tab.dart';
import '../tab/pizza_tab.dart';
import '../tab/smoothie_tab.dart';
import '../util/constents.dart';
import '../util/my_tab.dart';
import '../util/round_profile_icon.dart';
import 'cart.dart';
String? userName;
String? userEmail;
String? phoneNumber;
String? userImage;
class Home extends StatefulWidget {
  static String id="home_screen";
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  /// my tabs
  List<Widget> myTabs =  [
    // donut tab
    MyTab(
      iconPath: 'lib/icons/donut.png', label: 'Donut',
    ),

    // burger tab
    MyTab(
      iconPath: 'lib/icons/burger.png', label: 'Burger',
    ),

    // smoothie tab
    MyTab(
      iconPath: 'lib/icons/smoothie.png', label: 'Smoothie',
    ),

    // pancake tab
    MyTab(
      iconPath: 'lib/icons/pancakes.png', label: 'PanCakes',
    ),

    // pizza tab
    MyTab(
      iconPath: 'lib/icons/pizza.png', label: 'Pizza',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                    onTap: (){
                      setState(() {
                        _scaffoldKey.currentState?.openDrawer();
                      });
                    })
              ),
              //Account
              actions: [
                ///Profile Icon
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Hero(
                    tag: 'profile',
                    child: ProfileIcon(
                        hight:60,
                        width: 60,
                        iconPath: 'lib/icons/avatar_women.json',
                        onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProfilePage()));
                    }),
                  )
                ),
                ///Cart Icon
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Hero(
                    tag: 'cart',
                    child: RoundIconButton(
                        hight: 50,
                        widgh: 50,
                        iconPath: 'lib/icons/cart.png',
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context)=>const Cart()));
                          setState(() {});
                        }),
                  ),
                ),
              ],
            ),
           floatingActionButton: FloatingActionButton(
             heroTag: 'addItem',
             onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=> AddItem()));
           },
           child: Icon(Icons.add,color: Colors.white,),),
           ///Drawer
           drawer:  Drawer(width: 250,
             backgroundColor: Colors.pink.withOpacity(0.5),
             child: const MyDrawer(), ),

         body: Column(
               children: [
                 ///I want to EAT
                 Padding(
                   padding: const EdgeInsets.all(5),
                   child: Row(
                     children:  [
                       Text('I want to ',style: GoogleFonts.xanhMono(textStyle: const TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w100,)),),
                       Text('EAT',
                           style: GoogleFonts.oswald(
                               textStyle: const TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold,)
                           )),
                     ],),
                 ),
                 ///TabBar
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 5),
                   child: TabBar(tabs: myTabs,
                   indicator: BoxDecoration(
                     border: Border.all(color: Colors.pink,width: 2),
                     borderRadius: BorderRadius.circular(15)
                   ),),
                 ),
                 ///TabView
                 Expanded(
                   child: TabBarView(
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
 /*   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black26,));*/
    ///Lock orientations on Mobile Devices
    if(defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]);
    }
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
    getUserData();
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if(userImage!=null)
        UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.pink),
            // currentAccountPictureSiconst ze: Size(80, 80),
            currentAccountPicture:  Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: CircleAvatar(
                backgroundColor: Colors.white, backgroundImage:
              NetworkImage(userImage!,),),
            ),
            accountName: HeadingText(
                text: userName??"Not Found", color: Colors.white, isUnderline: false),
            accountEmail: NormalText(text: userEmail??phoneNumber??"Not Found", color: Colors.grey.shade400)
        ),
        ///User Detail not Found
        Visibility(
          visible: userName!=null?false:true,
            child: HeadingText(text: "Complete Your Personal Details", color: Colors.white, isUnderline: false)),
        ListTile(leading: Lottie.asset('lib/icons/heart.json',),
          title: const Text('Favourites',
            style: TextStyle(fontSize: 18, color: Colors.white),),),
        ListTile(leading: Lottie.asset('lib/icons/settings.json'),
          title: const Text(
            'Settings', style: TextStyle(fontSize: 18, color: Colors.white),),),
        InkWell(
          onTap: () async {
          SharedPreferences pref=await SharedPreferences.getInstance();
          try{
            FirebaseAuth.instance.signOut().then((value) =>{
              pref.setBool("isLogin", false),
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()))
            });
          }on FirebaseAuthException catch (e){
            Util_.showErrorDialog(context, e.message);
          }

          },
          child: ListTile(leading: Lottie.asset('lib/icons/logout.json'),
            title: const Text(
              'Logout', style: TextStyle(fontSize: 18, color: Colors.white),),),
        )
      ],
    );
  }
  getUserData() async{
    var userId=FirebaseAuth.instance.currentUser!.uid;
    var ref=FirebaseDatabase.instance.ref("Users/$userId");
    final snapshot = await ref.get();
    if (snapshot.exists) {
      Map<dynamic,dynamic> mapList=snapshot.value as dynamic;
      setState(() {
        if(mapList['userImage']!=null){
          userImage=mapList['userImage'];
        }
        if(mapList['email']!=null){
        userEmail=mapList['email'];
        }
        if(mapList['name']!=null){
        userName=mapList['name'];
        }
        if(mapList['phoneNumber']!=null){
        phoneNumber=mapList['phoneNumber'];
        }
      });

    }
  }
}
