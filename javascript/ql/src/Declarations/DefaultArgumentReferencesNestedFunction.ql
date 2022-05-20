/**
 * @name Default parameter references nested function
 * @description If a default parameter value references a function that is nested inside the
 *              function to which the parameter belongs, a runtime error will occur, since
 *              the function is not yet defined at the point where it is referenced.
 * @kind problem
 * @problem.severity error
 * @id js/nested-function-reference-in-default-parameter
 * @tags reliability
 *       correctness
 * @precision very-high
 */

import javascript

/**
 * Holds if `va` references function `inner`, which is nested inside function `outer`.
 */
predicate accessToNestedFunction(VarAccess va, FunctionDeclStmt inner, Function outer) {
  va.getVariable() = inner.getVariable() and
  inner.getEnclosingContainer() = outer
}

from Function f, VarAccess va, FunctionDeclStmt g
where
  accessToNestedFunction(va, g, f) and
  va.getParentExpr*() = f.getAParameter().getDefault()
select va, "This expression refers to $@ before it is defined.", g, g.getName()
