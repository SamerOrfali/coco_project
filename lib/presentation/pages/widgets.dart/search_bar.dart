import 'package:flutter/material.dart';

import '../search_page.dart';

/// search bar contains the selected categories names and can remove selected category from search bar with exit button
/// I didn't add textField and textController because I just used 10 categories
class SearchBar extends StatelessWidget {
   const SearchBar({Key? key,required this.selectedCategories,required this.onTap}) : super(key: key);
   final List<int> selectedCategories;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 30),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: List.generate(
              selectedCategories.length,
                  (index) {
                    int id = selectedCategories[index];
                    String? name = idToCat[id];
                    if (name == null) {
                      return const SizedBox();
                    }
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(right: 5, bottom: 7),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap:()=> onTap(id),
                            child: const Icon(Icons.clear, size: 15),
                          ),
                        ],
                      ),
                    );
                  },
            ),
          ),
        ),
      ),
    );
  }
}
