import 'dart:ui';

import 'package:flutter/material.dart';

class GlassEffectContainer extends StatelessWidget {
  double width;
  double hight;
  double borderRadius;
  double blur;
  Color borderColor;
  double borderWidth;
  Widget child;
   GlassEffectContainer({Key? key,
  required this.width,
    required this.hight,
     this.borderColor=Colors.white,
     this.blur=8,
     this.borderWidth=1,
     this.borderRadius=20.0,
     required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child:
      Stack(
          children: [
            //Blur Effect
          Container(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor,width: borderWidth),
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: LinearGradient(colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.1),
                  ]),
                ),
                child: child,
              ),
            ),
          )
          ],
        ),

    );
  }
}

/* Container(
        height: hight,
        width: width,
        child: Stack(
          children: [
            //Blur Effect
            BackdropFilter(
              filter: ImageFilter.blur(
              sigmaY: blur,
              sigmaX: blur,
            ),
            ),
            //Gradient Effect
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor,width: borderWidth),
                borderRadius: BorderRadius.circular(borderRadius),
                gradient: LinearGradient(colors: [
                  Colors.white.withOpacity(0.4),
                  Colors.white.withOpacity(0.1),
                ]),
              ),
              child: child,
            )
          ],
        ),
      ),*/