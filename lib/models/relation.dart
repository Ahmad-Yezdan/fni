import 'package:fni/common/enums/enums.dart';
import 'package:fni/models/functional_dependency.dart';

class Relation {
  final List<String> attributes; // Relation attributes
  final List<FunctionalDependency> fds; // Functional dependencies
  late final Set<List<String>> candidateKeys; // Candidate Keys
  final Set<String> primeAttributes = {}; // Prime Attributes
  late final Set<String> nonPrimeAttributes; // Non-Prime Attributes
  late int nf; // normal form value i.e. 1,2,3 and 4
  late NormalForm normalForm; // enum of normal form
  List<FunctionalDependency> problematicFDs =
      []; // problematic Functional Dependencies

  Relation(this.attributes, this.fds) {
    if (attributes.isEmpty) {
      throw ArgumentError('Attributes cannot be empty.');
    }
    final uniqueAttributes = attributes.toSet();
    if (uniqueAttributes.length < attributes.length) {
      throw ArgumentError('Attributes must be unique.');
    }

    if (fds.isEmpty) {
      throw ArgumentError('Functional dependencies cannot be empty.');
    }

    final uniqueFDs = fds.toSet();
    if (uniqueFDs.length < fds.length) {
      throw ArgumentError('Functional dependencies must be unique.');
    }

    init();
  }

  @override
  String toString() {
    return 'Attributes: ${attributes.join(", ")}\nFunctional Dependencies:\n${fds.join("\n")}';
  }

  void init() {
    candidateKeys = findCandidateKeys(this);
    for (var key in candidateKeys) {
      primeAttributes.addAll(key);
    }
    nonPrimeAttributes = attributes
        .where((element) => !primeAttributes.contains(element))
        .toSet();

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

    // Generate all combinations of attributes
    for (int i = 1; i < (1 << numAttributes); i++) {
      Set<String> subset = {};
      for (int j = 0; j < numAttributes; j++) {
        if (i & (1 << j) != 0) {
          subset.add(relation.attributes[j]);
        }
      }

      // Check if the closure of the subset equals the full set of attributes
      if (attributeClosure(subset, relation.fds).length ==
          relation.attributes.length) {
        candidateKeys.add(subset.toList());
      }
    }

    // Filter out non-minimal candidate keys
    Set<List<String>> minimalKeys = {};
    for (var key in candidateKeys) {
      bool isMinimal = true;
      for (var otherKey in candidateKeys) {
        if (key.length > otherKey.length &&
            key.toSet().containsAll(otherKey.toSet())) {
          isMinimal = false;
          break;
        }
      }
      if (isMinimal) {
        minimalKeys.add(key);
      }
    }

    return minimalKeys;
  }

  void checkNormalForm(Relation relation) {
    nf = 4;
    normalForm = NormalForm.bcnf;

    //checking for first normal form
    if (relation.attributes.isEmpty) {
      nf = 0;
      normalForm = NormalForm.zero;
      return;
    }

    //checking for second normal form
    outer:
    for (var fd in relation.fds) {
      for (var key in relation.candidateKeys) {
        // Skip this FD if its determinant is whole candidate key
        if (key.toSet().length == fd.determinant.toSet().length &&
            key.toSet().containsAll(fd.determinant.toSet())) {
          continue outer;
        }
      }

      // Skip this FD if its dependent is a prime attribute
      if (relation.primeAttributes.contains(fd.dependent)) {
        continue;
      }
      // Check for partial dependencies
      for (var key in relation.candidateKeys) {
        // If the determinant is part of the candidate key
        if (key.length > 1 && key.any((k) => fd.determinant.contains(k))) {
          nf = 1;
          problematicFDs.add(fd);
          print("Partial Dependency fount at: $fd");
        }
      }
    }
    if (nf == 1) {
      normalForm = NormalForm.first;
      return;
    }

    //checking for third normal form
    for (var fd in relation.fds) {
      // Skip this FD if its dependent is a prime attribute
      if (relation.primeAttributes.contains(fd.dependent)) {
        continue;
      }

      if (!(fd.determinant.any(
        (element) => relation.primeAttributes.contains(element),
      ))) {
        nf = 2;
        problematicFDs.add(fd);
        print("Transitive Dependency fount at: $fd");
      }
    }
    if (nf == 2) {
      normalForm = NormalForm.second;
      return;
    }

    //checking for boyce codd normal form
    for (var fd in relation.fds) {
      if (!isSuperKey(fd.determinant, relation.candidateKeys)) {
        nf = 3;
        problematicFDs.add(fd);
        print("Functional Dependency without SuperKey: $fd");
      }
    }
    if (nf == 3) {
      normalForm = NormalForm.third;
      return;
    }

    return;
  }

  //heper functions for BCNF
  bool setEquals(List<String> set1, List<String> set2) {
    // Check if two lists contain the same elements
    return set1.toSet().length == set2.toSet().length &&
        set1.toSet().containsAll(set2.toSet());
  }

  bool isSuperKey(List<String> determinant, Set<List<String>> candidateKeys) {
    for (var key in candidateKeys) {
      if (setEquals(key, determinant)) {
        return true; // Found a candidate key matching the determinant
      }
    }
    return false; // No matching candidate key found
  }

    // normal form functions
  bool isInFirstNormalForm(Relation relation) {
    // Assume all attributes are atomic
    return relation.attributes.isNotEmpty; // Ensure attributes are present
  }

  bool isInSecondNormalForm(Relation relation) {
    bool isInSecondNormalForm = true;
    if (!isInFirstNormalForm(relation)) {
      isInSecondNormalForm = false;
      return isInSecondNormalForm;
    }

    outer:
    for (var fd in relation.fds) {
      for (var key in relation.candidateKeys) {
        // Skip this FD if its determinant is whole candidate key
        if (key.toSet().length == fd.determinant.toSet().length &&
            key.toSet().containsAll(fd.determinant.toSet())) {
          continue outer;
        }
      }

      // Skip this FD if its dependent is a prime attribute
      if (relation.primeAttributes.contains(fd.dependent)) {
        continue;
      }
      // Check for partial dependencies
      for (var key in relation.candidateKeys) {
        // If the determinant is part of the candidate key
        if (key.length > 1 && key.any((k) => fd.determinant.contains(k))) {
          isInSecondNormalForm = false;
          print("Partial Dependency fount at: $fd");
        }
      }
    }

    return isInSecondNormalForm;
  }

  bool isInThirdNormalForm(Relation relation) {
    bool isInThirdNormalForm = true;
    if (!isInSecondNormalForm(relation)) {
      isInThirdNormalForm = false;
      return isInThirdNormalForm;
    }

    for (var fd in relation.fds) {
      // Skip this FD if its dependent is a prime attribute
      if (relation.primeAttributes.contains(fd.dependent)) {
        continue;
      }

      if (!(fd.determinant.any(
        (element) => relation.primeAttributes.contains(element),
      ))) {
        isInThirdNormalForm = false;
        print("Transitive Dependency fount at: $fd");
      }
    }

    return isInThirdNormalForm;
  }

  bool isInBCNF(Relation relation, bool isCheckingForNC) {
    bool isInBCNF = true;
    if (!isInThirdNormalForm(relation)) {
      isInBCNF = false;
      return isInBCNF;
    }

    for (var fd in relation.fds) {
      if (!isSuperKey(fd.determinant, relation.candidateKeys)) {
        isInBCNF = false;
        print("Functional Dependency without SuperKey: $fd");
      }
    }
    return isInBCNF;
  }


}
