import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatefulWidget {
   OrderConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(colors: [
          Color(0xff7ba7c2),
          Color(0xff517396),
        ],
            radius: 1
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body:
        Column(
          children: [
            Form(child: TextFormField(

            )),
          ],
        ),
      ),
    );
  }
}
