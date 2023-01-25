import 'package:carousel_slider/carousel_slider.dart';
import 'package:donut_hub/provider/credit_card_selection_provider.dart';
import 'package:donut_hub/ui_pages/home.dart';
import 'package:donut_hub/ui_pages/pending_order_screen.dart';
import 'package:donut_hub/util/Util.dart';
import 'package:donut_hub/util/constents.dart';
import 'package:donut_hub/util/custom_button.dart';
import 'package:donut_hub/util/glass_effect.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderConfirmationScreen extends StatefulWidget {
  int totalAmount = 0;
  OrderConfirmationScreen({Key? key, required this.totalAmount})
      : super(key: key);

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  bool visiblePas = false;
  bool isLoading = false;
  double? lat;
  double? long;
  String address = "";
  String name = "";
  TextEditingController addressController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  String adminDeviceToken="";


  List<String> cards=["Visa Card","Master Card"];

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Util_.showErrorDialog(context,
          "Location services are disabled!\n Go to Settings>>Location>>Location Turn On.");
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Util_.showToast("Location permissions are denied !");
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Util_.showToast(
          'Location permissions are permanently denied, we cannot request permissions.');
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getLatLong() {
    Future<Position> data = _determinePosition();
    data.then((value) {
      if (kDebugMode) {
        print("value $value");
      }
      setState(() {
        lat = value.latitude;
        long = value.longitude;
      });

      getAddress(value.latitude, value.longitude);
    }).catchError((error) {
      if (kDebugMode) {
        print("Error $error");
      }
    });
  }

//For convert lat long to address
  getAddress(lat, long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    setState(() {
      address =
          "${placemarks[0].locality!},${placemarks[0].subAdministrativeArea!}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}";
      addressController.clear();
      addressController.text = address;
    });

    for (int i = 0; i < placemarks.length; i++) {
      print("INDEX $i ${placemarks[i]}");
    }
  }
