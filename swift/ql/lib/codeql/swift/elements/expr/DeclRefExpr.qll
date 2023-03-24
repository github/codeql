private import codeql.swift.generated.expr.DeclRefExpr

class DeclRefExpr extends Generated::DeclRefExpr {
  override string toString() {
    if exists(this.getDecl().toString())
    then result = this.getDecl().toString()
    else result = "(unknown declaration)"
  }
}
