import java

Element nthChildOf(Element e, int i) {
  result.(Expr).isNthChildOf(e, i) or
  result.(Stmt).isNthChildOf(e, i)
}

predicate duplicateChildren(Element e, int i) {
  nthChildOf(e, i) != nthChildOf(e, i)
  // Bug?:
  and not e instanceof Method
  // Bug?:
  and not e instanceof Constructor
}

predicate gapInChildren(Element e, int i) {
  exists(nthChildOf(e, i))
  and not exists(nthChildOf(e, i - 1))
  and exists(int j | j < i | exists(nthChildOf(e, j)))
  // TODO: Tighten this up:
  and not e instanceof Class
  // TODO: Tighten this up:
  and not e instanceof Interface
  // TODO: Tighten this up:
  and not e instanceof ClassInstanceExpr
  // TODO: Tighten this up:
  and not e instanceof TypeAccess
  // TODO: Tighten this up:
  and not e instanceof TryStmt
  // TODO: Tighten this up:
  and not e instanceof ForStmt
  // Kotlin bug?
  and not (e instanceof MethodAccess and e.getFile().getExtension() = "kt")
}

predicate lateFirstChild(Element e, int i) {
  i > 0
  and exists(nthChildOf(e, i))
  and forex(int j | exists(nthChildOf(e, j)) | j >= i)
  // TODO: Tighten this up:
  and not e instanceof WildcardTypeAccess
  // TODO: Tighten this up:
  and not e instanceof LocalVariableDeclStmt
  // TODO: Tighten this up:
  and not e instanceof ForStmt
}

from Element e, int i, string problem
where problem = "duplicate" and duplicateChildren(e, i)
   or problem = "gap" and gapInChildren(e, i)
   or problem = "late" and lateFirstChild(e, i)
select e, e.getPrimaryQlClasses(), i, problem, nthChildOf(e, i),
       concat(int j | exists(nthChildOf(e, j)) | j.toString(), ", ")
