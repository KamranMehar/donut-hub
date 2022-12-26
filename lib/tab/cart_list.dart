import 'package:donut_hub/util/Util.dart';
import 'package:donut_hub/util/cart_item.dart';
import 'package:donut_hub/util/constents.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CartList extends StatefulWidget {
  const CartList({Key? key}) : super(key: key);

  @override
  State<CartList> createState() => _CartListState();
}
DatabaseReference ref=FirebaseDatabase.instance.ref('Users/'+FirebaseAuth.instance.currentUser!.uid+"/Cart/");

class _CartListState extends State<CartList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: HeadingText(text: "Cart List", color: Colors.black,),
      ),
      body: StreamBuilder(
        stream: ref.onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if(!snapshot.hasData){
            ///Loading tile
            return const Center(child: CircularProgressIndicator());
          }else {
            Map<dynamic, dynamic> ?map = snapshot.data!.snapshot
                .value as dynamic;
            List<dynamic> list = [];
            list.clear();
            if(map!=null) {
              list = map.values.toList();
              return  ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context,index){
                return CartItemTile(
                    name: list[index]['name'],
                    price: list[index]['price'],
                    titleImage: list[index]['titleImage'],
                    coverImage: list[index]['coverImage'],
                    onCancelClick: (){
                      ref.child(list[index]['name']).remove().then((value) {
                        Util_.showToast(list[index]['name']+" is deleted from cart");
                      }).onError((error, stackTrace){
                        Util_.showToast(error.toString());
                      });
                    },

                );
              });
            }else{
              return Center(child: NormalText(text: "No Data Found !", color: Colors.white60));
            }
          }
        },

      ),
    );
  }
}
