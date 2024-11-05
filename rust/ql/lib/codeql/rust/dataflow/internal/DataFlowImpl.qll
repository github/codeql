/**
 * Provides Rust-specific definitions for use in the data flow library.
 */

private import codeql.util.Void
private import codeql.util.Unit
private import codeql.dataflow.DataFlow
private import codeql.dataflow.internal.DataFlowImpl
private import rust
private import SsaImpl as SsaImpl
private import codeql.rust.controlflow.ControlFlowGraph
private import codeql.rust.controlflow.CfgNodes
private import codeql.rust.dataflow.Ssa

module Node {
  /**
   * An element, viewed as a node in a data flow graph. Either an expression
   * (`ExprNode`) or a parameter (`ParameterNode`).
   */
  abstract class Node extends TNode {
    /** Gets the location of this node. */
    abstract Location getLocation();

    /** Gets a textual representation of this node. */
    abstract string toString();

    /**
     * Gets the expression that corresponds to this node, if any.
     */
    Expr asExpr() { none() }

    /**
     * Gets the control flow node that corresponds to this data flow node.
     */
    CfgNode getCfgNode() { none() }

    /**
     * Gets this node's underlying SSA definition, if any.
     */
    Ssa::Definition asDefinition() { none() }

    /**
     * Gets the parameter that corresponds to this node, if any.
     */
    Param asParameter() { none() }
  }

  /** A node type that is not implemented. */
  final class NaNode extends Node {
    NaNode() { none() }

    override string toString() { result = "N/A" }

    override Location getLocation() { none() }
  }

  /**
   * A node in the data flow graph that corresponds to an expression in the
   * AST.
   *
   * Note that because of control-flow splitting, one `Expr` may correspond
   * to multiple `ExprNode`s, just like it may correspond to multiple
   * `ControlFlow::Node`s.
   */
  final class ExprNode extends Node, TExprNode {
    ExprCfgNode n;

    ExprNode() { this = TExprNode(n) }

    override Location getLocation() { result = n.getExpr().getLocation() }

    override string toString() { result = n.getExpr().toString() }

    override Expr asExpr() { result = n.getExpr() }

    override CfgNode getCfgNode() { result = n }
  }

  /**
   * The value of a parameter at function entry, viewed as a node in a data
   * flow graph.
   */
  final class ParameterNode extends Node, TParameterNode {
    Param parameter;

    ParameterNode() { this = TParameterNode(parameter) }

    override Location getLocation() { result = parameter.getLocation() }

    override string toString() { result = parameter.toString() }

    /** Gets the parameter in the AST that this node corresponds to. */
    Param getParameter() { result = parameter }
  }

  final class ArgumentNode = NaNode;

  /** An SSA node. */
  class SsaNode extends Node, TSsaNode {
    SsaImpl::DataFlowIntegration::SsaNode node;
    SsaImpl::DefinitionExt def;

    SsaNode() {
      this = TSsaNode(node) and
      def = node.getDefinitionExt()
    }

    SsaImpl::DefinitionExt getDefinitionExt() { result = def }

    /** Holds if this node should be hidden from path explanations. */
    abstract predicate isHidden();

    override Location getLocation() { result = node.getLocation() }

    override string toString() { result = node.toString() }
  }

  final class ReturnNode extends NaNode {
    RustDataFlow::ReturnKind getKind() { none() }
  }

  final class OutNode = NaNode;

  /**
   * A node associated with an object after an operation that might have
   * changed its state.
   *
   * This can be either the argument to a callable after the callable returns
   * (which might have mutated the argument), or the qualifier of a field after
   * an update to the field.
   *
   * Nodes corresponding to AST elements, for example `ExprNode`, usually refer
   * to the value before the update.
   */
  final class PostUpdateNode extends Node::NaNode {
    /** Gets the node before the state update. */
    Node getPreUpdateNode() { none() }
  }

  final class CastNode = NaNode;
}

final class Node = Node::Node;

