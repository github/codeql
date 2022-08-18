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
   * The `AST` stage.
   */
  cached
  module AST {
    private import codeql.ruby.AST as Ast1
    private import codeql.ruby.ast.internal.AST as Ast2
    private import codeql.ruby.ast.internal.Erb as Erb

    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the Ast stage.
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
      exists(any(Ast1::AstNode a).getEnclosingModule())
      or
      Ast2::lhsExpr(_)
      or
      exists(Erb::toGenerated(_))
      or
      exists(any(Ast1::AstNode a).toString())
    }
  }

  /**
   * The `CFG` stage.
   * Computes predicates based on the CFG.
   */
  cached
  module CFG {
    private import codeql.ruby.controlflow.internal.ControlFlowGraphImpl as CfgImpl
    private import codeql.ruby.controlflow.internal.Splitting as CfgSplitting
    private import codeql.ruby.controlflow.BasicBlocks as CfgBasicBlocks
    private import codeql.ruby.dataflow.internal.SsaImpl as SsaImpl
    private import codeql.ruby.controlflow.CfgNodes as CfgNodes

    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the Ast stage.
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
      exists(CfgImpl::TSuccessorType a)
      or
      exists(CfgSplitting::TSplitKind a)
      or
      exists(CfgSplitting::TSplit a)
      or
      exists(any(CfgBasicBlocks::JoinBlock b).getJoinBlockPredecessor(_))
      or
      SsaImpl::variableWriteActual(_, _, _, _)
      or
      exists(any(CfgNodes::ExprNodes::AssignExprCfgNode a).getLhs())
    }
  }

  /**
   * The `DataFlow` stage.
   * The DataFlow stages already included both lots of DataFlow and API-graphs without the collapsing that happens here.
   */
  cached
  module DataFlow {
    private import codeql.ruby.ApiGraphs::API as ApiGraphs
    private import codeql.ruby.dataflow.internal.DataFlowPublic as DataFlowPublic

    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the Ast stage.
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
      exists(
        ApiGraphs::root()
            .getMember(_)
            .getAMember()
            .getMethod(_)
            .getReturn(_)
            .getReturn()
            .getParameter(_)
            .getKeywordParameter(_)
            .getBlock()
            .getAnImmediateSubclass()
            .getAValueReachableFromSource()
      )
      or
      exists(ApiGraphs::root().getMember(_).getAMethodCall(_))
      or
      exists(any(DataFlowPublic::Node n).toString())
      or
      exists(any(DataFlowPublic::Node n).getLocation())
    }
  }

  /**
   * The `Taint` stage.
   */
  cached
  module Taint {
    private import codeql.ruby.dataflow.RemoteFlowSources as RemoteFlowSources
    private import codeql.ruby.dataflow.internal.TaintTrackingPublic as TaintTrackingPublic

    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the Ast stage.
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
      exists(any(RemoteFlowSources::RemoteFlowSource r).getSourceType())
      or
      TaintTrackingPublic::localTaintStep(_, _)
    }
  }
}
