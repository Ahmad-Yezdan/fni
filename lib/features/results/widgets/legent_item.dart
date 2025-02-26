import 'package:flutter/material.dart';

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 8),
        Text(text,
            style:
                const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
