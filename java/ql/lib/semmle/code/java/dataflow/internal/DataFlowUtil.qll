/**
 * Basic definitions for use in the data flow library.
 */

private import java
private import DataFlowPrivate
private import semmle.code.java.dataflow.SSA
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.dataflow.FlowSummary
private import semmle.code.java.dataflow.InstanceAccess
private import FlowSummaryImpl as FlowSummaryImpl
private import TaintTrackingUtil as TaintTrackingUtil
private import DataFlowNodes
import DataFlowNodes::Public

/** Holds if `n` is an access to an unqualified `this` at `cfgnode`. */
private predicate thisAccess(Node n, ControlFlowNode cfgnode) {
  n.(InstanceParameterNode).getCallable().getBody() = cfgnode.asStmt()
  or
  exists(InstanceAccess ia |
    ia = n.asExpr() and ia.getControlFlowNode() = cfgnode and ia.isOwnInstanceAccess()
  )
  or
  n.(ImplicitInstanceAccess).getInstanceAccess().(OwnInstanceAccess).getCfgNode() = cfgnode
}

/** Calculation of the relative order in which `this` references are read. */
private module ThisFlow {
  private predicate thisAccess(Node n, BasicBlock b, int i) { thisAccess(n, b.getNode(i)) }

  private predicate thisRank(Node n, BasicBlock b, int rankix) {
    exists(int i |
      i = rank[rankix](int j | thisAccess(_, b, j)) and
      thisAccess(n, b, i)
    )
  }

  private int lastRank(BasicBlock b) { result = max(int rankix | thisRank(_, b, rankix)) }

  private predicate blockPrecedesThisAccess(BasicBlock b) { thisAccess(_, b.getABBSuccessor*(), _) }

  private predicate thisAccessBlockReaches(BasicBlock b1, BasicBlock b2) {
    thisAccess(_, b1, _) and b2 = b1.getABBSuccessor()
    or
    exists(BasicBlock mid |
      thisAccessBlockReaches(b1, mid) and
      b2 = mid.getABBSuccessor() and
      not thisAccess(_, mid, _) and
      blockPrecedesThisAccess(b2)
    )
  }

  private predicate thisAccessBlockStep(BasicBlock b1, BasicBlock b2) {
    thisAccessBlockReaches(b1, b2) and
    thisAccess(_, b2, _)
  }

  /** Holds if `n1` and `n2` are control-flow adjacent references to `this`. */
  predicate adjacentThisRefs(Node n1, Node n2) {
    exists(int rankix, BasicBlock b |
      thisRank(n1, b, rankix) and
      thisRank(n2, b, rankix + 1)
    )
    or
    exists(BasicBlock b1, BasicBlock b2 |
      thisRank(n1, b1, lastRank(b1)) and
      thisAccessBlockStep(b1, b2) and
      thisRank(n2, b2, 1)
    )
  }
}

/**
 * Holds if data can flow from `node1` to `node2` in zero or more
 * local (intra-procedural) steps.
 */
pragma[inline]
predicate localFlow(Node node1, Node node2) { node1 = node2 or localFlowStepPlus(node1, node2) }

private predicate localFlowStepPlus(Node node1, Node node2) = fastTC(localFlowStep/2)(node1, node2)

/**
 * Holds if data can flow from `e1` to `e2` in zero or more
 * local (intra-procedural) steps.
 */
pragma[inline]
predicate localExprFlow(Expr e1, Expr e2) { localFlow(exprNode(e1), exprNode(e2)) }

/**
 * Holds if the `FieldRead` is not completely determined by explicit SSA
 * updates.
 */
predicate hasNonlocalValue(FieldRead fr) {
  not exists(SsaVariable v | v.getAUse() = fr)
  or
  exists(SsaVariable v, SsaVariable def | v.getAUse() = fr and def = v.getAnUltimateDefinition() |
    def instanceof SsaImplicitInit or
    def instanceof SsaImplicitUpdate
  )
}

cached
private module Cached {
  /**
   * Holds if data can flow from `node1` to `node2` in one local step.
   */
  cached
  predicate localFlowStep(Node node1, Node node2) {
    simpleLocalFlowStep0(node1, node2, _)
    or
    adjacentUseUse(node1.asExpr(), node2.asExpr())
    or
    // Simple flow through library code is included in the exposed local
    // step relation, even though flow is technically inter-procedural
    FlowSummaryImpl::Private::Steps::summaryThroughStepValue(node1, node2, _)
  }

  /**
   * INTERNAL: do not use.
   *
   * This is the local flow predicate that's used as a building block in global
   * data flow. It may have less flow than the `localFlowStep` predicate.
   */
  cached
  predicate simpleLocalFlowStep(Node node1, Node node2, string model) {
    simpleLocalFlowStep0(node1, node2, model)
    or
    any(AdditionalValueStep a).step(node1, node2) and
    pragma[only_bind_out](node1.getEnclosingCallable()) =
      pragma[only_bind_out](node2.getEnclosingCallable()) and
    model = "AdditionalValueStep" and
    // prevent recursive call
    (any(AdditionalValueStep a).step(_, _) implies any())
  }
}

