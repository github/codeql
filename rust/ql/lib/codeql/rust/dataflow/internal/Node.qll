/**
 * Provides the `Node` class and subclasses thereof.
 *
 * Classes with names ending in `Public` are exposed as `final` aliases in the
 * public `DataFlow` API, so they should not expose internal implementation details.
 */

private import codeql.util.Boolean
private import codeql.dataflow.DataFlow
private import codeql.dataflow.internal.DataFlowImpl
private import rust
private import SsaImpl as SsaImpl
private import codeql.rust.controlflow.ControlFlowGraph
private import codeql.rust.controlflow.CfgNodes
private import codeql.rust.dataflow.Ssa
private import codeql.rust.dataflow.FlowSummary
private import Node as Node
private import DataFlowImpl
private import FlowSummaryImpl as FlowSummaryImpl
private import codeql.rust.internal.CachedStages

/** An element, viewed as a node in a data flow graph. */
// It is important to not make this class `abstract`, as it otherwise results in
// a needless charpred, which will result in recomputation of internal non-cached
// predicates
class NodePublic extends TNode {
  /** Gets the location of this node. */
  cached
  abstract Location getLocation();

  /** Gets a textual representation of this node. */
  cached
  abstract string toString();

  /**
   * Gets the expression that corresponds to this node, if any.
   */
  final Expr asExpr() { this = TExprNode(result) }

  /**
   * Gets the parameter that corresponds to this node, if any.
   */
  ParamBase asParameter() { result = this.(SourceParameterNode).getParameter() }

  /**
   * Gets the pattern that corresponds to this node, if any.
   */
  final Pat asPat() { this = TPatNode(result) }
}

abstract class Node extends NodePublic {
  /** Gets the enclosing callable. */
  DataFlowCallable getEnclosingCallable() { result.asCfgScope() = this.getCfgScope() }

  /** Do not call: use `getEnclosingCallable()` instead. */
  abstract CfgScope getCfgScope();

  /**
   * Gets the AST node that corresponds to this data flow node, if any.
   */
  AstNode getAstNode() { none() }
}

/** A data flow node used to model flow summaries. */
class FlowSummaryNode extends Node, TFlowSummaryNode {
  FlowSummaryImpl::Private::SummaryNode getSummaryNode() { this = TFlowSummaryNode(result) }

  /** Gets the summarized callable that this node belongs to, if any. */
  FlowSummaryImpl::Public::SummarizedCallable getSummarizedCallable() {
    result = this.getSummaryNode().getSummarizedCallable()
  }

  /** Gets the AST source node that this node belongs to, if any */
  FlowSummaryImpl::Public::SourceElement getSourceElement() {
    result = this.getSummaryNode().getSourceElement()
  }

  /** Gets the AST sink node that this node belongs to, if any */
  FlowSummaryImpl::Public::SinkElement getSinkElement() {
    result = this.getSummaryNode().getSinkElement()
  }

  /** Holds is this node is a source node of kind `kind`. */
  predicate isSource(string kind, string model) {
    this.getSummaryNode().(FlowSummaryImpl::Private::SourceOutputNode).isEntry(kind, model)
  }

  /** Holds is this node is a sink node of kind `kind`. */
  predicate isSink(string kind, string model) {
    this.getSummaryNode().(FlowSummaryImpl::Private::SinkInputNode).isExit(kind, model)
  }

  override CfgScope getCfgScope() {
    result = this.getSummaryNode().getSourceElement().getEnclosingCfgScope()
    or
    result = this.getSummaryNode().getSinkElement().getEnclosingCfgScope()
  }

  override DataFlowCallable getEnclosingCallable() {
    result.asCfgScope() = this.getCfgScope()
    or
    result.asSummarizedCallable() = this.getSummarizedCallable()
  }

  override Location getLocation() {
    Stages::DataFlowStage::ref() and
    exists(this.getSummarizedCallable()) and
    result instanceof EmptyLocation
    or
    result = this.getSourceElement().getLocation()
    or
    result = this.getSinkElement().getLocation()
  }

  override string toString() {
    Stages::DataFlowStage::ref() and
    result = this.getSummaryNode().toString()
  }
}

