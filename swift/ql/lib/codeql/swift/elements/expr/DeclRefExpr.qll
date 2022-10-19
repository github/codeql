private import codeql.swift.generated.expr.DeclRefExpr

class DeclRefExpr extends Generated::DeclRefExpr {
  override string toString() { result = this.getDecl().toString() }
}
