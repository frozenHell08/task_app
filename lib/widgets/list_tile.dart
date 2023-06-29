import 'package:flutter/material.dart';

class SummaryTile extends StatelessWidget {
  final String title;
  final String description;
  final double titleSize;
  final double descSize;

  const SummaryTile({
    super.key,
    required this.title,
    required this.description,
    required this.titleSize,
    required this.descSize
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: titleSize,
          decoration: TextDecoration.underline,
        ),
      ),
      subtitle: Text(description),
      subtitleTextStyle: TextStyle(fontSize: descSize),
    );
  }
}