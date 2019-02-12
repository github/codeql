/**
 * @name Unused property
 * @description Unused properties may be a symptom of a bug and should be examined carefully.
 * @kind problem
 * @problem.severity recommendation
 * @id js/unused-property
 * @tags maintainability
 * @precision high
 */

import javascript
import semmle.javascript.dataflow.CapturedNodes
import UnusedVariable
import UnusedParameter
import Expressions.ExprHasNoEffect

predicate hasUnknownPropertyRead(CapturedSource obj) {
  // dynamic reads
  exists(DataFlow::PropRead r | obj.getAPropertyRead() = r | not exists(r.getPropertyName()))
  or
  // reflective reads
  obj.flowsToExpr(any(EnhancedForLoop l).getIterationDomain())
  or
  obj.flowsToExpr(any(InExpr l).getRightOperand())
  or
  obj.flowsToExpr(any(SpreadElement e).getOperand())
  or
  exists(obj.getAPropertyRead("hasOwnProperty"))
  or
  exists(obj.getAPropertyRead("propertyIsEnumerable"))
}

predicate flowsToTypeRestrictedExpression(CapturedSource n) {
  exists (Expr restricted, TypeExpr type |
    n.flowsToExpr(restricted) and
    not type.isAny() |
    exists (TypeAssertion assertion |
      type = assertion.getTypeAnnotation() and
      restricted = assertion.getExpression()
    )
    or
    exists (BindingPattern v |
      type = v.getTypeAnnotation() and
      restricted = v.getAVariable().getAnAssignedExpr()
    )
    // no need to reason about writes to typed fields, captured nodes do not reach them
  )
}

from DataFlow::PropWrite w, CapturedSource n, string name
where
  w = n.getAPropertyWrite(name) and
  not exists(n.getAPropertyRead(name)) and
  not w.getBase().analyze().getAValue() != n.analyze().getAValue() and
  not hasUnknownPropertyRead(n) and
  // avoid reporting if the definition is unreachable
  w.getAstNode().getFirstControlFlowNode().getBasicBlock() instanceof ReachableBasicBlock and
  // avoid implicitly read properties
  not (
    name = "toString" or
    name = "valueOf" or
    name.matches("@@%") // @@iterator, for example
  ) and
  // avoid flagging properties that a type system requires
  not flowsToTypeRestrictedExpression(n) and
  // flagged by js/unused-local-variable
  not exists(UnusedLocal l | l.getAnAssignedExpr().getUnderlyingValue().flow() = n) and
  // flagged by js/unused-parameter
  not exists(Parameter p | isAnAccidentallyUnusedParameter(p) |
    p.getDefault().getUnderlyingValue().flow() = n
  ) and
  // flagged by js/useless-expression
  not inVoidContext(n.asExpr())
select w, "Unused property " + name + "."
