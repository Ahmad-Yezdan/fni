import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fni/common/theme/colors.dart';
import 'package:fni/features/results/widgets/current_normal_forn.dart';
import 'package:fni/features/results/widgets/list_section.dart';
import 'package:fni/features/results/widgets/section_title.dart';
import 'package:fni/models/relation.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ResultScreen extends StatefulWidget {
  final Relation relation;
  const ResultScreen({super.key, required this.relation});

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
                    const SectionTitle(title: 'Normalization Analysis'),
                    ListSection(
                        title: "Candidate Keys",
                        keys: widget.relation.candidateKeys),
                    const SizedBox(
                      height: 8,
                    ),
                    ListSection(
                        title: "Prime Attributes",
                        attributes: widget.relation.primeAttributes),
                    const SizedBox(
                      height: 8,
                    ),
                    ListSection(
                        title: "Non-Prime Attributes",
                        attributes: widget.relation.nonPrimeAttributes),
                    const SizedBox(
                      height: 8,
                    ),
                    CurrentNormalForm(
                      title: "Normal Form",
                      currentCurrentNormalForm:
                          widget.relation.normalForm.normalForm,
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
