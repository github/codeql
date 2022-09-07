private import codeql.swift.generated.Raw

predicate constructDeclRefExpr(Raw::DeclRefExpr id) {
  // exclude an argument that will be part of a DotSyntaxCallExpr
  // that will be transformed into a MethodRefCallExpr
  not exists(Raw::DotSyntaxCallExpr c | id = c.getFunction())
}
