import 'package:flutter/material.dart';
import 'package:shrine/presentation/widgets/search_field.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SearchField(
          onPressed: null,
        )
      ],
    );
  }
}
