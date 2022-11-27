import 'package:flutter/material.dart';

import '../util/Util.dart';
import '../util/donut_tile.dart';


class BurgerTab extends StatelessWidget {
  List burgerForSale = [
    // [ donutFlavor, donutPrice, donutColor, imageName ]
    ["Chicken Burger", "49", Colors.blue, "lib/images/chicken_burger.png"],
    ["Cheese Burger", "45", Colors.red, "lib/images/cheese_burger.png"],
  ];
  @override
  Widget build(BuildContext context) {
    final hight=MediaQuery.of(context).size.height;
    final width=MediaQuery.of(context).size.width;
    return GridView.builder(
      itemCount: burgerForSale.length,
      padding: const EdgeInsets.all(12),
       gridDelegate:  const SliverGridDelegateWithMaxCrossAxisExtent(
         //  crossAxisCount: width>500? 3 :2,
         childAspectRatio: 1/1.6,
         maxCrossAxisExtent: 200   /* 1 / 1.6*/,
       ),
      itemBuilder: (context, index) {
        return DonutTile(
          donutFlavor: burgerForSale[index][0],
          donutPrice: burgerForSale[index][1],
          donutColor: burgerForSale[index][2],
          imageName: burgerForSale[index][3], click: () {
          ///Add to cart
          Util_.addToCart(
              burgerForSale[index][0],
              burgerForSale[index][1],
              burgerForSale[index][3]);
        },
        );
      },
    );
  }
}
