import 'package:flutter/material.dart';
import 'package:fni/common/utils.dart';
import 'package:fni/models/functional_dependency.dart';
import 'package:fni/models/relation.dart';

void addFunctionalDependency(
    List<List<String>> determinantSelections,
    List<String?> dependentSelections,
    ScrollController controller,
    Function setState) {
  setState(() {
    determinantSelections.add([]);
    dependentSelections.add(null);
  });

  // Scroll to the bottom after adding
  WidgetsBinding.instance.addPostFrameCallback((_) {
    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  });
}

void onDeterminantChanged(String? value, int index,
    List<List<String>> determinantSelections, Function setState) {
  if (value != null) {
    setState(() {
      if (!determinantSelections[index].contains(value)) {
        determinantSelections[index].add(value);
      }
    });
  }
}

void onDependentChanged(String? value, int index,
    List<String?> dependentSelections, Function setState) {
  setState(() {
    dependentSelections[index] = value;
  });
}

Relation? validateFunctionalDependencies(
    BuildContext context,
    List<String> attributes,
    List<List<String>> determinantSelections,
    List<String?> dependentSelections,
    List<FunctionalDependency> functionalDependencies) {
  functionalDependencies.clear();
  Set<FunctionalDependency> uniqueFDs = {};

  if (determinantSelections.isEmpty && determinantSelections.isEmpty) {
    showSnackBar(context, 'Functional dependencies cannot be empty.');
    return null;
  }

  for (int i = 0; i < determinantSelections.length; i++) {
    final determinant = determinantSelections[i];
    final dependent = dependentSelections[i];

    if (determinant.isEmpty) {
      showSnackBar(context, "Determinant(s) at FD ${i + 1} is empty.");
      return null;
    }
    if (dependent == null) {
      showSnackBar(context, "Dependent at FD ${i + 1} is empty.");
      return null;
    }

    try {
      final fd = FunctionalDependency(determinant, dependent);

      // Ensure uniqueness by sorting determinants before comparison
      if (!uniqueFDs.add(fd)) {
        showSnackBar(context, "Duplicate FD found: ${fd.toString()}");
        return null;
      }

      functionalDependencies.add(fd);
    } catch (e) {
      showSnackBar(context, '$e');
      return null;
    }
  }

  try {
    final relation = Relation(attributes, functionalDependencies);
    return relation;
  } catch (e) {
    showSnackBar(context, '$e');
    return null;
  }
}
