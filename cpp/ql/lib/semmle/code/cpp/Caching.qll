/**
 * INTERNAL: Do not use.
 *
 * The purpose of this file is to control which cached predicates belong to the same stage.
 *
 * Combining stages can improve performance as we are more likely to reuse shared, non-cached predicates.
 *
 * To make a predicate `p` belong to a stage `A`:
 * - make `p` depend on `A::ref()`, and
 * - make `A::backref()` depend on `p`.
 *
 * Since `A` is a cached module, `ref` and `backref` must be in the same stage, and the dependency
 * chain above thus forces `p` to be in that stage as well.
 *
 * With these two predicates in a `cached module` we ensure that all the cached predicates will be in a single stage at runtime.
 *
 * Grouping stages can cause unnecessary computation, as a concrete query might not depend on
 * all the cached predicates in a stage.
 * Care should therefore be taken not to combine two stages, if it is likely that a query only depend
 * on some but not all the cached predicates in the combined stage.
 */

private import cpp

/**
 * Contains a `cached module` for each stage.
 * Each `cached module` ensures that predicates that are supposed to be in the same stage, are in the same stage.
 *
 * Each `cached module` contain two predicates:
 * The first, `ref`, always holds, and is referenced from `cached` predicates.
 * The second, `backref`, contains references to the same `cached` predicates.
 * The `backref` predicate starts with `1 = 1 or` to ensure that the predicate will be optimized down to a constant by the optimizer.
 */
module Stages {
  private import semmle.code.cpp.ir.dataflow.internal.SsaInternalsCommon as SsaInternalsCommon
  private import semmle.code.cpp.ir.implementation.aliased_ssa.internal.AliasedSSA as AliasedSSA
  private import semmle.code.cpp.ir.implementation.raw.internal.IRConstruction as IRConstruction

  /**
   * The `IR` stage.
   */
  cached
  module IR {
    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the IR stage.
     */
    cached
    predicate ref() { 1 = 1 }

    /**
     * DONT USE!
     * Contains references to each predicate that use the above `ref` predicate.
     */
    cached
    predicate backref() {
      1 = 1
      or
      IRConstruction::Raw::hasInstruction(_, _)
      or
      SsaInternalsCommon::isUse(_, _, _, _)
      or
      exists(AliasedSSA::getOperandMemoryLocation(_))
      or
      exists(AliasedSSA::getResultMemoryLocation(_))
    }
  }
}
