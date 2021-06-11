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
 * An SSA definition for which a range can be deduced. As with
 * `RangeSsaDefinition` and `SsaDefinition`, instances of this class
 * correspond to points in the program where one or more variables are defined
 * or have their value constrained in some way.
 *
 * Extend this class to add functionality to the range analysis library.
 */
abstract class SimpleRangeAnalysisDefinition extends RangeSsaDefinition {
  /**
   * Holds if this `SimpleRangeAnalysisDefinition` adds range information for
   * `v`. Because a `SimpleRangeAnalysisDefinition` is just a point in the
   * program, it's possible that more than one variable might be defined at
   * this point. This predicate clarifies which variable(s) should get range
   * information from `this`.
   *
   * This predicate **must be overridden** to hold for any `v` that can show
   * up in the other members of `SimpleRangeAnalysisDefinition`. Conversely,
   * the other members **must be accurate** for any `v` in this predicate.
   */
  abstract predicate hasRangeInformationFor(StackVariable v);

  /**
   * Holds if `(this, v)` depends on the range of the unconverted expression
   * `e`. This information is used to inform the range analysis about cyclic
   * dependencies. Without this information, range analysis might work for
   * simple cases but will go into infinite loops on complex code.
   *
   * For example, when modelling the definition by reference in a call to an
   * overloaded `operator=`, written as `v = e`, the definition of `(this, v)`
   * depends on `e`.
   */
  abstract predicate dependsOnExpr(StackVariable v, Expr e);

  /**
   * Gets the lower bound of the variable `v` defined by this definition.
   *
   * Implementations of this predicate should use
   * `getFullyConvertedLowerBounds` and `getFullyConvertedUpperBounds` for
   * recursive calls to get the bounds of their dependencies.
   */
  abstract float getLowerBounds(StackVariable v);

  /**
   * Gets the upper bound of the variable `v` defined by this definition.
   *
   * Implementations of this predicate should use
   * `getFullyConvertedLowerBounds` and `getFullyConvertedUpperBounds` for
   * recursive calls to get the bounds of their dependencies.
   */
  abstract float getUpperBounds(StackVariable v);
}

import SimpleRangeAnalysisInternal
