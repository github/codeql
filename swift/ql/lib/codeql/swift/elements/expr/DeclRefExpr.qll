private import codeql.swift.generated.expr.DeclRefExpr

class DeclRefExpr extends DeclRefExprBase {
  override string toString() { result = this.getDecl().toString() }
}
