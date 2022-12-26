import 'package:donut_hub/util/cart_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../util/constents.dart';

class Orderitems extends StatefulWidget {
  const Orderitems({Key? key}) : super(key: key);

  @override
  State<Orderitems> createState() => _OrderitemsState();
}
class _OrderitemsState extends State<Orderitems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: HeadingText(text: "Order Items", color: Colors.black),
      ),
    );
  }
}
