/**
 * EXPERIMENTAL: The API of this module may change without notice.
 *
 * Provides a class for modeling `RangeSsaDefinition`s with a restricted range.
 */

import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

/**
 * EXPERIMENTAL: The API of this class may change without notice.
 *
 * An SSA definition for which a range can be deduced. Extend this class to add
 * functionality to the range analysis library.
 */
abstract class SimpleRangeAnalysisDefinition extends RangeSsaDefinition {
    /**
   * Gets the lower bound of the defomotopn.
   *
   * Implementations of this predicate should use
   * `getFullyConvertedLowerBounds` and `getFullyConvertedUpperBounds` for
   * recursive calls to get the bounds of their children.
   */
  abstract float getLowerBounds();

  /**
   * Gets the upper bound of the definition.
   *
   * Implementations of this predicate should use
   * `getFullyConvertedLowerBounds` and `getFullyConvertedUpperBounds` for
   * recursive calls to get the bounds of their children.
   */
  abstract float getUpperBounds();
}