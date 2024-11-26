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

private newtype TReturnKind = TNormalReturnKind()

/**
 * A return kind. A return kind describes how a value can be returned from a
 * callable.
 *
 * The only return kind is a "normal" return from a `return` statement or an
 * expression body.
 */
final class ReturnKind extends TNormalReturnKind {
  string toString() { result = "return" }
}

/**
 * A callable. This includes callables from source code, as well as callables
 * defined in library code.
 */
final class DataFlowCallable extends TDataFlowCallable {
  /**
   * Gets the underlying CFG scope, if any.
   */
  CfgScope asCfgScope() { this = TCfgScope(result) }

  /** Gets a textual representation of this callable. */
  string toString() { result = this.asCfgScope().toString() }

  /** Gets the location of this callable. */
  Location getLocation() { result = this.asCfgScope().getLocation() }
}

final class DataFlowCall extends TDataFlowCall {
  private CallExprBaseCfgNode call;

  DataFlowCall() { this = TCall(call) }

  /** Gets the underlying call in the CFG, if any. */
  CallExprCfgNode asCallExprCfgNode() { result = call }

  MethodCallExprCfgNode asMethodCallExprCfgNode() { result = call }

  CallExprBaseCfgNode asCallBaseExprCfgNode() { result = call }

  DataFlowCallable getEnclosingCallable() {
    result = TCfgScope(call.getExpr().getEnclosingCfgScope())
  }

  string toString() { result = this.asCallBaseExprCfgNode().toString() }

  Location getLocation() { result = this.asCallBaseExprCfgNode().getLocation() }
}

/**
 * The position of a parameter or an argument in a function or call.
 *
 * As there is a 1-to-1 correspondence between parameter positions and
 * arguments positions in Rust we use the same type for both.
 */
final class ParameterPosition extends TParameterPosition {
  /** Gets the underlying integer position, if any. */
  int getPosition() { this = TPositionalParameterPosition(result) }

  /** Holds if this position represents the `self` position. */
  predicate isSelf() { this = TSelfParameterPosition() }

  /** Gets a textual representation of this position. */
  string toString() {
    result = this.getPosition().toString()
    or
    result = "self" and this.isSelf()
  }

  ParamBase getParameterIn(ParamList ps) {
    result = ps.getParam(this.getPosition())
    or
    result = ps.getSelfParam() and this.isSelf()
  }
}

/** Holds if `arg` is an argument of `call` at the position `pos`. */
private predicate isArgumentForCall(ExprCfgNode arg, CallExprBaseCfgNode call, ParameterPosition pos) {
  arg = call.getArgument(pos.getPosition())
  or
  // The self argument in a method call.
  arg = call.(MethodCallExprCfgNode).getReceiver() and pos.isSelf()
}

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
    ExprCfgNode asExpr() { none() }

    /** Gets the enclosing callable. */
    DataFlowCallable getEnclosingCallable() { result = TCfgScope(this.getCfgScope()) }

    /** Do not call: use `getEnclosingCallable()` instead. */
    abstract CfgScope getCfgScope();

    /**
     * Gets the control flow node that corresponds to this data flow node.
     */
    CfgNode getCfgNode() { none() }

    /**
     * Gets this node's underlying SSA definition, if any.
     */
    Ssa::Definition asDefinition() { none() }
  }

  /** A node type that is not implemented. */
  final class NaNode extends Node {
    NaNode() { none() }

    override CfgScope getCfgScope() { none() }

    override string toString() { result = "N/A" }

    override Location getLocation() { none() }
  }

  /** A data flow node that corresponds directly to a CFG node for an AST node. */
  abstract class AstCfgFlowNode extends Node {
    AstCfgNode n;

    final override CfgNode getCfgNode() { result = n }

    final override CfgScope getCfgScope() { result = n.getAstNode().getEnclosingCfgScope() }

    final override Location getLocation() { result = n.getAstNode().getLocation() }

    final override string toString() { result = n.getAstNode().toString() }
  }

  /**
   * A node in the data flow graph that corresponds to an expression in the
   * AST.
   *
   * Note that because of control flow splitting, one `Expr` may correspond
   * to multiple `ExprNode`s, just like it may correspond to multiple
   * `ControlFlow::Node`s.
   */
  class ExprNode extends AstCfgFlowNode, TExprNode {
    override ExprCfgNode n;

    ExprNode() { this = TExprNode(n) }

    override ExprCfgNode asExpr() { result = n }
  }

  final class PatNode extends AstCfgFlowNode, TPatNode {
    override PatCfgNode n;

    PatNode() { this = TPatNode(n) }

    /** Gets the `PatCfgNode` in the CFG that this node corresponds to. */
    PatCfgNode getPat() { result = n }
  }

  /**
   * The value of a parameter at function entry, viewed as a node in a data
   * flow graph.
   */
  final class ParameterNode extends AstCfgFlowNode, TParameterNode {
    override ParamBaseCfgNode n;

    ParameterNode() { this = TParameterNode(n) }

    /** Gets the parameter in the CFG that this node corresponds to. */
    ParamBaseCfgNode getParameter() { result = n }
  }

  final class ArgumentNode extends ExprNode {
    ArgumentNode() { isArgumentForCall(n, _, _) }
  }

  /** An SSA node. */
  class SsaNode extends Node, TSsaNode {
    SsaImpl::DataFlowIntegration::SsaNode node;
    SsaImpl::DefinitionExt def;

    SsaNode() {
      this = TSsaNode(node) and
      def = node.getDefinitionExt()
    }

    override CfgScope getCfgScope() { result = def.getBasicBlock().getScope() }

    SsaImpl::DefinitionExt getDefinitionExt() { result = def }

    override Location getLocation() { result = node.getLocation() }

    override string toString() { result = "[SSA] " + node.toString() }
  }

  /** A data flow node that represents a value returned by a callable. */
  final class ReturnNode extends ExprNode {
    ReturnNode() { this.getCfgNode().getASuccessor() instanceof AnnotatedExitCfgNode }

    ReturnKind getKind() { any() }
  }

  /** A data-flow node that represents the output of a call. */
  abstract class OutNode extends Node, ExprNode {
    /** Gets the underlying call for this node. */
    abstract DataFlowCall getCall();
  }

  final private class ExprOutNode extends ExprNode, OutNode {
    ExprOutNode() { this.asExpr() instanceof CallExprBaseCfgNode }

    /** Gets the underlying call CFG node that includes this out node. */
    override DataFlowCall getCall() { result.asCallBaseExprCfgNode() = this.getCfgNode() }
  }

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
  final class PostUpdateNode extends Node, TArgumentPostUpdateNode {
    private ExprCfgNode n;

    PostUpdateNode() { this = TArgumentPostUpdateNode(n) }

    /** Gets the node before the state update. */
    Node getPreUpdateNode() { result = TExprNode(n) }

    final override CfgScope getCfgScope() { result = n.getScope() }

    final override Location getLocation() { result = n.getLocation() }

    final override string toString() { result = n.toString() }
  }

  final class CastNode = NaNode;
}

