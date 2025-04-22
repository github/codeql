private import AstImport

class ConstExpr extends Expr, TConstExpr {
  string getValueString() { result = getRawAst(this).(Raw::ConstExpr).getValue().getValue() }

  override string toString() { result = this.getValue().getValue() }
}
