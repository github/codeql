import javascript

query predicate capture(LocalVariable var, string name, VarDecl decl) {
  var.getADeclaration() = decl and name = var.getName()
}

query Expr getAnAssignedExpr(Variable v) { result = v.getAnAssignedExpr() }

query StmtContainer getDeclaringContainer(LocalVariable v) { result = v.getDeclaringContainer() }

query predicate varBindings(VarAccess va, VarDecl decl) {
  decl = va.getVariable().getADeclaration()
}
