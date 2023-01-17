
import 'package:donut_hub/util/constents.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';


class OrderConfirmationScreen extends StatefulWidget {
  int totalAmount=0;
   OrderConfirmationScreen({Key? key,required this.totalAmount}) : super(key: key);

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {

TextEditingController addressController=TextEditingController();
TextEditingController pinController=TextEditingController();
bool visiblePas=false;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Container(
      decoration:  const BoxDecoration(
        image: DecorationImage(image: AssetImage('lib/images/donuts/purple_donut.gif'),fit: BoxFit.fitHeight,
            opacity: 1),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: HeadingText(text: "Confirmation", color: Colors.white),
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.transparent,
        body:
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child:Column(children: [

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NormalText(text: "More Payment methods will be added soon !", color: Colors.white,size: 12,),
                    ),
                    GlassmorphicContainer(
                      width: 250,
                      height: 150,
                      borderRadius: 15,
                      blur: 5,
                      alignment: Alignment.bottomCenter,
                      border: 1,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFffffff).withOpacity(0.1),
                            Color(0xFFFFFFFF).withOpacity(0.05),
                          ],
                          stops: [
                            0.1,
                            1,
                          ]),
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFffffff).withOpacity(0.5),
                          Color((0xFFFFFFFF)).withOpacity(0.5),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: HeadingText(text: "THE BANK OF ANYTHING", color: Colors.white,size: 15,),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                            child: Image.asset('lib/icons/chip.png',height: 50,width: 50,),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              NormalText(text: "XXXX", color: Colors.white,size: 12,),
                              NormalText(text: "XXXX", color: Colors.white,size: 12,),
                              NormalText(text: "XXXX", color: Colors.white,size: 12,),
                              NormalText(text: "XXXX", color: Colors.white,size: 12,),
                            ],),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Image.asset('lib/icons/visa.png',height: 35,width: 35,color: Colors.white,),
                              ),
                            ],)
                        ],),
                    ),
                    HeadingText(text: "Total Amount: ${widget.totalAmount}", color: Colors.white,size: 21,),
                    NormalText(text: "Enter Your Order Delivery Address", color: Colors.white,size: 18,),
                    Container(
                      padding:const EdgeInsets.symmetric(horizontal: 5),
                      margin: const EdgeInsets.all( 12),
                      decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey[400]?.withOpacity(0.5),
                          border: Border.all(color: Colors.white,width: 1)
                      ),
                      child:   TextFormField(
                        style: const TextStyle(color: Colors.white),
                        validator: (value){
                          if(value!.isEmpty){
                            return "Address is Empty";
                          }
                        },
                        controller: addressController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.location_on,color: Colors.white60,),
                            border: InputBorder.none,
                            hintText: 'Address',
                            hintStyle: TextStyle(color: Colors.white60)
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        padding:const EdgeInsets.symmetric(horizontal: 5),
                        margin:const  EdgeInsets.all( 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[400]?.withOpacity(0.5),
                            border: Border.all(color: Colors.white,width: 1)
                        ),
                        child:   TextFormField(
                          style: const TextStyle(color: Colors.white),
                          validator: (value){
                            if(value!.isEmpty){
                              return "Pin Card Password is Empty";
                            }
                          },
                          obscureText: visiblePas? false:true,
                          controller: pinController,
                          keyboardType: TextInputType.number,
                          decoration:  InputDecoration(
                              suffixIcon: IconButton(
                                  color: Colors.grey,
                                  onPressed: (){
                                    if(!visiblePas){
                                      visiblePas=true;
                                    }else{
                                      visiblePas=false;
                                    }
                                    setState(() {});
                                  }, icon: visiblePas?const Icon(Icons.visibility_off,color: Colors.white60,)
                                  : const Icon(Icons.visibility,color: Colors.white60,)),
                              border: InputBorder.none,
                              hintText: 'PIN',
                              hintStyle:const TextStyle(color: Colors.white60),
                          ),
                        ),
                      ),
                    ),
                  ],)
                      //Order address Text form field
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
