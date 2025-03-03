import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:fni/common/constants/neumorphic_style.dart';
import 'package:fni/common/utils.dart';

class NeumorphicChip extends StatelessWidget {
  final String text;
  final VoidCallback onDeleted;

  const NeumorphicChip(
      {required this.text, required this.onDeleted, super.key});

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      style: NeumStyle.rect.copyWith(depth: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(truncate(text, 15)),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDeleted,
            child: const Icon(
              Icons.close,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
