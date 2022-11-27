import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///Headings Text
class HeadingText extends StatelessWidget {
  String text;
  Color color;
  double size;
  bool isUnderline;
   HeadingText({Key? key,
  required this.text,
   required this.color,
     this.size=25,
    required this.isUnderline,
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(isUnderline){
      return Text(text,
        style: GoogleFonts.roboto(
          textStyle:  TextStyle(color:color,fontSize:size,fontWeight: FontWeight.bold,
          decoration:  TextDecoration.underline),),);
    }else {
      return Text(text,
        style: GoogleFonts.roboto(
          textStyle: TextStyle(
            color: color, fontSize: size, fontWeight: FontWeight.bold,),),);
    }
  }
}

///Normal Text
class NormalText extends StatelessWidget {
   NormalText({Key? key,
  required this.text,
    required this.color,
    this.size=25
  }) : super(key: key);
  String text;
  Color color;
  double size;
  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: GoogleFonts.openSans(
          textStyle:  TextStyle(color:color,fontSize:size,)),);
  }
}
