private import codeql.util.Boolean
private import codeql.util.Unit
private import powershell
private import semmle.code.powershell.Cfg
private import semmle.code.powershell.dataflow.Ssa
private import DataFlowPublic
private import DataFlowDispatch
private import SsaImpl as SsaImpl

/** Gets the callable in which this node occurs. */
DataFlowCallable nodeGetEnclosingCallable(Node n) { result = n.(NodeImpl).getEnclosingCallable() }

/** Holds if `p` is a `ParameterNode` of `c` with position `pos`. */
predicate isParameterNode(ParameterNodeImpl p, DataFlowCallable c, ParameterPosition pos) {
  p.isParameterOf(c, pos)
}

/** Holds if `arg` is an `ArgumentNode` of `c` with position `pos`. */
predicate isArgumentNode(ArgumentNode arg, DataFlowCall c, ArgumentPosition pos) {
  arg.argumentOf(c, pos)
}

abstract class NodeImpl extends Node {
  DataFlowCallable getEnclosingCallable() { result = TCfgScope(this.getCfgScope()) }

  /** Do not call: use `getEnclosingCallable()` instead. */
  abstract CfgScope getCfgScope();

  /** Do not call: use `getLocation()` instead. */
  abstract Location getLocationImpl();

  /** Do not call: use `toString()` instead. */
  abstract string toStringImpl();
}

private class ExprNodeImpl extends ExprNode, NodeImpl {
  override CfgScope getCfgScope() { result = this.getExprNode().getExpr().getEnclosingScope() }

  override Location getLocationImpl() { result = this.getExprNode().getLocation() }

  override string toStringImpl() { result = this.getExprNode().toString() }
}

private class StmtNodeImpl extends StmtNode, NodeImpl {
  override CfgScope getCfgScope() { result = this.getStmtNode().getStmt().getEnclosingScope() }

  override Location getLocationImpl() { result = this.getStmtNode().getLocation() }

  override string toStringImpl() { result = this.getStmtNode().toString() }
}

/** Gets the SSA definition node corresponding to parameter `p`. */
pragma[nomagic]
SsaImpl::DefinitionExt getParameterDef(Parameter p) {
  exists(EntryBasicBlock bb, int i |
    SsaImpl::parameterWrite(bb, i, p) and
    result.definesAt(p, bb, i, _)
  )
}

/** Provides logic related to SSA. */
module SsaFlow {
  private module Impl = SsaImpl::DataFlowIntegration;

  private ParameterNodeImpl toParameterNode(SsaImpl::ParameterExt p) {
    result = TNormalParameterNode(p.asParameter())
  }

  Impl::Node asNode(Node n) {
    n = TSsaNode(result)
    or
    result.(Impl::ExprNode).getExpr() = n.asExpr()
    or
    result.(Impl::ExprNode).getExpr() = n.asStmt()
    or
    result.(Impl::ExprPostUpdateNode).getExpr() = n.(PostUpdateNode).getPreUpdateNode().asExpr()
    or
    n = toParameterNode(result.(Impl::ParameterNode).getParameter())
  }

  predicate localFlowStep(SsaImpl::DefinitionExt def, Node nodeFrom, Node nodeTo, boolean isUseStep) {
    Impl::localFlowStep(def, asNode(nodeFrom), asNode(nodeTo), isUseStep)
  }

  predicate localMustFlowStep(SsaImpl::DefinitionExt def, Node nodeFrom, Node nodeTo) {
    Impl::localMustFlowStep(def, asNode(nodeFrom), asNode(nodeTo))
  }
}

/** Provides predicates related to local data flow. */
module LocalFlow {
  pragma[nomagic]
  predicate localFlowStepCommon(Node nodeFrom, Node nodeTo) {
    nodeFrom.asExpr() = nodeTo.asExpr().(CfgNodes::ExprNodes::ConditionalCfgNode).getABranch()
    or
    nodeFrom.asStmt() = nodeTo.asStmt().(CfgNodes::StmtNodes::AssignStmtCfgNode).getRightHandSide()
    or
    nodeFrom.asExpr() = nodeTo.asStmt().(CfgNodes::StmtNodes::CmdExprCfgNode).getExpr()
  }

