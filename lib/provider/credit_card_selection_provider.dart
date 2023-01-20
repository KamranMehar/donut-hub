import 'package:flutter/foundation.dart';

class CardSelectProvider with ChangeNotifier{
  int _index=0;

  int get index => _index;

  set index(int value) {
    _index = value;
  }

  setIndex(int index){
    _index=index;
    notifyListeners();
  }
}