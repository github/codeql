import java

Element enclosingStmtOrOther(ExprParent ep) {
  result = ep.(Stmt) or
  result = enclosingStmtOrOther(ep.(Expr).getParent()) or
  result = enclosingStmtOrOther(ep.(WhenBranch).getWhenExpr()) or
  result = ep.(Callable) or
  result = enclosingStmtOrOther(ep.(Field).getDeclaration()) or
  result = ep.(FieldDeclaration) or
  result = ep.(Class) or
  result = ep.(Interface) or
  result = ep.(Parameter) or
  result = enclosingStmtOrOther(ep.(LocalVariableDecl).getDeclExpr()) or
  result = ep.(TypeVariable)
}

predicate multipleSpecified(Expr e) {
  e.getEnclosingStmt() != e.getEnclosingStmt()
}

predicate multipleInferred(Expr e) {
  enclosingStmtOrOther(e) != enclosingStmtOrOther(e)
}

predicate noneInferred(Expr e) {
  not exists(enclosingStmtOrOther(e))
}

predicate difference(Expr e) {
  e.getEnclosingStmt() != enclosingStmtOrOther(e)
  // bug in Java?:
  and not enclosingStmtOrOther(e) instanceof LocalVariableDeclStmt
}

predicate notSpecified(Expr e) {
  enclosingStmtOrOther(e) instanceof Stmt and not exists(e.getEnclosingStmt())
  // bug in Java?
  and not e instanceof Annotation and e.getFile().isJavaSourceFile()
  // bug in Kotlin?
  and not e instanceof TypeAccess and e.getFile().isKotlinSourceFile()
}

predicate problem(Expr e, string s) {
  multipleSpecified(e) and s = "multiple specified" or
  multipleInferred(e) and s = "multiple inferred" or
  noneInferred(e) and s = "none inferred" or
  difference(e) and s = "difference" or
  notSpecified(e) and s = "not specified"
}

from Expr e, string s
where problem(e, s)
  and // bug in external deps?
      e.getCompilationUnit().fromSource()
select e, s, e.getPrimaryQlClasses()

