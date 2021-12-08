import java

Element nthChildOf(Element e, int i) {
  result.(Expr).isNthChildOf(e, i) or
  result.(Stmt).isNthChildOf(e, i)
}

predicate duplicateChildren(Element e, int i) {
  nthChildOf(e, i) != nthChildOf(e, i)
  // Java #165
  and not e instanceof Method
  // Java #165
  and not e instanceof Constructor
}

predicate gapInChildren(Element e, int i) {
  exists(int left, int right |
         left = min(int l | exists(nthChildOf(e, l))) and
         right = max(int r | exists(nthChildOf(e, r))) and
         i in [left .. right] and
         not exists(nthChildOf(e, i)))
  // TODO: Tighten this up:
  and not e instanceof Class
  // TODO: Tighten this up:
  and not e instanceof Interface
  // A class instance creation expression has the type as child -3,
  // may or may not have a qualifier as child -2, and will never have
  // a child -1.
  and not (e instanceof ClassInstanceExpr and i = [-2, -1])
  // Type access have annotations from -2 down, and type
  // arguments from 0 up, but may or may not have a qualifier
  // at -1.
  and not (e instanceof TypeAccess and i = -1)
  // Try statements have their 'finally' clause as child 2,
  // and that may or may not exist.
  and not (e instanceof TryStmt and i = -2)
  // TODO: Tighten this up:
  and not e instanceof ForStmt
  // Kotlin bug?
  and not (e instanceof MethodAccess and e.getFile().getExtension() = "kt")
}

predicate lateFirstChild(Element e, int i) {
  i > 0
  and exists(nthChildOf(e, i))
  and forex(int j | exists(nthChildOf(e, j)) | j >= i)
  // A wildcard type access can be `?` with no children,
  // `? extends T` with only a child 0, or `? super T`
  // with only a child 1.
  and not (e instanceof WildcardTypeAccess and i = 1)
  // For a normal local variable decl, child 0 is the type.
  // However, for a Java 10 `var x = ...` declaration, there is
  // no type, so the first child is the variable as child 1.
  // There can only be one variable declared in these declarations,
  // so there will never be a child 2.
  and not (e instanceof LocalVariableDeclStmt and i = 1 and not exists(nthChildOf(e, 2)))
  // TODO: Tighten this up:
  and not e instanceof ForStmt
}

from Element e, int i, string problem
where problem = "duplicate" and duplicateChildren(e, i)
   or problem = "gap" and gapInChildren(e, i)
   or problem = "late" and lateFirstChild(e, i)
select e, e.getPrimaryQlClasses(), i, problem,
       concat(int j | exists(nthChildOf(e, j)) | j.toString(), ", " order by j)
