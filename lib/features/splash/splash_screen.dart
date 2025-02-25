import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:fni/common/theme/colors.dart';
import 'package:fni/common/widgets/neum_logo.dart';
import 'package:fni/features/attributes/screens/attributes_screen.dart';
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
      Get.off(
        () => const AttributesScreen(),
        transition: Transition.zoom,
        curve: Curves.linear,
        duration: Durations.long2,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const NeumLogo(
            textColor: MyColors.white,
            bgColor: MyColors.primary,
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
