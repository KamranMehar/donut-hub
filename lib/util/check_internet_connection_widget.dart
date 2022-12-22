import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:donut_hub/util/constents.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class CheckInternetConnectionWidget extends StatelessWidget {
  final AsyncSnapshot<ConnectivityResult> snapshot;
  final Widget widget ;
  bool changeDefault;
  VoidCallback onReTry;
  CheckInternetConnectionWidget({
    Key? key,
    required this.snapshot,
    required this.widget,
    required this.onReTry,
    this.changeDefault=false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    switch (snapshot.connectionState) {
      case ConnectionState.active:
        final state = snapshot.data!;
        switch (state) {
          case ConnectivityResult.none:
            return  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('lib/icons/no_internet.json',height: 200,width: 200),
                NormalText(text: "No Internet Connection", color: Colors.grey.shade700,size: 18,),
                GestureDetector(
                  onTap: onReTry,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding:const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[500],
                      ),
                      child: NormalText(text: 'Refresh', color: Colors.white,size: 21,),
                    ),
                  ),
                )
              ],
            );
          default:
            return  widget;
        }
      default:
        if(changeDefault==true){
          return  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('lib/icons/no_internet.json',height: 200,width: 200),
              NormalText(text: "No Internet Connection", color: Colors.grey.shade700,size: 18,),
              GestureDetector(
                onTap: onReTry,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding:const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[500],
                    ),
                    child: NormalText(text: 'Refresh', color: Colors.white,size: 21,),
                  ),
                ),
              )
            ],
          );
        }else{
          return widget;
        }
    }
  }
}
