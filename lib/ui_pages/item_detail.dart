
import 'package:donut_hub/util/Util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../util/constents.dart';
import '../util/ingredients_eclipse_shap.dart';

class ItemDetail extends StatefulWidget {
 static String id="item_detail";
 String ref;
  String path;
  String name;
  String price;
  String detail;
  int sugarGram;
  int saltGram;
  int fatGram;
  int energyGram;
  int sugarPercentage;
  int saltPercentage;
  int fatPercentage;
  int energyPercentage;

   ItemDetail({Key? key,
     required this.price,
     required this.path,
     required this.name,
     required this.detail,
     required this.ref,

     required this.sugarGram,
     required this.sugarPercentage,
     required this.saltGram,
     required this.saltPercentage,
     required this.fatGram,
     required this.fatPercentage,
     required this.energyGram,
     required this.energyPercentage,
   }) : super(key: key);

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    print("REF: "+widget.ref);
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
                  child: Image.network(widget.path,fit: BoxFit.cover,)),
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
                      Text(widget.name, style: GoogleFonts.oswald(textStyle:
                      const TextStyle(color: Colors.white,fontSize:21,fontWeight:
                      FontWeight.bold,)),),
                      Spacer(),
                      ///Admin checker
                      if(FirebaseAuth.instance.currentUser!.uid=='9IHNNPnvYZYCgQMJzJswYhVo7pl2')
                      IconButton(onPressed: (){
                        deleteItem(widget.ref);
                      }, icon:const Icon(Icons.delete,color: Colors.white,),)
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
                          padding: const EdgeInsets.all(5),
                          child: HeadingText(text: "Ingredients", color: Colors.black, isUnderline: false,),
                        ),
                        ///Details Eclipse
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                          IngredientsEclipseShape(
                              ingredient_name: 'Sugar',
                              grams: widget.sugarGram,
                              percentage:widget.sugarPercentage,
                              color: Colors.red.shade300),
                            IngredientsEclipseShape(
                              ingredient_name: 'Salt',
                              grams: widget.saltGram,
                              percentage: widget.saltGram,
                              color: Colors.yellowAccent.shade200),
                            IngredientsEclipseShape(
                              ingredient_name: 'Fat',
                              grams: widget.fatGram,
                              percentage: widget.fatPercentage,
                              color: Colors.lightBlueAccent.shade200),
                            IngredientsEclipseShape(
                              ingredient_name: 'Energy',
                              grams: widget.energyGram,
                              percentage: widget.energyPercentage,
                              color: Colors.orange),
                        ],),
                        ///Details Text Headings
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: HeadingText(text: 'Details', color: Colors.black,size: 22, isUnderline: false,),
                        ),
                        /// Detail Text
                        Expanded(
                          child: Center(child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: NormalText(text: widget.detail,
                              color: Colors.black45,size: 15,),
                          ),)
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
  deleteItem(String path)async{
    DatabaseReference ref=FirebaseDatabase.instance.ref(path);
    ref.remove().then((value) {
      Navigator.pop(context);
    Util_.showToast("${widget.name} is Deleted Successfully");
    })
        .onError((error, stackTrace) {
          Util_.showErrorDialog(context, "Unable To Delete Item\nError: $error");
    });
  }
}
