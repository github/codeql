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
private import codeql.rust.internal.typeinference.TypeInference as TypeInference
private import codeql.rust.internal.typeinference.DerefChain
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
  abstract predicate isParameterOf(DataFlowCallable c, RustDataFlow::ParameterPosition pos);
}

final class SourceParameterNode extends AstNodeNode, ParameterNode, TSourceParameterNode {
  override ParamBase n;

  SourceParameterNode() { this = TSourceParameterNode(n) }

  override predicate isParameterOf(DataFlowCallable c, RustDataFlow::ParameterPosition pos) {
    n = pos.getParameterIn(c.asCfgScope().(Callable).getParamList())
  }

  /** Get the parameter position of this parameter. */
  RustDataFlow::ParameterPosition getPosition() { this.isParameterOf(_, result) }

  /** Gets the parameter in the CFG that this node corresponds to. */
  ParamBase getParameter() { result = n }
}

/** A parameter for a library callable with a flow summary. */
final class SummaryParameterNode extends ParameterNode, FlowSummaryNode {
  private RustDataFlow::ParameterPosition pos_;

  SummaryParameterNode() {
    FlowSummaryImpl::Private::summaryParameterNode(this.getSummaryNode(), pos_)
  }

  override predicate isParameterOf(DataFlowCallable c, RustDataFlow::ParameterPosition pos) {
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

  override predicate isParameterOf(DataFlowCallable c, RustDataFlow::ParameterPosition pos) {
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

  ExprArgumentNode() {
    isArgumentForCall(n, call_, pos_) and
    not TypeInference::implicitDerefChainBorrow(n, _, _)
  }

  override predicate isArgumentOf(DataFlowCall call, RustDataFlow::ArgumentPosition pos) {
    call.asCall() = call_ and pos = pos_
  }
}

private newtype TImplicitDerefNodeState =
  TImplicitDerefNodeAfterBorrowState() or
  TImplicitDerefNodeBeforeDerefState() or
  TImplicitDerefNodeAfterDerefState()

/**
 * A state used to represent the flow steps involved in implicit dereferencing.
 *
 * For example, if there is an implicit dereference in a call like `x.m()`,
 * then that desugars into `(*Deref::deref(&x)).m()`, and
 *
 * - `TImplicitDerefNodeAfterBorrowState` represents the `&x` part,
 * - `TImplicitDerefNodeBeforeDerefState` represents the `Deref::deref(&x)` part, and
 * - `TImplicitDerefNodeAfterDerefState` represents the entire `*Deref::deref(&x)` part.
 *
 * When the targeted `deref` function is from `impl<T> Deref for &(mut) T`, we optimize
 * away the call, skipping the `TImplicitDerefNodeAfterBorrowState` state, and instead
 * add a local step directly from `x` to the `TImplicitDerefNodeBeforeDerefState` state.
 */
class ImplicitDerefNodeState extends TImplicitDerefNodeState {
  string toString() {
    this = TImplicitDerefNodeAfterBorrowState() and result = "after borrow"
    or
    this = TImplicitDerefNodeBeforeDerefState() and result = "before deref"
    or
    this = TImplicitDerefNodeAfterDerefState() and result = "after deref"
  }
}

/**
 * A node used to represent implicit dereferencing or borrowing.
 */
abstract class ImplicitDerefBorrowNode extends Node {
  /**
   * Gets the node that should be the predecessor in a reference store-step into this
   * node, if any.
   */
  abstract Node getBorrowInputNode();

  abstract Expr getExpr();

  override CfgScope getCfgScope() { result = this.getExpr().getEnclosingCfgScope() }

  override Location getLocation() { result = this.getExpr().getLocation() }
}

/**
 * A node used to represent implicit dereferencing.
 *
 * Each node is tagged with its position in a `DerefChain` and the
 * `ImplicitDerefNodeState` state that the corresponding implicit deference
 * is in.
 */
class ImplicitDerefNode extends ImplicitDerefBorrowNode, TImplicitDerefNode {
  Expr e;
  DerefChain derefChain;
  ImplicitDerefNodeState state;
  int i;

  ImplicitDerefNode() { this = TImplicitDerefNode(e, derefChain, state, i, false) }

  override Expr getExpr() { result = e }

  private predicate isBuiltinDeref() { derefChain.isBuiltinDeref(i) }

  private Node getInputNode() {
    // The first implicit deref has the underlying AST node as input
    i = 0 and
    result.asExpr() = e
    or
    // Subsequent implicit derefs have the previous implicit deref as input
    result = TImplicitDerefNode(e, derefChain, TImplicitDerefNodeAfterDerefState(), i - 1, false)
  }

  /**
   * Gets the node that should be the predecessor in a local flow step into this
   * node, if any.
   */
  Node getLocalInputNode() {
    this.isBuiltinDeref() and
    state = TImplicitDerefNodeBeforeDerefState() and
    result = this.getInputNode()
  }

  override Node getBorrowInputNode() {
    not this.isBuiltinDeref() and
    state = TImplicitDerefNodeAfterBorrowState() and
    result = this.getInputNode()
  }

  /**
   * Gets the node that should be the successor in a reference read-step out of this
   * node, if any.
   */
  Node getDerefOutputNode() {
    state = TImplicitDerefNodeBeforeDerefState() and
    result = TImplicitDerefNode(e, derefChain, TImplicitDerefNodeAfterDerefState(), i, false)
  }

  /**
   * Holds if this node represents the last implicit deref in the underlying chain.
   */
  predicate isLast(Expr expr) {
    expr = e and
    state = TImplicitDerefNodeAfterDerefState() and
    i = derefChain.length() - 1
  }

  override string toString() { result = e + " [implicit deref " + i + " in state " + state + "]" }
}

final class ImplicitDerefArgNode extends ImplicitDerefNode, ArgumentNode {
  private DataFlowCall call_;
  private RustDataFlow::ArgumentPosition pos_;

  ImplicitDerefArgNode() {
    not derefChain.isBuiltinDeref(i) and
    state = TImplicitDerefNodeAfterBorrowState() and
    call_.isImplicitDerefCall(e, derefChain, i, _) and
    pos_.isSelf()
    or
    this.isLast(_) and
    TypeInference::implicitDerefChainBorrow(e, derefChain, false) and
    isArgumentForCall(e, call_.asCall(), pos_)
  }

  override predicate isArgumentOf(DataFlowCall call, RustDataFlow::ArgumentPosition pos) {
    call = call_ and pos = pos_
  }
}

private class ImplicitDerefOutNode extends ImplicitDerefNode, OutNode {
  private DataFlowCall call;

  ImplicitDerefOutNode() {
    not derefChain.isBuiltinDeref(i) and
    state = TImplicitDerefNodeBeforeDerefState()
  }

  override DataFlowCall getCall(ReturnKind kind) {
    result.isImplicitDerefCall(e, derefChain, i, _) and
    kind = TNormalReturnKind()
  }
}

/**
 * A node that represents the value of an expression _after_ implicit borrowing.
 */
class ImplicitBorrowNode extends ImplicitDerefBorrowNode, TImplicitBorrowNode {
  Expr e;
  DerefChain derefChain;

  ImplicitBorrowNode() { this = TImplicitBorrowNode(e, derefChain, false) }

  override Expr getExpr() { result = e }

  override Node getBorrowInputNode() {
    result =
      TImplicitDerefNode(e, derefChain, TImplicitDerefNodeAfterDerefState(),
        derefChain.length() - 1, false)
    or
    derefChain.isEmpty() and
    result.(AstNodeNode).getAstNode() = e
  }

  override string toString() { result = e + " [implicit borrow]" }
}

final class ImplicitBorrowArgNode extends ImplicitBorrowNode, ArgumentNode {
  private DataFlowCall call_;
  private RustDataFlow::ArgumentPosition pos_;

  ImplicitBorrowArgNode() { isArgumentForCall(e, call_.asCall(), pos_) }

  override predicate isArgumentOf(DataFlowCall call, RustDataFlow::ArgumentPosition pos) {
    call = call_ and pos = pos_
  }
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
  private Call call_;

  ClosureArgumentNode() { lambdaCallExpr(call_, _, this.asExpr()) }

  override predicate isArgumentOf(DataFlowCall call, RustDataFlow::ArgumentPosition pos) {
    call.asCall() = call_ and pos.isClosureSelf()
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
  ExprOutNode() {
    exists(Call call |
      call = this.asExpr() and
      not call instanceof DerefExpr and // Handled by `DerefOutNode`
      not call instanceof IndexExpr // Handled by `IndexOutNode`
    )
  }

  /** Gets the underlying call node that includes this out node. */
  override DataFlowCall getCall(ReturnKind kind) {
    result.asCall() = n and
    kind = TNormalReturnKind()
  }
}

/**
 * A node that represents the value of a `*` expression _before_ implicit
 * dereferencing:
 *
 * `*v` equivalent to `*Deref::deref(&v)`, and this node represents the
 * `Deref::deref(&v)` part.
 */
class DerefOutNode extends OutNode, TDerefOutNode {
  DerefExpr de;

  DerefOutNode() { this = TDerefOutNode(de, false) }

  DerefExpr getDerefExpr() { result = de }

  override CfgScope getCfgScope() { result = de.getEnclosingCfgScope() }

  override DataFlowCall getCall(ReturnKind kind) {
    result.asCall() = de and
    kind = TNormalReturnKind()
  }

  override Location getLocation() { result = de.getLocation() }

  override string toString() { result = de.toString() + " [pre-dereferenced]" }
}

/**
 * A node that represents the value of a `x[y]` expression _before_ implicit
 * dereferencing:
 *
 * `x[y]` equivalent to `*x.index(y)`, and this node represents the
 * `x.index(y)` part.
 */
class IndexOutNode extends OutNode, TIndexOutNode {
  IndexExpr ie;

  IndexOutNode() { this = TIndexOutNode(ie, false) }

  IndexExpr getIndexExpr() { result = ie }

  override CfgScope getCfgScope() { result = ie.getEnclosingCfgScope() }

  override DataFlowCall getCall(ReturnKind kind) {
    result.asCall() = ie and
    kind = TNormalReturnKind()
  }

  override Location getLocation() { result = ie.getLocation() }

  override string toString() { result = ie.toString() + " [pre-dereferenced]" }
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

final class ImplicitDerefPostUpdateNode extends PostUpdateNode, TImplicitDerefNode {
  AstNode n;
  DerefChain derefChain;
  ImplicitDerefNodeState state;
  int i;

  ImplicitDerefPostUpdateNode() { this = TImplicitDerefNode(n, derefChain, state, i, true) }

  override ImplicitDerefNode getPreUpdateNode() {
    result = TImplicitDerefNode(n, derefChain, state, i, false)
  }

  override CfgScope getCfgScope() { result = n.getEnclosingCfgScope() }

  override Location getLocation() { result = n.getLocation() }
}

final class ImplicitBorrowPostUpdateNode extends PostUpdateNode, TImplicitBorrowNode {
  AstNode n;
  DerefChain derefChain;

  ImplicitBorrowPostUpdateNode() { this = TImplicitBorrowNode(n, derefChain, true) }

  override ImplicitBorrowNode getPreUpdateNode() {
    result = TImplicitBorrowNode(n, derefChain, false)
  }

  override CfgScope getCfgScope() { result = n.getEnclosingCfgScope() }

  override Location getLocation() { result = n.getLocation() }
}

class DerefOutPostUpdateNode extends PostUpdateNode, TDerefOutNode {
  DerefExpr de;

  DerefOutPostUpdateNode() { this = TDerefOutNode(de, true) }

  override DerefOutNode getPreUpdateNode() { result = TDerefOutNode(de, false) }

  override CfgScope getCfgScope() { result = de.getEnclosingCfgScope() }

  override Location getLocation() { result = de.getLocation() }
}

class IndexOutPostUpdateNode extends PostUpdateNode, TIndexOutNode {
  IndexExpr ie;

  IndexOutPostUpdateNode() { this = TIndexOutNode(ie, true) }

  override IndexOutNode getPreUpdateNode() { result = TIndexOutNode(ie, false) }

  override CfgScope getCfgScope() { result = ie.getEnclosingCfgScope() }

  override Location getLocation() { result = ie.getLocation() }
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
      isArgumentForCall(e, _, _) and
      // For compound assignments into variables like `x += y`, we do not want flow into
      // `[post] x`, as that would create spurious flow when `x` is a parameter.
      not (e = any(CompoundAssignmentExpr cae).getLhs() and e instanceof VariableAccess)
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
          any(FieldExpr access).getContainer(), //
          any(TryExpr try).getExpr(), //
          any(AwaitExpr a).getExpr(), //
          getPostUpdateReverseStep(any(PostUpdateNode n).getPreUpdateNode().asExpr(), _)
        ]
    )
  } or
  TImplicitDerefNode(
    Expr e, DerefChain derefChain, ImplicitDerefNodeState state, int i, Boolean isPost
  ) {
    e.hasEnclosingCfgScope() and
    TypeInference::implicitDerefChainBorrow(e, derefChain, _) and
    i in [0 .. derefChain.length() - 1]
  } or
  TImplicitBorrowNode(Expr e, DerefChain derefChain, Boolean isPost) {
    e.hasEnclosingCfgScope() and
    TypeInference::implicitDerefChainBorrow(e, derefChain, true)
  } or
  TDerefOutNode(DerefExpr de, Boolean isPost) or
  TIndexOutNode(IndexExpr ie, Boolean isPost) or
  TSsaNode(SsaImpl::DataFlowIntegration::SsaNode node) or
  TFlowSummaryNode(FlowSummaryImpl::Private::SummaryNode sn) {
    forall(AstNode n | n = sn.getSinkElement() or n = sn.getSourceElement() |
      n.hasEnclosingCfgScope()
    )
  } or
  TClosureSelfReferenceNode(CfgScope c) { lambdaCreationExpr(c) } or
  TCaptureNode(VariableCapture::Flow::SynthesizedCaptureNode cn)
