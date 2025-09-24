private import AstImport

/**
 * A constant expression. For example, the number `42` or the string `"hello"`.
 */
class ConstExpr extends Expr, TConstExpr {
  string getValueString() { result = getRawAst(this).(Raw::ConstExpr).getValue().getValue() }

  override string toString() { result = this.getValue().getValue() }
}
