/**
 * Provides classes and predicates for reasoning about guards and the control
 * flow elements controlled by those guards.
 */

import cpp
import semmle.code.cpp.controlflow.BasicBlocks
import semmle.code.cpp.controlflow.SSA
import semmle.code.cpp.controlflow.Dominance
import IRGuards

/** An `SsaDefinition` with an additional predicate `isLt`. */
class GuardedSsa extends SsaDefinition {
  /** Holds if this `SsaDefinition` is guarded such that `this(var) < gt + k` is `testIsTrue` in `block`. */
  predicate isLt(StackVariable var, Expr gt, int k, BasicBlock block, boolean testIsTrue) {
    exists(Expr luse, GuardCondition test | this.getAUse(var) = luse |
      test.ensuresLt(luse, gt, k, block, testIsTrue)
    )
  }
}
