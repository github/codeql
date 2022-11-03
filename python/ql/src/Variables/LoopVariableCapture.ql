/**
 * @name Loop variable capture
 * @description Capture of a loop variable is not the same as capturing the value of a loop variable, and may be erroneous.
 * @kind problem
 * @tags correctness
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/loop-variable-capture
 */

import python

// Gets the scope of the iteration variable of the looping scope
Scope iteration_variable_scope(AstNode loop) {
  result = loop.(For).getScope()
  or
  result = loop.(Comp).getFunction()
}

predicate capturing_looping_construct(CallableExpr capturing, AstNode loop, Variable var) {
  var.getScope() = iteration_variable_scope(loop) and
  var.getAnAccess().getScope() = capturing.getInnerScope() and
  capturing.getParentNode+() = loop and
  (
    loop.(For).getTarget() = var.getAnAccess()
    or
    var = loop.(Comp).getAnIterationVariable()
  )
}

predicate escaping_capturing_looping_construct(CallableExpr capturing, AstNode loop, Variable var) {
  capturing_looping_construct(capturing, loop, var) and
  // Escapes if used out side of for loop or is a lambda in a comprehension
  (
    loop instanceof For and
    exists(Expr e | e.pointsTo(_, _, capturing) | not loop.contains(e))
    or
    loop.(Comp).getElt() = capturing
    or
    loop.(Comp).getElt().(Tuple).getAnElt() = capturing
  )
}

from CallableExpr capturing, AstNode loop, Variable var
where escaping_capturing_looping_construct(capturing, loop, var)
select capturing, "Capture of loop variable '$@'", loop, var.getId()
