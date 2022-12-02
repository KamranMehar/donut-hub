import 'dart:core';
import 'dart:io';

import 'package:donut_hub/classes/item_class.dart';
import 'package:donut_hub/util/Util.dart';
import 'package:donut_hub/util/add_ingred_buttom.dart';
import 'package:donut_hub/util/ingredients_eclipse_shap.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';


String itemTypeSelected="Select Item type";
const List<String> itemList = <String>['Donut', 'Burger', 'Smoothie', 'PanCakes','Pizza'];
//onst List<String> ingredList = ['Sugar', 'Salt', 'Fat', 'Energy',];
//String ingredientsTypeSelected="Select Ingredients type ";


Item item= Item();
class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {

  final _formKey = GlobalKey<FormState>();
  bool allDone=false;
  String coverImagePath="";
  String titleImagePath="";
  String weight="";
  bool loading=false;
  final databaseRef=FirebaseDatabase.instance.ref();
  final titleController=TextEditingController();
  final priceTextController=TextEditingController();
  final detailController=TextEditingController();
  final weightTextController=TextEditingController();

  //ingredients flags
  bool isSugar=false;
  bool isSalt=false;
  bool isFat=false;
  bool isEnergy=false;
  @override
  Widget build(BuildContext context) {
    return Hero(tag: 'addItem',
        child: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(colors: [
                Colors.grey.shade200,
                Colors.grey,
              ],radius: 1)
          ),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: true,
            ),
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              scrollDirection: Axis.vertical,
              child: Column(children: [
                Stack(
                  children: [
                 const SizedBox(height: 450,width: double.infinity,),
                  ///Cover Image
                  InkWell(
                    onTap: (){
                      pickImage(true);
                    },
                    child: Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30) ),
                        border: Border.all(color: Colors.pink,width: 1)
                      ),
                      child: Image.file(File(coverImagePath.toString()),
                         // width: double.infinity,
                         // height: 300,
                          fit: BoxFit.fill,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){
                            return const SafeArea(child:  Center(child:
                            Text("Chose Cover Image",style: TextStyle(fontSize: 18,color: Colors.white),)));
                          }),
                    ),
                  ),
                  ///Title Image Upload Image button
                  Positioned(
                    left: MediaQuery.of(context).size.width*1/3,
                    right: MediaQuery.of(context).size.width*1/3,
                    bottom: 50,
                    child: GestureDetector(
                      onTap: (){
                        pickImage(false);
                      },
                      child: Container(
                          height: 150,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.pink,width: 1),
                          ),
                          child:ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(File(titleImagePath),
                              fit: BoxFit.fitWidth,
                              errorBuilder: (BuildContext context,Object exception,StackTrace? stackTrace){
                                return const Center(
                                  child: Text(
                                    "add Image",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                                );
                              },),
                          )
                      ),
                    ),
                  ),
                ],),
                Column(children: [
                  ///Chose Item Type
                 const MyDropDown(),
                  Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding:const EdgeInsets.symmetric(horizontal: 5),
                        margin: const EdgeInsets.all( 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.white,width: 1)
                        ),
                        child:   TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return "Title is Empty";
                            }
                          },
                          controller: titleController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Title here',
                              hintStyle: TextStyle(color: Colors.grey)
                          ),
                        ),
                      ),
                      Container(
                        padding:const EdgeInsets.symmetric(horizontal: 5),
                        margin: const EdgeInsets.all( 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.white,width: 1)
                        ),
                        child:   Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (value){
                                  if(value!.isEmpty){
                                    return "Price is Empty";
                                  }
                                },
                                controller: priceTextController,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Price here',
                                    hintStyle: TextStyle(color: Colors.grey)
                                ),
                              ),
                            ),
                           const FaIcon(FontAwesomeIcons.dollarSign,color: Colors.pink,)
                          ],
                        ),),
                     const SizedBox(height: 20,),
                      const Text("Details",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.pink),),
                      Container(
                        padding:const EdgeInsets.symmetric(horizontal: 5),
                        margin: const EdgeInsets.all( 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.white,width: 1)
                        ),
                        child:   TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return "Detail is Empty";
                            }
                          },
                          controller: detailController,
                          maxLines: 3,
                          minLines: 3,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Detail here',
                              hintStyle: TextStyle(color: Colors.grey)
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      const Text("Ingredients",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.pink),),
                     ///Weight
                      Container(
                        width: double.infinity,
                        padding:const EdgeInsets.symmetric(horizontal: 5),
                        margin: const EdgeInsets.all( 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.white,width: 1)
                        ),
                        child:   TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Weight is Empty";
                            }
                          },
                          controller: weightTextController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Weight of item',
                              hintStyle: TextStyle(color: Colors.grey)
                          ),
                        ),),
                    ],
                  )),
                ///Ingredient
                SizedBox(
                  height: 110,
                  width: double.infinity,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics:const BouncingScrollPhysics(parent: PageScrollPhysics()),
                    shrinkWrap: true,
                    children: [
                      if(isSugar==false)
                      AddIngredientButton(
                          color: Colors.white,
                          title: 'Sugar',
                          onTap: (){
                             if(weightTextController.text.isNotEmpty){
                               isSugar=!isSugar;
                               showInputDialog('Sugar');
                             }else{
                               Util_.showToast("weight is empty");
                             }
                          }),
                      if(isSugar==true)
                        InkWell(
                          onTap: (){
                            if(weightTextController.text.isNotEmpty){
                              showInputDialog('Sugar');
                            }else{
                              Util_.showToast("weight is empty");
                            }
                          },
                          child: IngredientsEclipseShape(
                              ingredient_name: 'Sugar',
                              grams: item.sugarGram,
                              percentage: item.sugarPercentage,
                              color: Colors.white),
                        ),
                      if(isSalt==false)
                      AddIngredientButton(
                          color: Colors.white,
                          title: "Salt",
                          onTap: (){
                            if(weightTextController.text.isNotEmpty){
                              isSalt=!isSalt;
                              showInputDialog("Salt");
                            }else{
                              Util_.showToast("weight is empty");
                            }

                          }),
                      if(isSalt==true)
                        InkWell(
                          onTap: (){
                            if(weightTextController.text.isNotEmpty){
                              showInputDialog("Salt");
                            }else{
                              Util_.showToast("weight is empty");
                            }

                          },
                          child: IngredientsEclipseShape(
                              ingredient_name: 'Salt',
                              grams: item.saltGram,
                              percentage: item.saltPercentage,
                              color: Colors.green),
                        ),
                      if(isFat==false)
                      AddIngredientButton(
                          color: Colors.white,
                          title: "Fat",
                          onTap: (){
                            if(weightTextController.text.isNotEmpty){
                              isFat=!isFat;
                              showInputDialog("Fat");
                            }else{
                              Util_.showToast("weight is empty");
                            }
                          }),
                      if(isFat==true)
                        InkWell(
                          onTap: (){
                            if(weightTextController.text.isNotEmpty){
                              showInputDialog('Fat');
                            }else{
                              Util_.showToast("weight is empty");
                            }
                          },
                          child: IngredientsEclipseShape(
                              ingredient_name: "Fat",
                              grams: item.fateGram,
                              percentage: item.fatPercentage,
                              color: Colors.red),
                        ),
                      if(isEnergy==false)
                      AddIngredientButton(
                          color: Colors.white,
                          title: "Energy",
                          onTap: (){
                            if(weightTextController.text.isNotEmpty){
                              isEnergy=!isEnergy;
                              showInputDialog("Energy");
                            }else{
                              Util_.showToast("weight is empty");
                            }
                          }),
                      if(isEnergy==true)
                        InkWell(
                          onTap: (){
                            if(weightTextController.text.isNotEmpty){
                              showInputDialog('Energy');
                            }else{
                              Util_.showToast("weight is empty");
                            }
                          },
                          child: IngredientsEclipseShape(
                              ingredient_name: 'Energy',
                              grams: item.energyGrams,
                              percentage: item.energyPercentage,
                              color: Colors.yellow),
                        )
                    ],
                  ),
                )
                ],),
              ],),
            ),
            floatingActionButton:
            Visibility(
              visible: allDone,
              child: InkWell(
                onTap: (){
                  if(_formKey.currentState!.validate()){
                    item.name=titleController.text;
                    item.price=priceTextController.text;
                    item.details=detailController.text;
                  }
                  ///Upload to firebase Logic will be here
                  Util_.showToast("All Done");
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.pink,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.shade800,
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset:const Offset(4, 4)
                      ),
                    ],
                  ),
                child: const Icon(Icons.done_outlined,color: Colors.white,),),
              ),)
            ,),
        ));
  }
   pickImage(bool isCover) async{
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      //  allowedExtensions: ['jpg', 'png',],
      );
      if(result!=null){
       // setState((){allDone=true;});
        if(isCover==true){
         coverImagePath= result.files.single.path!;
         item.coverImage=coverImagePath;
         setState(() {});
        }else{
          titleImagePath= result.files.single.path!;
          item.titleImage= titleImagePath;
          setState((){});
        }
      }
  }
