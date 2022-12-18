
import 'package:flutter/material.dart';

class DonutTile extends StatelessWidget {
  final String donutFlavor;
  final String donutPrice;
  final donutColor;
  final String imageName;
  final double borderRadius = 12;
  VoidCallback click;
    DonutTile({
    super.key,
    required this.donutFlavor,
    required this.donutPrice,
    required this.donutColor,
    required this.imageName,
     required this.click
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: donutColor[50],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          children: [
            /// price
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: donutColor[100],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '\$$donutPrice',
                    style: TextStyle(
                      color: donutColor[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),

            /// donut picture
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.network(imageName,fit: BoxFit.cover,)),
            ),

            /// donut flavor
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    donutFlavor,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      //fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                'Dunkins',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),

            /// love icon + add button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // love icon
                  Icon(
                    Icons.favorite,
                    color: Colors.pink[400],
                  ),

                  // plus button
                  InkWell(
                    onTap: click,
                    child: Icon(
                      Icons.add,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoadingTile extends StatelessWidget {
  const LoadingTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor=Colors.grey[300]!;
    Color fColor=Colors.grey[400]!;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
            borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            /// price
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: fColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child:  Text(
                    '\$   ',
                    style: TextStyle(
                      color: bgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),

            /// donut picture
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: fColor,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: bgColor,
              ),),
            ),

            /// donut flavor
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Divider(
                    thickness: 12,
                    color: fColor,
                  ),
                ),
              ),
            ),

             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Divider(thickness: 8,color: fColor,),
            ),

            /// love icon + add button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // love icon
                  Icon(
                    Icons.favorite,
                    color: fColor
                  ),

                  // plus button
                  Icon(
                    Icons.add,
                    color: fColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
