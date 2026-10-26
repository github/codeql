/**
 * Provides C++-specific definitions for use in sign analysis.
 */

private import semmle.code.cpp.rangeanalysis.new.internal.semantic.Semantic

/**
 * Workaround to allow certain expressions to have a negative sign, even if the type of the
 * expression is unsigned.
 */
predicate ignoreTypeRestrictions(SemExpr e) { none() }

/**
 * Workaround to track the sign of certain expressions even if the type of the expression is not
 * numeric.
 */
predicate trackUnknownNonNumericExpr(SemExpr e) { none() }

/**
 * Workaround to ignore tracking of certain expressions even if the type of the expression is
 * numeric.
 */
predicate ignoreExprSign(SemExpr e) { none() }
