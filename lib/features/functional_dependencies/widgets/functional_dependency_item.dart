import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:fni/common/constants/neumorphic_style.dart';
import 'package:fni/features/functional_dependencies/helper_functions/functional_dependencies_screen_helper.dart';
import 'package:fni/features/functional_dependencies/widgets/neumophic_chip.dart';
import 'package:fni/features/functional_dependencies/widgets/neumorphic_dropdown.dart';

class FunctionalDependencyItem extends StatelessWidget {
  final int index;
  final Size sizeOf;
  final List<String> attributes;
  final List<List<String>> determinantSelections;
  final List<String?> dependentSelections;
  final Function setState;
  final VoidCallback onRemove;

  const FunctionalDependencyItem({
    required this.index,
    required this.sizeOf,
    required this.attributes,
    required this.determinantSelections,
    required this.dependentSelections,
    required this.setState,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      style: NeumStyle.rect,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Determinant dropdown
                NeumorphicDropdown(
                  width: sizeOf.width * 0.31,
                  label: "Determinant(s)",
                  value: determinantSelections[index].isNotEmpty
                      ? determinantSelections[index].last
                      : null,
                  items: attributes,
                  onChanged: (value) => onDeterminantChanged(
                      value, index, determinantSelections, setState),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward),
                const SizedBox(width: 8),
                // Dependent dropdown
                NeumorphicDropdown(
                  width: sizeOf.width * 0.31,
                  label: "Dependent",
                  value: dependentSelections[index],
                  items: attributes,
                  onChanged: (value) => onDependentChanged(
                      value, index, dependentSelections, setState),
                ),
                const SizedBox(width: 8),
                // Delete button
                NeumorphicButton(
                  onPressed: onRemove,
                  style: NeumStyle.circle.copyWith(depth: 4),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.delete, size: 22),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            children: determinantSelections[index]
                .map(
                  (determinant) => NeumorphicChip(
                    text: determinant,
                    onDeleted: () {
                      setState(() {
                        determinantSelections[index].remove(determinant);
                      });
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
