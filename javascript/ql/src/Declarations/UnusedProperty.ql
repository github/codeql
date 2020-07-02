/**
 * @name Unused property
 * @description Unused properties may be a symptom of a bug and should be examined carefully.
 * @kind problem
 * @problem.severity recommendation
 * @id js/unused-property
 * @tags maintainability
 * @precision low
 */

import javascript
import semmle.javascript.dataflow.LocalObjects
import UnusedVariable
import UnusedParameter
import Expressions.ExprHasNoEffect

predicate hasUnknownPropertyRead(LocalObject obj) {
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

/**
 * Holds if `obj` flows to an expression that must have a specific type.
 */
predicate flowsToTypeRestrictedExpression(LocalObject obj) {
  exists(Expr restricted, TypeExpr type |
    obj.flowsToExpr(restricted) and
    not type.isAny()
  |
    exists(TypeAssertion assertion |
      type = assertion.getTypeAnnotation() and
      restricted = assertion.getExpression()
    )
    or
    exists(BindingPattern v |
      type = v.getTypeAnnotation() and
      restricted = v.getAVariable().getAnAssignedExpr()
    )
    // no need to reason about writes to typed fields, captured nodes do not reach them
  )
}

from DataFlow::PropWrite write, LocalObject obj, string name
where
  write = obj.getAPropertyWrite(name) and
  not exists(obj.getAPropertyRead(name)) and
  // `obj` is the only base object for the write: it is not spurious
  not write.getBase().analyze().getAValue() != obj.analyze().getAValue() and
  not hasUnknownPropertyRead(obj) and
  // avoid reporting if the definition is unreachable
  write.getAstNode().getFirstControlFlowNode().getBasicBlock() instanceof ReachableBasicBlock and
  // avoid implicitly read properties
  not (
    name = "toString" or
    name = "valueOf" or
    name.matches("@@%") // @@iterator, for example
  ) and
  // avoid flagging properties that a type system requires
  not flowsToTypeRestrictedExpression(obj) and
  // flagged by js/unused-local-variable
  not exists(UnusedLocal l | l.getAnAssignedExpr().getUnderlyingValue().flow() = obj) and
  // flagged by js/unused-parameter
  not exists(Parameter p | isAnAccidentallyUnusedParameter(p) |
    p.getDefault().getUnderlyingValue().flow() = obj
  ) and
  // flagged by js/useless-expression
  not inVoidContext(obj.asExpr())
select write, "Unused property " + name + "."
