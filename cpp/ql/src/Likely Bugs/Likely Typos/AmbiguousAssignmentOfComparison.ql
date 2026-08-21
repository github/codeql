/**
 * @name Ambiguous assignment of comparison in condition
 * @description Assigning the result of an unparenthesized comparison in a condition may indicate
 *              that the assignment and comparison are grouped incorrectly.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/ambiguous-assignment-of-comparison
 * @tags quality
 *       reliability
 *       correctness
 *       external/cwe/cwe-783
 */

import cpp

/** Gets a condition that controls branching. */
private Expr getACondition() {
  result = any(IfStmt s).getCondition()
  or
  result = any(Loop s).getCondition()
  or
  result = any(ConditionalExpr e).getCondition()
}

/**
 * Holds if `assignment` occurs within a condition that controls branching.
 *
 * This includes nested expressions, such as function arguments and either operand of a comma
 * expression, because the ambiguous syntax still occurs within the condition.
 */
private predicate occursInCondition(Assignment assignment) {
  assignment.getParent*() = getACondition()
}

/**
 * Holds if `comparison` is explicitly grouped using parentheses or an explicit cast.
 */
private predicate isExplicitlyGrouped(ComparisonOperation comparison) {
  comparison.isParenthesised()
  or
  exists(Cast cast | cast = comparison.getConversion+() and not cast.isImplicit())
}

from Assignment assignment, ComparisonOperation comparison
where
  assignment.getRValue() = comparison and
  not isExplicitlyGrouped(comparison) and
  occursInCondition(assignment) and
  // Assigning a comparison result to a Boolean is normally intentional.
  not assignment.getLValue().getUnspecifiedType() instanceof BoolType and
  not assignment.isUnevaluated() and
  not assignment.isFromUninstantiatedTemplate(_)
select assignment,
  "The '" + assignment.getOperator() +
    "' operation assigns the result of an unparenthesized comparison used in a condition."
