import 'package:fni/common/utils.dart';

class FunctionalDependency {
  final List<String> _determinant;
  final String _dependent;

  FunctionalDependency(List<String> determinant, String dependent)
      : _determinant = List.from(determinant)..sort(), 
        _dependent = dependent {
    if (_determinant.isEmpty) {
      throw ArgumentError('Determinant(s) cannot be empty.');
    }
    if (_dependent.isEmpty) {
      throw ArgumentError('Dependent cannot be empty.');
    }
  }

  List<String> get determinant => _determinant;
  String get dependent => _dependent;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FunctionalDependency &&
        other._dependent == _dependent &&
        other._determinant.length == _determinant.length &&
        other._determinant.every((attr) => _determinant.contains(attr));
  }

  @override
  int get hashCode => Object.hash(_dependent, _determinant.join(','));

  @override
  String toString() {
    return '${_determinant.map((item) => truncate(item, 15)).join(", ")} -> ${truncate(_dependent, 15)}';
  }
}
