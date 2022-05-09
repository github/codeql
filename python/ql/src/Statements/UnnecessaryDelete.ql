/**
 * @name Unnecessary delete statement in function
 * @description Using a 'delete' statement to delete a local variable is
 *              unnecessary, because the variable is deleted automatically when
 *              the function exits.
 * @kind problem
 * @tags maintainability
 *       useless-code
 * @problem.severity warning
 * @sub-severity low
 * @precision high
 * @id py/unnecessary-delete
 */

import python

predicate isInsideLoop(AstNode node) {
  node.getParentNode() instanceof While
  or
  node.getParentNode() instanceof For
  or
  exists(AstNode prev | isInsideLoop(prev) | node = prev.getAChildNode())
}

from Delete del, Expr e, Function f
where
  f.getLastStatement() = del and
  e = del.getATarget() and
  f.containsInScope(e) and
  not e instanceof Subscript and
  not e instanceof Attribute and
  not isInsideLoop(del) and
  // False positive: calling `sys.exc_info` within a function results in a
  //       reference cycle, and an explicit call to `del` helps break this cycle.
  not exists(FunctionValue ex |
    ex = Value::named("sys.exc_info") and
    ex.getACall().getScope() = f
  )
select del, "Unnecessary deletion of local variable $@ in function $@.", e.getLocation(),
  e.toString(), f.getLocation(), f.getName()
