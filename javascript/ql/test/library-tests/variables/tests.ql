import javascript

query predicate capture(LocalVariable var, string name, VarDecl decl) {
  var.getADeclaration() = decl and name = var.getName()
}

query predicate getAnAssignedExpr(Variable v, Expr e) { e = v.getAnAssignedExpr() }

query predicate getDeclaringContainer(LocalVariable v, StmtContainer container) {
  container = v.getDeclaringContainer()
}

query predicate varBindings(VarAccess va, VarDecl decl) {
  decl = va.getVariable().getADeclaration()
}
