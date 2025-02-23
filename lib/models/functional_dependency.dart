class FunctionalDependency {
  final List<String> determinant;
  final String dependent;

  FunctionalDependency(this.determinant, this.dependent) {
    if (determinant.isEmpty || dependent.isEmpty) {
      throw ArgumentError('Determinant and dependent cannot be empty.');
    }
  }

  @override
  String toString() => '${determinant.join(", ")} -> $dependent';
}