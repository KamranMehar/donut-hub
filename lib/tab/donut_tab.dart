import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../ui_pages/item_detail.dart';
import '../util/donut_tile.dart';

class DonutTab extends StatelessWidget {

DatabaseReference ref=FirebaseDatabase.instance.ref('Items/Donut/');
  @override
  Widget build(BuildContext context) {

    return  StreamBuilder(
      stream: ref.onValue,
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
       if(!snapshot.hasData){
         return const Center(child: CircularProgressIndicator(color: Colors.pink,));
       }else{
          Map<dynamic,dynamic> map= snapshot.data!.snapshot.value as dynamic;
          List<dynamic> list=[];
          list.clear();
          list=map.values.toList();
        if (kDebugMode) {
          print(list[0]['name'].toString());
        }
          return GridView.builder(
            itemCount: list.length,
            padding: const EdgeInsets.all(12),
            gridDelegate:  const SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: 1/1.6,
                maxCrossAxisExtent: 200
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)
                  => ItemDetail(path:list[index]['coverImage'],
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
                  energyPercentage: list[index]['energyPercentage'],)));
                },
                child: DonutTile(
                    donutFlavor: list[index]['name'],
                    donutPrice: list[index]['price'],
                    donutColor: Colors.pink,
                    imageName: list[index]['titleImage'],
                    click: ()async{

                    })
              );
            },
          );
       }
      },

    );
  }
}