int getPercentage(String grams,String weight){
    int percentage=((int.parse(grams)/int.parse(weight))*100).round();
    print("Percentage:: "+percentage.toString());
    return percentage;
}
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    weightTextController.dispose();
    titleController.dispose();
    priceTextController.dispose();
  }

   showInputDialog(String type){
    FocusManager.instance.primaryFocus?.unfocus();
   final formKey = GlobalKey<FormState>();
    final gramsController=TextEditingController();
    QuickAlert.show(
      showCancelBtn: false,
        barrierDismissible: false,
        context: context,
        confirmBtnColor: Colors.pink,
        type: QuickAlertType.custom,
      widget: Form(
        key: formKey,
        child: Column(
          children: [
            Text(type,style:const TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,fontSize: 20),),
            Text("Weight: ${weightTextController.text}",style: TextStyle(color: Colors.pink[300],fontWeight: FontWeight.bold,fontSize: 18),),
         //   const IngrDropDown(),
            Container(
              padding:const EdgeInsets.symmetric(horizontal: 5),
              margin: const EdgeInsets.all( 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.white,width: 1)
              ),
              child:  TextFormField(
                keyboardType: TextInputType.number,
                controller: gramsController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Grams',
                    hintStyle: TextStyle(color: Colors.grey)
                ),
                validator: (value){
                  if(value==""){
                    return 'gram is Empty';
                  }else if(int.parse(weightTextController.text)<=int.parse(value!)){
                    return 'must be smaller than item weight';
                  }
                },
              ),),
          ],
        ),
      ),
      onConfirmBtnTap: (){
          if(formKey.currentState!.validate()){
            switch(type) {
              case 'Sugar': {
                  item.sugarGram=int.parse(gramsController.text);
                 // item.sugarPercentage=int.parse(percentageController.text);
                  item.sugarPercentage=getPercentage(gramsController.text, weightTextController.text);
                  //gramsController.clear();
                 // percentageController.clear();
                  Navigator.pop(context);
                  setState(() {
                    isSugar=true;
                  });
              }
              break;
              case 'Salt': {
                item.saltGram=int.parse(gramsController.text);
               // item.saltPercentage=int.parse(percentageController.text);
                item.saltPercentage=getPercentage(gramsController.text, weightTextController.text);
              //  gramsController.clear();
               // percentageController.clear();
                Navigator.pop(context);
                setState(() {
                  isSalt=true;
                });
              }
              break;
              case 'Fat':{
                item.fateGram=int.parse(gramsController.text);
               // item.fatPercentage=int.parse(percentageController.text);
                item.fatPercentage=getPercentage(gramsController.text, weightTextController.text);
               // gramsController.clear();
             //   percentageController.clear();
                Navigator.pop(context);
                setState(() {
                  isFat=true;
                });
              }
              break;
              case 'Energy':{
                item.energyGrams=int.parse(gramsController.text);
               // item.energyPercentage=int.parse(percentageController.text);
                item.energyPercentage=getPercentage(gramsController.text, weightTextController.text);
              //  gramsController.clear();
              //  percentageController.clear();
                Navigator.pop(context);
                setState(() {
                  isEnergy=true;
                });
              }
            }

          }
      }
    );
}
}
class MyDropDown extends StatefulWidget {

