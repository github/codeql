private import codeql.swift.generated.Raw

predicate constructMethodLookupExpr(Raw::SelfApplyExpr id) { any() }

Raw::Decl extractDeclFromSelfApplyExpr(Raw::SelfApplyExpr e) {
  exists(Raw::Expr unwrappedFunction | unwrappedFunction = unwrapConversion*(e.getFunction()) |
    result =
      [
        unwrappedFunction.(Raw::DeclRefExpr).getDecl(),
        unwrappedFunction.(Raw::OtherConstructorDeclRefExpr).getConstructorDecl()
      ]
  )
}

private Raw::Expr unwrapConversion(Raw::Expr e) {
  e.(Raw::ImplicitConversionExpr).getSubExpr() = result
}