/** A data flow node that corresponds directly to an AST node. */
abstract class AstNodeNode extends Node {
  AstNode n;

  final override AstNode getAstNode() { result = n }

  final override CfgScope getCfgScope() { result = n.getEnclosingCfgScope() }

  final override Location getLocation() { result = n.getLocation() }

  final override string toString() { result = n.toString() }
}

/**
 * A node in the data flow graph that corresponds to an expression in the
 * AST.
 *
 * Note that because of control flow splitting, one `Expr` may correspond
 * to multiple `ExprNode`s, just like it may correspond to multiple
 * `ControlFlow::Node`s.
 */
class ExprNode extends AstNodeNode, TExprNode {
  override Expr n;

  ExprNode() { this = TExprNode(n) }
}

final class PatNode extends AstNodeNode, TPatNode {
  override Pat n;

  PatNode() { this = TPatNode(n) }
}

/** A data flow node that corresponds to a name node in the CFG. */
final class NameNode extends AstNodeNode, TNameNode {
  override Name n;

  NameNode() { this = TNameNode(n) }

  Name getName() { result = n }
}

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph.
 */
abstract class ParameterNode extends Node {
  /** Holds if this node is a parameter of `c` at position `pos`. */
  abstract predicate isParameterOf(DataFlowCallable c, ParameterPosition pos);
}

final class SourceParameterNode extends AstNodeNode, ParameterNode, TSourceParameterNode {
  override ParamBase n;

  SourceParameterNode() { this = TSourceParameterNode(n) }

  override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
    n = pos.getParameterIn(c.asCfgScope().(Callable).getParamList())
  }

  /** Get the parameter position of this parameter. */
  ParameterPosition getPosition() { this.isParameterOf(_, result) }

  /** Gets the parameter in the CFG that this node corresponds to. */
  ParamBase getParameter() { result = n }
}

/** A parameter for a library callable with a flow summary. */
final class SummaryParameterNode extends ParameterNode, FlowSummaryNode {
  private ParameterPosition pos_;

  SummaryParameterNode() {
    FlowSummaryImpl::Private::summaryParameterNode(this.getSummaryNode(), pos_)
  }

  override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
    this.getSummarizedCallable() = c.asSummarizedCallable() and pos = pos_
  }
}

/**
 * The run-time representation of a closure itself at function entry, viewed
 * as a node in a data flow graph.
 */
final class ClosureParameterNode extends ParameterNode, TClosureSelfReferenceNode {
  private CfgScope cfgScope;

  ClosureParameterNode() { this = TClosureSelfReferenceNode(cfgScope) }

  final override CfgScope getCfgScope() { result = cfgScope }

  override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
    cfgScope = c.asCfgScope() and pos.isClosureSelf()
  }

  override Location getLocation() { result = cfgScope.getLocation() }

  override string toString() { result = "closure self in " + cfgScope }
}

abstract class ArgumentNode extends Node {
  abstract predicate isArgumentOf(DataFlowCall call, RustDataFlow::ArgumentPosition pos);
}

final class ExprArgumentNode extends ArgumentNode, ExprNode {
  private Call call_;
  private RustDataFlow::ArgumentPosition pos_;

  ExprArgumentNode() { isArgumentForCall(n, call_, pos_) }

  override predicate isArgumentOf(DataFlowCall call, RustDataFlow::ArgumentPosition pos) {
    call.asCall() = call_ and pos = pos_
  }
}

/**
 * The receiver of a method call _after_ any implicit borrow or dereferencing
 * has taken place.
 */
final class ReceiverNode extends ArgumentNode, TReceiverNode {
  private Call n;

  ReceiverNode() { this = TReceiverNode(n, false) }

  Expr getReceiver() { result = n.getReceiver() }

  MethodCallExpr getMethodCall() { result = n }

  override predicate isArgumentOf(DataFlowCall call, RustDataFlow::ArgumentPosition pos) {
    call.asCall() = n and pos = TSelfParameterPosition()
  }

  override CfgScope getCfgScope() { result = n.getEnclosingCfgScope() }

  override Location getLocation() { result = this.getReceiver().getLocation() }

