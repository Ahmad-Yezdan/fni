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
    var sizeOf = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: sizeOf.height * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const NeumLogo(
                textColor: MyColors.white,
                bgColor: MyColors.primary,
              ),
              const SizedBox(
                height: 25,
              ),
              DefaultTextStyle(
                style: textTheme.headlineSmall!.copyWith(
                  color: MyColors.black,
                ),
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TypewriterAnimatedText('Fuzzy Normalization Index',
                        speed: const Duration(milliseconds: 100),
                        textAlign: TextAlign.center),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
