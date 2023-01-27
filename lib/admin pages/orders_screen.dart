import 'dart:async';

import 'package:donut_hub/ui_pages/home.dart';
import 'package:donut_hub/util/constents.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrdersScreen extends StatefulWidget {
  static String id="OrderScreen";
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  StreamController<DatabaseEvent> orderStreamController = StreamController<DatabaseEvent>.broadcast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              //for Android devices
              statusBarIconBrightness: Brightness.light,
              //for IOS Devices
              statusBarBrightness: Brightness.light
          ),
        title: HeadingText(text: "Orders", color: Colors.white),
      ),
      body: Column(children: [
        Expanded(
          child: StreamBuilder(
              stream: orderStreamController.stream,
              builder: (context,/*AsyncSnapshot<DatabaseEvent>*/ snapshot) {

                if (snapshot.data != null) {
                  Map<dynamic, dynamic> ?map = snapshot.data!.snapshot.value as dynamic;
                  List<dynamic> list = [];
                  list.clear();
                  if(map!=null){
                    list=map.values.toList();

                    return ListView.builder(
                        physics:const BouncingScrollPhysics(),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.pink
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                              HeadingText(text: "Total Price", color: Colors.white,size: 21,),
                              NormalText(text:  list[index]['totalPrice'].toString(), color: Colors.white,size: 18,),
                              HeadingText(text: "Address", color: Colors.white,size: 21,),
                              NormalText(text:  list[index]['address'].toString(), color: Colors.white,size: 18,),

                            ],),
                          );
                        });
                  } else {
                    return const Center(child: Text("NO RECORD"),);
                  }
                } else {
                  return  const Center(child: CircularProgressIndicator(color: Colors.pink,),);
                }

              }
          ),
        ),
      ],),
    );
  }

  getOrderData()async{
    var ref=FirebaseDatabase.instance
        .ref("Admin/Pending Orders/");
    DatabaseEvent event=await ref.once();
    orderStreamController.sink.add(event);
  }

  @override
  void initState() {

    Timer.periodic(const Duration(seconds: 3), (timer) {
      getOrderData();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    Home.updateOrderBadge();
    super.dispose();
  }
}
