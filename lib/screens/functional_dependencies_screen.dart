import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:fni/common/constants/neumorphic_style.dart';
import 'package:fni/common/theme/colors.dart';
import 'package:fni/common/utils.dart';
import 'package:fni/models/functional_dependency.dart';
import 'package:fni/models/relation.dart';

class FunctionalDependenciesScreen extends StatefulWidget {
  final List<String> attributes;

  const FunctionalDependenciesScreen({required this.attributes, super.key});

  @override
  State<FunctionalDependenciesScreen> createState() =>
      _FunctionalDependenciesScreenState();
}

class _FunctionalDependenciesScreenState
    extends State<FunctionalDependenciesScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<List<String>> _determinantSelections = [];
  final List<String?> _dependentSelections = [];
  List<FunctionalDependency> _functionalDependencies = [];
  ScrollController controller = ScrollController();

  // Add a new functional dependency
  void _addFunctionalDependency() {
    setState(() {
      _determinantSelections.add([]);
      _dependentSelections.add(null);
    });

    // Scroll to the bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    });
  }

  // Remove a functional dependency
  void _removeFunctionalDependency(int index) {
    setState(() {
      _determinantSelections.removeAt(index);
      _dependentSelections.removeAt(index);
    });
  }

  // Create the table after input
  void _createTable() {
    if (_formKey.currentState!.validate()) {
      _functionalDependencies.clear();
      for (int i = 0; i < _determinantSelections.length; i++) {
        final determinant = _determinantSelections[i];
        final dependent = _dependentSelections[i];
        if (determinant.isNotEmpty && dependent != null) {
          _functionalDependencies
              .add(FunctionalDependency(determinant, dependent));
        }
      }

      try {
        final table = Relation(widget.attributes, _functionalDependencies);
        showSnackBar(context, table.toString());
      } catch (e) {
        showSnackBar(context, '$e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var sizeOf = MediaQuery.sizeOf(context);
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Functional Dependencies'),
        actions: [
          IconButton(
            onPressed: _createTable,
            icon: const Icon(
              Icons.done,
            ),
            tooltip: "Done",
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _determinantSelections.length,
                  controller: controller,
                  itemBuilder: (context, index) {
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
                                SizedBox(
                                  width: sizeOf.width * 0.31,
                                  child: Neumorphic(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    style: NeumStyle.rect.copyWith(
                                      depth: -3,
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: null,
                                      decoration: const InputDecoration(
                                        labelText: 'Determinant',
                                        border: InputBorder.none,
                                      ),
                                      dropdownColor:
                                          MyColors.scaffoldBackground,
                                      menuMaxHeight: sizeOf.height * 0.5,
                                      borderRadius: BorderRadius.circular(30),
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            if (!_determinantSelections[index]
                                                .contains(value)) {
                                              _determinantSelections[index]
                                                  .add(value);
                                            }
                                          });
                                        }
                                      },
                                      items: widget.attributes.map((attr) {
                                        return DropdownMenuItem<String>(
                                          value: attr,
                                          child: Text(attr),
                                        );
                                      }).toList(),
                                      isExpanded: true,
                                      hint: const Text('Select attribute'),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward),
                                const SizedBox(width: 8),
                                // Dependent dropdown
                                SizedBox(
                                  width: sizeOf.width * 0.31,
                                  child: Neumorphic(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    style: NeumStyle.rect.copyWith(
                                      depth: -3,
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: _dependentSelections[index],
                                      decoration: const InputDecoration(
                                        labelText: 'Dependent',
                                        border: InputBorder.none,
                                      ),
                                      dropdownColor:
                                          MyColors.scaffoldBackground,
                                      menuMaxHeight: sizeOf.height * 0.5,
                                      borderRadius: BorderRadius.circular(30),
                                      onChanged: (value) {
                                        setState(() {
                                          _dependentSelections[index] = value;
                                        });
                                      },
                                      items: widget.attributes.map((attr) {
                                        return DropdownMenuItem<String>(
                                          value: attr,
                                          child: Text(attr),
                                        );
                                      }).toList(),
                                      isExpanded: true,
                                      hint: const Text(
                                          'Select dependent attribute'),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Delete button
                                NeumorphicButton(
                                  onPressed: () =>
                                      _removeFunctionalDependency(index),
                                  style: NeumStyle.circle.copyWith(
                                    depth: 4,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: const Icon(Icons.delete, size: 22),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Show selected determinants
                          Wrap(
                            children: _determinantSelections[index]
                                .map(
                                  (determinant) => NeumorphicChip(
                                    text: determinant,
                                    onDeleted: () {
                                      setState(() {
                                        _determinantSelections[index]
                                            .remove(determinant);
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: NeumorphicButton(
        onPressed: _addFunctionalDependency,
        style: const NeumorphicStyle(
          depth: 6,
          intensity: 1,
          surfaceIntensity: 0,
          color: MyColors.scaffoldBackground,
          boxShape: NeumorphicBoxShape.circle(),
        ),
        child: const Icon(
          Icons.add,
          size: 27,
        ),
      ),
    );
  }
}

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
          Text(text),
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
