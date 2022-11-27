import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

///Profile
class ProfileIcon extends StatelessWidget {
  String iconPath;
  double hight;
  double width;
  VoidCallback onTap;
  ProfileIcon({Key? key,
    required this.iconPath,
    this.hight=30,
    this.width=30,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //  padding: const EdgeInsets.all(10),
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
        onTap: onTap,
        child: SizedBox(
            height: hight,
            width: width,
            child: Lottie.asset(iconPath,)),
      ),
    );
  }
}
