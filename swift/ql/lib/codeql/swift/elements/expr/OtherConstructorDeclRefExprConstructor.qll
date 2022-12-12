private import codeql.swift.generated.Raw
private import codeql.swift.elements.expr.MethodLookupExprConstructor

predicate constructOtherConstructorDeclRefExpr(Raw::OtherConstructorDeclRefExpr id) {
  // exclude an argument that will be part of a SelfApplyExpr
  // that will be transformed into a MethodLookupExpr
  not exists(Raw::SelfApplyExpr e | id.getConstructorDecl() = extractDeclFromSelfApplyExpr(e))
}
