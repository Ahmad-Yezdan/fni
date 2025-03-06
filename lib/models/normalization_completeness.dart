import 'package:fni/models/functional_dependency.dart';
import 'package:fni/models/relation.dart';

class NormalizationCompleteness {
  final Relation
      _relation; // The relation object containing the attributes and functional dependencies
  late final List<FunctionalDependency>
      _pfds; // List of Preventing Functional Dependencies
  late final List<FunctionalDependency>
      _npfds; // List of Non-Preventing Functional Dependencies
  final Set<String> _preventingAttributes =
      {}; // Set of attributes involved in preventing dependencies
  final Set<String> _completenessAttributes =
      {}; // Set of attributes involved in completeness dependencies
  late final Set<String>
      _totalAttributes; // Union of both preventing and completeness attributes
  late double
      _fuzzyFunctionality; // The fuzzy functionality measure, reflecting normalization quality
  late double
      _normalizationCompleteness; // The overall normalization completeness measure

  // Constructor to initialize the NormalizationCompleteness object with the relation
  NormalizationCompleteness(this._relation) {
    init(); // Call the init method to initialize the internal values
  }

  // Initialize all the internal values
  void init() {
    // Initialize Preventing Functional Dependencies (PFDs)
    _pfds = findPFDs();

    // Initialize Non-Preventing Functional Dependencies (NPFDs) by excluding the PFDs from the original FDs
    _npfds =
        _relation.fds.where((element) => !_pfds.contains(element)).toList();

    // Initialize the Preventing Attributes by adding both determinants and dependents of PFDs
    for (var fd in _pfds) {
      _preventingAttributes
          .addAll(fd.determinant); // Add determinant attributes of PFDs
      _preventingAttributes
          .add(fd.dependent); // Add dependent attributes of PFDs
    }

    // Initialize the Completeness Attributes by adding both determinants and dependents of NPFDs
    for (var fd in _npfds) {
      _completenessAttributes
          .addAll(fd.determinant); // Add determinant attributes of NPFDs
      _completenessAttributes
          .add(fd.dependent); // Add dependent attributes of NPFDs
    }

    // Initialize Total Attributes as the union of preventing and completeness attributes
    _totalAttributes = _completenessAttributes.union(_preventingAttributes);

    // Calculate Fuzzy Functionality (a measure of how complete the normalization is)
    _fuzzyFunctionality = (((_completenessAttributes.length /
                _totalAttributes.length) +
            (1 - (_preventingAttributes.length / _totalAttributes.length))) /
        2);
    // Round the value to two decimal places for consistency
    _fuzzyFunctionality = double.parse(_fuzzyFunctionality.toStringAsFixed(2));

    // Calculate Normalization Completeness as the sum of the relation's normal form and the fuzzy functionality
    _normalizationCompleteness = _relation.nf + _fuzzyFunctionality;
    _normalizationCompleteness =
        double.parse(_normalizationCompleteness.toStringAsFixed(2));
  }

  // Private method to find Preventing Functional Dependencies (PFDs)
  List<FunctionalDependency> findPFDs() {
    Set<FunctionalDependency> pfds =
        {}; // Set to hold preventing functional dependencies

    // Check if any functional dependency violates 2NF or 3NF
    for (var fd in _relation.fds) {
      // If the determinant is part of any candidate key, skip it (it's not a preventing FD)
      if (_relation.candidateKeys
          .any((key) => setEquals(key, fd.determinant))) {
        continue;
      }
      // If the dependent attribute is not a prime attribute (it's non-prime), check for 2NF and 3NF violation
      if (!_relation.primeAttributes.contains(fd.dependent)) {
        // Checking for 2NF violation
        if (_relation.candidateKeys.any((key) =>
            key.length > 1 && key.any((k) => fd.determinant.contains(k)))) {
          pfds.add(fd); // Add as preventing FD
        }
        // Checking for 3NF violation
        else {
          pfds.add(fd); // Add as preventing FD
        }
      }
    }

    // Checking for BCNF violation
    for (var fd in _relation.fds) {
      if (!isSuperKey(fd.determinant, _relation.candidateKeys)) {
        pfds.add(fd); // Add as preventing FD
      }
    }

    return pfds.toList(); // Return as a list
  }

  // Helper method to check if a determinant is a superkey (part of a candidate key)
  bool isSuperKey(List<String> determinant, Set<List<String>> candidateKeys) =>
      candidateKeys.any((key) => setEquals(key, determinant));

  // Checks if two sets are equal (i.e., they contain the same elements)
  bool setEquals(List<String> set1, List<String> set2) =>
      set1.toSet().containsAll(set2) && set2.toSet().containsAll(set1);

  // Getters for accessing private fields
  List<FunctionalDependency> get pfds => _pfds;
  List<FunctionalDependency> get npfds => _npfds;
  Set<String> get preventingAttributes => _preventingAttributes;
  Set<String> get completenessAttributes => _completenessAttributes;
  Set<String> get totalAttributes => _totalAttributes;
  double get fuzzyFunctionality => _fuzzyFunctionality;
  double get normalizationCompleteness => _normalizationCompleteness;
}
