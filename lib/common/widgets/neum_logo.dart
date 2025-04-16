import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:fni/common/constants/neumorphic_style.dart';

class NeumLogo extends StatelessWidget {
  final Color textColor;
  final Color bgColor;
  const NeumLogo({
    super.key,
    required this.textColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var padding = EdgeInsets.all(width >= 361 ? 28 : width * 0.077);
    double fontSize = width >= 361 ? 127 : width * 0.33;
    return Center(
      child: Neumorphic(
        style: NeumStyle.circle.copyWith(color: bgColor),
        child: Padding(
          padding: padding,
          child: Text(
            "FNI",
            style: TextStyle(
                fontSize: fontSize,
                fontFamily: "Rubik",
                color: textColor,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
