import java

Element nthChildOf(Element e, int i) {
  result.(Expr).isNthChildOf(e, i) or
  result.(Stmt).isNthChildOf(e, i)
}

predicate duplicateChildren(Element e, int i) {
  nthChildOf(e, i) != nthChildOf(e, i) and
  // Java #165
  not e instanceof Method and
  // Java #165
  not e instanceof Constructor
}

predicate gapInChildren(Element e, int i) {
  exists(int left, int right |
    left = min(int l | exists(nthChildOf(e, l))) and
    right = max(int r | exists(nthChildOf(e, r))) and
    i in [left .. right] and
    not exists(nthChildOf(e, i))
  ) and
  // Annotations are child 0 upwards, 'implements' are -2 downwards,
  // and there may or may not be an 'extends' for child -1.
  not (e instanceof ClassOrInterface and i = -1) and
  // A class instance creation expression has the type as child -3,
  // may or may not have a qualifier as child -2, and will never have
  // a child -1.
  not (e instanceof ClassInstanceExpr and i = [-2, -1]) and
  // Type access have annotations from -2 down, and type
  // arguments from 0 up, but may or may not have a qualifier
  // at -1.
  not (e instanceof TypeAccess and i = -1) and
  // Try statements have their 'finally' clause as child 2,
  // and that may or may not exist.
  not (e instanceof TryStmt and i = -2) and
  // For statements may or may not declare a new variable (child 0), or
  // have a condition (child 1).
  not (e instanceof ForStmt and i = [0, 1]) and
  // TODO: Clarify situation with Kotlin and MethodCall.
  // -1 can be skipped (type arguments from -2 down, no qualifier at -1,
  // then arguments from 0).
  // Can we also skip arguments, e.g. due to defaults for parameters?
  not (e instanceof MethodCall and e.getFile().isKotlinSourceFile()) and
  // Kotlin-extracted annotations can have missing children where a default
  // value should be, because kotlinc doesn't load annotation defaults and we
  // want to leave a space for another extractor to fill in the default if it
  // is able.
  not e instanceof Annotation and
  // Pattern case statements legitimately have a TypeAccess (-2) and a pattern (0) but not a rule (-1)
  not (i = -1 and e instanceof PatternCase and not e.(PatternCase).isRule()) and
  // Pattern case statements can have a gap at -3 when they have more than one pattern but no guard.
  not (
    i = -3 and count(e.(PatternCase).getAPattern()) > 1 and not exists(e.(PatternCase).getGuard())
  ) and
  // Pattern case statements may have some missing type accesses, depending on the nature of the direct child
  not (
    (i = -2 or i < -4) and
    e instanceof PatternCase
  ) and
  // Instanceof with a record pattern is not expected to have a type access in position 1
  not (i = 1 and e.(InstanceOfExpr).getPattern() instanceof RecordPatternExpr) and
  // RecordPatternExpr extracts type-accesses only for its LocalVariableDeclExpr children
  not (i < 0 and e instanceof RecordPatternExpr)
}

predicate lateFirstChild(Element e, int i) {
  i > 0 and
  i = min(int j | exists(nthChildOf(e, j))) and
  // A wildcard type access can be `?` with no children,
  // `? extends T` with only a child 0, or `? super T`
  // with only a child 1.
  not (e instanceof WildcardTypeAccess and i = 1) and
  // For a normal local variable decl, child 0 is the type.
  // However, for a Java 10 `var x = ...` declaration, there is
  // no type, so the first child is the variable as child 1.
  // There can only be one variable declared in these declarations,
  // so there will never be a child 2.
  not (e instanceof LocalVariableDeclStmt and i = 1 and not exists(nthChildOf(e, 2))) and
  // For statements may or may not declare a new variable (child 0), or
  // have a condition (child 1).
  not (e instanceof ForStmt and i = [1, 2]) and
  // Kotlin-extracted annotations can have missing children where a default
  // value should be, because kotlinc doesn't load annotation defaults and we
  // want to leave a space for another extractor to fill in the default if it
  // is able.
  not e instanceof Annotation
}

from Element e, int i, string problem
where
  problem = "duplicate" and duplicateChildren(e, i)
  or
  problem = "gap" and gapInChildren(e, i)
  or
  problem = "late" and lateFirstChild(e, i)
select e, e.getPrimaryQlClasses(), i, problem,
  concat(int j | exists(nthChildOf(e, j)) | j.toString(), ", " order by j)