  predicate localMustFlowStep(Node nodeFrom, Node nodeTo) {
    nodeFrom.asStmt() = nodeTo.asStmt().(CfgNodes::StmtNodes::AssignStmtCfgNode).getRightHandSide()
  }
}

/** Provides logic related to captured variables. */
module VariableCapture {
  // TODO
}

/** A collection of cached types and predicates to be evaluated in the same stage. */
cached
private module Cached {
  private import semmle.code.powershell.typetracking.internal.TypeTrackingImpl

  cached
  newtype TNode =
    TExprNode(CfgNodes::ExprCfgNode n) or
    TStmtNode(CfgNodes::StmtCfgNode n) or
    TSsaNode(SsaImpl::DataFlowIntegration::SsaNode node) or
    TNormalParameterNode(Parameter p) or
    TExprPostUpdateNode(CfgNodes::ExprCfgNode n) {
      n instanceof CfgNodes::ExprNodes::ArgumentCfgNode
      or
      n instanceof CfgNodes::ExprNodes::QualifierCfgNode
      or
      exists(CfgNodes::ExprNodes::MemberCfgNode member |
        n = member.getBase() and
        not member.isStatic()
      )
      or
      n = any(CfgNodes::ExprNodes::IndexCfgNode index).getBase()
    }

  cached
  Location getLocation(NodeImpl n) { result = n.getLocationImpl() }

  cached
  string toString(NodeImpl n) { result = n.toStringImpl() }

  /**
   * This is the local flow predicate that is used as a building block in global
   * data flow.
   */
  cached
  predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo, string model) {
    (
      LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
      or
      SsaFlow::localFlowStep(_, nodeFrom, nodeTo, _)
    ) and
    model = ""
  }

  /** This is the local flow predicate that is exposed. */
  cached
  predicate localFlowStepImpl(Node nodeFrom, Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
    or
    SsaFlow::localFlowStep(_, nodeFrom, nodeTo, _)
  }

  /**
   * This is the local flow predicate that is used in type tracking.
   */
  cached
  predicate localFlowStepTypeTracker(Node nodeFrom, Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
    or
    SsaFlow::localFlowStep(_, nodeFrom, nodeTo, _)
  }

  /** Holds if `n` wraps an SSA definition without ingoing flow. */
  private predicate entrySsaDefinition(SsaDefinitionExtNode n) {
    n.getDefinitionExt() =
      any(SsaImpl::WriteDefinition def | not def.(Ssa::WriteDefinition).assigns(_))
  }

  pragma[nomagic]
  private predicate reachedFromExprOrEntrySsaDef(Node n) {
    localFlowStepTypeTracker(any(Node n0 |
        n0 instanceof ExprNode
        or
        entrySsaDefinition(n0)
      ), n)
    or
    exists(Node mid |
      reachedFromExprOrEntrySsaDef(mid) and
      localFlowStepTypeTracker(mid, n)
    )
  }

  private predicate isStoreTargetNode(Node n) {
    TypeTrackingInput::storeStep(_, n, _)
    or
    TypeTrackingInput::loadStoreStep(_, n, _, _)
    or
    TypeTrackingInput::withContentStepImpl(_, n, _)
    or
    TypeTrackingInput::withoutContentStepImpl(_, n, _)
  }

  cached
  predicate isLocalSourceNode(Node n) {
    n instanceof ParameterNode
    or
    // Expressions that can't be reached from another entry definition or expression
    n instanceof ExprNode and
    not reachedFromExprOrEntrySsaDef(n)
    or
    // Ensure all entry SSA definitions are local sources, except those that correspond
    // to parameters (which are themselves local sources)
    entrySsaDefinition(n) and
    not exists(SsaImpl::ParameterExt p |
      p.isInitializedBy(n.(SsaDefinitionExtNode).getDefinitionExt())
    )
    or
    isStoreTargetNode(n)
    or
    TypeTrackingInput::loadStep(_, n, _)
  }

  cached
  newtype TContentSet =
    TSingletonContent(Content c) or
    TAnyElementContent() or
    TKnownOrUnknownElementContent(Content::KnownElementContent c)

  private predicate trackKnownValue(ConstantValue cv) {
    exists(cv.asString())
    or
    cv.asInt() = [0 .. 10]
  }

  cached
  newtype TContent =
    TFieldContent(string name) {
      name = any(PropertyMember member).getName()
      or
      name = any(MemberExpr me).getMemberName()
    } or
    TKnownElementContent(ConstantValue cv) { trackKnownValue(cv) } or
    TUnknownElementContent()

  cached
  newtype TContentApprox =
    TNonElementContentApprox(Content c) { not c instanceof Content::ElementContent } or
    TUnknownElementContentApprox() or
    TKnownIntegerElementContentApprox() or
    TKnownElementContentApprox(string approx) { approx = approxKnownElementIndex(_) }

  cached
  newtype TDataFlowType = TUnknownDataFlowType()
}

