class FunctionalDependency {
  final List<String> determinant;
  final String dependent;

  FunctionalDependency(List<String> determinant, this.dependent)
      : determinant = List.from(determinant)..sort() {
    if (determinant.isEmpty) {
      throw ArgumentError('Determinant(s) cannot be empty.');
    }
    if (dependent.isEmpty) {
      throw ArgumentError('Dependent cannot be empty.');
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FunctionalDependency &&
        other.dependent == dependent &&
        other.determinant.length == determinant.length &&
        other.determinant.every((attr) => determinant.contains(attr));
  }

  @override
  int get hashCode => Object.hash(dependent, determinant.join(','));

  @override
  String toString() => '${determinant.join(", ")} -> $dependent';
}