/** Provides logic related to SSA. */
module SsaFlow {
  private module Impl = SsaImpl::DataFlowIntegration;

  private Node::ParameterNode toParameterNode(Param p) { result = TParameterNode(p) }

  /** Converts a control flow node into an SSA control flow node. */
  Impl::Node asNode(Node n) {
    n = TSsaNode(result)
    or
    result.(Impl::ExprNode).getExpr() = n.(Node::ExprNode).getCfgNode()
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

/**
 * Holds for expressions `e` that evaluate to the value of any last (in
 * evaluation order) subexpressions within it. E.g., expressions that propagate
 * a values from a subexpression.
 *
 * For instance, the predicate holds for if expressions as `if b { e1 } else {
 * e2 }` evalates to the value of one of the subexpressions `e1` or `e2`.
 */
private predicate propagatesValue(Expr e) {
  e instanceof IfExpr or
  e instanceof LoopExpr or
  e instanceof ReturnExpr or
  e instanceof BreakExpr or
  e.(BlockExpr).getStmtList().hasTailExpr() or
  e instanceof MatchExpr
}

/**
 * Gets a node that may execute last in `n`, and which, when it executes last,
 * will be the value of `n`.
 */
private ExprCfgNode getALastEvalNode(ExprCfgNode n) {
  propagatesValue(n.getExpr()) and result.getASuccessor() = n
}

module LocalFlow {
  pragma[nomagic]
  predicate localFlowStepCommon(Node nodeFrom, Node nodeTo) {
    nodeFrom.getCfgNode() = getALastEvalNode(nodeTo.getCfgNode())
  }
}

module RustDataFlow implements InputSig<Location> {
  /**
   * An element, viewed as a node in a data flow graph. Either an expression
   * (`ExprNode`) or a parameter (`ParameterNode`).
   */
  final class Node = Node::Node;

  final class ParameterNode = Node::ParameterNode;

  final class ArgumentNode = Node::ArgumentNode;

  final class ReturnNode = Node::ReturnNode;

  final class OutNode = Node::OutNode;

  final class PostUpdateNode = Node::PostUpdateNode;

  final class CastNode = Node::NaNode;

  predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) { none() }

  predicate isArgumentNode(ArgumentNode n, DataFlowCall call, ArgumentPosition pos) { none() }

  DataFlowCallable nodeGetEnclosingCallable(Node node) { none() }

  DataFlowType getNodeType(Node node) { none() }

  predicate nodeIsHidden(Node node) { none() }

  class DataFlowExpr = ExprCfgNode;

  /** Gets the node corresponding to `e`. */
  Node exprNode(DataFlowExpr e) { result.getCfgNode() = e }

  final class DataFlowCall extends TNormalCall {
    private CallExpr c;

    DataFlowCall() { this = TNormalCall(c) }

    DataFlowCallable getEnclosingCallable() { none() }

    string toString() { result = c.toString() }

    Location getLocation() { result = c.getLocation() }
  }

  final class DataFlowCallable = CfgScope;

  final class ReturnKind = Void;

  /** Gets a viable implementation of the target of the given `Call`. */
  DataFlowCallable viableCallable(DataFlowCall c) { none() }

  OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) { none() }

  final class DataFlowType = Unit;

  predicate compatibleTypes(DataFlowType t1, DataFlowType t2) { any() }

  predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) { none() }

  final class Content = Void;

  predicate forceHighPrecision(Content c) { none() }

  class ContentSet extends TContentSet {
    /** Gets a textual representation of this element. */
    string toString() { result = "ContentSet" }

    /** Gets a content that may be stored into when storing into this set. */
    Content getAStoreContent() { none() }

    /** Gets a content that may be read from when reading from this set. */
    Content getAReadContent() { none() }
  }

  final class ContentApprox = Void;

  ContentApprox getContentApprox(Content c) { any() }

  class ParameterPosition extends string {
    ParameterPosition() { this = "pos" }
  }

  class ArgumentPosition extends string {
    ArgumentPosition() { this = "pos" }
  }

  /**
   * Holds if the parameter position `ppos` matches the argument position
   * `apos`.
   */
  predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) { none() }

  /**
   * Holds if there is a simple local flow step from `node1` to `node2`. These
   * are the value-preserving intra-callable flow steps.
   */
  predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo, string model) { none() }

  /**
   * Holds if data can flow from `node1` to `node2` through a non-local step
   * that does not follow a call edge. For example, a step through a global
   * variable.
   */
  predicate jumpStep(Node node1, Node node2) { none() }

  /**
   * Holds if data can flow from `node1` to `node2` via a read of `c`.  Thus,
   * `node1` references an object with a content `c.getAReadContent()` whose
   * value ends up in `node2`.
   */
  predicate readStep(Node node1, ContentSet c, Node node2) { none() }

  /**
   * Holds if data can flow from `node1` to `node2` via a store into `c`.  Thus,
   * `node2` references an object with a content `c.getAStoreContent()` that
   * contains the value of `node1`.
   */
  predicate storeStep(Node node1, ContentSet c, Node node2) { none() }

  /**
   * Holds if values stored inside content `c` are cleared at node `n`. For example,
   * any value stored inside `f` is cleared at the pre-update node associated with `x`
   * in `x.f = newValue`.
   */
  predicate clearsContent(Node n, ContentSet c) { none() }

  /**
   * Holds if the value that is being tracked is expected to be stored inside content `c`
   * at node `n`.
   */
  predicate expectsContent(Node n, ContentSet c) { none() }

  class NodeRegion instanceof Void {
    string toString() { result = "NodeRegion" }

    predicate contains(Node n) { none() }
  }

  /**
   * Holds if the nodes in `nr` are unreachable when the call context is `call`.
   */
  predicate isUnreachableInCall(NodeRegion nr, DataFlowCall call) { none() }

  /**
   * Holds if flow is allowed to pass from parameter `p` and back to itself as a
   * side-effect, resulting in a summary from `p` to itself.
   *
   * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
   * by default as a heuristic.
   */
  predicate allowParameterReturnInSelf(ParameterNode p) { none() }

  /**
   * Holds if the value of `node2` is given by `node1`.
   *
   * This predicate is combined with type information in the following way: If
   * the data flow library is able to compute an improved type for `node1` then
   * it will also conclude that this type applies to `node2`. Vice versa, if
   * `node2` must be visited along a flow path, then any type known for `node2`
   * must also apply to `node1`.
   */
  predicate localMustFlowStep(Node node1, Node node2) {
    SsaFlow::localMustFlowStep(_, node1, node2)
  }

  class LambdaCallKind = Void;

  // class LambdaCallKind;
  /** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
  predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) { none() }

  /** Holds if `call` is a lambda call of kind `kind` where `receiver` is the lambda expression. */
  predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) { none() }

  /** Extra data flow steps needed for lambda flow analysis. */
  predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

  predicate knownSourceModel(Node source, string model) { none() }

  predicate knownSinkModel(Node sink, string model) { none() }

  class DataFlowSecondLevelScope = Void;
}

final class ContentSet = RustDataFlow::ContentSet;

import MakeImpl<Location, RustDataFlow>

/** A collection of cached types and predicates to be evaluated in the same stage. */
cached
private module Cached {
  cached
  newtype TNode =
    TExprNode(ExprCfgNode n) or
    TParameterNode(Param p) or
    TSsaNode(SsaImpl::DataFlowIntegration::SsaNode node)

  cached
  newtype TDataFlowCall = TNormalCall(CallExpr c)

  cached
  newtype TOptionalContentSet =
    TAnyElementContent() or
    TAnyContent()

  cached
  class TContentSet = TAnyElementContent or TAnyContent;

  /** This is the local flow predicate that is exposed. */
  cached
  predicate localFlowStepImpl(Node::Node nodeFrom, Node::Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
    or
    SsaFlow::localFlowStep(_, nodeFrom, nodeTo, _)
  }
}

import Cached
