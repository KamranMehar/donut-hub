class CartItem{
  String name;
  String price;
  String titleImage;
  String coverImage;
  String itemType;
  String details;
  int id;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.titleImage,
    required this.coverImage,
    required this.itemType,
    required this.details,
    required this.id,
    required this.quantity,
  });

  CartItem.fromMap(Map<String,dynamic> res):
        name=res['name'],
        price=res['price'],
        titleImage=res['titleImage'],
        coverImage=res['coverImage'],
        itemType=res['itemType'],
        details=res['details'],
        id=res['id'],
        quantity=res['quantity'];

  Map<String,Object?> toMap(){
    return {
      'name':name,
      'price':price,
      'titleImage':titleImage,
      'coverImage':coverImage,
      'itemType':coverImage,
      'details':details,
      'id':id,
      'quantity':quantity,
    };
  }
}