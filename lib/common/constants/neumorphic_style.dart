

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:fni/common/theme/colors.dart';

class NeumStyle {

  static const circle = NeumorphicStyle(
    depth: 6,
    intensity: 1,
    surfaceIntensity: 0,
    boxShape: NeumorphicBoxShape.circle(),
    color: MyColors.scaffoldBackground,
  );
  static final rect = NeumorphicStyle(
    depth: -4,
    intensity: 1,
    surfaceIntensity: 0,
    boxShape: NeumorphicBoxShape.roundRect(
      BorderRadius.circular(30),
    ),
    color: MyColors.scaffoldBackground,
  );
}
