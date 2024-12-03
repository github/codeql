import javascript

query predicate comprehensionBlock(ComprehensionBlock cb, Expr dom, BindingPattern iter) {
  iter = cb.getIterator() and dom = cb.getDomain()
}

query predicate comprehensionExpr(ComprehensionExpr ce, int numBlock, int numFilter, Expr body) {
  numBlock = ce.getNumBlock() and
  numFilter = ce.getNumFilter() and
  body = ce.getBody()
}

query ComprehensionBlock getBlock(ComprehensionExpr ce, int i) { result = ce.getBlock(i) }

query Expr getFilter(ComprehensionExpr ce, int i) { result = ce.getFilter(i) }

query predicate varDecls(VarAccess va, VarDecl decl) { decl = va.getVariable().getADeclaration() }
