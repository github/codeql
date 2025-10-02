/**
 * Provides predicates for reasoning about improper memoization methods.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.internal.DataFlowDispatch

/**
 * A `||=` statement that memoizes a value by storing it in an instance variable.
 */
private class MemoStmt extends AssignLogicalOrExpr {
  private InstanceVariableAccess instanceVariable;

  MemoStmt() { instanceVariable.getParent*() = this.getLeftOperand() }

  /**
   * Gets the variable access on the LHS of this statement.
   * This is the `@a` in `@a ||= e`.
   */
  VariableAccess getVariableAccess() { result = instanceVariable }
}

/**
 * A `||=` statement that stores a value at a particular location in a Hash,
 * which itself is stored in an instance variable.
 * For example:
 * ```rb
 * @a[key] ||= e
 * ```
 */
private class HashMemoStmt extends MemoStmt {
  HashMemoStmt() {
    exists(ElementReference e |
      e = this.getLeftOperand() and this.getVariableAccess().getParent+() = e
    )
  }
}

/**
 * A method that may be performing memoization.
 */
private class MemoCandidate extends Method {
  MemoCandidate() { this = any(MemoStmt m).getEnclosingMethod() }
}

/**
 * Holds if parameter `p` of `m` is read in the right hand side of `a`.
 */
private predicate parameterUsedInMemoValue(Method m, Parameter p, MemoStmt a) {
  p = m.getAParameter() and
  a.getEnclosingMethod() = m and
  p.getAVariable().getAnAccess().getParent*() = a.getRightOperand()
}

/**
 * Holds if parameter `p` of `m` is read in the left hand side of `a`.
 */
private predicate parameterUsedInMemoKey(Method m, Parameter p, HashMemoStmt a) {
  p = m.getAParameter() and
  a.getEnclosingMethod() = m and
  p.getAVariable().getAnAccess().getParent+() = a.getLeftOperand()
}

/**
 * Holds if the assignment `s` is returned from its parent method `m`.
 */
private predicate memoReturnedFromMethod(Method m, MemoStmt s) {
  exists(DataFlow::Node n | n.asExpr().getExpr() = s and exprNodeReturnedFrom(n, m))
  or
  // If we don't have flow (e.g. due to the dataflow library not supporting instance variable flow yet),
  // fall back to a syntactic heuristic: does the last statement in the method mention the memoization variable?
  m.getLastStmt().getAChild*().(InstanceVariableReadAccess).getVariable() =
    s.getVariableAccess().getVariable()
}

/**
 * Holds if `m` is a memoization method with a parameter `p` which is not used in the memoization key.
 * This can cause stale or incorrect values to be returned when the method is called with different arguments.
 */
predicate isImproperMemoizationMethod(Method m, Parameter p, AssignLogicalOrExpr s) {
  m instanceof MemoCandidate and
  m.getName() != "initialize" and
  parameterUsedInMemoValue(m, p, s) and
  not parameterUsedInMemoKey(m, p, s) and
  memoReturnedFromMethod(m, s)
}
