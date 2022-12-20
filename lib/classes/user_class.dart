
import 'package:donut_hub/ui_pages/edit_profile_page.dart';

class User {
  String nameUser;
  String emailUser;
  String phoneUser;
  String image;

  User.fromJson(Map<String,dynamic>json)
      : nameUser =json['name'],
      image=json['userImage'],
      phoneUser=json['phoneUser'],
      emailUser=json['emailUSer'];

  //method that convert object to json
  Map<String,dynamic> toJson()=>{
    'name':nameUser,
    'phoneUser':phoneUser,
    'emailUser':emailUser,
    'userImage':image,
  };
}