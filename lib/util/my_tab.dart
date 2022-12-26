import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTab extends StatelessWidget {
  final String iconPath;
  String label;
  double fontSize;
  double tabHeightSize;
  double imageHeightSize;
   MyTab({super.key, required this.iconPath,required this.label,
   this.fontSize=10.0,
   this.tabHeightSize=80,
     this.imageHeightSize=50
   });

  @override
  Widget build(BuildContext context) {
  /*  final screenHight=MediaQuery.of(context).size.height;
    final screenWidth=MediaQuery.of(context).size.width;*/

    return Tab(
       height: tabHeightSize,//screenHight*0.12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        SizedBox(
            height: imageHeightSize,//screenHight*0.08,
            width:  imageHeightSize,//screenWidth*0.10,
            /*decoration: BoxDecoration(
                color: Colors.grey[300], borderRadius: BorderRadius.circular(15))*/
            child: Image.asset(
              iconPath,fit: BoxFit.contain,
            ),
          ),
        Text(label,
            selectionColor: Colors.black,
            style: GoogleFonts.oswald(textStyle:  TextStyle(color: Colors.black,fontSize: fontSize)),),
      ],)
    );
  }
}