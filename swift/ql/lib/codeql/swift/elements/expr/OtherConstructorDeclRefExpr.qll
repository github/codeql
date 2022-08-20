private import codeql.swift.generated.expr.OtherConstructorDeclRefExpr

class OtherConstructorDeclRefExpr extends OtherConstructorDeclRefExprBase {
  override string toString() { result = this.getConstructorDecl().toString() }
}
