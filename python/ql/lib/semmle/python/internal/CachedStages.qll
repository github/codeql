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
   * Computes predicates based on the AST.
   * These include SSA and basic-blocks.
   */
  cached
  module AST {
    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the Ast stage.
     */
    cached
    predicate ref() { 1 = 1 }

    private import semmle.python.essa.SsaDefinitions as SsaDefinitions
    private import semmle.python.essa.SsaCompute as SsaCompute
    private import semmle.python.essa.Essa as Essa
    private import semmle.python.Module as PyModule
    private import semmle.python.Exprs as Exprs
    private import semmle.python.AstExtended as AstExtended
    private import semmle.python.Flow as PyFlow

    /**
     * DONT USE!
     * Contains references to each predicate that use the above `ref` predicate.
     */
    cached
    predicate backref() {
      1 = 1
      or
      SsaDefinitions::SsaSource::method_call_refinement(_, _, _)
      or
      SsaCompute::SsaDefinitions::reachesEndOfBlock(_, _, _, _)
      or
      exists(any(Essa::PhiFunction p).getInput(_))
      or
      exists(PyModule::moduleNameFromFile(_))
      or
      exists(any(Exprs::Expr e).toString())
      or
      exists(any(AstExtended::AstNode n).getLocation())
      or
      exists(any(AstExtended::AstNode n).getAChildNode())
      or
      exists(any(AstExtended::AstNode n).getParentNode())
      or
      exists(any(AstExtended::AstNode n).getAFlowNode())
      or
      exists(any(PyFlow::BasicBlock b).getImmediateDominator())
      or
      exists(any(PyFlow::BasicBlock b).getScope())
      or
      any(PyFlow::BasicBlock b).strictlyDominates(_)
      or
      any(PyFlow::BasicBlock b).strictlyReaches(_)
      or
      exists(any(PyFlow::BasicBlock b).getASuccessor())
      or
      exists(any(PyFlow::ControlFlowNode b).getScope())
      or
      exists(PyFlow::DefinitionNode b)
      or
      exists(any(PyFlow::SequenceNode n).getElement(_))
      or
      exists(any(PyFlow::ControlFlowNode c).toString())
    }
  }

  /**
   * The `TypeTracking` stage.
   */
  cached
  module TypeTracking {
    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the Ast stage.
     */
    cached
    predicate ref() { 1 = 1 }

    private import semmle.python.dataflow.new.DataFlow::DataFlow as NewDataFlow
    private import semmle.python.dataflow.new.internal.TypeTrackingImpl as TypeTrackingImpl
    private import semmle.python.ApiGraphs::API as API

    /**
     * DONT USE!
     * Contains references to each predicate that use the above `ref` predicate.
     */
    cached
    predicate backref() {
      1 = 1
      or
      exists(TypeTrackingImpl::append(_, _))
      or
      exists(any(API::Node n).getAMember().getAValueReachableFromSource())
    }
  }

  /**
   * The points-to stage.
   */
  cached
  module PointsTo {
    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the points-to stage.
     */
    cached
    predicate ref() { 1 = 1 }

    private import semmle.python.pointsto.Base as PointsToBase
    private import semmle.python.types.Object as TypeObject
    private import semmle.python.objects.TObject as TObject
    private import semmle.python.objects.ObjectInternal as ObjectInternal
    // have to alias since this module is also called PointsTo
    private import semmle.python.pointsto.PointsTo as RealPointsTo

    /**
     * DONT USE!
     * Contains references to each predicate that use the above `ref` predicate.
     */
    cached
    predicate backref() {
      1 = 1
      or
      PointsToBase::BaseFlow::scope_entry_value_transfer_from_earlier(_, _, _, _)
      or
      exists(TypeObject::Object a)
      or
      exists(TObject::TObject f)
      or
      exists(any(ObjectInternal::ObjectInternal o).toString())
      or
      RealPointsTo::AttributePointsTo::variableAttributePointsTo(_, _, _, _, _)
    }
  }

  /**
   * The `dataflow` stage.
   */
  cached
  module DataFlow {
    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the DataFlow stage.
     */
    cached
    predicate ref() { 1 = 1 }

    private import semmle.python.dataflow.new.internal.DataFlowPublic as DataFlowPublic
    private import semmle.python.dataflow.new.internal.DataFlowDispatch as DataFlowDispatch
    private import semmle.python.dataflow.new.internal.LocalSources as LocalSources
    private import semmle.python.internal.Awaited as Awaited

    /**
     * DONT USE!
     * Contains references to each predicate that use the above `ref` predicate.
     */
    cached
    predicate backref() {
      1 = 1
      or
      exists(any(DataFlowPublic::Node node).toString())
      or
      exists(any(DataFlowPublic::Node node).getLocation())
      or
      DataFlowDispatch::resolveCall(_, _, _)
      or
      DataFlowDispatch::getCallArg(_, _, _, _, _)
      or
      any(LocalSources::LocalSourceNode n).flowsTo(_)
      or
      exists(Awaited::awaited(_))
    }
  }
}
