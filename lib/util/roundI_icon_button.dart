import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  String iconPath;
  double hight;
  double widgh;
  VoidCallback onTap;
   RoundIconButton({Key? key,
   required this.iconPath,
   this.hight=30,
     this.widgh=30,
     required this.onTap
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: hight,
      width: widgh,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            spreadRadius: 2,
            blurRadius: 5.0,
            offset: const Offset(2,2)
          ),
          const BoxShadow(
              color: Colors.white,
              spreadRadius: 2,
              blurRadius: 5.0,
              offset: Offset(-2,-2)
          )
        ]
      ),
      child: GestureDetector(
          onTap:onTap,
          child:  SizedBox(
           // height: 50,width: 50,
            child: Image.asset(iconPath,),))
    );
  }
}


