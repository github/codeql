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

  /**
   * Holds if the range this expression depends on the definition `srcDef` for
   * StackVariable `srcVar`.
   *
   * Because this predicate cannot be recursive, most implementations should
   * override `dependsOnChild` instead.
   */
  predicate dependsOnDef(RangeSsaDefinition srcDef, StackVariable srcVar) { none() }

  /**
   * Holds if this expression depends on the range of its unconverted
   * subexpression `child`. This information is used to inform the range
   * analysis about cyclic dependencies. Without this information, range
   * analysis might work for simple cases but will go into infinite loops on
   * complex code.
   *
   * For example, when modeling a function call whose return value depends on
   * all of its arguments, implement this predicate as
   * `child = this.getAnArgument()`.
   */
  abstract predicate dependsOnChild(Expr child);
}

import SimpleRangeAnalysisInternal

/**
 * This class exists to prevent the QL front end from emitting compile errors
 * inside `SimpleRangeAnalysis.qll` about certain conjuncts being empty
 * because the overrides of `SimpleRangeAnalysisExpr` that happen to be in
 * scope do not make use of every feature it offers.
 */
private class Empty extends SimpleRangeAnalysisExpr {
  Empty() {
    // This predicate is complicated enough that the QL type checker doesn't
    // see it as empty but simple enough that the optimizer should.
    this = this and none()
  }

  override float getLowerBounds() { none() }

  override float getUpperBounds() { none() }

  override predicate dependsOnChild(Expr child) { none() }
}
