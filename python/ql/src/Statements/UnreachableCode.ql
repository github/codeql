/**
 * @name Unreachable code
 * @description Code is unreachable
 * @kind problem
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-561
 * @problem.severity warning
 * @sub-severity low
 * @precision very-high
 * @id py/unreachable-statement
 */

import python

predicate typing_import(ImportingStmt is) {
  exists(Module m |
    is.getScope() = m and
    exists(TypeHintComment tc | tc.getLocation().getFile() = m.getFile())
  )
}

/** Holds if `s` contains the only `yield` in scope */
predicate unique_yield(Stmt s) {
  exists(Yield y | s.contains(y)) and
  exists(Function f |
    f = s.getScope() and
    strictcount(Yield y | f.containsInScope(y)) = 1
  )
}

/** Holds if `contextlib.suppress` may be used in the same scope as `s` */
predicate suppression_in_scope(Stmt s) {
  exists(With w |
    w.getContextExpr().(Call).getFunc().pointsTo(Value::named("contextlib.suppress")) and
    w.getScope() = s.getScope()
  )
}

/** Holds if `s` is a statement that raises an exception at the end of an if-elif-else chain. */
predicate marks_an_impossible_else_branch(Stmt s) {
  exists(If i | i.getOrelse().getItem(0) = s |
    s.(Assert).getTest() instanceof False
    or
    s instanceof Raise
  )
}

predicate reportable_unreachable(Stmt s) {
  s.isUnreachable() and
  not typing_import(s) and
  not suppression_in_scope(s) and
  not exists(Stmt other | other.isUnreachable() |
    other.contains(s)
    or
    exists(StmtList l, int i, int j | l.getItem(i) = other and l.getItem(j) = s and i < j)
  ) and
  not unique_yield(s) and
  not marks_an_impossible_else_branch(s)
}

from Stmt s
where reportable_unreachable(s)
select s, "Unreachable statement."
