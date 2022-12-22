import 'dart:core';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:donut_hub/util/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:donut_hub/ui_pages/home.dart';
import '../util/Util.dart';
import 'home.dart';

String? image;
String? name;
String? email;
String? phoneNumber;

class EditProfile extends StatefulWidget {
  const EditProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final picker = ImagePicker();
  File? titleImage;
  bool loading = false;
  var userId = FirebaseAuth.instance.currentUser!.uid;

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
    Size size = MediaQuery.of(context).size;
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController emailController = TextEditingController(text: email);
    TextEditingController phoneController =
        TextEditingController(text: phoneNumber);
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                //for Android devices
                statusBarIconBrightness: Brightness.dark,
                //for IOS Devices
                statusBarBrightness: Brightness.light
            )
        ),
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      }, child: SizedBox(
                      height: 60,width: 60,
                      child: Lottie.asset('lib/icons/arrow_left.json',fit: BoxFit.cover))),
                ),
                SizedBox(
                  width: size.width,
                ),
                const SizedBox(
                  height: 5,
                ),
                ///Image
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Hero(
                    tag: 'dp',
                    child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.purple,
                        child: CircleAvatar(
                          backgroundColor: Colors.purple,
                          radius: 78,
                          backgroundImage: titleImage != null
                              ? FileImage(titleImage!.absolute)
                              : image != null
                              ? NetworkImage(image!)
                              : const AssetImage('lib/images/user.png')
                          as ImageProvider,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () {
                                pickImage();
                              },
                              child: Container(
                                height: 35,
                                width: 60,
                                decoration: BoxDecoration(
                                    borderRadius:  BorderRadius.circular(100),
                                    color: Colors.black.withOpacity(0.4)),
                                child: const Center(
                                    child: Text(
                                      'Change',
                                      style:
                                      TextStyle(color: Colors.white, fontSize: 12),
                                    )),
                              ),
                            ),
                          ),
                        )),
                  ),
                ),

                ///Name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                    tag: 'name',
                    child: TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        fillColor: Colors.grey,
                        labelText: "Name",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                            color: Colors.pink,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                ///Phone
                if (phoneNumber != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Hero(
                      tag: 'phone',
                      child: TextField(
                        controller: phoneController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: "phone",
                          fillColor: Colors.grey,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.pink,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (email != null)
                ///Email
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Hero(
                      tag: 'email',
                      child:
                      TextField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          fillColor: Colors.grey,
                          labelText: "Email",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.pink,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ///Save Button
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: CustomButton(
                      isLoading: loading,
                      text: "Save",
                      click: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        DatabaseReference ref =
                        FirebaseDatabase.instance.ref("Users/$userId");
                        setState(() {
                          if (email != null) {
                            email = emailController.text;
                          }
                          name = nameController.text;
                          if (phoneNumber != null) {
                            phoneNumber = phoneController.text;
                          }
                          loading = true;
                        });

                        ///Set Data without image
                        if (titleImage == null) {
                          ref.set({
                            if (email != null) 'email': email,
                            'name': name,
                            if (phoneNumber != null) 'phoneNumber': phoneNumber,
                            'userImage': image,
                          }).then((_) {
                            Util_.showToast("details Updated Successfully");
                            setState(() {
                              loading = false;
                            });
                          }).onError((error, stackTrace) {
                            setState(() {
                              loading = false;
                            });
                            Util_.showErrorDialog(context, error.toString());
                          });
                        } else {
                          ///Set Data with image
                          firebase_storage.Reference storageRef = firebase_storage
                              .FirebaseStorage.instance
                              .ref("UsersImages/$userId");

                          firebase_storage.UploadTask imageUploadTask =
                          storageRef.putFile(titleImage!.absolute);
                          await Future.value(imageUploadTask).then((value) async {
                            var imageUrl = await storageRef.getDownloadURL();
                            ref.set({
                              if (email != null) 'email': email,
                              'name': name,
                              if (phoneNumber != null) 'phoneNumber': phoneNumber,
                              'userImage': imageUrl
                            }).then((_) {
                              Util_.showToast("details Updated Successfully");
                              setState(() {
                                loading = false;
                              });
                              Home.getUserData();
                            }).onError((error, stackTrace) {
                              setState(() {
                                loading = false;
                              });
                              Util_.showErrorDialog(context, error.toString());
                            });
                          }).onError((error, stackTrace) {
                            setState(() {
                              loading = false;
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
      ),
    );
  }

  getData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$userId");
    final snapshot = await ref.get();
    print(userId);
    if (snapshot.exists) {
      Map<dynamic, dynamic> mapList = snapshot.value as dynamic;
      setState(() {
        if (mapList['userImage'] != null) {
          image = mapList['userImage'];

          setState(() {});
        }
        if (mapList['email'] != null) {
          email = mapList['email'];
          print(email);
          setState(() {});
        }
        if (mapList['name'] != null) {
          name = mapList['name'];
          print(name);
          setState(() {});
        }
        if (mapList['phoneNumber'] != null) {
          phoneNumber = mapList['phoneNumber'].toString();
          print(phoneNumber);
          setState(() {});
        }
      });
    } else {
      print("Data Not Found");
    }
  }

  pickImage() async {
    final pickerFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 40);
    setState(() {
      if (pickerFile != null) {
        titleImage = File(pickerFile.path);
        image = pickerFile.path;
      } else {
        Util_.showToast("No Image selected");
      }
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }
}
