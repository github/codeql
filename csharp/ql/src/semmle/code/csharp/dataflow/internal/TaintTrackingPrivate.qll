private import csharp
private import TaintTrackingPublic
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.dataflow.internal.ControlFlowReachability
private import semmle.code.csharp.dataflow.LibraryTypeDataFlow
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.commons.ComparisonTest
private import semmle.code.csharp.frameworks.JsonNET
private import cil
private import dotnet

/**
 * Holds if `node` should be a barrier in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintBarrier(DataFlow::Node node) { none() }

/**
 * Holds if the additional step from `src` to `sink` should be included in all
 * global taint flow configurations.
 */
predicate defaultAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  localAdditionalTaintStep(pred, succ)
  or
  succ = pred.(DataFlow::NonLocalJumpNode).getAJumpSuccessor(false)
}

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
        ei = e2.(ObjectCreation).getInitializer().(CollectionInitializer).getAnElementInitializer() and
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
      e1 = e2.(UnaryLogicalOperation).getAnOperand() and
      scope = e2 and
      isSuccessor = false
      or
      e1 = e2.(BinaryLogicalOperation).getAnOperand() and
      scope = e2 and
      isSuccessor = false
      or
      // Taint from tuple argument
      e2 =
        any(TupleExpr te |
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
      e2 =
        any(MemberAccess ma |
          ma.getQualifier().getType() instanceof TupleType and
          e1 = ma.getQualifier() and
          scope = e2 and
          isSuccessor = true
        )
      or
      e2 =
        any(OperatorCall oc |
          oc.getTarget().(ConversionOperator).fromLibrary() and
          e1 = oc.getAnArgument() and
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
      defTo.(AssignableDefinitions::LocalVariableDefinition).getDeclaration() =
        fs.getVariableDeclExpr() and
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
  private import semmle.code.csharp.Caching

  cached
  predicate localAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    Stages::DataFlowStage::forceCachingInSameStage() and
    any(LocalTaintExprStepConfiguration x).hasNodePath(nodeFrom, nodeTo)
    or
    nodeFrom.(DataFlow::ExprNode).getControlFlowNode() =
      nodeTo.(YieldReturnNode).getControlFlowNode()
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
    exists(LibraryCodeNode n | not n.preservesValue() |
      n = nodeTo and
      nodeFrom = n.getPredecessor(AccessPath::empty())
      or
      n = nodeFrom and
      nodeTo = n.getSuccessor(AccessPath::empty())
    )
  }
}

import Cached
