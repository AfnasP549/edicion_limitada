import 'package:edicion_limitada/common/widget/custom_textformfield.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomTextFormField(
            labelText: 'Explore Limited Editions...',
            controller: _searchController),
      )),
    );
  }
}
