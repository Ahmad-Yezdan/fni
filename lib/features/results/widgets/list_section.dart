import 'package:flutter/material.dart';

class ListSection extends StatelessWidget {
  final String title;
  final Set<List<String>>? keys;
  final Set<String>? attributes;

  const ListSection(
      {super.key, required this.title, this.keys, this.attributes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        if (keys != null)
          Text(keys!
              .toList()
              .asMap()
              .entries
              .map((e) => "${e.key + 1}. ${e.value.join(', ')}")
              .join('\n')),
        if (attributes != null) Text(attributes!.join(", ")),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
