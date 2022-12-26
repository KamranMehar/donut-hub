
import 'package:badges/badges.dart';
import 'package:donut_hub/tab/cart_list.dart';
import 'package:donut_hub/tab/orders_items.dart';
import 'package:flutter/material.dart';

import '../util/my_tab.dart';
class Cart extends StatefulWidget {
  static String id="cart_page";
  const Cart({Key? key}) : super(key: key);
  

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<Widget> myTabs = [
    // donut tab
    MyTab(
      tabHeightSize: 60,
      imageHeightSize: 25,
      iconPath: 'lib/icons/list_check.png',
      label: 'Cart List',
      fontSize: 10,
    ),
    // burger tab
    MyTab(
      tabHeightSize: 60,
      imageHeightSize: 25,
      iconPath: 'lib/icons/order_icon.png',
      label: 'Orders',
      fontSize: 10,
    ),

  ];
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'cart',
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(colors: [
            Colors.blueGrey.shade100,
            Colors.blueGrey.shade600
          ],
          radius: 1
          ),
        ),
        child: DefaultTabController(
          length: myTabs.length,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading:true,
            ),
            body: Column(children: [
              ///Tab Bar
              Padding(
                padding: const EdgeInsets.all(10),
                child: TabBar(
                  tabs: myTabs,
                  indicator: BoxDecoration(
                      border: Border.all(color: Colors.pink, width: 2),
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              ///Tab View
              const Expanded(
                child: TabBarView(
                  children: [
                  CartList(),
                    Orderitems()
                  ],
                ),
              )
            ],),
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
}