class TElementContent = TKnownElementContent or TUnknownElementContent;

/** Gets a string for approximating known element indices. */
private string approxKnownElementIndex(ConstantValue cv) {
  not exists(cv.asInt()) and
  exists(string s | s = cv.serialize() |
    s.length() < 2 and
    result = s
    or
    result = s.prefix(2)
  )
}

import Cached

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) { none() }

/** An SSA node. */
abstract class SsaNode extends NodeImpl, TSsaNode {
  SsaImpl::DataFlowIntegration::SsaNode node;
  SsaImpl::DefinitionExt def;

  SsaNode() {
    this = TSsaNode(node) and
    def = node.getDefinitionExt()
  }

  SsaImpl::DefinitionExt getDefinitionExt() { result = def }

  /** Holds if this node should be hidden from path explanations. */
  abstract predicate isHidden();

  override Location getLocationImpl() { result = node.getLocation() }

  override string toStringImpl() { result = node.toString() }
}

/** An (extended) SSA definition, viewed as a node in a data flow graph. */
class SsaDefinitionExtNode extends SsaNode {
  override SsaImpl::DataFlowIntegration::SsaDefinitionExtNode node;

  /** Gets the underlying variable. */
  Variable getVariable() { result = def.getSourceVariable() }

  override predicate isHidden() {
    not def instanceof Ssa::WriteDefinition
    or
    def = getParameterDef(_)
  }

  override CfgScope getCfgScope() { result = def.getBasicBlock().getScope() }
}

class SsaDefinitionNodeImpl extends SsaDefinitionExtNode {
  Ssa::Definition ssaDef;

  SsaDefinitionNodeImpl() { ssaDef = def }

  override Location getLocationImpl() { result = ssaDef.getLocation() }

  override string toStringImpl() { result = ssaDef.toString() }
}

class SsaInputNode extends SsaNode {
  override SsaImpl::DataFlowIntegration::SsaInputNode node;

  override predicate isHidden() { any() }

  override CfgScope getCfgScope() { result = node.getDefinitionExt().getBasicBlock().getScope() }
}

private string getANamedArgument(CfgNodes::CallCfgNode c) { exists(c.getNamedArgument(result)) }

private module NamedSetModule =
  QlBuiltins::InternSets<CfgNodes::CallCfgNode, string, getANamedArgument/1>;

private newtype NamedSet0 =
  TEmptyNamedSet() or
  TNonEmptyNamedSet(NamedSetModule::Set ns)

/** A (possiby empty) set of argument names. */
class NamedSet extends NamedSet0 {
  /** Gets the non-empty set of names, if any. */
  NamedSetModule::Set asNonEmpty() { this = TNonEmptyNamedSet(result) }

  /** Holds if this is the empty set. */
  predicate isEmpty() { this = TEmptyNamedSet() }

  /** Gets a name in this set. */
  string getAName() { this.asNonEmpty().contains(result) }

