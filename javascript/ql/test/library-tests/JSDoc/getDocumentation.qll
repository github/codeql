import javascript

query predicate test_AssignExpr_getDocumentation(AssignExpr assgn, JSDoc res) {
  res = assgn.getDocumentation()
}

query predicate test_Function_getDocumentation(Function f, JSDoc res) { res = f.getDocumentation() }

query predicate test_VarDeclStmt_getDocumentation(VarDeclStmt vds, JSDoc res) {
  res = vds.getDocumentation()
}
