private import csharp

/**
 * INTERNAL: Do not use.
 *
 * Provides modules and predicates for enforcing evaluation of cached predicates
 * in the same stage across different files.
 */
module Stages {
  cached
  module ControlFlowStage {
    private import semmle.code.csharp.controlflow.internal.Splitting
    private import semmle.code.csharp.controlflow.internal.SuccessorType
    private import semmle.code.csharp.controlflow.Guards as Guards

    cached
    predicate forceCachingInSameStage() { any() }

    cached
    private predicate forceCachingInSameStageRev() {
      exists(SplitImpl si)
      or
      exists(SuccessorType st)
      or
      exists(ControlFlow::Node n)
      or
      Guards::Internal::isCustomNullCheck(_, _, _, _)
      or
      forceCachingInSameStageRev()
    }
  }

  cached
  module GuardsStage {
    private import semmle.code.csharp.controlflow.Guards

    cached
    predicate forceCachingInSameStage() { any() }

    cached
    private predicate forceCachingInSameStageRev() {
      any(ControlFlowElement cfe).controlsBlock(_, _, _)
      or
      exists(GuardedExpr ge)
      or
      forceCachingInSameStageRev()
    }
  }

  cached
  module DataFlowStage {
    private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
    private import semmle.code.csharp.dataflow.internal.DataFlowImplCommon
    private import semmle.code.csharp.dataflow.internal.TaintTrackingPrivate

    cached
    predicate forceCachingInSameStage() { any() }

    cached
    private predicate forceCachingInSameStageRev() {
      defaultAdditionalTaintStep(_, _)
      or
      any(ArgumentNode n).argumentOf(_, _)
      or
      exists(any(DataFlow::Node n).getEnclosingCallable())
      or
      exists(any(DataFlow::Node n).getControlFlowNode())
      or
      exists(any(DataFlow::Node n).getType())
      or
      exists(any(NodeImpl n).getDataFlowType())
      or
      exists(any(DataFlow::Node n).getLocation())
      or
      exists(any(DataFlow::Node n).toString())
      or
      exists(any(OutNode n).getCall(_))
      or
      exists(CallContext cc)
      or
      forceCachingInSameStageRev()
    }
  }

  cached
  module UnificationStage {
    private import semmle.code.csharp.Unification

    cached
    predicate forceCachingInSameStage() { any() }

    cached
    private predicate forceCachingInSameStageRev() {
      exists(Gvn::CompoundTypeKind k)
      or
      exists(any(Gvn::GvnType t).toString())
      or
      exists(Unification::UnconstrainedTypeParameter utp)
      or
      forceCachingInSameStageRev()
    }
  }
}
