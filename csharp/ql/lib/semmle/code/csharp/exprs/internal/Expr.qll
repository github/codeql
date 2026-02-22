private import csharp

predicate isPatternExprAncestor(Expr e) {
  e instanceof PatternExpr
  or
  exists(Expr parent |
    isPatternExprAncestor(parent) and
    e = parent.getAChildExpr()
  )
}
