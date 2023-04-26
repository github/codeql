/**
 * C++-specific implementation of constant analysis.
 */

private import semmle.code.cpp.rangeanalysis.new.internal.semantic.Semantic

/**
 * Gets the constant integer value of the specified expression, if any.
 */
int getIntConstantValue(SemExpr expr) { none() }
