/**
 * @name Statement nesting depth
 * @description The maximum level of nesting of statements (for example 'if', 'for', 'while') in a
 *              method. Blocks are not counted.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg max
 * @id java/statement-nesting-depth-per-function
 * @tags maintainability
 *       complexity
 */

import java

/**
 * The parent of a statement, excluding some common cases that don't really make
 * sense for nesting depth. For example, in `if (...) { } else if (...) { }` we don't
 * consider the second `if` nested. Blocks are also skipped.
 */
predicate realParent(Stmt inner, Stmt outer) {
  if skipParent(inner) then realParent(inner.getParent(), outer) else outer = inner.getParent()
}

predicate skipParent(Stmt s) {
  exists(Stmt parent | parent = s.getParent() |
    s instanceof IfStmt and parent.(IfStmt).getElse() = s
    or
    parent instanceof BlockStmt
  )
}

predicate nestingDepth(Stmt s, int depth) {
  depth = count(Stmt enclosing | realParent+(s, enclosing))
}

from Method m, int depth
where
  depth =
    max(Stmt s, int aDepth | s.getEnclosingCallable() = m and nestingDepth(s, aDepth) | aDepth)
select m, depth order by depth
