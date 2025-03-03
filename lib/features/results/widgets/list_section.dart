import 'package:flutter/material.dart';
import 'package:fni/common/utils.dart';
import 'package:fni/models/functional_dependency.dart';

class ListSection extends StatelessWidget {
  final String title;
  final Set<List<String>>? keys;
  final Set<String>? attributes;
  final List<FunctionalDependency>? dependencies;

  const ListSection({
    super.key,
    required this.title,
    this.keys,
    this.attributes,
    this.dependencies,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
 
        if ((keys?.isNotEmpty ?? false) ||
            (attributes?.isNotEmpty ?? false) ||
            (dependencies?.isNotEmpty ?? false))
          const SizedBox(height: 2),

        if (keys?.isNotEmpty ?? false)
          Text(keys!.toList().asMap().entries.map((e) {
            String truncatedValues =
                e.value.map((str) => truncate(str, 15)).join(', ');

            return "${e.key + 1}. $truncatedValues";
          }).join('\n')),

        if (attributes?.isNotEmpty ?? false)
          Text(attributes!.map((attr) => truncate(attr, 15)).join(", ")),

        if (dependencies?.isNotEmpty ?? false)
          Text(dependencies!
              .asMap()
              .entries
              .map((e) => "${e.key + 1}. ${e.value}")
              .join('\n')),
        if (dependencies?.isEmpty ?? false)
          const Text("No preventing functional dependencies found."),

        SizedBox(height: dependencies?.isNotEmpty ?? false ? 2 : 8),
      ],
    );
  }
}
