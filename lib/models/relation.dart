import 'package:fni/common/enums/enums.dart';
import 'package:fni/models/functional_dependency.dart';

class Relation {
  final List<String> _attributes; // List of attributes of the relation
  final List<FunctionalDependency>
      _fds; // List of functional dependencies for the relation
  late final Set<List<String>> _candidateKeys; // Candidate keys of the relation
  final Set<String> _primeAttributes =
      {}; // Set of prime attributes (part of candidate keys)
  late final Set<String> _nonPrimeAttributes; // Set of non-prime attributes
  late int _nf; // Normal form of the relation (1st, 2nd, 3rd, or BCNF)
  late NormalForm _normalForm; // Enum that represents the normal form
  final List<FunctionalDependency> _problematicFDs =
      []; // List of problematic functional dependencies

  // Constructor that initializes the relation with its attributes and functional dependencies
  Relation(this._attributes, this._fds) {
    // Validation checks for attributes and functional dependencies
    if (_attributes.isEmpty || _fds.isEmpty) {
      throw ArgumentError('Attributes cannot be empty.');
    }
    if (_fds.isEmpty) {
      throw ArgumentError('Functional dependencies cannot be empty.');
    }
    if (_attributes.length != _attributes.toSet().length) {
      throw ArgumentError('Attributes must be unique.');
    }
    if (_fds.length != _fds.toSet().length) {
      throw ArgumentError('Functional dependencies must be unique.');
    }
    // Initialize internal values
    init();
  }

  // Converts the Relation to a string representation (useful for debugging)
  @override
  String toString() =>
      'Attributes: ${_attributes.join(", ")}\nFunctional Dependencies:\n${_fds.join("\n")}';

  // Initializes internal state such as candidate keys, prime attributes, non-prime attributes, and normal form
  void init() {
    // Find the candidate keys of the relation
    _candidateKeys = findCandidateKeys(this);

    // Add the attributes of candidate keys to the primeAttributes set
    for (var key in _candidateKeys) {
      _primeAttributes.addAll(key);
    }

    // The non-prime attributes are those that are not part of any candidate key
    _nonPrimeAttributes =
        _attributes.where((e) => !_primeAttributes.contains(e)).toSet();

    // Check the normal form of the relation
    checkNormalForm(this);
  }

  // Computes the closure of a set of attributes with respect to the functional dependencies
  Set<String> attributeClosure(
      Set<String> attributes, List<FunctionalDependency> fds) {
    Set<String> closure =
        Set.from(attributes); // Start with the given attributes
    bool changed;
    do {
      changed = false;
      // For each functional dependency, check if we can add new attributes to the closure
      for (var fd in fds) {
        if (closure.containsAll(fd.determinant) &&
            !closure.contains(fd.dependent)) {
          closure
              .add(fd.dependent); // Add the dependent attribute to the closure
          changed = true;
        }
      }
    } while (changed); // Repeat until no new attributes are added
    return closure;
  }

  // Finds all the candidate keys for the relation
  Set<List<String>> findCandidateKeys(Relation relation) {
    Set<List<String>> candidateKeys = {}; // Set to hold the candidate keys
    int numAttributes = relation._attributes.length;

    // Iterate over all possible subsets of attributes (power set)
    for (int i = 1; i < (1 << numAttributes); i++) {
      var subset = {
        for (int j = 0; j < numAttributes; j++)
          if (i & (1 << j) != 0)
            relation._attributes[j] // Select attributes for the subset
      };

      // If the closure of the subset contains all attributes, it's a candidate key
      if (attributeClosure(subset, relation._fds).length ==
          relation._attributes.length) {
        candidateKeys.add(subset.toList());
      }
    }

    // Filter out non-minimal candidate keys (keys that are supersets of others)
    return candidateKeys
        .where((key) => !candidateKeys.any(
              (otherKey) =>
                  key.length > otherKey.length &&
                  key.toSet().containsAll(otherKey),
            ))
        .toSet();
  }

  // Checks the normal form of the relation (1NF, 2NF, 3NF, or BCNF)
  void checkNormalForm(Relation relation) {
    _nf = 4; // Start with BCNF as the default
    _normalForm = NormalForm.bcnf;

    // Check if any functional dependency violates 2NF or 3NF
    for (var fd in relation._fds) {
      if (relation._candidateKeys
          .any((key) => setEquals(key, fd.determinant))) {
        continue; // Skip if determinant is part of a candidate key
      }
      // If the dependent attribute is not a prime attribute (it's non-prime), check for 2NF and 3NF violation
      if (!relation._primeAttributes.contains(fd.dependent)) {
        // Checking for 2NF violation
        if (relation._candidateKeys.any((key) =>
            key.length > 1 && key.any((k) => fd.determinant.contains(k)))) {
          _nf = 1; // 1NF
          _problematicFDs.add(fd); // Add as Partial Dependency
        }
        // Checking for 3NF violation
        else {
          _nf = 2; // 2NF
          _problematicFDs.add(fd); // Add as Transitive Dependency
        }
      }
    }

    // If it violates either 2NF OR 3NF then return
    if (_nf == 1) {
      _normalForm = NormalForm.first;
      return;
    }
    if (_nf == 2) {
      _normalForm = NormalForm.second;
      return;
    }

    // Checking for BCNF violation
    for (var fd in relation._fds) {
      if (!isSuperKey(fd.determinant, relation._candidateKeys)) {
        _nf = 3; // 3NF
        _problematicFDs.add(fd); // Add as functional dependencies where the determinant is not a superkey
      }
    }
    if (_nf == 3) _normalForm = NormalForm.third;
  }

  // Checks if a set of attributes is a superkey (a candidate key or superset of it)
  bool isSuperKey(List<String> determinant, Set<List<String>> candidateKeys) =>
      candidateKeys.any((key) => setEquals(key, determinant));

  // Checks if two sets are equal (i.e., they contain the same elements)
  bool setEquals(List<String> set1, List<String> set2) =>
      set1.toSet().containsAll(set2) && set2.toSet().containsAll(set1);

  // Getters for accessing private fields
  List<String> get attributes => _attributes;
  List<FunctionalDependency> get fds => _fds;
  Set<List<String>> get candidateKeys => _candidateKeys;
  Set<String> get primeAttributes => _primeAttributes;
  Set<String> get nonPrimeAttributes => _nonPrimeAttributes;
  int get nf => _nf;
  NormalForm get normalForm => _normalForm;
  List<FunctionalDependency> get problematicFDs => _problematicFDs;
}
