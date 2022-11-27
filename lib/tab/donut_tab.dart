import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/item_detail.dart';
import '../util/Util.dart';
import '../util/donut_tile.dart';

class DonutTab extends StatelessWidget {
  // list of donuts
  List donutsOnSale = [
    // [ donutFlavor, donutPrice, donutColor, imageName ,detailImagePath]
    ["Ice Cream", "36", Colors.blue, "lib/images/icecream_donut.png","lib/images/donuts/ice_cream_donut.jpg"],
    ["Strawberry", "45", Colors.red, "lib/images/strawberry_donut.png","lib/images/donuts/strawberry_donut.jpg"],
    ["Grape Ape", "84", Colors.purple, "lib/images/grape_donut.png","lib/images/donuts/grape_donut.jpg"],
    ["Choco", "95", Colors.brown, "lib/images/chocolate_donut.png","lib/images/donuts/chocolate_donut.jpg"],
  ];


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,));
    return  GridView.builder(
        itemCount: donutsOnSale.length,
        padding: const EdgeInsets.all(12),
        gridDelegate:  const SliverGridDelegateWithMaxCrossAxisExtent(
          //  crossAxisCount: width>500? 3 :2,
          childAspectRatio: 1/1.6,
          maxCrossAxisExtent: 200   /* 1 / 1.6*/,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ItemDetail(path:donutsOnSale[index][4],
                name: donutsOnSale[index][0],
                price: donutsOnSale[index][1], )));
            },
            child: DonutTile(
              donutFlavor: donutsOnSale[index][0],
              donutPrice: donutsOnSale[index][1],
              donutColor: donutsOnSale[index][2],
              imageName: donutsOnSale[index][3],
              click: () { 
                ///Add to cart
                Util_.addToCart(
                    donutsOnSale[index][0],
                    donutsOnSale[index][1],
                    donutsOnSale[index][3]);
              },
            ),
          );
        },
      );
  }

}
