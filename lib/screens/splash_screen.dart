import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:fni/common/colors.dart';
import 'package:fni/screens/attributes_screen.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      Get.offAll(const AttributesScreen(),
          transition: Transition.zoom,
          curve: Curves.linear,
          duration: const Duration(milliseconds: 500));
    });
  }

  @override
  Widget build(BuildContext context) {
    var sizeOf = MediaQuery.sizeOf(context);
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Neumorphic(
              style: const NeumorphicStyle(
                depth: 6,
                intensity: 1,
                surfaceIntensity: 0,
                color: MyColors.scaffoldBackground,
                boxShape: NeumorphicBoxShape.circle(),
              ),
              child: Image.asset(
                'assets/images/logo.png',
                width: sizeOf.width * 0.6,
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          DefaultTextStyle(
            style: textTheme.headlineSmall!.copyWith(color: Colors.black),
            child: AnimatedTextKit(
              isRepeatingAnimation: false,
              animatedTexts: [
                TypewriterAnimatedText(
                  'Fuzzy Normalization Index',
                  speed: const Duration(milliseconds: 100),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
