
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../util/constents.dart';
import '../util/ingredients_eclipse_shap.dart';

class ItemDetail extends StatefulWidget {
 static String id="item_detail";
  String path;
  String name;
  String price;
   ItemDetail({Key? key,
     required this.price,
     required this.path,
     required this.name,
   }) : super(key: key);

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(width:size.width,height:size.height,),
              //Image
              SizedBox(
                width: size.width,
                  height:  size. height*0.4,
                  child: Image.asset(widget.path,fit: BoxFit.cover,)),
              ///App Bar
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                  decoration: BoxDecoration(color: Colors.grey[600]?.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15)),
                    child: Row(children: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon:  const Icon(Icons.arrow_back_ios,color: Colors.white,size: 35)),
                      Text(widget.name, style: GoogleFonts.oswald(textStyle: const TextStyle(color: Colors.white,fontSize:25,fontWeight:
                      FontWeight.bold,)),)
                    ],),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.7,
                decoration:const BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50))),
                  child:
                    Column(
                      children: [
                        ///Ingredients
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: HeadingText(text: "Ingredients", color: Colors.black, isUnderline: false,),
                        ),
                        ///Details Eclipse
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                          IngredientsEclipseShape(
                              ingredient_name: 'Sugar',
                              grams: 5,
                              percentage: 8,
                              color: Colors.red.shade300),
                            IngredientsEclipseShape(
                              ingredient_name: 'Salt',
                              grams: 2,
                              percentage: 1,
                              color: Colors.yellowAccent.shade200),
                            IngredientsEclipseShape(
                              ingredient_name: 'Fat',
                              grams: 8,
                              percentage: 21,
                              color: Colors.lightBlueAccent.shade200),
                            IngredientsEclipseShape(
                              ingredient_name: 'Energy',
                              grams: 60,
                              percentage: 48,
                              color: Colors.orange),
                        ],),
                        ///Details Text Headings
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: HeadingText(text: 'Details', color: Colors.black,size: 22, isUnderline: false,),
                        ),
                        /// Detail Text
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: NormalText(text: "The Sweet And Subtle Salty Combo Of ChocolateMeets Caramel."
                              " Introduce The Caramel DuoTo Your Mouth!",
                              color: Colors.black45,size: 15,),
                        ),
                       const Expanded(child: SizedBox()),
                        ///Add To cart and price
                        Container(
                          margin: const EdgeInsets.all(10),
                          height:size.height*0.12,
                          width: size.width-20,
                          decoration:  BoxDecoration(
                            border: Border.all(color: Colors.black,width: 2),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: Row(children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: HeadingText(text: "\$ ${widget.price}", color: Colors.black,size: 22, isUnderline: false,),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3),
                                child: NormalText(text: "Delivery not included", color: Colors.grey.shade800,size: 15,),
                              ),
                            ],),
                            const Expanded(child: SizedBox()),
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: HeadingText(text: "Add to Cart", color: Colors.black,size: 20, isUnderline: true,),
                             ),
                          ],),
                        )
                      ],
                    ),
                  ))],)
        ],
      ),
    );
  }

 @override
 void initState() {
   super.initState();
   // SystemChrome.setEnabledSystemUIOverlays([]);
   //Transparent the Status Bar :)
   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
     statusBarColor: Colors.transparent,
   ));
 }
}
