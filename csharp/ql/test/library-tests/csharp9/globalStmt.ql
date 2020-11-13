import csharp

query predicate global_stmt(Stmt stmt) { stmt.isGlobal() }

query predicate globalBlock(BlockStmt block, Method m, Parameter p, Type t) {
  block.isGlobalStatementContainer() and
  block.getEnclosingCallable() = m and
  m.getDeclaringType() = t and
  m.getAParameter() = p
}

query predicate methods(Method m, string entry) {
  m.getFile().getStem() = "GlobalStmt" and
  if m.isEntry() then entry = "entry" else entry = "non-entry"
}
