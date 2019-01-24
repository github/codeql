import javascript

from DeclStmt ds, VariableDeclarator d1, VariableDeclarator d2, Variable v, int i, int j
where
  d1 = ds.getDecl(i) and
  d2 = ds.getDecl(j) and
  i < j and
  v = d1.getBindingPattern().getAVariable() and
  v = d2.getBindingPattern().getAVariable() and
  not ds.getTopLevel().isMinified()
select ds, "Variable " + v.getName() + " is declared both $@ and $@.", d1, "here", d2, "here"