  /** Gets the textual representation of this set. */
  string toString() {
    result = "{" + strictconcat(this.getAName(), ", ") + "}"
    or
    this.isEmpty() and
    result = "{}"
  }

  /**
   * Gets a `CfgNodes::CallCfgNode` that provides a named parameter for every name in `this`.
   *
   * NOTE: The `CfgNodes::CallCfgNode` may also provide more names.
   */
  CfgNodes::CallCfgNode getABindingCall() {
    forex(string name | name = this.getAName() | exists(result.getNamedArgument(name)))
    or
    this.isEmpty() and
    exists(result)
  }

  /**
   * Gets a `Cmd` that provides exactly the named parameters represented by
   * this set.
   */
  CfgNodes::CallCfgNode getAnExactBindingCall() {
    forex(string name | name = this.getAName() | exists(result.getNamedArgument(name))) and
    forex(string name | exists(result.getNamedArgument(name)) | name = this.getAName())
    or
    this.isEmpty() and
    not exists(result.getNamedArgument(_))
  }

  /** Gets a function that has a parameter for each name in this set. */
  Function getAFunction() {
    forex(string name | name = this.getAName() | result.getAParameter().hasName(name))
    or
    this.isEmpty() and
    exists(result)
  }
}

private module ParameterNodes {
  abstract class ParameterNodeImpl extends NodeImpl {
    abstract Parameter getParameter();

    abstract predicate isParameterOf(DataFlowCallable c, ParameterPosition pos);
  }

  /**
   * The value of a normal parameter at function entry, viewed as a node in a data
   * flow graph.
   */
  class NormalParameterNode extends ParameterNodeImpl, TNormalParameterNode {
    Parameter parameter;

    NormalParameterNode() { this = TNormalParameterNode(parameter) }

    override Parameter getParameter() { result = parameter }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      parameter.getDeclaringScope() = c.asCfgScope() and
      (
        pos.isThis() and
        parameter.isThis()
        or
        pos.isKeyword(parameter.getName())
        or
        // Given a function f with parameters x, y we map
        // x to the positions:
        // 1. keyword(x)
        // 2. position(0, {y})
        // 3. position(0, {})
        // Likewise, y is mapped to the positions:
        // 1. keyword(y)
        // 2. position(0, {x})
        // 3. position(1, {})
        // The interpretation of `position(i, S)` is the position of the i'th unnamed parameter when the
        // keywords in S are specified.
        exists(int i, int j, string name, NamedSet ns, Function f |
          pos.isPositional(j, ns) and
          parameter.getIndex() = i and
          f = parameter.getFunction() and
          f = ns.getAFunction() and
          name = parameter.getName() and
          not name = ns.getAName() and
          j = i - count(int k | k < i and f.getParameter(k).getName() = ns.getAName())
        )
      )
    }

    override CfgScope getCfgScope() {
      result.getAParameter() = parameter or result.getThisParameter() = parameter
    }

    override Location getLocationImpl() { result = parameter.getLocation() }

    override string toStringImpl() { result = parameter.toString() }
  }
}

import ParameterNodes

/** A data-flow node that represents a call argument. */
abstract class ArgumentNode extends Node {
  /** Holds if this argument occurs at the given position in the given call. */
  abstract predicate argumentOf(DataFlowCall call, ArgumentPosition pos);

  /** Gets the call in which this node is an argument. */
  final DataFlowCall getCall() { this.argumentOf(result, _) }
}

module ArgumentNodes {
  class ExplicitArgumentNode extends ArgumentNode {
    CfgNodes::ExprNodes::ArgumentCfgNode arg;

    ExplicitArgumentNode() { this.asExpr() = arg }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      arg.getCall() = call.asCall() and
      (
        pos.isKeyword(arg.getName())
        or
        exists(NamedSet ns, int i |
          i = arg.getPosition() and
          ns.getAnExactBindingCall() = call.asCall() and
          pos.isPositional(i, ns)
        )
        or
        arg.isQualifier() and
        pos.isThis()
      )
    }
  }
}

