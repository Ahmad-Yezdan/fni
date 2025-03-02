import 'package:fni/common/enums/enums.dart';
import 'package:fni/models/functional_dependency.dart';

class Relation {
  final List<String> attributes;
  final List<FunctionalDependency> fds;
  late final Set<List<String>> candidateKeys;
  final Set<String> primeAttributes = {};
  late final Set<String> nonPrimeAttributes;
  late int nf;
  late NormalForm normalForm;
  List<FunctionalDependency> problematicFDs = [];

  Relation(this.attributes, this.fds) {
    if (attributes.isEmpty || fds.isEmpty) {
      throw ArgumentError('Attributes cannot be empty.');
    }
    if(fds.isEmpty){
      throw ArgumentError('Functional dependencies cannot be empty.');
    }
    if (attributes.length != attributes.toSet().length) {
      throw ArgumentError('Attributes must be unique.');
    }
    if (fds.length != fds.toSet().length) {
      throw ArgumentError('Functional dependencies must be unique.');
    }
    init();
  }

  @override
  String toString() =>
      'Attributes: ${attributes.join(", ")}\nFunctional Dependencies:\n${fds.join("\n")}';

  void init() {
    candidateKeys = findCandidateKeys(this);
    for (var key in candidateKeys) {
      primeAttributes.addAll(key);
    }
    nonPrimeAttributes =
        attributes.where((e) => !primeAttributes.contains(e)).toSet();
    checkNormalForm(this);
  }

  Set<String> attributeClosure(
      Set<String> attributes, List<FunctionalDependency> fds) {
    Set<String> closure = Set.from(attributes);
    bool changed;
    do {
      changed = false;
      for (var fd in fds) {
        if (closure.containsAll(fd.determinant) &&
            !closure.contains(fd.dependent)) {
          closure.add(fd.dependent);
          changed = true;
        }
      }
    } while (changed);
    return closure;
  }

  Set<List<String>> findCandidateKeys(Relation relation) {
    Set<List<String>> candidateKeys = {};
    int numAttributes = relation.attributes.length;

    for (int i = 1; i < (1 << numAttributes); i++) {
      var subset = {
        for (int j = 0; j < numAttributes; j++)
          if (i & (1 << j) != 0) relation.attributes[j]
      };

      if (attributeClosure(subset, relation.fds).length ==
          relation.attributes.length) {
        candidateKeys.add(subset.toList());
      }
    }

    return candidateKeys.where((key) => !candidateKeys.any(
          (otherKey) =>
              key.length > otherKey.length && key.toSet().containsAll(otherKey),
        )).toSet();
  }

  void checkNormalForm(Relation relation) {
    nf = 4;
    normalForm = NormalForm.bcnf;

    for (var fd in relation.fds) {
      if (relation.candidateKeys.any((key) => setEquals(key, fd.determinant))) {
        continue;
      }
      if (!relation.primeAttributes.contains(fd.dependent)) {
        if (relation.candidateKeys
            .any((key) => key.length > 1 && key.any((k) => fd.determinant.contains(k)))) {
          nf = 1;
          problematicFDs.add(fd);
        } else {
          nf = 2;
          problematicFDs.add(fd);
        }
      }
    }
    if (nf == 1) {
      normalForm = NormalForm.first;
      return;
    }
    if (nf == 2) {
      normalForm = NormalForm.second;
      return;
    }

    for (var fd in relation.fds) {
      if (!isSuperKey(fd.determinant, relation.candidateKeys)) {
        nf = 3;
        problematicFDs.add(fd);
      }
    }
    if (nf == 3) normalForm = NormalForm.third;
  }

  bool isSuperKey(List<String> determinant, Set<List<String>> candidateKeys) =>
      candidateKeys.any((key) => setEquals(key, determinant));

  bool setEquals(List<String> set1, List<String> set2) =>
      set1.toSet().containsAll(set2) && set2.toSet().containsAll(set1);
}
