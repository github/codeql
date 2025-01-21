/**
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

import rust

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
  /**
   * The abstract syntex tree (AST) stage.
   */
  cached
  module AstStage {
    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the AST stage.
     */
    cached
    predicate ref() { 1 = 1 }

    /**
     * DO NOT USE!
     *
     * Contains references to each predicate that use the above `ref` predicate.
     */
    cached
    predicate backref() {
      1 = 1
      or
      exists(Location l)
      or
      exists(any(Locatable l).getLocation())
      or
      exists(Format f)
    }
  }

  /**
   * The control flow graph (CFG) stage.
   */
  cached
  module CfgStage {
    private import codeql.rust.controlflow.internal.Splitting
    private import codeql.rust.controlflow.internal.SuccessorType
    private import codeql.rust.controlflow.internal.ControlFlowGraphImpl
    private import codeql.rust.controlflow.CfgNodes

    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the CFG stage.
     */
    cached
    predicate ref() { 1 = 1 }

    /**
     * DO NOT USE!
     *
     * Contains references to each predicate that use the above `ref` predicate.
     */
    cached
    predicate backref() {
      1 = 1
      or
      exists(TConditionalCompletionSplitKind())
      or
      exists(TNormalSuccessor())
      or
      exists(AstCfgNode n)
      or
      exists(CallExprCfgNode n | exists(n.getFunction()))
    }
  }

  /**
   * The data flow stage.
   */
  cached
  module DataFlowStage {
    private import codeql.rust.dataflow.internal.DataFlowImpl
    private import codeql.rust.dataflow.internal.TaintTrackingImpl

    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the data flow stage.
     */
    cached
    predicate ref() { 1 = 1 }

    /**
     * DO NOT USE!
     *
     * Contains references to each predicate that use the above `ref` predicate.
     */
    cached
    predicate backref() {
      1 = 1
      or
      exists(Node n)
      or
      RustTaintTracking::defaultAdditionalTaintStep(_, _, _)
    }
  }
}
