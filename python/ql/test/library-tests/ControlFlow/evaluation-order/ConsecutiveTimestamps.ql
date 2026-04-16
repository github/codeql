/**
 * Checks that consecutive annotated nodes have consecutive timestamps:
 * for each annotation with timestamp `a`, some CFG node for that annotation
 * must have a next annotation containing `a + 1`.
 *
 * Handles CFG splitting (e.g., finally blocks duplicated for normal/exceptional
 * flow) by checking that at least one split has the required successor.
 *
 * Only applies to functions where all annotations are in the function's
 * own scope (excludes tests with generators, async, comprehensions, or
 * lambdas that have annotations in nested scopes).
 */

import python
import TimerUtils

/**
 * Holds if function `f` has an annotation in a nested scope
 * (generator, async function, comprehension, lambda).
 */
private predicate hasNestedScopeAnnotation(TestFunction f) {
  exists(TimerAnnotation a |
    a.getTestFunction() = f and
    a.getExpr().getScope() != f
  )
}

from TimerAnnotation ann, int a
where
  not hasNestedScopeAnnotation(ann.getTestFunction()) and
  not ann.isDead() and
  a = ann.getATimestamp() and
  not exists(TimerCfgNode x, TimerCfgNode y |
    ann.getExpr() = x.getNode() and
    nextTimerAnnotation(x, y) and
    (a + 1) = y.getATimestamp()
  ) and
  // Exclude the maximum timestamp in the function (it has no successor)
  not a =
    max(TimerAnnotation other |
      other.getTestFunction() = ann.getTestFunction()
    |
      other.getATimestamp()
    )
select ann, "$@ in $@ has no consecutive successor (expected " + (a + 1) + ")",
  ann.getTimestampExpr(a), "Timestamp " + a, ann.getTestFunction(), ann.getTestFunction().getName()