/**
 * Holds if the value of `node2` is given by `node1`.
 */
predicate localMustFlowStep(Node node1, Node node2) {
  exists(Callable c | node1.(InstanceParameterNode).getCallable() = c |
    exists(InstanceAccess ia |
      ia = node2.asExpr() and ia.getEnclosingCallable() = c and ia.isOwnInstanceAccess()
    )
    or
    c =
      node2.(ImplicitInstanceAccess).getInstanceAccess().(OwnInstanceAccess).getEnclosingCallable()
  )
  or
  exists(SsaImplicitInit init |
    init.isParameterDefinition(node1.asParameter()) and init.getAUse() = node2.asExpr()
  )
  or
  exists(SsaExplicitUpdate upd |
    upd.getDefiningExpr().(VariableAssign).getSource() = node1.asExpr() and
    upd.getAUse() = node2.asExpr()
  )
  or
  node2.asExpr().(CastingExpr).getExpr() = node1.asExpr()
  or
  node2.asExpr().(AssignExpr).getSource() = node1.asExpr()
  or
  FlowSummaryImpl::Private::Steps::summaryLocalMustFlowStep(node1.(FlowSummaryNode).getSummaryNode(),
    node2.(FlowSummaryNode).getSummaryNode())
}

import Cached

private predicate capturedVariableRead(Node n) {
  n.asExpr().(VarRead).getVariable() instanceof CapturedVariable
}

/**
 * Holds if there is a data flow step from `e1` to `e2` that only steps from
 * child to parent in the AST.
 */
predicate simpleAstFlowStep(Expr e1, Expr e2) {
  e2.(CastingExpr).getExpr() = e1
  or
  e2.(ChooseExpr).getAResultExpr() = e1
  or
  e2.(AssignExpr).getSource() = e1
  or
  e2.(ArrayCreationExpr).getInit() = e1
  or
  e2 = any(StmtExpr stmtExpr | e1 = stmtExpr.getResultExpr())
  or
  e2 = any(NotNullExpr nne | e1 = nne.getExpr())
  or
  e2.(WhenExpr).getBranch(_).getAResult() = e1
  or
  // In the following three cases only record patterns need this flow edge, leading from the bound instanceof
  // or switch tested expression to a record pattern that will read its fields. Simple binding patterns are
  // handled via VariableAssign.getSource instead.
  // We only consider patterns that declare any identifiers
  exists(SwitchExpr se, RecordPatternExpr recordPattern | recordPattern = e2 |
    e1 = se.getExpr() and
    recordPattern = se.getACase().(PatternCase).getAPattern() and
    recordPattern.declaresAnyIdentifiers()
  )
  or
  exists(SwitchStmt ss, RecordPatternExpr recordPattern | recordPattern = e2 |
    e1 = ss.getExpr() and
    recordPattern = ss.getACase().(PatternCase).getAPattern() and
    recordPattern.declaresAnyIdentifiers()
  )
  or
  exists(InstanceOfExpr ioe | e1 = ioe.getExpr() and e2 = ioe.getPattern().asRecordPattern())
}

private predicate simpleLocalFlowStep0(Node node1, Node node2, string model) {
  (
    TaintTrackingUtil::forceCachingInSameStage() and
    // Variable flow steps through adjacent def-use and use-use pairs.
    exists(SsaExplicitUpdate upd |
      upd.getDefiningExpr().(VariableAssign).getSource() = node1.asExpr() or
      upd.getDefiningExpr().(AssignOp) = node1.asExpr() or
      upd.getDefiningExpr().(RecordBindingVariableExpr) = node1.asExpr()
    |
      node2.asExpr() = upd.getAFirstUse() and
      not capturedVariableRead(node2)
    )
    or
    exists(SsaImplicitInit init |
      init.isParameterDefinition(node1.asParameter()) and
      node2.asExpr() = init.getAFirstUse() and
      not capturedVariableRead(node2)
    )
    or
    adjacentUseUse(node1.asExpr(), node2.asExpr()) and
    not exists(FieldRead fr |
      hasNonlocalValue(fr) and fr.getField().isStatic() and fr = node1.asExpr()
    ) and
    not FlowSummaryImpl::Private::Steps::prohibitsUseUseFlow(node1, _) and
    not capturedVariableRead(node2)
    or
    ThisFlow::adjacentThisRefs(node1, node2)
    or
    adjacentUseUse(node1.(PostUpdateNode).getPreUpdateNode().asExpr(), node2.asExpr()) and
    not capturedVariableRead(node2)
    or
    ThisFlow::adjacentThisRefs(node1.(PostUpdateNode).getPreUpdateNode(), node2)
    or
    simpleAstFlowStep(node1.asExpr(), node2.asExpr())
    or
    captureValueStep(node1, node2)
  ) and
  model = ""
  or
  exists(MethodCall ma, ValuePreservingMethod m, int argNo |
    ma.getCallee().getSourceDeclaration() = m and m.returnsValue(argNo)
  |
    node2.asExpr() = ma and
    node1.(ArgumentNode).argumentOf(any(DataFlowCall c | c.asCall() = ma), argNo) and
    model = "ValuePreservingMethod"
  )
  or
  cloneStep(node1, node2) and model = "CloneStep"
  or
  FlowSummaryImpl::Private::Steps::summaryLocalStep(node1.(FlowSummaryNode).getSummaryNode(),
    node2.(FlowSummaryNode).getSummaryNode(), true, model)
}