  override string toString() { result = "receiver for " + this.getReceiver() }
}

final class SummaryArgumentNode extends FlowSummaryNode, ArgumentNode {
  private FlowSummaryImpl::Private::SummaryNode receiver;
  private RustDataFlow::ArgumentPosition pos_;

  SummaryArgumentNode() {
    FlowSummaryImpl::Private::summaryArgumentNode(receiver, this.getSummaryNode(), pos_)
  }

  override predicate isArgumentOf(DataFlowCall call, RustDataFlow::ArgumentPosition pos) {
    call.isSummaryCall(_, receiver) and pos = pos_
  }
}

/**
 * A data flow node that represents the run-time representation of a closure
 * passed into the closure body at an invocation.
 */
final class ClosureArgumentNode extends ArgumentNode, ExprNode {
  private CallExpr call_;

  ClosureArgumentNode() { lambdaCallExpr(call_, _, this.asExpr()) }

  override predicate isArgumentOf(DataFlowCall call, RustDataFlow::ArgumentPosition pos) {
    call.asCall() = call_ and
    pos.isClosureSelf()
  }
}

/** An SSA node. */
class SsaNode extends Node, TSsaNode {
  SsaImpl::DataFlowIntegration::SsaNode node;

  SsaNode() { this = TSsaNode(node) }

  override CfgScope getCfgScope() { result = node.getBasicBlock().getScope() }

  /** Gets the definition this node corresponds to, if any. */
  SsaImpl::Definition asDefinition() {
    result = node.(SsaImpl::DataFlowIntegration::SsaDefinitionNode).getDefinition()
  }

  override Location getLocation() { result = node.getLocation() }

  override string toString() { result = "[SSA] " + node.toString() }
}

/** A data flow node that represents a value returned by a callable. */
abstract class ReturnNode extends Node {
  abstract ReturnKind getKind();
}

final class ExprReturnNode extends ExprNode, ReturnNode {
  ExprReturnNode() { n.getACfgNode().getASuccessor() instanceof AnnotatedExitCfgNode }

  override ReturnKind getKind() { result = TNormalReturnKind() }
}

final class SummaryReturnNode extends FlowSummaryNode, ReturnNode {
  private ReturnKind rk;

  SummaryReturnNode() { FlowSummaryImpl::Private::summaryReturnNode(this.getSummaryNode(), rk) }

  override ReturnKind getKind() { result = rk }
}

/** A data flow node that represents the output of a call. */
abstract class OutNode extends Node {
  /** Gets the underlying call for this node. */
  abstract DataFlowCall getCall(ReturnKind kind);
}

final private class ExprOutNode extends ExprNode, OutNode {
  ExprOutNode() { this.asExpr() instanceof Call }

  /** Gets the underlying call CFG node that includes this out node. */
  override DataFlowCall getCall(ReturnKind kind) {
    result.asCall() = n and
    kind = TNormalReturnKind()
  }
}

final class SummaryOutNode extends FlowSummaryNode, OutNode {
  private DataFlowCall call;
  private ReturnKind kind_;

  SummaryOutNode() {
    exists(FlowSummaryImpl::Private::SummaryNode receiver |
      call.isSummaryCall(_, receiver) and
      FlowSummaryImpl::Private::summaryOutNode(receiver, this.getSummaryNode(), kind_)
    )
  }

  override DataFlowCall getCall(ReturnKind kind) { result = call and kind = kind_ }
}

/**
 * A synthesized data flow node representing a closure object that tracks
 * captured variables.
 */
class CaptureNode extends Node, TCaptureNode {
  private VariableCapture::Flow::SynthesizedCaptureNode cn;

  CaptureNode() { this = TCaptureNode(cn) }

  VariableCapture::Flow::SynthesizedCaptureNode getSynthesizedCaptureNode() { result = cn }

  override CfgScope getCfgScope() { result = cn.getEnclosingCallable() }

  override Location getLocation() { result = cn.getLocation() }

