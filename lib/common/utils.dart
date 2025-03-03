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

String truncate(String value, int maxLength) {
  return value.length > maxLength
      ? '${value.substring(0, maxLength)}...'
      : value;
}
