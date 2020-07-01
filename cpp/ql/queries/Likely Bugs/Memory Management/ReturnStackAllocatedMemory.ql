/**
 * @name Returning stack-allocated memory
 * @description A function returns a pointer to a stack-allocated region of
 *              memory. This memory is deallocated at the end of the function,
 *              which may lead the caller to dereference a dangling pointer.
 * @kind problem
 * @id cpp/return-stack-allocated-memory
 * @problem.severity warning
 * @precision high
 * @tags reliability
 *       external/cwe/cwe-825
 */

import cpp
import semmle.code.cpp.dataflow.EscapesTree
import semmle.code.cpp.dataflow.DataFlow

/**
 * Holds if `n1` may flow to `n2`, ignoring flow through fields because these
 * are currently modeled as an overapproximation that assumes all objects may
 * alias.
 */
predicate conservativeDataFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
  DataFlow::localFlowStep(n1, n2) and
  not n2.asExpr() instanceof FieldAccess and
  not hasNontrivialConversion(n2.asExpr())
}

/**
 * Holds if `e` has a conversion that changes it from lvalue to pointer or
 * back. As the data-flow library does not support conversions, we cannot track
 * data flow through such expressions.
 */
predicate hasNontrivialConversion(Expr e) {
  e instanceof Conversion and
  not (
    e instanceof Cast
    or
    e instanceof ParenthesisExpr
  )
  or
  hasNontrivialConversion(e.getConversion())
}

from StackVariable var, VariableAccess va, ReturnStmt r
where
  not var.getUnspecifiedType() instanceof ReferenceType and
  not r.isFromUninstantiatedTemplate(_) and
  va = var.getAnAccess() and
  (
    // To check if the address escapes directly from `e` in `return e`, we need
    // to check the fully-converted `e` in case there are implicit
    // array-to-pointer conversions or reference conversions.
    variableAddressEscapesTree(va, r.getExpr().getFullyConverted())
    or
    // The data flow library doesn't support conversions, so here we check that
    // the address escapes into some expression `pointerToLocal`, which flows
    // in one or more steps to a returned expression.
    exists(Expr pointerToLocal |
      variableAddressEscapesTree(va, pointerToLocal.getFullyConverted()) and
      not hasNontrivialConversion(pointerToLocal) and
      conservativeDataFlowStep+(DataFlow::exprNode(pointerToLocal), DataFlow::exprNode(r.getExpr()))
    )
  )
select r, "May return stack-allocated memory from $@.", va, va.toString()
