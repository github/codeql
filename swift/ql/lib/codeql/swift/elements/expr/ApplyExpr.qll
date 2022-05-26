private import codeql.swift.generated.expr.ApplyExpr
private import codeql.swift.elements.decl.FuncDecl
private import codeql.swift.elements.expr.DeclRefExpr

class ApplyExpr extends ApplyExprBase {
  FuncDecl getStaticTarget() { result = this.getFunction().(DeclRefExpr).getDecl() }
}
