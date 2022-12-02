
class Item {

  String _name="";
  String _price="";
  String _titleImage="";
  String _coverImage="";
  String _itemType="";
  String _details="";


  int _sugarGram=0;
  int _sugarPercentage=0;
  int _saltGram=0;
  int _saltPercentage=0;
  int _fateGram=0;
  int _fatPercentage=0;
  int _energyGrams=0;
  int _energyPercentage=0;

  String get details => _details;

  set details(String value) {
    _details = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get price => _price;

  int get energyPercentage => _energyPercentage;

  set energyPercentage(int value) {
    _energyPercentage = value;
  }

  int get energyGrams => _energyGrams;

  set energyGrams(int value) {
    _energyGrams = value;
  }

  int get fatPercentage => _fatPercentage;

  set fatPercentage(int value) {
    _fatPercentage = value;
  }

  int get fateGram => _fateGram;

  set fateGram(int value) {
    _fateGram = value;
  }

  int get saltPercentage => _saltPercentage;

  set saltPercentage(int value) {
    _saltPercentage = value;
  }

  int get saltGram => _saltGram;

  set saltGram(int value) {
    _saltGram = value;
  }

  int get sugarPercentage => _sugarPercentage;

  set sugarPercentage(int value) {
    _sugarPercentage = value;
  }

  int get sugarGram => _sugarGram;

  set sugarGram(int value) {
    _sugarGram = value;
  }

  String get itemType => _itemType;

  set itemType(String value) {
    _itemType = value;
  }

  String get coverImage => _coverImage;

  set coverImage(String value) {
    _coverImage = value;
  }

  String get titleImage => _titleImage;

  set titleImage(String value) {
    _titleImage = value;
  }

  set price(String value) {
    _price = value;
  }
}