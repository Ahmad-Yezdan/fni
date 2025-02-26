import 'package:fni/models/functional_dependency.dart';
import 'package:fni/models/relation.dart';

class NormalizationCompleteness {
  final Relation relation;
  late final List<FunctionalDependency>
      pfds; // Preventing Functional Dependencies
  late final List<FunctionalDependency>
      npfds; // Non Preventing Functional Dependencies
  final Set<String> preventingAttributes = {};
  final Set<String> completenessAttributes = {};
  late final Set<String> totalAttributes;
  late double fuzzyFunctionality;
  late final double normalizationCompleteness;

  NormalizationCompleteness(this.relation) {
    init();
  }

  void init() {
    pfds = findPFDs(); // initializing Preventing Functional Dependencies
    npfds = relation.fds.where((element) => !pfds.contains(element)).toList();

    //initializing Preventing Attributes
    for (var fd in pfds) {
      preventingAttributes.addAll(fd.determinant);
      preventingAttributes.add(fd.dependent);
    }

    //initializing Completeness Attributes
    for (var fd in npfds) {
      completenessAttributes.addAll(fd.determinant);
      completenessAttributes.add(fd.dependent);
    }

    //initializing Total Attributes
    totalAttributes = completenessAttributes.union(preventingAttributes);

    //initializing Fuzzy Functionality
    fuzzyFunctionality =
        (((completenessAttributes.length / totalAttributes.length) +
                (1 - (preventingAttributes.length / totalAttributes.length))) /
            2);
    fuzzyFunctionality = (fuzzyFunctionality * 100).floor() /
        100; //flooring Fuzzy Functionality upto 2 decimal places

    //initializing Normalization Completeness
    normalizationCompleteness = relation.nf + fuzzyFunctionality;
  }

  List<FunctionalDependency> findPFDs() {
    Set<FunctionalDependency> pfds = {};

    for (var fd in relation.fds) {
      if (relation.candidateKeys.any((key) => setEquals(key, fd.determinant))) {
        continue;
      }
      if (!relation.primeAttributes.contains(fd.dependent)) {
        if (relation.candidateKeys.any((key) =>
            key.length > 1 && key.any((k) => fd.determinant.contains(k)))) {
          pfds.add(fd);
        } else {
          pfds.add(fd);
        }
      }
    }

    for (var fd in relation.fds) {
      if (!isSuperKey(fd.determinant, relation.candidateKeys)) {
        pfds.add(fd);
      }
    }

    return pfds.toList();
  }

  bool isSuperKey(List<String> determinant, Set<List<String>> candidateKeys) =>
      candidateKeys.any((key) => setEquals(key, determinant));

  bool setEquals(List<String> set1, List<String> set2) =>
      set1.toSet().containsAll(set2) && set2.toSet().containsAll(set1);
}
