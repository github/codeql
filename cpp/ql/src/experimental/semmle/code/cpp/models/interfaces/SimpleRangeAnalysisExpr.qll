/**
 * Provides a class for modeling `Expr`s with a restricted range.
 */

import cpp

/**
 * An expression for which a range can be deduced.
 */
abstract class SimpleRangeAnalysisExpr extends Expr {
  /** Gets the lower bound of the expression. */
  abstract float getLowerBounds();

  /** Gets the upper bound of the expression. */
  abstract float getUpperBounds();

  /** Holds if this expression depends on the definition `srcDef` for StackVariable `srcVar`. */
  predicate dependsOnDef(RangeSsaDefinition srcDef, StackVariable srcVar) { none() }
}
