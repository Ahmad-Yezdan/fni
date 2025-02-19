import 'package:flutter/material.dart';


void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
}


Column buildTextWidget({
  required String title,
  required String currentNormalForm,
  required String reason,
  required List<String> dependencies,
}) {
  return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(
          height: 2,
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'The table is in '),
              TextSpan(
                text: currentNormalForm,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              TextSpan(text: ' $reason'),
              ...dependencies.map(
                (dep) =>
                    TextSpan(text: "\n${dependencies.indexOf(dep) + 1}. $dep"),
              ),
            ],
          ),
        ),
      ]);
}

Widget buildSection(String title, List<String> items) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 8),
      Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 2),
      ...items.map((item) => Text("${items.indexOf(item) + 1}. $item")),
    ],
  );
}

Widget buildAttributeSection(String title, List<String> attributes) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 8),
      Text('$title = ${attributes.length}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 2),
      Text(attributes.join(", ")),
    ],
  );
}

Widget buildListSection(
    String title, List<String> items, bool marginNeeded, bool isKeys) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: marginNeeded ? 8 : 0),
      Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 2),
      if (isKeys)
        ...items.map((item) => Text("${items.indexOf(item) + 1}. $item")),
      if (!isKeys) Text(items.join(", ")),
    ],
  );
}

Widget sectionTitle({required String title}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Text(
      title,
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
    ),
  );
}
