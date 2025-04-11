import 'package:flutter/material.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final dynamic category; // Replace `dynamic` with the actual type of `category`

  const CategoryDetailsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category['name']),
      ),
      body: Center(
        child: Text('Category: ${category.toString()}'),
      ),
    );
  }
}