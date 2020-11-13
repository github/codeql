import javascript

query predicate comprehensionBlock(ComprehensionBlock cb, Expr dom, BindingPattern iter) {
  iter = cb.getIterator() and dom = cb.getDomain()
}

query predicate comprehensionExpr(ComprehensionExpr ce, int numBlock, int numFilter, Expr body) {
  numBlock = ce.getNumBlock() and
  numFilter = ce.getNumFilter() and
  body = ce.getBody()
}

query predicate getBlock(ComprehensionExpr ce, int i, ComprehensionBlock block) {
  ce.getBlock(i) = block
}

query predicate getFilter(ComprehensionExpr ce, int i, Expr filter) { ce.getFilter(i) = filter }

query predicate varDecls(VarAccess va, VarDecl decl) { decl = va.getVariable().getADeclaration() }
