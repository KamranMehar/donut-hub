
import 'dart:async';
import 'package:donut_hub/classes/cart_class.dart';
import 'package:donut_hub/ui_pages/home.dart';
import 'package:donut_hub/ui_pages/order_confirmation_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../util/Util.dart';
import '../util/cart_item.dart';
import '../util/constents.dart';
class Cart extends StatefulWidget {
  static String id="cart_page";


  const Cart({Key? key}) : super(key: key);


  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
   StreamController<int> totalStreamController = StreamController<int>.broadcast();
   StreamController<int> itemTotalStreamController = StreamController<int>.broadcast();
    int totalPrice=0;

  @override
  Widget build(BuildContext context) {
    var ref=FirebaseDatabase.instance
        .ref("Users/"+FirebaseAuth.instance.currentUser!.uid+"/Cart").onValue.asBroadcastStream();
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
        child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              title: HeadingText(
                text: "Cart List", color: Colors.white, size: 23,),
              automaticallyImplyLeading: true,
              backgroundColor: Colors.white.withOpacity(0.3),
              elevation: 0,
            ),
            body:
            Column(
              children: [
                Expanded(
                    child:
                  StreamBuilder(
                stream: ref,
                builder: (context,AsyncSnapshot<DatabaseEvent> snapshot) {

                    if (snapshot.data != null) {
                      Map<dynamic, dynamic> ?map = snapshot.data!.snapshot
                          .value as dynamic;
                      List<dynamic> list = [];
                      list.clear();

                      if (map != null) {
                        list = map.values.toList();

                        //adding total item numbers to item stream
                        addTotalItemsToStream(list.length);

                        //adding sum of total items prices to total price stream
                        totalPrice=0;
                          for(int i=0;i<list.length;i++){
                            int quantity=list[i]['quantity'];
                            int price=int.parse(list[i]['price']);
                            totalPrice=totalPrice+(quantity*price);
                          }
                          addTotalToStream(totalPrice);

                        return ListView.builder(
                            physics:const BouncingScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return CartItemTile(
                                  name: list[index]['name'],
                                  price: list[index]['price'],
                                  titleImage: list[index]['titleImage'],
                                  coverImage: list[index]['coverImage'],
                                  quantity: list[index]['quantity'],
                                  onCancelClick: () async {
                                    ///Delete from cart list
                                    DatabaseReference ref = FirebaseDatabase
                                        .instance
                                        .ref("Users/" +
                                        FirebaseAuth.instance.currentUser!.uid +
                                        "/Cart/" + list[index]['name']);
                                    ref.remove().then((value) {
                                      Util_.showToast(list[index]['name'] +
                                          " Removed from cart");
                                      Home.updateCartBadge();
                                    });
                                  },
                                  incrementPriceCallBack: (int v) {
                                    FirebaseDatabase.instance
                                        .ref("Users/${FirebaseAuth.instance.currentUser!.uid}/Cart/"+list[index]['name']).update({
                                      'quantity': v,
                                    }).onError((error, stackTrace) => print(error.toString()));

                                  }
                                  ,
                                  decrementPriceCallback: (int v) {

                                    FirebaseDatabase.instance
                                        .ref("Users/${FirebaseAuth.instance.currentUser!.uid}/Cart/"+list[index]['name']).update({
                                      'quantity': v,
                                    }).onError((error, stackTrace) => print(error.toString()));
                                  });
                            });
                      } else {
                        return const Center(child: Text("NO RECORD"),);
                      }
                    } else {
                      return  Center(child: TextButton(
                          onPressed: (){
                            setState(() {});
                          }, child:const Text("Refresh",
                        style: TextStyle(fontSize: 21,color: Colors.black,fontWeight: FontWeight.bold),)),);
                    }

                }
                ),
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1),
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20), topRight: Radius
                          .circular(20))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ///Price and Item Count
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder<int>(
                              stream: totalStreamController.stream.asBroadcastStream(),
                              builder: (context,snap){
                                return HeadingText(text: "Total Amount: ${snap.data!=null?snap.data.toString():0}",
                                  color: Colors.white,
                                  size: 20,);
                              }),
                          StreamBuilder<int>(
                              stream: itemTotalStreamController.stream.asBroadcastStream(),
                              builder: (context,snap){
                                return HeadingText(text: "Total Items: ${snap.data!=null?snap.data.toString():0}",
                                  color: Colors.white,
                                  size: 18,);
                              }),
                        ],
                      ),

                      ///Buy button
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.pink
                        ),
                        child: TextButton(onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderConfirmationScreen()));
                        },
                            child: HeadingText(text: "Buy",
                              color: Colors.white,
                              size: 20,)),
                      )
                    ],
                  ),
                )
              ],
            ),
        ),
      ),
    );
  }

addTotalToStream(int num)async{
    totalStreamController.sink.add(num);
}
addTotalItemsToStream(int num)async{
    itemTotalStreamController.sink.add(num);
}

@override
  void dispose() {
    Home.updateCartBadge();
    super.dispose();
  }

}
