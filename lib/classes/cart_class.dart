
class CartItem{
  String name;
  String price;
  String titleImage;
  String coverImage;
  String itemType;
  String details;

  int sugarGram;
  int sugarPercentage;
  int saltGram;
  int saltPercentage;
  int fateGram;
  int fatPercentage;
  int energyGrams;
  int energyPercentage;

  CartItem({
  required this.name,
  required this.price,
    required this.titleImage,
    required this.coverImage,
    required this.itemType,
    required this.details,

    this.sugarGram=0,
    this. sugarPercentage=0,
    this. saltGram=0,
    this. saltPercentage=0,
    this. fateGram=0,
    this. fatPercentage=0,
    this. energyGrams=0,
    this. energyPercentage=0,
  });

}