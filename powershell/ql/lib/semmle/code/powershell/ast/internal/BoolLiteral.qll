private import AstImport

/**
 * A boolean literal. For example:
 * ```
 * $true
 * $false
 * ```
 */
class BoolLiteral extends Literal, TBoolLiteral {
  final override string toString() { result = this.getValue().toString() }

  final override ConstantValue getValue() { result.asBoolean() = this.getBoolValue() }

  boolean getBoolValue() { any(Synthesis s).booleanValue(this, result) }
}
