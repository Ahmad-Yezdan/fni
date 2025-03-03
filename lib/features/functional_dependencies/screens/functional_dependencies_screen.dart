import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:fni/common/constants/neumorphic_style.dart';
import 'package:fni/features/functional_dependencies/helper_functions/functional_dependencies_screen_helper.dart';
import 'package:fni/features/functional_dependencies/widgets/functional_dependency_item.dart';
import 'package:fni/features/results/screens/result_screen.dart';
import 'package:fni/models/functional_dependency.dart';
import 'package:fni/models/normalization_completeness.dart';
import 'package:fni/models/relation.dart';
import 'package:get/get.dart';

class FunctionalDependenciesScreen extends StatefulWidget {
  final List<String> attributes;

  const FunctionalDependenciesScreen({required this.attributes, super.key});

  @override
  State<FunctionalDependenciesScreen> createState() =>
      _FunctionalDependenciesScreenState();
}

class _FunctionalDependenciesScreenState
    extends State<FunctionalDependenciesScreen> {
  final List<List<String>> _determinantSelections = [];
  final List<String?> _dependentSelections = [];
  final List<FunctionalDependency> _functionalDependencies = [];
  final ScrollController _scrollController = ScrollController();

  void navigateToResultScreen(
      Relation relation, NormalizationCompleteness normalizationCompleteness) {
    Get.to(
      () => ResultScreen(
        relation: relation,
        normalizationCompleteness: normalizationCompleteness,
      ),
      transition: Transition.rightToLeft,
      curve: Curves.linear,
    );
  }

  void doneButtonOnTap() {
    Relation? relation = validateFunctionalDependencies(
        context,
        widget.attributes,
        _determinantSelections,
        _dependentSelections,
        _functionalDependencies);
    if (relation != null) {
      NormalizationCompleteness normalizationCompleteness =
          NormalizationCompleteness(relation);
      navigateToResultScreen(relation, normalizationCompleteness);
    }
  }

  @override
  Widget build(BuildContext context) {
    var sizeOf = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Functional Dependencies'),
        actions: [
          IconButton(
            onPressed: doneButtonOnTap,
            icon: const Icon(Icons.done),
            tooltip: "Done",
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _determinantSelections.length,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text("FD${index + 1}:"),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FunctionalDependencyItem(
                          key: UniqueKey(),
                          index: index,
                          sizeOf: sizeOf,
                          attributes: widget.attributes,
                          determinantSelections: _determinantSelections,
                          dependentSelections: _dependentSelections,
                          setState: setState,
                          onRemove: () => setState(() {
                            _determinantSelections.removeAt(index);
                            _dependentSelections.removeAt(index);
                          }),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: NeumorphicButton(
        onPressed: () => addFunctionalDependency(_determinantSelections,
            _dependentSelections, _scrollController, setState),
        style: NeumStyle.circle,
        child: const Icon(Icons.add, size: 27),
      ),
    );
  }
}
