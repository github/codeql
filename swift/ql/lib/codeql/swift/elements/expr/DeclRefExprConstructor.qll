private import codeql.swift.generated.Raw
private import codeql.swift.elements.expr.MethodLookupExprConstructor

predicate constructDeclRefExpr(Raw::DeclRefExpr id) {
  // exclude an argument that will be part of a SelfApplyExpr
  // that will be transformed into a MethodLookupExpr
  not exists(Raw::SelfApplyExpr e | id.getDecl() = extractDeclFromSelfApplyExpr(e))
}
