private import AstImport

class NullLiteral extends Literal, TNullLiteral {
  final override string toString() { result = this.getValue().toString() }

  final override ConstantValue getValue() { result.isNull() }
}
