import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  String text;
  bool isLoading;
  VoidCallback click;
   CustomButton({Key? key,
    required this.text,
     required this.click,
     this.isLoading=false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: click,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.pink,
          border: Border.all(color: Colors.pink.shade800,width: 1),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.pink.shade800,
              offset: const Offset(5, 5)
            )
          ]
        ),
        child:isLoading?
       const Center(
           child: SizedBox(
               height: 30,
               child: CircularProgressIndicator(color: Colors.white,))):
        Center(child: Text(text,style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),)),
      ),
    );
  }
}
