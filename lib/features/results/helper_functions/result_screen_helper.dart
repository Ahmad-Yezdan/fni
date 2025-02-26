import 'package:flutter/material.dart';
import 'package:fni/common/theme/colors.dart';
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
            Wrap(
              alignment: WrapAlignment.center,
              children: attributes.asMap().entries.map((entry) {
                int index = entry.key;
                String attr = entry.value;

                return Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border(
                      top: const BorderSide(
                          color: MyColors.black), // Top border for all
                      bottom: const BorderSide(
                          color: MyColors.black), // Bottom border for all
                      right: const BorderSide(
                          color: MyColors.black), // Right border for all
                      left: index == 0 // Left border only for first attribute
                          ? const BorderSide(color: MyColors.black)
                          : BorderSide.none,
                    ),
                  ),
                  child: Text(
                    attr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Functional Dependencies Section
            const Text("Functional Dependencies:",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis)),
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


//TODO: confirm from sir which approach to keep
// void showRelationDetailsDialog(BuildContext context, List<String> attributes,
//     List<FunctionalDependency> fds, List<FunctionalDependency> pfds) {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: const Text("Relation Details"),
//       content: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Attributes Table Header
//             Wrap(
//               alignment: WrapAlignment.center,
//               children: attributes.asMap().entries.map((entry) {
//                 int index = entry.key;
//                 String attr = entry.value;

//                 return Container(
//                   padding: const EdgeInsets.all(6),
//                   decoration: BoxDecoration(
//                     border: Border(
//                       top: const BorderSide(
//                           color: MyColors.black), // Top border for all
//                       bottom: const BorderSide(
//                           color: MyColors.black), // Bottom border for all
//                       right: const BorderSide(
//                           color: MyColors.black), // Right border for all
//                       left: index == 0 // Left border only for first attribute
//                           ? const BorderSide(color: MyColors.black)
//                           : BorderSide.none,
//                     ),
//                   ),
//                   child: Text(
//                     attr,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 16),

//             // Non-Preventing Functional Dependencies Section
//             if (fds.isNotEmpty) ...[
//               const Text(
//                 "Non-Preventing Functional Dependencies:",
//                 style: textTheme.bodyLarge,
//               ),
//               const SizedBox(height: 2),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: fds
//                     .where((fd) => !pfds.contains(fd))
//                     .toList() // Non-preventing FDs
//                     .asMap()
//                     .entries
//                     .map((fd) => Text("${fd.key + 1}. ${fd.value}"))
//                     .toList(),
//               ),
//               const SizedBox(height: 12),
//             ],

//             // Preventing Functional Dependencies Section
//             if (pfds.isNotEmpty) ...[
//               const Text(
//                 "Preventing Functional Dependencies:",
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red),
//               ),
//               const SizedBox(height: 2),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: pfds
//                     .asMap()
//                     .entries
//                     .map((fd) => Text(
//                           "${fd.key + 1}. ${fd.value}",
//                           style: const TextStyle(color: Colors.red),
//                         ))
//                     .toList(),
//               ),
//             ],
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("Close"),
//         ),
//       ],
//     ),
//   );
// }
