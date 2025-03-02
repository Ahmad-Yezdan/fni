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
    return Center(
      child: Neumorphic(
        style: NeumStyle.circle.copyWith(color: bgColor),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Text(
            "FNI",
            style: TextStyle(
                fontSize: 127,
                fontFamily: "Rubik",
                color: textColor,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
