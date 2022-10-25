private import codeql.swift.generated.expr.OtherConstructorDeclRefExpr

class OtherConstructorDeclRefExpr extends Generated::OtherConstructorDeclRefExpr {
  override string toString() { result = this.getConstructorDecl().toString() }
}
