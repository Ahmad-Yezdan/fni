import 'package:flutter/material.dart';
import 'package:fni/common/theme/colors.dart';
import 'package:fni/common/utils.dart';
import 'package:fni/models/functional_dependency.dart';

void showRelationDetailsDialog(
  BuildContext context,
  List<String> attributes,
  List<FunctionalDependency> fds,
  List<FunctionalDependency> pfds,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Relation Details"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Attributes Table Header
            const Text("Attributes:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 2),
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 4,
              children: attributes.map((attribute) {
                return Container(
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(top: 4),
                  decoration:
                      BoxDecoration(border: Border.all(color: MyColors.black)),
                  child: Text(
                    truncate(attribute, 15),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),

            // Functional Dependencies Section
            const Text("Functional Dependencies:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 2),

            // List of Functional Dependencies
            ...fds.asMap().entries.map((fd) => Text(
                  "${fd.key + 1}. ${fd.value}",
                  style: TextStyle(
                      color: pfds.contains(fd.value)
                          ? Colors.red
                          : MyColors.black),
                )),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    ),
  );
}