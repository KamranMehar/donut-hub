import 'package:flutter/material.dart';

import 'constents.dart';
import 'custom_button.dart';

class CartItemTile extends StatefulWidget {
  String coverImage;
  String titleImage;
  String name;
  String price;
  VoidCallback onCancelClick;

  bool isLoading=false;
   CartItemTile({Key? key,
  required this.name,
    required this.price,
    required this.titleImage,
    required this.coverImage,
    required this.onCancelClick,
     required
  }) : super(key: key);

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  int counter=1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      child: Stack(
        children: [
          Container(
            height: 350,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(image: NetworkImage(widget.coverImage),
                    fit: BoxFit.fill),
            ),
          ),
          Container(
            height: 350,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                    Colors.black,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              ),
            ),
            child: Column(
              children: [
                Row(children: [
                  const Spacer(),
                  IconButton(
                      onPressed: widget.onCancelClick,
                      icon: Icon(Icons.cancel_rounded,
                        color: Colors.white.withOpacity(0.5),
                        size: 35,)),
                ],),
                const Spacer(),
                ///Title image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.network(widget.titleImage,
                        fit: BoxFit.fill,)
                  ),
                ),
                ///Name
                HeadingText(text: widget.name, color: Colors.white,),
                NormalText(text: "Price: ${widget.price}\$", color: Colors.white),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  //-
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        if(counter!=1){
                          counter--;
                        }
                      });
                    },
                    child: Container(height: 40,width: 40,decoration:
                    BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(child: NormalText(text: "-", color: Colors.black)),),
                  ),
                  //counter
                  Container(height: 40,width: 40,decoration:
                  BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                    child: Center(child: NormalText(text: counter.toString(), color: Colors.black)),),
                  //+
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        if(counter<99){
                          counter++;
                        }
                      });
                    },
                    child: Container(height: 40,width: 40,decoration:
                    BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(child: NormalText(text: "+", color: Colors.black)),),
                  )
                ],),
                ///buy button
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: CustomButton(text: "Buy", click: (){

                  },isLoading: widget.isLoading,),
                ),
              ],),
          )
        ],
      ),
    );
  }
}
