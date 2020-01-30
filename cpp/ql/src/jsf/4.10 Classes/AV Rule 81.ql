/**
 * @name AV Rule 81
 * @description The assignment operator shall handle self-assignment correctly.
 * @kind problem
 * @id cpp/jsf/av-rule-81
 * @precision low
 * @problem.severity error
 * @tags correctness
 *       external/jsf
 */

import cpp

/*
 * Note: it's almost impossible to implement this rule fully. We take a bug-finding
 * approach: try to look for some patterns that are definitely bad, while allowing
 * common patterns. Passing this query by no means implies that the implementation
 * is correct; though it probably shows that some thought has been put into it.
 * Hopefully correct implementations also pass, but 'cunning' implementations may not.
 */

/**
 * A copy assignment operator taking its parameter by reference.
 * For our purposes, copy assignment operators taking parameters by
 * value are likely fine, since the copy already happened
 */
class ReferenceCopyAssignmentOperator extends MemberFunction {
  ReferenceCopyAssignmentOperator() {
    this.getName() = "operator=" and
    this.getNumberOfParameters() = 1 and
    exists(ReferenceType rt |
      rt = this.getParameter(0).getType() and
      (
        rt.getBaseType() = this.getDeclaringType() or
        rt.getBaseType().(SpecifiedType).getBaseType() = this.getDeclaringType()
      )
    )
  }

  Parameter getRhs() { result = this.getParameter(0) }

  /** A self-equality test: between 'this' and the RHS parameter */
  IfStmt getASelfEqualityTest() {
    result.getEnclosingFunction() = this and
    exists(ComparisonOperation op |
      op = result.getCondition() and
      op.getAnOperand() instanceof ThisExpr and
      op.getAnOperand().(AddressOfExpr).getOperand().(VariableAccess).getTarget() = this.getRhs()
    )
  }

  /**
   * A call to a function called swap. Note: could be a member,
   * `std::swap` or a function overloading `std::swap` (not in `std::`)
   * so keep it simple
   */
  FunctionCall getASwapCall() {
    result.getEnclosingFunction() = this and
    result.getTarget().getName() = "swap"
  }

  /** A call to delete on a member variable */
  DeleteExpr getADeleteExpr() {
    result.getEnclosingFunction() = this and
    result.getExpr().(VariableAccess).getTarget().(MemberVariable).getDeclaringType() =
      this.getDeclaringType()
  }
}

/**
 * Test whether a class has a resource that needs management. Value class types are
 * okay because they get their semantics from their assignment operator. Primitive
 * types are fine (no management needed). Constant and reference values are okay too
 * (they can't be changed anyway). All that remains are pointer types.
 */
predicate hasResource(Class c) {
  exists(MemberVariable mv |
    mv.getDeclaringType() = c and
    mv.getType() instanceof PointerType
  )
}

from ReferenceCopyAssignmentOperator op
where
  hasResource(op.getDeclaringType()) and
  not exists(op.getASelfEqualityTest()) and
  not exists(op.getASwapCall()) and
  exists(op.getADeleteExpr())
select op, "AV Rule 81: The assignment operator shall handle self-assignment correctly."
