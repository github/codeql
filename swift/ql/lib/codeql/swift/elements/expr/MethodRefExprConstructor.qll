private import codeql.swift.generated.Raw

predicate constructMethodRefExpr(Raw::DotSyntaxCallExpr id) {
  id.getFunction() instanceof Raw::DeclRefExpr
}
