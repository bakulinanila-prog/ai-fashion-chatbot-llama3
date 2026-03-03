import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/mock_categories.dart';
import 'product_list_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String gender;

  const CategoryScreen({
    super.key,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    final List<Category> subcategories = mockCategories
        .where((category) => category.gender == gender)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(gender),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: subcategories.length,
        itemBuilder: (context, index) {
          final category = subcategories[index];

          return ListTile(
            title: Text(
              category.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductListScreen(
                    gender: gender,
                    categoryId: category.id,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}