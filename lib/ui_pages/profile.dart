import 'package:donut_hub/ui_pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui' as ui;
import '../util/constents.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  static String id="profile_page";
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    final Size size=MediaQuery.of(context).size;

    return Stack(children: [
      Hero(tag: 'profile',
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),),
      Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children:   [
            SizedBox(height: size.height,width: size.width,),
            Align(
              alignment: Alignment.topCenter,
              child: CustomPaint(
                size: Size(size.width,(size.width*0.625).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                painter: RPSCustomPainter(),
              ),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ///Back Icon
                      SafeArea(child: Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                            onTap: (){
                              //clear all screens from stack except new
                              Navigator.pop(context);
                            }, child: SizedBox(
                            height: 60,width: 60,
                            child: Lottie.asset('lib/icons/arrow_left.json',fit: BoxFit.cover))),
                      ),),
                      ///Profile Image
                      Padding(padding: const EdgeInsets.only(bottom: 5),
                        child: Hero(
                          tag: 'dp',
                          child: CircleAvatar(
                            radius: 53,
                            backgroundColor: Colors.purple,
                            child: StreamBuilder(
                              stream: Home.imageStreamController.stream,
                              builder: (context,snap) {
                                if(snap.hasData){
                                return CircleAvatar(
                                  backgroundColor: Colors.purple,
                                  radius: 50,
                                  backgroundImage:NetworkImage(snap.data.toString())
                                );
                                }else {
                                  return const CircleAvatar(
                                      backgroundColor: Colors.purple,
                                      radius: 50,
                                      backgroundImage:AssetImage('lib/images/user.png')
                                  );
                                }
                              }
                            ),
                          ),
                        ),),
                      ///name
                      Hero(
                          tag: 'name',
                          child: StreamBuilder(
                            stream: Home.nameStreamController.stream,
                            builder: (context,snap) {
                              if(snap.hasData) {
                                return HeadingText(text:snap.data.toString(), color: Colors.black,
                                  isUnderline: false,
                                  size: 25,);
                              }else{
                                return HeadingText(text:"", color: Colors.black,
                                  isUnderline: false,
                                  size: 25,);
                              }
                            }
                          )),
                      const SizedBox(height: 5,),
                      ///email or phone
                      StreamBuilder(
                          stream: Home.emailStreamController.stream,
                          builder: (context,snap){
                            if(snap.hasData){
                              return Hero(
                                  tag: 'email',
                                  child: NormalText(text: snap.data.toString(), color: Colors.grey.shade800,size: 18,));
                            }else{
                              return StreamBuilder(
                                  stream: Home.phoneStreamController.stream,
                                  builder: (context,snap){
                                if(snap.hasData){
                                 return Hero(
                                    tag: 'phone',
                                    child: NormalText(text: snap.data.toString(), color: Colors.grey.shade800,size: 18,),
                                  );
                                }else{
                                return  Hero(
                                    tag: 'phone',
                                    child: NormalText(text: "", color: Colors.grey.shade800,size: 18,),
                                  );
                                }
                              }

                              );
                            }

                      })
                      ,
                      const SizedBox(height: 5,),

                      ///Edit Profile btn
                      InkWell(
                        onTap: (){
                          setState(() {
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>const EditProfile()));
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 90,
                          decoration:  BoxDecoration(
                              gradient:  LinearGradient(colors: [
                                Colors.pink,
                                Colors.pink.shade200,
                              ]),
                              borderRadius:const BorderRadius.all(Radius.circular(15))
                          ),
                          child: Center(child: NormalText(text: 'Edit Profile', color: Colors.white,size: 15,)),
                        ),
                      ),
                      ///Recently ordered txt
                      Padding(
                        padding:const EdgeInsets.all(5),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: NormalText(text: 'Recently Ordered', color: Colors.grey.shade800,size: 15,)),
                      ),
                    ],),
                )
            ),
          ],
        ),
      ),
    ],);
  }

 /* getUserData()async{
    var userId=FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref=FirebaseDatabase.instance.ref("Users/$userId");
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
          userPhoneNumber=mapList['phoneNumber'].toString();
        }
      });

    }
  }*/

  @override
  void initState() {
    Home.getUserData();
    super.initState();
  }
}
class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 243, 33, 118)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;
    paint0.shader = ui.Gradient.linear(Offset(size.width*-0.01,size.height*0.34),Offset(size.width*1.00,size.height*0.34),[Color(0xffff00b8),Color(0xffff0002)],[0.00,1.00]);

    Path path0 = Path();
    path0.moveTo(0,0);
    path0.lineTo(size.width*0.9987500,size.height*-0.0020000);
    path0.quadraticBezierTo(size.width*0.8678125,size.height*0.7005000,size.width*0.4925000,size.height*0.7040000);
    path0.cubicTo(size.width*0.1178125,size.height*0.6985000,size.width*-0.0090625,size.height*-0.0265000,size.width*-0.0012500,size.height*-0.0020000);
    path0.quadraticBezierTo(size.width*-0.0012500,size.height*-0.0020000,0,0);
    path0.close();

    canvas.drawPath(path0, paint0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
