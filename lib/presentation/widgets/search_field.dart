import 'package:flutter/material.dart';

import '../themes/theme.dart';

class SearchField extends StatefulWidget {
  final Function()? onPressed;
  const SearchField({super.key, required this.onPressed});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: whiteContainer,
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8.0, right: 8, top: 5, bottom: 5),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                suffixIcon: IconButton(
                    onPressed: () => widget.onPressed,
                    icon: const Icon(Icons.search)),
                border: InputBorder.none,
              ),
            ),
          ),
        ));
  }
}