import ArgumentNodes

/** A data-flow node that represents a value returned by a callable. */
abstract class ReturnNode extends Node {
  /** Gets the kind of this return node. */
  abstract ReturnKind getKind();
}

private module ReturnNodes {
  // TODO
}

import ReturnNodes

/** A data-flow node that represents the output of a call. */
abstract class OutNode extends Node {
  /** Gets the underlying call, where this node is a corresponding output of kind `kind`. */
  abstract DataFlowCall getCall(ReturnKind kind);
}

private module OutNodes {
  // TODO
}

import OutNodes

predicate jumpStep(Node pred, Node succ) {
  none() // TODO
}

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to
 * content `c`.
 */
predicate storeStep(Node node1, ContentSet c, Node node2) {
  exists(CfgNodes::ExprNodes::MemberCfgWriteAccessNode var, Content::FieldContent fc |
    node2.(PostUpdateNode).getPreUpdateNode().asExpr() = var.getBase() and
    node1.asStmt() = var.getAssignStmt().getRightHandSide() and
    fc.getName() = var.getMemberName() and
    c.isSingleton(fc)
  )
  or
  exists(
    CfgNodes::ExprNodes::IndexCfgWriteNode var, Content::KnownElementContent ec, int index,
    CfgNodes::ExprCfgNode e
  |
    node2.(PostUpdateNode).getPreUpdateNode().asExpr() = var.getBase() and
    node1.asStmt() = var.getAssignStmt().getRightHandSide() and
    c.isKnownOrUnknownElement(ec) and
    index = ec.getIndex().asInt() and
    e = var.getIndex()
  |
    index = e.getValue().asInt()
    or
    not exists(e.getValue().asInt())
  )
  or
  exists(Content::KnownElementContent ec, int index |
    node2.asExpr().(CfgNodes::ExprNodes::ArrayLiteralCfgNode).getElement(index) = node1.asExpr() and
    c.isKnownOrUnknownElement(ec) and
    index = ec.getIndex().asInt()
  )
}

/**
 * Holds if there is a read step of content `c` from `node1` to `node2`.
 */
