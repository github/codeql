/**
 * EXPERIMENTAL: The API of this module may change without notice.
 *
 * Provides a class for modeling `Expr`s with a restricted range.
 */

import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

/**
 * EXPERIMENTAL: The API of this class may change without notice.
 *
 * An expression for which a range can be deduced. Extend this class to add
 * functionality to the range analysis library.
 */
abstract class SimpleRangeAnalysisExpr extends Expr {
  /**
   * Gets the lower bound of the expression.
   *
   * Implementations of this predicate should use
   * `getFullyConvertedLowerBounds` and `getFullyConvertedUpperBounds` for
   * recursive calls to get the bounds of their children.
   */
  abstract float getLowerBounds();

  /**
   * Gets the upper bound of the expression.
   *
   * Implementations of this predicate should use
   * `getFullyConvertedLowerBounds` and `getFullyConvertedUpperBounds` for
   * recursive calls to get the bounds of their children.
   */
  abstract float getUpperBounds();

  /** Holds if this expression depends on the definition `srcDef` for StackVariable `srcVar`. */
  predicate dependsOnDef(RangeSsaDefinition srcDef, StackVariable srcVar) { none() }
}

import SimpleRangeAnalysisInternal
