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
import DataFlowNodes::Public
import semmle.code.Unit

/** Holds if `n` is an access to an unqualified `this` at `cfgnode`. */
private predicate thisAccess(Node n, ControlFlowNode cfgnode) {
  n.(InstanceParameterNode).getCallable().getBody() = cfgnode
  or
  exists(InstanceAccess ia | ia = n.asExpr() and ia = cfgnode and ia.isOwnInstanceAccess())
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
predicate localFlow(Node node1, Node node2) { localFlowStep*(node1, node2) }

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

/**
 * Holds if data can flow from `node1` to `node2` in one local step.
 */
predicate localFlowStep(Node node1, Node node2) {
  simpleLocalFlowStep(node1, node2)
  or
  adjacentUseUse(node1.asExpr(), node2.asExpr())
  or
  // Simple flow through library code is included in the exposed local
  // step relation, even though flow is technically inter-procedural
  FlowSummaryImpl::Private::Steps::summaryThroughStep(node1, node2, true)
}

/**
 * INTERNAL: do not use.
 *
 * This is the local flow predicate that's used as a building block in global
 * data flow. It may have less flow than the `localFlowStep` predicate.
 */
cached
predicate simpleLocalFlowStep(Node node1, Node node2) {
  TaintTrackingUtil::forceCachingInSameStage() and
  // Variable flow steps through adjacent def-use and use-use pairs.
  exists(SsaExplicitUpdate upd |
    upd.getDefiningExpr().(VariableAssign).getSource() = node1.asExpr() or
    upd.getDefiningExpr().(AssignOp) = node1.asExpr()
  |
    node2.asExpr() = upd.getAFirstUse()
  )
  or
  exists(SsaImplicitInit init |
    init.isParameterDefinition(node1.asParameter()) and
    node2.asExpr() = init.getAFirstUse()
  )
  or
  adjacentUseUse(node1.asExpr(), node2.asExpr()) and
  not exists(FieldRead fr |
    hasNonlocalValue(fr) and fr.getField().isStatic() and fr = node1.asExpr()
  ) and
  not FlowSummaryImpl::Private::Steps::summaryClearsContentArg(node1, _)
  or
  ThisFlow::adjacentThisRefs(node1, node2)
  or
  adjacentUseUse(node1.(PostUpdateNode).getPreUpdateNode().asExpr(), node2.asExpr())
  or
  ThisFlow::adjacentThisRefs(node1.(PostUpdateNode).getPreUpdateNode(), node2)
  or
  node2.asExpr().(CastExpr).getExpr() = node1.asExpr()
  or
  node2.asExpr().(ChooseExpr).getAResultExpr() = node1.asExpr()
  or
  node2.asExpr().(AssignExpr).getSource() = node1.asExpr()
  or
  node2.asExpr().(ArrayCreationExpr).getInit() = node1.asExpr()
  or
  exists(MethodAccess ma, ValuePreservingMethod m, int argNo |
    ma.getCallee().getSourceDeclaration() = m and m.returnsValue(argNo)
  |
    node2.asExpr() = ma and
    node1.(ArgumentNode).argumentOf(any(DataFlowCall c | c.asCall() = ma), argNo)
  )
  or
  FlowSummaryImpl::Private::Steps::summaryLocalStep(node1, node2, true)
  or
  any(AdditionalValueStep a).step(node1, node2) and
  pragma[only_bind_out](node1.getEnclosingCallable()) =
    pragma[only_bind_out](node2.getEnclosingCallable())
}

private newtype TContent =
  TFieldContent(InstanceField f) or
  TArrayContent() or
  TCollectionContent() or
  TMapKeyContent() or
  TMapValueContent() or
  TSyntheticFieldContent(SyntheticField s)

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
 * A guard that validates some expression.
 *
 * To use this in a configuration, extend the class and provide a
 * characteristic predicate precisely specifying the guard, and override
 * `checks` to specify what is being validated and in which branch.
 *
 * It is important that all extending classes in scope are disjoint.
 */
class BarrierGuard extends Guard {
  /** Holds if this guard validates `e` upon evaluating to `branch`. */
  abstract predicate checks(Expr e, boolean branch);

  /** Gets a node guarded by this guard. */
  final Node getAGuardedNode() {
    exists(SsaVariable v, boolean branch, RValue use |
      this.checks(v.getAUse(), branch) and
      use = v.getAUse() and
      this.controls(use.getBasicBlock(), branch) and
      result.asExpr() = use
    )
  }
}
