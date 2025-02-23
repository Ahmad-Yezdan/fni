import 'package:fni/models/functional_dependency.dart';

class Relation {
  final List<String> attributes;
  final List<FunctionalDependency> fds;
  late final Set<List<String>> candidateKeys;
  final Set<String> primeAttributes = {};
  late final Set<String> nonPrimeAttributes;

  Relation(this.attributes, this.fds) {
    if (attributes.isEmpty) {
      throw ArgumentError('Attributes cannot be empty.');
    }
    final uniqueAttributes = attributes.toSet();
    if (uniqueAttributes.length < attributes.length) {
      throw ArgumentError('Attributes must be unique.');
    }

    final uniqueFDs = fds.toSet();
    if (uniqueFDs.length < fds.length) {
      throw ArgumentError('Functional dependencies must be unique.');
    }
  }

  @override
  String toString() {
    return 'Attributes: ${attributes.join(", ")}\nFunctional Dependencies:\n${fds.join("\n")}';
  }
}