  override string toString() { result = cn.toString() }
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
abstract class PostUpdateNodePublic extends NodePublic {
  /** Gets the node before the state update. */
  abstract NodePublic getPreUpdateNode();
}

abstract class PostUpdateNode extends PostUpdateNodePublic, Node {
  override string toString() { result = "[post] " + this.getPreUpdateNode().toString() }
}

final class ExprPostUpdateNode extends PostUpdateNode, TExprPostUpdateNode {
  private Expr e;

  ExprPostUpdateNode() { this = TExprPostUpdateNode(e) }

  override Node getPreUpdateNode() { result = TExprNode(e) }

  override CfgScope getCfgScope() { result = e.getEnclosingCfgScope() }

  override Location getLocation() { result = e.getLocation() }
}

final class ReceiverPostUpdateNode extends PostUpdateNode, TReceiverNode {
  private Call call;

  ReceiverPostUpdateNode() { this = TReceiverNode(call, true) }

  override Node getPreUpdateNode() { result = TReceiverNode(call, false) }

  override CfgScope getCfgScope() { result = call.getEnclosingCfgScope() }

  override Location getLocation() { result = call.getReceiver().getLocation() }
}

final class SummaryPostUpdateNode extends FlowSummaryNode, PostUpdateNode {
  private FlowSummaryNode pre;

  SummaryPostUpdateNode() {
    FlowSummaryImpl::Private::summaryPostUpdateNode(this.getSummaryNode(), pre.getSummaryNode())
  }

  override Node getPreUpdateNode() { result = pre }

  final override string toString() { result = PostUpdateNode.super.toString() }
}

private class CapturePostUpdateNode extends PostUpdateNode, CaptureNode {
  private CaptureNode pre;

  CapturePostUpdateNode() {
    VariableCapture::Flow::capturePostUpdateNode(this.getSynthesizedCaptureNode(),
      pre.getSynthesizedCaptureNode())
  }

  override Node getPreUpdateNode() { result = pre }

  final override string toString() { result = PostUpdateNode.super.toString() }
}

final class CastNode extends ExprNode {
  CastNode() { none() }
}

cached
newtype TNode =
  TExprNode(Expr e) { e.hasEnclosingCfgScope() and Stages::DataFlowStage::ref() } or
  TSourceParameterNode(ParamBase p) { p.hasEnclosingCfgScope() } or
  TPatNode(Pat p) { p.hasEnclosingCfgScope() } or
  TNameNode(Name n) { n = any(Variable v).getName() and n.hasEnclosingCfgScope() } or
  TExprPostUpdateNode(Expr e) {
    e.hasEnclosingCfgScope() and
    (
      isArgumentForCall(e, _, _)
      or
      lambdaCallExpr(_, _, e)
      or
      lambdaCreationExpr(e)
      or
      // Whenever `&mut e` has a post-update node we also create one for `e`.
      // E.g., for `e` in `f(..., &mut e, ...)` or `*(&mut e) = ...`.
      e = any(RefExpr ref | ref.isMut() and exists(TExprPostUpdateNode(ref))).getExpr()
      or
      e =
        [
          any(IndexExpr i).getBase(), //
          any(FieldExpr access).getContainer(), //
          any(TryExpr try).getExpr(), //
          any(PrefixExpr pe | pe.getOperatorName() = "*").getExpr(), //
          any(AwaitExpr a).getExpr(), //
          any(MethodCallExpr mc).getReceiver(), //
          getPostUpdateReverseStep(any(PostUpdateNode n).getPreUpdateNode().asExpr(), _)
        ]
    )
  } or
  TReceiverNode(Call call, Boolean isPost) {
    call.hasEnclosingCfgScope() and
    call.receiverImplicitlyBorrowed() and
    // TODO: Handle index expressions as calls in data flow.
    not call instanceof IndexExpr
  } or
  TSsaNode(SsaImpl::DataFlowIntegration::SsaNode node) or
  TFlowSummaryNode(FlowSummaryImpl::Private::SummaryNode sn) {
    forall(AstNode n | n = sn.getSinkElement() or n = sn.getSourceElement() |
      n.hasEnclosingCfgScope()
    )
  } or
  TClosureSelfReferenceNode(CfgScope c) { lambdaCreationExpr(c) } or
  TCaptureNode(VariableCapture::Flow::SynthesizedCaptureNode cn)