predicate readStep(Node node1, ContentSet c, Node node2) {
  exists(CfgNodes::ExprNodes::MemberCfgReadAccessNode var, Content::FieldContent fc |
    node2.asExpr() = var and
    node1.asExpr() = var.getBase() and
    fc.getName() = var.getMemberName() and
    c.isSingleton(fc)
  )
  or
  exists(
    CfgNodes::ExprNodes::IndexCfgReadNode var, Content::KnownElementContent ec, int index,
    CfgNodes::ExprCfgNode e
  |
    node2.asExpr() = var and
    node1.asExpr() = var.getBase() and
    c.isKnownOrUnknownElement(ec) and
    index = ec.getIndex().asInt() and
    e = var.getIndex()
  |
    index = e.getValue().asInt()
    or
    not exists(e.getValue().asInt())
  )
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`. For example,
 * any value stored inside `f` is cleared at the pre-update node associated with `x`
 * in `x.f = newValue`.
 */
predicate clearsContent(Node n, ContentSet c) {
  n = any(PostUpdateNode pun | storeStep(_, c, pun)).getPreUpdateNode()
}

/**
 * Holds if the value that is being tracked is expected to be stored inside content `c`
 * at node `n`.
 */
predicate expectsContent(Node n, ContentSet c) {
  none() // TODO
}

class DataFlowType extends TDataFlowType {
  string toString() { result = "" }
}

predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) {
  t1 != TUnknownDataFlowType() and
  t2 = TUnknownDataFlowType()
}

predicate localMustFlowStep(Node node1, Node node2) { none() }

/** Gets the type of `n` used for type pruning. */
DataFlowType getNodeType(Node n) {
  result = TUnknownDataFlowType() and // TODO
  exists(n)
}

pragma[inline]
private predicate compatibleTypesNonSymRefl(DataFlowType t1, DataFlowType t2) {
  t1 != TUnknownDataFlowType() and
  t2 = TUnknownDataFlowType()
}

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
predicate compatibleTypes(DataFlowType t1, DataFlowType t2) {
  t1 = t2
  or
  compatibleTypesNonSymRefl(t1, t2)
  or
  compatibleTypesNonSymRefl(t2, t1)
}

abstract class PostUpdateNodeImpl extends Node {
  /** Gets the node before the state update. */
  abstract Node getPreUpdateNode();
}

private module PostUpdateNodes {
  class ExprPostUpdateNode extends PostUpdateNodeImpl, NodeImpl, TExprPostUpdateNode {
    private CfgNodes::ExprCfgNode e;

    ExprPostUpdateNode() { this = TExprPostUpdateNode(e) }

    override ExprNode getPreUpdateNode() { e = result.getExprNode() }

    override CfgScope getCfgScope() { result = e.getExpr().getEnclosingScope() }

    override Location getLocationImpl() { result = e.getLocation() }

    override string toStringImpl() { result = "[post] " + e.toString() }
  }
}

private import PostUpdateNodes

/** A node that performs a type cast. */
class CastNode extends Node {
  CastNode() { none() }
}

class DataFlowExpr = CfgNodes::ExprCfgNode;

/**
 * Holds if access paths with `c` at their head always should be tracked at high
 * precision. This disables adaptive access path precision for such access paths.
 */
predicate forceHighPrecision(Content c) { c instanceof Content::ElementContent }

class NodeRegion instanceof Unit {
  string toString() { result = "NodeRegion" }

  predicate contains(Node n) { none() }

  /** Gets a best-effort total ordering. */
  int totalOrder() { result = 1 }
}

/**
 * Holds if the nodes in `nr` are unreachable when the call context is `call`.
 */
predicate isUnreachableInCall(NodeRegion nr, DataFlowCall call) { none() }

newtype LambdaCallKind = TLambdaCallKind()

private class CmdName extends StringConstExpr {
  CmdName() { this = any(Cmd c).getCmdName() }

  string getName() { result = this.getValue().getValue() }
}

/** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) {
  creation.asExpr().getExpr().(CmdName).getName() = c.asCfgScope().getEnclosingFunction().getName() and
  exists(kind)
}

/**
 * Holds if `call` is a (from-source or from-summary) lambda call of kind `kind`
 * where `receiver` is the lambda expression.
 */
predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) {
  call.asCall().getCommand() = receiver.asExpr() and exists(kind)
}

/** Extra data-flow steps needed for lambda flow analysis. */
predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

predicate knownSourceModel(Node source, string model) { none() }

predicate knownSinkModel(Node sink, string model) { none() }

class DataFlowSecondLevelScope = Unit;

/**
 * Holds if flow is allowed to pass from parameter `p` and back to itself as a
 * side-effect, resulting in a summary from `p` to itself.
 *
 * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
 * by default as a heuristic.
 */
predicate allowParameterReturnInSelf(ParameterNodeImpl p) {
  none() // TODO
}

/** An approximated `Content`. */
class ContentApprox extends TContentApprox {
  string toString() {
    exists(Content c |
      this = TNonElementContentApprox(c) and
      result = c.toString()
    )
  }
}

/** Gets an approximated value for content `c`. */
ContentApprox getContentApprox(Content c) {
  c instanceof Content::UnknownElementContent and
  result = TUnknownElementContentApprox()
  or
  exists(c.(Content::KnownElementContent).getIndex().asInt()) and
  result = TKnownIntegerElementContentApprox()
  or
  result =
    TKnownElementContentApprox(approxKnownElementIndex(c.(Content::KnownElementContent).getIndex()))
  or
  result = TNonElementContentApprox(c)
}

/**
 * A unit class for adding additional jump steps.
 *
 * Extend this class to add additional jump steps.
 */
class AdditionalJumpStep extends Unit {
  /**
   * Holds if data can flow from `pred` to `succ` in a way that discards call contexts.
   */
  abstract predicate step(Node pred, Node succ);
}
