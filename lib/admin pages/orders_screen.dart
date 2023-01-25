import 'package:donut_hub/util/constents.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  static String id="OrderScreen";
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeadingText(text: "Orders", color: Colors.white),
      ),
      body: Column(children: [

      ],),
    );
  }
}
