private import AstImport

/**
 * A constant string expression. For example, the string `"hello"` or `'world'`.
 */
class StringConstExpr extends Expr, TStringConstExpr {
  string getValueString() { result = getRawAst(this).(Raw::StringConstExpr).getValue().getValue() }

  override string toString() { result = this.getValueString() }
}
