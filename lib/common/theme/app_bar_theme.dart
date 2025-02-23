import 'package:flutter/material.dart';
import 'package:fni/common/theme/colors.dart';

var appBarTheme = const AppBarTheme(
  centerTitle: true,
  backgroundColor: MyColors.primary,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(30),
      bottomRight: Radius.circular(30),
    ),
  ),
  iconTheme: IconThemeData(color: MyColors.white),
);
