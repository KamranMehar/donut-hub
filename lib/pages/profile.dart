import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui' as ui;

import '../util/contants.dart';

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

    return Hero(
      tag: 'profile',
      child: Scaffold(
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
                              Navigator.pop(context,true);
                            }, child: SizedBox(
                            height: 60,width: 60,
                            child: Lottie.asset('lib/icons/arrow_left.json',fit: BoxFit.cover))),
                      ),),
                      ///Profile Image
                   const Padding(padding: EdgeInsets.only(bottom: 5),
                   child: CircleAvatar(
                     radius: 53,
                     backgroundColor: Colors.purple,
                     child: CircleAvatar(
                       backgroundColor: Colors.purple,
                       radius: 50,
                       backgroundImage: NetworkImage('https://media.istockphoto.com/id/1309328823/photo/headshot-portrait-of-smiling-male-employee-in-office.jpg?b=1&s=170667a&w=0&k=20&c=MRMqc79PuLmQfxJ99fTfGqHL07EDHqHLWg0Tb4rPXQc='),
                     ),
                   ),),
                     HeadingText(text: "Profile Name", color: Colors.black, isUnderline: false,size: 23,),
                     ///Edit Profile
                     Container(
                       height: 40,
                       width: 90,
                       decoration:  BoxDecoration(
                         gradient:  LinearGradient(colors: [
                           Colors.pink,
                           Colors.pink.shade200,
                         ]),
                         borderRadius: BorderRadius.all(Radius.circular(15))
                       ),
                       child: InkWell(
                           onTap: (){
                             setState(() {
                               ///On Edit Profile
                             });
                           },
                           child: Center(child: NormalText(text: 'Edit Profile', color: Colors.white,size: 15,))),
                     ),
                      ///Recently ordered txt
                      Padding(
                        padding: EdgeInsets.all(5),
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
    );
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
