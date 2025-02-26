import 'package:flutter/material.dart';
import 'package:fni/models/functional_dependency.dart';

class CurrentNormalForm extends StatelessWidget {
  final String title, currentNormalForm;
  final String? reason;
  final List<FunctionalDependency> dependencies;
  final bool forNC;

  const CurrentNormalForm({
    super.key,
    required this.title,
    required this.currentNormalForm,
    this.reason,
    required this.dependencies,
    required this.forNC,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                )),
        const SizedBox(height: 2),
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              const TextSpan(text: 'The table is in '),
              TextSpan(
                  text: currentNormalForm,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              if (reason == null) TextSpan(text: !forNC ? '.' : ". So there's no need to proceed further."),
              if (reason != null) TextSpan(text: ' due to following $reason:'),
              if (dependencies.isNotEmpty)
                ...dependencies.asMap().entries.map((entry) =>
                    TextSpan(text: "\n${entry.key + 1}. ${entry.value}")),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
