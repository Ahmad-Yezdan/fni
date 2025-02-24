import 'package:flutter/material.dart';
import 'package:fni/common/utils.dart';

// validating attributes
List<String>? validateAttributes(BuildContext context, String? value) {
  if (value == null || value.isEmpty) {
    showSnackBar(context, 'Please enter the attributes.');
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
    ///TODO: select one error message
    // showSnackBar(context, 'Attribute names must be unique.');
    showSnackBar(context, 'Duplicate attribute names are not allowed.');
    return null;
  }

  for (var attribute in attributes) {
    if (attribute.isEmpty) {
      ///TODO: select one error message
      showSnackBar(context, 'Attributes cannot be empty between commas.');
      // showSnackBar(context, 'Empty attributes are not allowed.');
      return null;
    }

    // Regex validation
    if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*[a-zA-Z0-9]*$').hasMatch(attribute)) {
      String attributeName =
          attribute.length >= 7 ? '${attribute.substring(0, 7)}...' : attribute;
      showSnackBar(context,
          'Invalid attribute name: "$attributeName". Attribute names must start with a letter and can only contain letters, numbers, or underscores.');
      return null;
    }

    //TODO: confirm for Sir whether to add or not add this check
    // Reserved keyword check
    // final reservedKeywords = {
    //   'SELECT',
    //   'FROM',
    //   'WHERE',
    //   'INSERT',
    //   'UPDATE',
    //   'DELETE'
    // };

    // if (reservedKeywords.contains(attribute.toUpperCase())) {
    //   showSnackBar(context,
    //       'Attribute name "$attribute" is a reserved keyword and cannot be used.');
    //   return null;
    // }

    // Length restriction
    if (attribute.length > 64) {
      String attributeName =
          attribute.length >= 7 ? '${attribute.substring(0, 7)}...' : attribute;
      showSnackBar(context,
          'Attribute name "$attributeName" exceeds the maximum length of 64 characters.');
      return null;
    }
  }

  return attributes;
}
