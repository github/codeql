/**
 * C++-specific implementation of constant analysis.
 */

private import experimental.semmle.code.cpp.semantic.Semantic

/**
 * Gets the constant integer value of the specified expression, if any.
 */
int getIntConstantValue(SemExpr expr) { none() }
