import javascript

query predicate test_query7(
  DeclStmt ds, string res0, VariableDeclarator d1, string res1, VariableDeclarator d2, string res2
) {
  exists(Variable v, int i, int j |
    d1 = ds.getDecl(i) and
    d2 = ds.getDecl(j) and
    i < j and
    v = d1.getBindingPattern().getAVariable() and
    v = d2.getBindingPattern().getAVariable() and
    not ds.getTopLevel().isMinified()
  |
    res0 = "Variable " + v.getName() + " is declared both $@ and $@." and
    res1 = "here" and
    res2 = "here"
  )
}
