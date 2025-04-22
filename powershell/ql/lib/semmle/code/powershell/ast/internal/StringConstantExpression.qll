private import AstImport

class StringConstExpr extends Expr, TStringConstExpr {
  string getValueString() { result = getRawAst(this).(Raw::StringConstExpr).getValue().getValue() }

  override string toString() { result = this.getValueString() }
}