/**
 * A description of the way data may be stored inside an object. Examples
 * include instance fields, the contents of a collection object, or the contents
 * of an array.
 */
class Content extends TContent {
  /** Gets the type of the contained data for the purpose of type pruning. */
  abstract DataFlowType getType();

  /** Gets a textual representation of this element. */
  abstract string toString();

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    path = "" and sl = 0 and sc = 0 and el = 0 and ec = 0
  }
}

/** A reference through an instance field. */
class FieldContent extends Content, TFieldContent {
  InstanceField f;

  FieldContent() { this = TFieldContent(f) }

  InstanceField getField() { result = f }

  override DataFlowType getType() { result = getErasedRepr(f.getType()) }

  override string toString() { result = f.toString() }

  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    f.getLocation().hasLocationInfo(path, sl, sc, el, ec)
  }
}

/** A reference through an array. */
class ArrayContent extends Content, TArrayContent {
  override DataFlowType getType() { result instanceof TypeObject }

  override string toString() { result = "[]" }
}

/** A reference through the contents of some collection-like container. */
class CollectionContent extends Content, TCollectionContent {
  override DataFlowType getType() { result instanceof TypeObject }

  override string toString() { result = "<element>" }
}

/** A reference through a map key. */
class MapKeyContent extends Content, TMapKeyContent {
  override DataFlowType getType() { result instanceof TypeObject }

  override string toString() { result = "<map.key>" }
}

/** A reference through a map value. */
class MapValueContent extends Content, TMapValueContent {
  override DataFlowType getType() { result instanceof TypeObject }

  override string toString() { result = "<map.value>" }
}

/** A captured variable. */
class CapturedVariableContent extends Content, TCapturedVariableContent {
  CapturedVariable v;

  CapturedVariableContent() { this = TCapturedVariableContent(v) }

  CapturedVariable getVariable() { result = v }

  override DataFlowType getType() { result = getErasedRepr(v.(Variable).getType()) }

  override string toString() { result = v.toString() }
}

/** A reference through a synthetic instance field. */
class SyntheticFieldContent extends Content, TSyntheticFieldContent {
  SyntheticField s;

  SyntheticFieldContent() { this = TSyntheticFieldContent(s) }

  SyntheticField getField() { result = s }

  override DataFlowType getType() { result = getErasedRepr(s.getType()) }

  override string toString() { result = s.toString() }
}

/**
 * An entity that represents a set of `Content`s.
 *
 * The set may be interpreted differently depending on whether it is
 * stored into (`getAStoreContent`) or read from (`getAReadContent`).
 */
class ContentSet instanceof Content {
  /** Gets a content that may be stored into when storing into this set. */
  Content getAStoreContent() { result = this }

  /** Gets a content that may be read from when reading from this set. */
  Content getAReadContent() { result = this }

  /** Gets a textual representation of this content set. */
  string toString() { result = super.toString() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    super.hasLocationInfo(path, sl, sc, el, ec)
  }
}

/**
 * Holds if the guard `g` validates the expression `e` upon evaluating to `branch`.
 *
 * The expression `e` is expected to be a syntactic part of the guard `g`.
 * For example, the guard `g` might be a call `isSafe(x)` and the expression `e`
 * the argument `x`.
 */
signature predicate guardChecksSig(Guard g, Expr e, boolean branch);

/**
 * Provides a set of barrier nodes for a guard that validates an expression.
 *
 * This is expected to be used in `isBarrier`/`isSanitizer` definitions
 * in data flow and taint tracking.
 */
module BarrierGuard<guardChecksSig/3 guardChecks> {
  /** Gets a node that is safely guarded by the given guard check. */
  Node getABarrierNode() {
    exists(Guard g, SsaVariable v, boolean branch, VarRead use |
      guardChecks(g, v.getAUse(), branch) and
      use = v.getAUse() and
      g.controls(use.getBasicBlock(), branch) and
      result.asExpr() = use
    )
  }
}
