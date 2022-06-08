private import codeql.swift.generated.expr.OtherConstructorDeclRefExpr

class OtherConstructorDeclRefExpr extends OtherConstructorDeclRefExprBase {
  override string toString() {
    result = "call to ..." // TODO: We can make this better once we extract the constructor call
  }
}
