import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../ui_pages/item_detail.dart';
import '../util/constents.dart';
import '../util/donut_tile.dart';

class PancakeTab extends StatelessWidget {
  DatabaseReference ref=FirebaseDatabase.instance.ref('Items/PanCakes/');
  List<Color> colors=[
    Colors.pink,
    Colors.cyan,
    Colors.teal,
    Colors.deepPurple,
    Colors.deepOrange,
    Colors.brown
  ];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
            return GridView.builder(
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
                                ref: ref.toString()+list[index]['name'],)));
                    },
                    child: DonutTile(
                        donutFlavor: list[index]['name'],
                        donutPrice: list[index]['price'],
                        donutColor: colors[index%colors.length],
                        imageName: list[index]['titleImage'],
                        click: () {})
                );
              },
            );
          }else{
            return Center(child: NormalText(text: "No Data Found !", color: Colors.grey));
          }
        }
      },

    );
  }
}
