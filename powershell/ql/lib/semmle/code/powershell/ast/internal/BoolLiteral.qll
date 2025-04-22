private import AstImport

class BoolLiteral extends Literal, TBoolLiteral {
  final override string toString() { result = this.getValue().toString() }

  final override ConstantValue getValue() { result.asBoolean() = this.getBoolValue() }

  boolean getBoolValue() { any(Synthesis s).booleanValue(this, result) }
}
