/**
 * @name Incorrect return-value check for a 'scanf'-like function
 * @description Failing to account for EOF in a call to a scanf-like function can lead to 
 *             undefined behavior.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id cpp/discarded-scanf
 * @tags security
 *       correctness
 *       external/cwe/cwe-252
 *       external/cwe/cwe-253
 */

import cpp
import semmle.code.cpp.commons.Scanf

predicate exprInBooleanContext(Expr e) {
  e.getParent() instanceof BinaryLogicalOperation
  or
  e.getParent() instanceof UnaryLogicalOperation
  or
  e = any(IfStmt ifStmt).getCondition()
  or
  e = any(WhileStmt whileStmt).getCondition()
  or
  exists(EqualityOperation eqOp, Expr other |
    eqOp.hasOperands(e, other) and
    other.getValue() = "0"
  )
  or
  exists(Variable v |
    v.getAnAssignedValue() = e and
    forex(Expr use | use = v.getAnAccess() | exprInBooleanContext(use))
  )
}

from ScanfFunctionCall call
where
  exprInBooleanContext(call) and
  not exists(call.getTarget().getDefinition()) // ignore calls where the scanf is defined as they might be different (e.g. linux)
select call, "The result of scanf is onyl checkeck against 0, but it can also return EOF."