  const MyDropDown({Key? key}) : super(key: key);

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}
class _MyDropDownState extends State<MyDropDown> {
  bool isOpen=false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          InkWell(
            onTap: (){
              setState(() {
                isOpen=!isOpen;
              });
            },
            child: AnimatedContainer(
              duration:const Duration(milliseconds: 600),
              padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
              decoration: BoxDecoration(
                color: isOpen?Colors.pink:Colors.grey.shade400,
                border: Border.all(color: Colors.pink,width: 1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(itemTypeSelected,style: const TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),
                  const Icon(Icons.keyboard_arrow_down_outlined,color: Colors.white,)
                ],
              ),
            ),
          ),
          if(isOpen)
            ListView(
              scrollDirection: Axis.vertical,
              primary: false,
              shrinkWrap: true,
              children: itemList.map((e) =>
                  Padding(padding:const EdgeInsets.all(5),
                    child:  InkWell(
                      onTap: (){
                        setState(() {
                          isOpen=false;
                        //  itemTypeSelected=e;
                          item.name=e;
                          itemTypeSelected=item.name;
                        });
                      },
                      child: Container(
                padding:const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  border: Border.all(color: Colors.pink,width: 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                        child:   Text(e,style:const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
              ),
                    ),)).toList(),
            )
        ],
      ),
    );
  }
}

/*
class IngrDropDown extends StatefulWidget {
  const IngrDropDown({Key? key}) : super(key: key);

  @override
  State<IngrDropDown> createState() => _IngrDropDownState();
}

class _IngrDropDownState extends State<IngrDropDown> {
  bool isOpen=false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: (){
            setState(() {
              FocusManager.instance.primaryFocus?.unfocus();
              isOpen=!isOpen;
            });
          },
          child: AnimatedContainer(
padding: const EdgeInsets.symmetric(horizontal: 15),
            duration:const Duration(milliseconds: 600),
            width: 200,
            decoration: BoxDecoration(
              color: isOpen?Colors.pink:Colors.grey.shade500,
              border: Border.all(color: Colors.pink,width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(ingredientsTypeSelected,style: const TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.bold),),
                const Icon(Icons.keyboard_arrow_down_outlined,color: Colors.white,)
              ],
            ),
          ),
        ),
        if(isOpen)
          SingleChildScrollView(
            child: SizedBox(
              width: 100,
              child: ListView(
                primary: false,
                shrinkWrap: true,
                children: ingredList.map((e) =>
                    Padding(padding:const EdgeInsets.all(5),
                      child:  InkWell(
                        onTap: (){
                          setState(() {
                            isOpen=false;
                            ingredientsTypeSelected=e;
                          });
                        },
                        child: Container(
                          padding:const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            border: Border.all(color: Colors.pink,width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(e,style:const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10),),
                        ),
                      ),)).toList(),
              ),
            ),
          )
      ],
    );
  }
}
*/