//get user Name
  Future<String> getUserName()async{
  DatabaseReference ref=FirebaseDatabase.instance
      .ref("Users/${FirebaseAuth.instance.currentUser!.uid}/details");
  final snapshot = await ref.get();
  if(snapshot.exists){
    Map<dynamic, dynamic> mapList = snapshot.value as dynamic;

    if(mapList!=null){
      name= mapList['name'];
      return name;
    }else{
      return name;
    }
  }
  return "";
  }
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('lib/images/donuts/purple_donut.gif'),
            fit: BoxFit.fitHeight,
            opacity: 1),
      ),
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            //changing the colors of status bar icons to white (light) /for Android
              statusBarIconBrightness: Brightness.light,
              //changing the colors of status bar icons to white (light) /for IOS
              statusBarBrightness: Brightness.light
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: HeadingText(text: "Confirmation", color: Colors.white),
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NormalText(
                      text: "More Payment methods will be added soon !",
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                 Consumer<CardSelectProvider>(builder: (context,value,child){
                   return  CarouselSlider(
                       items: [
                         ///Card View
                         GlassEffectContainer(
                           width: 150,
                           hight: 250,
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Row(
                                 children: [
                                 Padding(
                                   padding: const EdgeInsets.all(8),
                                   child: HeadingText(
                                     text: "THE BANK OF ANYTHING",
                                     color: Colors.white,
                                     size: 15,
                                   ),
                                 ),
                                 const Spacer(),
                                 const RotationTransition(
                                   turns: AlwaysStoppedAnimation(90 / 360),
                                   child: Icon(Icons.wifi,color: Colors.white,),
                                 ),
                               ],),
                             ),
                               Padding(
                                 padding: const EdgeInsets.symmetric(
                                     horizontal: 8.0, vertical: 5),
                                 child: Image.asset(
                                   'lib/icons/chip.png',
                                   height: 50,
                                   width: 50,
                                 ),
                               ),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.spaceAround,
                                 children: [
                                   NormalText(
                                     text: "XXXX",
                                     color: Colors.white,
                                     size: 12,
                                   ),
                                   NormalText(
                                     text: "XXXX",
                                     color: Colors.white,
                                     size: 12,
                                   ),
                                   NormalText(
                                     text: "XXXX",
                                     color: Colors.white,
                                     size: 12,
                                   ),
                                   NormalText(
                                     text: "XXXX",
                                     color: Colors.white,
                                     size: 12,
                                   ),
                                 ],
                               ),
                               Spacer(),
                               Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 10),
                                 child: FutureBuilder(
                                     future: getUserName(),
                                     builder: (context,snap){
                                       return HeadingText(text: snap.data.toString(), color: Colors.white,size: 15,);
                                     }),
                               ),
                               const Spacer(),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.end,
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.symmetric(
                                         horizontal: 8.0),
                                     child: Image.asset(
                                       'lib/icons/visa.png',
                                       height: 35,
                                       width: 35,
                                       color: Colors.white,
                                     ),
                                   ),
                                 ],
                               )
                             ],
                           ),
                         ),
                         GlassEffectContainer(
                           width: 150,
                           hight: 250,
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Padding(
                                 padding: const EdgeInsets.all(8),
                                 child: Row(
                                   children: [
                                     HeadingText(
                                       text: "Mastercard",
                                       color: Colors.white,
                                       size: 20,
                                     ),
                                     const Spacer(),
                                     const RotationTransition(
                                       turns: AlwaysStoppedAnimation(90 / 360),
                                       child: Icon(Icons.wifi,color: Colors.white,),
                                     )
                                   ],
                                 ),
                               ),
                               Padding(
                                 padding: const EdgeInsets.symmetric(
                                     horizontal: 8.0, vertical: 5),
                                 child: Image.asset(
                                   'lib/icons/chip.png',
                                   height: 50,
                                   width: 50,
                                 ),
                               ),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.spaceAround,
                                 children: [
                                   NormalText(
                                     text: "XXXX",
                                     color: Colors.white,
                                     size: 12,
                                   ),
                                   NormalText(
                                     text: "XXXX",
                                     color: Colors.white,
                                     size: 12,
                                   ),
                                   NormalText(
                                     text: "XXXX",
                                     color: Colors.white,
                                     size: 12,
                                   ),
                                   NormalText(
                                     text: "XXXX",
                                     color: Colors.white,
                                     size: 12,
                                   ),
                                 ],
                               ),
                              const Spacer(),
                               Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 10),
                                 child: FutureBuilder(
                                     future: getUserName(),
                                     builder: (context,snap){
                                       return HeadingText(text: snap.data.toString(), color: Colors.white,size: 15,);
                                     }),
                               ),
                               const Spacer(),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.end,
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.symmetric(
                                         horizontal: 8.0),
                                     child: SizedBox(
                                       height: 30,
                                       width: 30,
                                       child: Image.asset(
                                         'lib/icons/master_card.png',
                                         height: 35,
                                         width: 35,
                                       ),
                                     ),
                                   ),
                                 ],
                               )
                             ],
                           ),
                         ),
                       ],
                       options: CarouselOptions(
                         initialPage: 0,
                         enableInfiniteScroll: false,
                         disableCenter: true,
                         // viewportFraction: 0.8,
                         reverse: false,
                         enlargeCenterPage: true,
                         scrollDirection: Axis.horizontal,
                         onPageChanged:
                             (int _index, CarouselPageChangedReason reason) {
                           value.setIndex(_index);
                         },
                       ));
                 }),
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer<CardSelectProvider>(builder: (context,value,child){
                    return HeadingText(text: cards[value.index], color: Colors.white,size: 18,);
                  }),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        HeadingText(
                          text: "Total Amount: ${widget.totalAmount} \$",
                          color: Colors.white,
                          size: 21,
                        ),
                        NormalText(
                          text: "Enter Your Order Delivery Address",
                          color: Colors.white,
                          size: 18,
                        ),

                        ///Address TextField
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 240,
                              padding:
                              const EdgeInsets.symmetric(horizontal: 5),
                              margin: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey[400]?.withOpacity(0.5),
                                  border: Border.all(
                                      color: Colors.white, width: 1)),
                              child: TextFormField(
                                style: const TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Address is Empty";
                                  }
                                },
                                controller: addressController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          if (addressController
                                              .text.isNotEmpty) {
                                            addressController.clear();
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.clear,
                                          color: Colors.white60,
                                        )),
                                    border: InputBorder.none,
                                    hintText: 'Address',
                                    hintStyle:
                                    const TextStyle(color: Colors.white60)),
                              ),
                            ),

                            ///Get Current Location
                            InkWell(
                              onTap: () async {
                                getLatLong();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey[400]?.withOpacity(0.5),
                                    border: Border.all(
                                        color: Colors.white, width: 1)),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.location_on_sharp,
                                      color: Colors.white60,
                                    ),
                                    NormalText(
                                      text: "Location",
                                      color: Colors.white,
                                      size: 9,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),

                        ///card number
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            width: 300,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            margin: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey[400]?.withOpacity(0.5),
                                border:
                                Border.all(color: Colors.white, width: 1)),
                            child: TextFormField(
                              style: const TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Card Number is Empty";
                                }
                              },
                              controller: cardNumberController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  color: Colors.grey,
                                  onPressed: () {
                                    if (cardNumberController.text.isNotEmpty) {
                                      cardNumberController.clear();
                                    }
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.white60,
                                  ),
                                ),
                                border: InputBorder.none,
                                hintText: 'Enter Your Card Number',
                                hintStyle:
                                const TextStyle(color: Colors.white60),
                              ),
                            ),
                          ),
                        ),

                        ///pin card field
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            width: 300,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            margin: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey[400]?.withOpacity(0.5),
                                border:
                                Border.all(color: Colors.white, width: 1)),
                            child: TextFormField(
                              style: const TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Pin Card Password is Empty";
                                }
                              },
                              obscureText: visiblePas ? false : true,
                              controller: pinController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    color: Colors.grey,
                                    onPressed: () {
                                      if (!visiblePas) {
                                        visiblePas = true;
                                      } else {
                                        visiblePas = false;
                                      }
                                      setState(() {});
                                    },
                                    icon: visiblePas
                                        ? const Icon(
                                      Icons.visibility_off,
                                      color: Colors.white60,
                                    )
                                        : const Icon(
                                      Icons.visibility,
                                      color: Colors.white60,
                                    )),
                                border: InputBorder.none,
                                hintText: 'PIN',
                                hintStyle:
                                const TextStyle(color: Colors.white60),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ///Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                    text: "Confirm Order",
                    isLoading: isLoading,
                    click: () async {
                      if (_formKey.currentState!.validate()) {
                        Home.sendNotificationToTopic("New Order Placed by ${name}", "Address: \n${addressController.text}",
                        adminDeviceToken,10);
                        setState(() {
                          isLoading = true;
                        });
                        var userId=FirebaseAuth.instance.currentUser!.uid;
                        FirebaseDatabase.instance.ref("Admin/Pending Orders/"
                            "${userId}/").set({
                            'userId':userId,
                            'address':addressController.text,
                            'totalPrice': widget.totalAmount
                        }).then((value){
                          /* ///set Locally pending order shared preferences to show pending order screen
                        SharedPreferences pref =
                        await SharedPreferences.getInstance();
                        pref.setBool("pendingOrder", true).then((value) {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const PendingOrderScreen()));
                        }).onError((error, stackTrace) {
                          setState(() {
                            isLoading = false;
                          });
                        });*/
                          setState(() {
                            isLoading = false;
                          });
                        }).onError((error, stackTrace){
                          setState(() {
                            isLoading = false;
                          });
                          Util_.showErrorDialog(context, error.toString());
                        });

                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

   getAdminToken()async{
    String result;
   await FirebaseDatabase.instance.ref("Admin/adminToken/adminToken").once().then((value){
     result=value.snapshot.value.toString();
     adminDeviceToken=result;
   });

  }

  @override
  void initState() {
    getUserName();
    getAdminToken();
    // TODO: implement initState
    super.initState();
  }
}
