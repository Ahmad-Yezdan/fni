import 'package:flutter/material.dart';
import 'package:fni/common/theme/app_bar_theme.dart';
import 'package:fni/common/theme/colors.dart';
import 'package:fni/features/splash/splash_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GetMaterialApp(
      title: 'FNI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: MyColors.scaffoldBackground,
        appBarTheme: appBarTheme.copyWith(
          titleTextStyle:
              textTheme.headlineSmall!.copyWith(color: Colors.white),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
