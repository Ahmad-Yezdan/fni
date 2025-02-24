import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fni/common/theme/colors.dart';
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

  void _loadResult() {
    setState(() {
      _resultLoaded = true;
    });
  }

  @override
  void initState() {
    Timer(const Duration(milliseconds: 1500), () {
      _loadResult();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Results"),
      ),
      body: _resultLoaded
          ? null
          : Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: MyColors.primary,
                size: 80,
              ),
            ),
    );
  }
}
