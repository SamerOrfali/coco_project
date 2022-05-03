import 'package:flutter/material.dart';

///widget to display the icon of categories
///I only choose first 10 categories because its enough to to fit the functionality of the app and test it
///when user tap the category it will be added to selected categories and add it to search bar
class CategoryIconWidget extends StatelessWidget {
  const CategoryIconWidget({Key? key, required this.id, required this.selected, required this.onTap}) : super(key: key);

  final int id;
  final bool selected;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: InkWell(
        onTap: ()=> onTap(id),
        child: Container(
          decoration: BoxDecoration(
            border: selected ? Border.all(color: Colors.green, width: 3) : Border.all(color: Colors.black),
          ),
          child: Image.asset(
            'assets/icons/$id.jpg',
            width: 50,
            height: 50,
          ),
        ),
      ),
    );
  }
}
