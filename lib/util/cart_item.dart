import 'package:flutter/material.dart';

import 'constents.dart';
import 'custom_button.dart';

class CartItemTile extends StatefulWidget {
  int quantity;
  String coverImage;
  String titleImage;
  String name;
  String price;
  VoidCallback onCancelClick;
  Function(int) incrementPriceCallBack;
  Function(int) decrementPriceCallback;
   CartItemTile({Key? key,
  required this.name,
    required this.price,
    required this.titleImage,
    required this.coverImage,
     required this.quantity,
    required this.onCancelClick,
  required this.incrementPriceCallBack,
     required this.decrementPriceCallback,
  }) : super(key: key);

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  //int counter=widget.quantity;

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
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(image: NetworkImage(widget.coverImage),
                    fit: BoxFit.fill),
            ),
          ),
          Container(
            height: 350,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient:  LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.7),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                    ///-
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          if(widget.quantity!=1){
                            widget.quantity--;
                            widget.decrementPriceCallback(widget.quantity);
                            setState(() {});
                          }
                        });
                      },
                      child: Container(height: 40,width: 40,decoration:
                      BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(child: NormalText(text: "-", color: Colors.black,)),),
                    ),
                    //counter
                    Container(height: 40,width: 40,decoration:
                    BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                      child: Center(child: NormalText(text: widget.quantity.toString(), color: Colors.black)),),
                    ///+
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          if(widget.quantity<99){
                            widget.quantity++;
                            widget.incrementPriceCallBack(widget.quantity);
                            setState(() {});
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
                ),

              ],),
          )
        ],
      ),
    );
  }
}
