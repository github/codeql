private import csharp

pragma[nomagic]
predicate isPatternExprDescendant(Expr e) {
  e instanceof PatternExpr
  or
  exists(Expr parent |
    isPatternExprDescendant(parent) and
    e = parent.getAChildExpr()
  )
}
