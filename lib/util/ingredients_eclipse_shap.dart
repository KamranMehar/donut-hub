import 'package:flutter/material.dart';


class IngredientsEclipseShape extends StatelessWidget {
   String ingredient_name;
   num grams;
   num percentage;
   Color color;
  IngredientsEclipseShape({super.key,
    required this.ingredient_name,
    required this.grams,
    required this.percentage,
    required this.color

});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        padding: const EdgeInsets.all(10),
//        height: 90,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black,width: 2),
            borderRadius: const BorderRadius.vertical(top: Radius.elliptical(40,40),bottom: Radius.elliptical(40,40))
        ),
        child: Column(children:  [
           Text(ingredient_name,style: const TextStyle(fontSize: 15,color: Colors.black),),
          Text('$grams Grams',style: TextStyle(fontSize: 10,color: Colors.grey[900]),),
          CircleAvatar(backgroundColor:  color,radius: 20,
            child:   Text("$percentage%",style: const TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),)
        ],),
      ),
    );
  }
}
