
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:donut_hub/ui_pages/home.dart';
import 'package:donut_hub/util/Util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../ui_pages/item_detail.dart';
import '../util/check_internet_connection_widget.dart';
import '../util/constents.dart';
import '../util/donut_tile.dart';

class DonutTab extends StatefulWidget {

  @override
  State<DonutTab> createState() => _DonutTabState();
}

class _DonutTabState extends State<DonutTab> {
DatabaseReference ref=FirebaseDatabase.instance.ref('Items/Donut/');

List<Color> colors=[
      Colors.pink,
      Colors.cyan,
      Colors.teal,
      Colors.deepPurple,
      Colors.deepOrange,
      Colors.brown
];

Connectivity connectivity = Connectivity();

bool refreshPage = false;

  @override
  Widget build(BuildContext context) {
    return   StreamBuilder<ConnectivityResult>(
                stream: connectivity.onConnectivityChanged,
                builder: (context, snapshot) {
                  return CheckInternetConnectionWidget(
                    snapshot: snapshot,
                    widget: StreamBuilder(
      stream: ref.onValue,
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if(!snapshot.hasData){
          ///Loading tile
          return  GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 1/1.6,
                  maxCrossAxisExtent: 200
              ),
              itemCount: 4,
              itemBuilder: (context,index){
                return const LoadingTile();
              });
        }else {
          Map<dynamic, dynamic> ?map = snapshot.data!.snapshot
              .value as dynamic;
          List<dynamic> list = [];
          list.clear();
          if(map!=null) {
            list = map.values.toList();
            return  GridView.builder(
              itemCount: list.length,
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 1 / 1.6,
                  maxCrossAxisExtent: 200
              ),
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>
                              ItemDetail(path: list[index]['coverImage'],
                                name: list[index]['name'],
                                price: list[index]['price'],
                                detail: list[index]['details'],
                                sugarGram: list[index]['sugarGram'],
                                sugarPercentage: list[index]['sugarPercentage'],
                                saltGram: list[index]['saltGram'],
                                saltPercentage: list[index]['saltPercentage'],
                                fatGram: list[index]['fatGram'],
                                fatPercentage: list[index]['fatPercentage'],
                                energyGram: list[index]['energyGram'],
                                energyPercentage: list[index]['energyPercentage'],
                                ref: "Items/Donut/"+list[index]['name'],)));
                    },
                    child: DonutTile(
                        donutFlavor: list[index]['name'],
                        donutPrice: list[index]['price'],
                        donutColor:colors[index%colors.length],
                        imageName: list[index]['titleImage'],
                        ///Add To Card on Tap method
                        click: () async {
                        //  var orderID=DateTime.now().millisecondsSinceEpoch;
                          var orderName=list[index]['name'];
                          DatabaseReference reference=FirebaseDatabase.instance
                              .ref("Users/${FirebaseAuth.instance.currentUser!.uid}/Cart/$orderName");
                                reference.set({
                                  'name':list[index]['name'],
                                  'price':list[index]['price'],
                                  'titleImage':list[index]['titleImage'],
                                  'coverImage':list[index]['coverImage'],
                                  'itemType':"Donut",
                                  'details':list[index]['details'],
                                  'sugarGram':list[index]['sugarGram'],
                                  'sugarPercentage':list[index]['sugarPercentage'],
                                  'saltGram':list[index]['saltGram'],
                                  'saltPercentage':list[index]['saltPercentage'],
                                  'fatGram':list[index]['fatGram'],
                                  'fatPercentage':list[index]['fatPercentage'],
                                  'energyGram':list[index]['energyGram'],
                                  'energyPercentage':list[index]['energyPercentage'],

                                }).then((value) {
                                  Home.updateCartBadge();
                                  Util_.showToast(list[index]['name']+" Added To Cart");
                                }).onError((error, stackTrace) {
                                  Util_.showToast(error.toString());
                                });
                        })
                );
              },
            );
          }else{
            return Center(child: NormalText(text: "No Data Found !", color: Colors.grey));
          }
        }
      },

    ),
                    changeDefault: refreshPage,
                    onReTry: () {
                       setState(() {
                         if(refreshPage==false){
                           refreshPage = true;
                         }else{
                           refreshPage = false;
                         }
                       });
                    },
                  );
                });
  }
}
