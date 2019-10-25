import cpp

/**
 * Gets the enclosing element of statement `s`.
 */
cached
Element stmtEnclosingElement(Stmt s) {
  result.(Function).getEntryPoint() = s or
  result = stmtEnclosingElement(s.getParent()) or
  result = exprEnclosingElement(s.getParent())
}

/**
 * Gets the enclosing element of expression `e`.
 */
cached
Element exprEnclosingElement(Expr e) {
  result = exprEnclosingElement(e.getParent())
  or
  result = stmtEnclosingElement(e.getParent())
  or
  result.(Function) = e.getParent()
  or
  result = exprEnclosingElement(e.(Conversion).getExpr())
  or
  exists(Initializer i |
    i.getExpr() = e and
    if exists(i.getEnclosingStmt())
    then result = stmtEnclosingElement(i.getEnclosingStmt())
    else
      if i.getDeclaration() instanceof Parameter
      then result = i.getDeclaration().(Parameter).getFunction()
      else result = i.getDeclaration()
  )
  or
  exists(Expr anc |
    expr_ancestor(unresolveElement(e), unresolveElement(anc)) and result = exprEnclosingElement(anc)
  )
  or
  exists(Stmt anc |
    expr_ancestor(unresolveElement(e), unresolveElement(anc)) and result = stmtEnclosingElement(anc)
  )
  or
  exists(DeclarationEntry de |
    expr_ancestor(unresolveElement(e), unresolveElement(de)) and
    if exists(DeclStmt ds | de = ds.getADeclarationEntry())
    then
      exists(DeclStmt ds |
        de = ds.getADeclarationEntry() and
        result = stmtEnclosingElement(ds)
      )
    else result = de.getDeclaration()
  )
}
