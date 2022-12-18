import 'dart:core';
import 'dart:io';

import 'package:donut_hub/classes/item_class.dart';
import 'package:donut_hub/util/Util.dart';
import 'package:donut_hub/util/add_ingred_buttom.dart';
import 'package:donut_hub/util/custom_button.dart';
import 'package:donut_hub/util/ingredients_eclipse_shap.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as  firebase_storage;


String itemTypeSelected="Select Item type";
const List<String> itemList = <String>['Donut', 'Burger', 'Smoothie', 'PanCakes','Pizza'];


Item item= Item();
class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {

  final _formKey = GlobalKey<FormState>();
  bool allDone=false;
  File? coverImage;
  File? titleImage;
  final picker=ImagePicker();
  String weight="";
  bool loading=false;
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
                      child: ClipRRect(
                        borderRadius:const  BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30),),
                        child:coverImage!=null? Image.file(coverImage!.absolute,
                           // width: double.infinity,
                           // height: 300,
                            fit: BoxFit.fill,
                        ):const SafeArea(child:  Center(child:
                        Text("Chose Cover Image",style: TextStyle(fontSize: 18,color: Colors.white),))),
                      ),
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
                            child:titleImage!=null? Image.file(titleImage!.absolute,
                              fit: BoxFit.fitWidth,):const Center(
                              child: Text(
                                "add Image",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                            ),
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
                          maxLines: 1,
                          maxLength: 25,
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
                ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomButton(text: "Upload",
                        isLoading:loading, click: ()async{
                      if(_formKey.currentState!.validate()) {
                        item.name = titleController.text;
                        item.price = priceTextController.text;
                        item.details = detailController.text;
                        if ((titleImage==null) && (coverImage==null)) {
                          Util_.showToast("Select Images");
                        } else if (item.itemType == "") {
                          Util_.showToast("Select Item Type");
                        } else if ((item.sugarPercentage == "") &&
                            (item.sugarGram == "")
                            && (item.saltPercentage == "") &&
                            (item.saltGram == "")
                            && (item.fatPercentage == "") && (item.fateGram == "")
                            && (item.energyPercentage == "") &&
                            (item.energyGrams == "")) {
                          Util_.showToast("Add All ingredients");
                        } else {
                          setState(() {
                            loading=true;
                          });
                          ///Firebase Logic
                          DatabaseReference dataBaseRef=FirebaseDatabase.instance
                              .ref("Items/${item.itemType}/${item.name}");

                          firebase_storage.Reference reference=firebase_storage.FirebaseStorage.instance.
                          ref("${item.itemType}/${item.name}/${item.name}_titleImage_${ DateTime.now().millisecond}");
                          firebase_storage.UploadTask uploadTask=reference.putFile(titleImage!.absolute);
                          await Future.value(uploadTask).then((value) async{

                            var titleImageUrl=await reference.getDownloadURL();
                            item.titleImage=titleImageUrl;

                            firebase_storage.Reference ref=firebase_storage.FirebaseStorage.instance.
                            ref("${item.itemType}/${item.name}/${item.name}_coverImage_${ DateTime.now().millisecond}");
                            firebase_storage.UploadTask upload_task=ref.putFile(coverImage!.absolute);
                            await Future.value(upload_task).then((value) async {
                              var coverImageUrl=await ref.getDownloadURL();
                              item.coverImage=coverImageUrl;

                              dataBaseRef.set({
                                'name':item.name,
                                'price':item.price,
                                'titleImage':item.titleImage,
                                'coverImage':item.coverImage,
                                'itemType':item.itemType,
                                'details':item.details,
                                'sugarGram':item.sugarGram,
                                'sugarPercentage':item.sugarPercentage,
                                'saltGram':item.saltGram,
                                'saltPercentage':item.saltPercentage,
                                'fatGram':item.fateGram,
                                'fatPercentage':item.fatPercentage,
                                'energyGram':item.energyGrams,
                                'energyPercentage':item.energyPercentage
                              }).then((value) {
                                Util_.showToast("${item.name} Added Successfully");
                                setState(() {
                                  loading=false;
                                });
                              }).onError((error, stackTrace){
                                setState(() {
                                  loading=false;
                                });
                                Util_.showErrorDialog(context, error.toString());
                              });

                            }).onError((error, stackTrace) {
                              setState(() {
                                loading=false;
                              });
                              Util_.showErrorDialog(context, error.toString());
                            });

                          }).onError((error, stackTrace){
                            setState(() {
                              loading=false;
                            });
                            Util_.showErrorDialog(context, error.toString());
                          });

                        }
                      }

                    }),
                  )
                ],),
              ],),
            ),
          ),
        ));
  }



  pickImage(bool isCover) async{
     final pickerFile=await picker.pickImage(source: ImageSource.gallery,imageQuality:isCover==true?70:40);
     setState(() {
       if(pickerFile!=null){
         // setState((){allDone=true;});
         if(isCover==true){
           coverImage=File(pickerFile.path);
         }else{
         titleImage=File(pickerFile.path);
         }
       }else{
         Util_.showToast("No Image selected");
       }
     });
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
                          item.itemType=e;
                          itemTypeSelected=item.itemType;
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
