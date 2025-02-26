import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fni/common/theme/colors.dart';

import 'package:fni/features/results/helper_functions/result_screen_helper.dart';
import 'package:fni/features/results/widgets/current_normal_forn.dart';
import 'package:fni/features/results/widgets/legent_item.dart';
import 'package:fni/features/results/widgets/list_section.dart';
import 'package:fni/features/results/widgets/section_title.dart';
import 'package:fni/features/results/widgets/stacked_bar_chart.dart';
import 'package:fni/models/normalization_completeness.dart';
import 'package:fni/models/relation.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ResultScreen extends StatefulWidget {
  final Relation relation;
  final NormalizationCompleteness normalizationCompleteness;
  const ResultScreen(
      {super.key,
      required this.relation,
      required this.normalizationCompleteness});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _resultLoaded = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      setState(() => _resultLoaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Results")),
      body: _resultLoaded
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Normalizatoin Completeness Section
                    const SectionTitle(
                      title: 'Normalization Completeness',
                    ),
                    const Text(
                      'NC = N + Fuzzy Functionality\n'
                      'NC = N + (((CA / TA) + (1 - (PA / TA))) / 2)',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CurrentNormalForm(
                      title: "Current Normal Form (N) = ${widget.relation.nf}",
                      currentNormalForm: widget.relation.normalForm.normalForm,
                      reason:
                          widget.relation.normalForm.problematicdependencyName,
                      dependencies: widget.relation.problematicFDs,
                    ),

                    ListSection(
                      title: "Preventing Functional Dependencies",
                      dependencies: widget.normalizationCompleteness.pfds,
                    ),
                    // if (widget.normalizationCompleteness.pfds.isNotEmpty)
                    Row(
                      children: [
                        const Text(
                          "Want more details?",
                        ),
                        GestureDetector(
                          onTap: () => showRelationDetailsDialog(
                            context,
                            widget.relation.attributes,
                            widget.relation.fds,
                            widget.normalizationCompleteness.pfds,
                          ),
                          child: const Text(
                            " Click here",
                            style: TextStyle(
                              color: MyColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListSection(
                      title:
                          "Completeness Attributes (CA) = ${widget.normalizationCompleteness.completenessAttributes.length}",
                      attributes: widget
                          .normalizationCompleteness.completenessAttributes,
                    ),
                    ListSection(
                      title:
                          "Total Attributes (TA) = ${widget.normalizationCompleteness.totalAttributes.length}",
                      attributes:
                          widget.normalizationCompleteness.totalAttributes,
                    ),
                    ListSection(
                      title:
                          "Preventing Attributes (PA) = ${widget.normalizationCompleteness.preventingAttributes.length}",
                      attributes:
                          widget.normalizationCompleteness.preventingAttributes,
                    ),
                    ListSection(
                        title:
                            "Fuzzy Functionality = ${widget.normalizationCompleteness.fuzzyFunctionality}"),
                    const Text('Hence,',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                        'Normalization Completeness = ${widget.normalizationCompleteness.normalizationCompleteness}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(
                      height: 8,
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: MyColors.black)),
                          child: StackedBarChart(
                            normalForm: widget.relation.nf.toDouble(),
                            completeness: widget
                                .normalizationCompleteness.fuzzyFunctionality,
                            normalizationCompleteness: widget
                                .normalizationCompleteness
                                .normalizationCompleteness,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        LegendItem(
                            color: MyColors.lightprimary, text: 'Completeness'),
                        const SizedBox(
                          height: 4,
                        ),
                        const LegendItem(
                            color: MyColors.primary, text: 'Normal Form'),
                      ],
                    ),

                    //Normalizatoin Analysis Section
                    const SectionTitle(title: 'Normalization Analysis'),
                    ListSection(
                        title: "Candidate Keys",
                        keys: widget.relation.candidateKeys),
                    ListSection(
                        title: "Prime Attributes",
                        attributes: widget.relation.primeAttributes),
                    if (widget.relation.nonPrimeAttributes.isNotEmpty)
                      ListSection(
                          title: "Non-Prime Attributes",
                          attributes: widget.relation.nonPrimeAttributes),
                    CurrentNormalForm(
                      title: "Normal Form",
                      currentNormalForm: widget.relation.normalForm.normalForm,
                      reason:
                          widget.relation.normalForm.problematicdependencyName,
                      dependencies: widget.relation.problematicFDs,
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                  color: MyColors.primary, size: 80),
            ),
    );
  }
}
