
enum NormalForm {
  zero('First Normal Form(1NF)', null),
  first('First Normal Form(1NF)', 'partial dependencies'),
  second('Second Normal Form(1NF)', 'transitive dependencies'),
  third('Third Normal Form(1NF)', 'functional dependencies where the determinant is not a superkey'),
  bcnf('Boyce Codd Normal Form(BCNF)',null);

  final String normalForm;
  final String? problematicdependencyName;
  const NormalForm(this.normalForm, this.problematicdependencyName);
}
