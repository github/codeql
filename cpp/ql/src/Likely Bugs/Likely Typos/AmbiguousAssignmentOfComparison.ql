/**
 * @name Ambiguous assignment of comparison used as truth value
 * @description Assigning the result of an unparenthesized comparison when the assignment is used
 *              as a truth value may indicate that the assignment and comparison are grouped
 *              incorrectly.
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

/** Holds if the value of `expression` is directly used as a truth value. */
private predicate isDirectlyUsedAsTruthValue(Expr expression) {
  expression.isCondition()
  or
  expression = any(UnaryLogicalOperation operation).getAnOperand()
  or
  expression = any(BinaryLogicalOperation operation).getAnOperand()
}

/**
 * Holds if the value of `expression` is used as a truth value, possibly after contributing to a
 * comma, conditional, or comparison expression.
 */
private predicate isUsedAsTruthValue(Expr expression) {
  isDirectlyUsedAsTruthValue(expression)
  or
  exists(CommaExpr comma |
    expression = comma.getRightOperand() and
    isUsedAsTruthValue(comma)
  )
  or
  exists(ConditionalExpr conditional |
    expression = [conditional.getThen(), conditional.getElse()] and
    isUsedAsTruthValue(conditional)
  )
  or
  exists(ComparisonOperation comparison |
    expression = comparison.getAnOperand() and
    isUsedAsTruthValue(comparison)
  )
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
  isUsedAsTruthValue(assignment) and
  // A Boolean lvalue makes assigning the comparison result type-appropriate and normally
  // intentional.
  not assignment.getLValue().getUnspecifiedType() instanceof BoolType and
  not assignment.isUnevaluated() and
  not assignment.isFromUninstantiatedTemplate(_)
select assignment,
  "The '" + assignment.getOperator() +
    "' operation assigns the result of an unparenthesized comparison, and its result is used as " +
    "a truth value."
