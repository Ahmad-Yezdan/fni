import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:fni/common/constants/neumorphic_style.dart';
import 'package:fni/common/theme/colors.dart';

class NeumorphicDropdown extends StatelessWidget {
  final double width;
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const NeumorphicDropdown({
    required this.width,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Neumorphic(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        style: NeumStyle.rect.copyWith(depth: -3),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
          dropdownColor: MyColors.scaffoldBackground,
          menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
          borderRadius: BorderRadius.circular(30),
          onChanged: onChanged,
          items: items
              .map((attr) => DropdownMenuItem<String>(
                    value: attr,
                    child: Text(attr),
                  ))
              .toList(),
          isExpanded: true,
          hint: Text('Select $label'),
        ),
      ),
    );
  }
}
