/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */

import csharp

module TaintTracking {
  private import semmle.code.csharp.dataflow.internal.DataFlowImplCommon
  private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
  private import semmle.code.csharp.dataflow.internal.ControlFlowReachability
  private import semmle.code.csharp.dataflow.LibraryTypeDataFlow
  private import semmle.code.csharp.dispatch.Dispatch
  private import semmle.code.csharp.commons.ComparisonTest
  private import semmle.code.csharp.frameworks.JsonNET
  private import cil
  private import dotnet

  /**
   * Holds if taint propagates from `source` to `sink` in zero or more local
   * (intra-procedural) steps.
   */
  predicate localTaint(DataFlow::Node source, DataFlow::Node sink) { localTaintStep*(source, sink) }

  /** A member (property or field) that is tainted if its containing object is tainted. */
  abstract class TaintedMember extends AssignableMember { }

  /**
   * Holds if taint propagates from `nodeFrom` to `nodeTo` in exactly one local
   * (intra-procedural) step.
   */
  predicate localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // Ordinary data flow
    DataFlow::localFlowStep(nodeFrom, nodeTo)
    or
    localAdditionalTaintStep(nodeFrom, nodeTo)
  }

  /**
   * A taint tracking configuration.
   *
   * A taint tracking configuration is a special dataflow configuration
   * (`DataFlow::Configuration`) that allows for flow through nodes that do not
   * necessarily preserve values, but are still relevant from a taint tracking
   * perspective. (For example, string concatenation, where one of the operands
   * is tainted.)
   *
   * Each use of the taint tracking library must define its own unique extension
   * of this abstract class. A configuration defines a set of relevant sources
   * (`isSource`) and sinks (`isSink`), and may additionally treat intermediate
   * nodes as "sanitizers" (`isSanitizer`) as well as add custom taint flow steps
   * (`isAdditionalTaintStep()`).
   */
  abstract class Configuration extends DataFlow::Configuration {
    bindingset[this]
    Configuration() { any() }

    /**
     * Holds if `source` is a relevant taint source.
     *
     * The smaller this predicate is, the faster `hasFlow()` will converge.
     */
    // overridden to provide taint-tracking specific qldoc
    abstract override predicate isSource(DataFlow::Node source);

    /**
     * Holds if `sink` is a relevant taint sink.
     *
     * The smaller this predicate is, the faster `hasFlow()` will converge.
     */
    // overridden to provide taint-tracking specific qldoc
    abstract override predicate isSink(DataFlow::Node sink);

    /** Holds if the intermediate node `node` is a taint sanitizer. */
    predicate isSanitizer(DataFlow::Node node) { none() }

    final override predicate isBarrier(DataFlow::Node node) { isSanitizer(node) }

    /**
     * Holds if the additional taint propagation step from `pred` to `succ`
     * must be taken into account in the analysis.
     */
    predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

    final override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
      isAdditionalTaintStep(pred, succ)
      or
      localAdditionalTaintStep(pred, succ)
      or
      succ = pred.(DataFlow::NonLocalJumpNode).getAJumpSuccessor(false)
    }

    /**
     * Holds if taint may flow from `source` to `sink` for this configuration.
     */
    // overridden to provide taint-tracking specific qldoc
    override predicate hasFlow(DataFlow::Node source, DataFlow::Node sink) {
      super.hasFlow(source, sink)
    }
  }

  /** INTERNAL: Do not use. */
  module Internal {
    private CIL::DataFlowNode asCilDataFlowNode(DataFlow::Node node) {
      result = node.asParameter() or
      result = node.asExpr()
    }

    private predicate localTaintStepCil(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      asCilDataFlowNode(nodeFrom).getALocalFlowSucc(asCilDataFlowNode(nodeTo), any(CIL::Tainted t))
    }

    /** Gets the qualifier of element access `ea`. */
    private Expr getElementAccessQualifier(ElementAccess ea) { result = ea.getQualifier() }

    private class LocalTaintExprStepConfiguration extends ControlFlowReachabilityConfiguration {
      LocalTaintExprStepConfiguration() { this = "LocalTaintExprStepConfiguration" }

      override predicate candidate(
        Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
      ) {
        exactScope = false and
        (
          // Taint propagation using library code
          LocalFlow::libraryFlow(e1, e2, scope, isSuccessor, false)
          or
          // Taint from assigned value to element qualifier (`x[i] = 0`)
          exists(AssignExpr ae |
            e1 = ae.getRValue() and
            e2.(AssignableRead) = getElementAccessQualifier+(ae.getLValue()) and
            scope = ae and
            isSuccessor = false
          )
          or
          // Taint from array initializer
          e1 = e2.(ArrayCreation).getInitializer().getAnElement() and
          scope = e2 and
          isSuccessor = false
          or
          // Taint from object initializer
          exists(ElementInitializer ei |
            ei = e2
                  .(ObjectCreation)
                  .getInitializer()
                  .(CollectionInitializer)
                  .getAnElementInitializer() and
            e1 = ei.getArgument(ei.getNumberOfArguments() - 1) and // assume the last argument is the value (i.e., not a key)
            scope = e2 and
            isSuccessor = false
          )
          or
          // Taint from element qualifier
          e1 = e2.(ElementAccess).getQualifier() and
          scope = e2 and
          isSuccessor = true
          or
          e1 = e2.(AddExpr).getAnOperand() and
          scope = e2 and
          isSuccessor = true
          or
          // A comparison expression where taint can flow from one of the
          // operands if the other operand is a constant value.
          exists(ComparisonTest ct, Expr other |
            ct.getExpr() = e2 and
            e1 = ct.getAnArgument() and
            other = ct.getAnArgument() and
            other.stripCasts().hasValue() and
            e1 != other and
            scope = e2 and
            isSuccessor = true
          )
          or
          e1 = e2.(LogicalOperation).getAnOperand() and
          scope = e2 and
          isSuccessor = false
          or
          // Taint from tuple argument
          e2 = any(TupleExpr te |
              e1 = te.getAnArgument() and
              te.isReadAccess() and
              scope = e2 and
              isSuccessor = true
            )
          or
          e1 = e2.(InterpolatedStringExpr).getAChild() and
          scope = e2 and
          isSuccessor = true
          or
          // Taint from tuple expression
          e2 = any(MemberAccess ma |
              ma.getQualifier().getType() instanceof TupleType and
              e1 = ma.getQualifier() and
              scope = e2 and
              isSuccessor = true
            )
        )
      }

      override predicate candidateDef(
        Expr e, AssignableDefinition defTo, ControlFlowElement scope, boolean exactScope,
        boolean isSuccessor
      ) {
        // Taint from `foreach` expression
        exists(ForeachStmt fs |
          e = fs.getIterableExpr() and
          defTo.(AssignableDefinitions::LocalVariableDefinition).getDeclaration() = fs
                .getVariableDeclExpr() and
          isSuccessor = true
        |
          scope = fs and
          exactScope = true
          or
          scope = fs.getIterableExpr() and
          exactScope = false
          or
          scope = fs.getVariableDeclExpr() and
          exactScope = false
        )
      }
    }

    cached
    module Cached {
      cached
      predicate forceCachingInSameStage() { DataFlowPrivateCached::forceCachingInSameStage() }

      cached
      predicate localAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        any(LocalTaintExprStepConfiguration x).hasNodePath(nodeFrom, nodeTo)
        or
        nodeTo = nodeFrom.(TaintedParameterNode).getUnderlyingNode()
        or
        nodeFrom = nodeTo.(TaintedReturnNode).getUnderlyingNode()
        or
        flowOutOfDelegateLibraryCall(nodeFrom, nodeTo, false)
        or
        localTaintStepCil(nodeFrom, nodeTo)
        or
        // Taint members
        exists(Access access |
          access = nodeTo.asExpr() and
          access.getTarget() instanceof TaintedMember
        |
          access.(FieldRead).getQualifier() = nodeFrom.asExpr()
          or
          access.(PropertyRead).getQualifier() = nodeFrom.asExpr()
        )
        or
        flowThroughLibraryCallableOutRef(_, nodeFrom, nodeTo, false)
      }
    }
    import Cached
  }
  private import Internal
}
