import 'package:flutter/material.dart';
import 'package:fni/common/utils.dart';

// validating attributes
List<String>? validateAttributes(BuildContext context, String? value) {
  if (value == null || value.isEmpty) {
    showSnackBar(context, 'Attributes cannot be empty.');
    return null;
  }
  value = value.trim();

  if (value.startsWith(',')) {
    showSnackBar(context, 'Attributes cannot start with a comma.');
    return null;
  }

  if (value.endsWith(',')) {
    showSnackBar(context, 'Attributes cannot end with a comma.');
    return null;
  }

  final attributes = value.split(',');

  // Check for uniqueness
  if (attributes.toSet().length != attributes.length) {
    showSnackBar(context, 'Duplicate attribute names are not allowed.');
    return null;
  }

  for (var attribute in attributes) {
    if (attribute.isEmpty) {
      showSnackBar(context, 'Attributes cannot be empty between commas.');
      return null;
    }

    // Regex validation
    if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*[a-zA-Z0-9]*$').hasMatch(attribute)) {
      showSnackBar(context,
          '"${truncate(attribute, 7)}" is an invalid attribute name. Attribute names must start with a letter and can only contain letters, numbers, or underscores.');
      return null;
    }

    // Length restriction
    if (attribute.length > 64) {
      showSnackBar(context,
          '"${truncate(attribute, 7)}" exceeds the maximum length of 64 characters.');
      return null;
    }
  }

  return attributes;
}
