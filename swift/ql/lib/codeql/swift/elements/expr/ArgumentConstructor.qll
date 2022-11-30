private import codeql.swift.generated.Raw

predicate constructArgument(Raw::Argument id) {
  // exclude an argument that will be part of a DotSyntaxCallExpr
  // that will be transformed into a MethodRefCallExpr
  not exists(Raw::DotSyntaxCallExpr c |
    c.getFunction() instanceof Raw::DeclRefExpr and id = c.getArgument(0)
  )
}
