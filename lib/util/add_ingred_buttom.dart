import 'package:flutter/material.dart';
class AddIngredientButton extends StatefulWidget {
  String title;
  VoidCallback onTap;
  Color color;
   AddIngredientButton({Key? key,
   required this.title,
     required this.onTap,
     this.color=Colors.red
   }) : super(key: key);

  @override
  State<AddIngredientButton> createState() => _AddIngredientButtonState();
}

class _AddIngredientButtonState extends State<AddIngredientButton> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          height: 90,
          width: 60,
          decoration:BoxDecoration(
              border: Border.all(color: widget.color,width: 2),
              borderRadius: const BorderRadius.vertical(top: Radius.elliptical(40,40),bottom: Radius.elliptical(40,40))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:  [
              Text(widget.title,
                  style:TextStyle(fontWeight: FontWeight.bold,color: widget.color,fontSize: 15)),
              Icon(Icons.add,color: widget.color,)
            ],
          ),
        ),
      ),
    );
  }
}