final class Node = Node::Node;

/** Provides logic related to SSA. */
module SsaFlow {
  private module SsaFlow = SsaImpl::DataFlowIntegration;

  private Node::ParameterNode toParameterNode(ParamCfgNode p) {
    result.(Node::ParameterNode).getParameter() = p
  }

  /** Converts a control flow node into an SSA control flow node. */
  SsaFlow::Node asNode(Node n) {
    n = TSsaNode(result)
    or
    result.(SsaFlow::ExprNode).getExpr() = n.asExpr()
    or
    n = toParameterNode(result.(SsaFlow::ParameterNode).getParameter())
  }

  predicate localFlowStep(SsaImpl::DefinitionExt def, Node nodeFrom, Node nodeTo, boolean isUseStep) {
    SsaFlow::localFlowStep(def, asNode(nodeFrom), asNode(nodeTo), isUseStep)
  }

  predicate localMustFlowStep(SsaImpl::DefinitionExt def, Node nodeFrom, Node nodeTo) {
    SsaFlow::localMustFlowStep(def, asNode(nodeFrom), asNode(nodeTo))
  }
}

/**
 * Gets a node that may execute last in `n`, and which, when it executes last,
 * will be the value of `n`.
 */
private ExprCfgNode getALastEvalNode(ExprCfgNode e) {
  e = any(IfExprCfgNode n | result = [n.getThen(), n.getElse()]) or
  result = e.(LoopExprCfgNode).getLoopBody() or
  result = e.(ReturnExprCfgNode).getExpr() or
  result = e.(BreakExprCfgNode).getExpr() or
  result = e.(BlockExprCfgNode).getTailExpr() or
  result = e.(MatchExprCfgNode).getArmExpr(_) or
  result.(BreakExprCfgNode).getTarget() = e
}

module LocalFlow {
  pragma[nomagic]
  predicate localFlowStepCommon(Node nodeFrom, Node nodeTo) {
    nodeFrom.getCfgNode() = getALastEvalNode(nodeTo.getCfgNode())
    or
    exists(LetStmtCfgNode s |
      nodeFrom.getCfgNode() = s.getInitializer() and
      nodeTo.getCfgNode() = s.getPat()
    )
    or
    // An edge from a pattern/expression to its corresponding SSA definition.
    nodeFrom.(Node::AstCfgFlowNode).getCfgNode() =
      nodeTo.(Node::SsaNode).getDefinitionExt().(Ssa::WriteDefinition).getControlFlowNode()
    or
    nodeFrom.(Node::ParameterNode).getParameter().(ParamCfgNode).getPat() =
      nodeTo.(Node::PatNode).getPat()
    or
    SsaFlow::localFlowStep(_, nodeFrom, nodeTo, _)
    or
    exists(AssignmentExprCfgNode a |
      a.getRhs() = nodeFrom.getCfgNode() and
      a.getLhs() = nodeTo.getCfgNode()
    )
  }
}

