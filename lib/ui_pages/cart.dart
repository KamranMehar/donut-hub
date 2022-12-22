
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/Util.dart';

class Cart extends StatefulWidget {
  static String id="cart_page";
  const Cart({Key? key}) : super(key: key);
  

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  
  List<String>? itemData;
  
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading:true,
          ),
          body:itemData==null?const Center(child: CircularProgressIndicator()): ListView.builder(
          itemCount: itemData?.length,
              itemBuilder: (context,index){
            if(itemData==null){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }else{
              return Padding(padding: EdgeInsets.all(8),
              child: Stack(
                children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width-50,
                    decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            tileMode: TileMode.mirror,
                            colors: [
                              Colors.pink,
                              Colors.purple,
                              Colors.deepPurple,
                            ])
                    ),

                  ),
                ),
                 Align(
                   alignment: Alignment.topLeft,
                   child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: Image.asset(itemData![2]),
                      ),
                      Text(itemData![0],style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),
                      Text(itemData![1]+" \$",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),
                      IconButton(onPressed: (){
                        Util_.deleteFromCart('cart');
                        itemData?.clear();
                        setState(() {});
                      }, icon:const Center(child: Icon(Icons.delete_outline,color: Colors.white,))),
                    ],),
                 ),

              ],),);
            }

          }),
        ),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // getData();
  }
  
  getData()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    itemData= pref.getStringList("cart")!;
    setState(() {});
  }
}
