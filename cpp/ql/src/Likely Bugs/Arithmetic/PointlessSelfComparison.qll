/**
 * Provides the implementation of the PointlessSelfComparison query. The
 * query is implemented as a library, so that we can avoid producing
 * duplicate results in other similar queries.
 */

import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

/**
 * Holds if `cmp` is a comparison of the following form:
 *
 *     x == x
 *     (char)x != x
 *     x < (int)x
 *
 * Usually, the intention of the comparison is to detect whether the value
 * of `x` overflows when it is cast to a smaller type.  However, if
 * overflow is impossible then the comparison is either always true or
 * always false, depending on the type of comparison (`==`, `!=`, `<`, `>`,
 * `<=`, `>=`).
 */
predicate pointlessSelfComparison(ComparisonOperation cmp) {
  exists(Variable v, VariableAccess lhs, VariableAccess rhs |
    lhs = cmp.getLeftOperand() and
    rhs = cmp.getRightOperand() and
    lhs = v.getAnAccess() and
    rhs = v.getAnAccess() and
    not exists(lhs.getQualifier()) and // Avoid structure fields
    not exists(rhs.getQualifier()) and // Avoid structure fields
    not convertedExprMightOverflow(lhs) and
    not convertedExprMightOverflow(rhs) and
    // Don't warn if the comparison is part of a template argument.
    not any(ClassTemplateInstantiation inst).getATemplateArgument() = cmp.getParent*()
  )
}

/**
 * Holds if `cmp` is a floating point self comparison:
 *
 *     x == x
 *     x != x
 *
 * If the type of `x` is a floating point type, then such comparisons can
 * be used to detect if the value of `x` is NaN. Therefore, they should not
 * be reported as results of the PointlessSelfComparison query.
 */
predicate nanTest(EqualityOperation cmp) {
  pointlessSelfComparison(cmp) and
  exists(Type t | t = cmp.getLeftOperand().getUnspecifiedType() |
    t instanceof FloatingPointType or
    t instanceof TypeTemplateParameter
  )
}

/**
 * Holds if `cmp` looks like a test to see whether a value would fit in a
 * smaller type. The type may not be smaller on the platform where we the code
 * was extracted, but it could be smaller on a different platform.
 *
 * For example, `cmp` might be `x == (long)x`. If `x` already has type `long`,
 * and `long` does not come from a macro expansion that could be
 * platform-dependent, then `cmp` is _not_ and overflow test.
 */
predicate overflowTest(EqualityOperation cmp) {
  pointlessSelfComparison(cmp) and
  exists(Cast cast |
    cast = cmp.getAnOperand().getConversion+() and
    not cast.isCompilerGenerated() and
    (
      cast.getType() != cast.getExpr().getType()
      or
      cast.isAffectedByMacro()
    )
  )
}