private class DataFlowCallableAlias = DataFlowCallable;

private class ReturnKindAlias = ReturnKind;

private class DataFlowCallAlias = DataFlowCall;

private class ParameterPositionAlias = ParameterPosition;

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

  /** Holds if `p` is a parameter of `c` at the position `pos`. */
  predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
    p.getCfgNode().getAstNode() = pos.getParameterIn(c.asCfgScope().(Callable).getParamList())
  }

  /** Holds if `n` is an argument of `c` at the position `pos`. */
  predicate isArgumentNode(ArgumentNode n, DataFlowCall call, ArgumentPosition pos) {
    isArgumentForCall(n.getCfgNode(), call.asCallBaseExprCfgNode(), pos)
  }

  DataFlowCallable nodeGetEnclosingCallable(Node node) { result = node.getEnclosingCallable() }

  DataFlowType getNodeType(Node node) { any() }

  predicate nodeIsHidden(Node node) { node instanceof Node::SsaNode }

  class DataFlowExpr = ExprCfgNode;

  /** Gets the node corresponding to `e`. */
  Node exprNode(DataFlowExpr e) { result.asExpr() = e }

  final class DataFlowCall = DataFlowCallAlias;

  final class DataFlowCallable = DataFlowCallableAlias;

  final class ReturnKind = ReturnKindAlias;

  private import codeql.util.Option

  private class CrateOrigin extends string {
    CrateOrigin() {
      this = [any(Item i).getCrateOrigin(), any(Resolvable r).getResolvedCrateOrigin()]
    }
  }

  private class CrateOriginOption = Option<CrateOrigin>::Option;

  pragma[nomagic]
  private predicate hasExtendedCanonicalPath(
    DataFlowCallable c, CrateOriginOption crate, string path
  ) {
    exists(Item i |
      i = c.asCfgScope() and
      path = i.getExtendedCanonicalPath()
    |
      crate.asSome() = i.getCrateOrigin()
      or
      crate.isNone() and
      not i.hasCrateOrigin()
    )
  }

  pragma[nomagic]
  private predicate resolvesExtendedCanonicalPath(
    DataFlowCall c, CrateOriginOption crate, string path
  ) {
    exists(Resolvable r |
      path = r.getResolvedPath() and
      (
        r = c.asMethodCallExprCfgNode().getExpr()
        or
        r = c.asCallExprCfgNode().getFunction().(PathExprCfgNode).getPath()
      )
    |
      crate.asSome() = r.getResolvedCrateOrigin()
      or
      crate.isNone() and
      not r.hasResolvedCrateOrigin()
    )
  }

  /** Gets a viable implementation of the target of the given `Call`. */
  DataFlowCallable viableCallable(DataFlowCall call) {
    exists(string path, CrateOriginOption crate |
      hasExtendedCanonicalPath(result, crate, path) and
      resolvesExtendedCanonicalPath(call, crate, path)
    )
  }

  /**
   * Gets a node that can read the value returned from `call` with return kind
   * `kind`.
   */
  OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
    call = result.getCall() and exists(kind)
  }

  // NOTE: For now we use the type `Unit` and do not benefit from type
  // information in the data flow analysis.
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

  class ParameterPosition = ParameterPositionAlias;

  class ArgumentPosition = ParameterPosition;

  /**
   * Holds if the parameter position `ppos` matches the argument position
   * `apos`.
   */
  predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) { ppos = apos }

  /**
   * Holds if there is a simple local flow step from `node1` to `node2`. These
   * are the value-preserving intra-callable flow steps.
   */
  predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo, string model) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo) and
    model = ""
  }

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
    TParameterNode(ParamBaseCfgNode p) or
    TPatNode(PatCfgNode p) or
    TArgumentPostUpdateNode(ExprCfgNode e) { isArgumentForCall(e, _, _) } or
    TSsaNode(SsaImpl::DataFlowIntegration::SsaNode node)

  cached
  newtype TDataFlowCall = TCall(CallExprBaseCfgNode c)

  cached
  newtype TOptionalContentSet =
    TAnyElementContent() or
    TAnyContent()

  cached
  class TContentSet = TAnyElementContent or TAnyContent;

  cached
  newtype TDataFlowCallable = TCfgScope(CfgScope scope)

  /** This is the local flow predicate that is exposed. */
  cached
  predicate localFlowStepImpl(Node::Node nodeFrom, Node::Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
  }

  cached
  newtype TParameterPosition =
    TPositionalParameterPosition(int i) {
      i in [0 .. max([any(ParamList l).getNumberOfParams(), any(ArgList l).getNumberOfArgs()]) - 1]
    } or
    TSelfParameterPosition()
}

import Cached
