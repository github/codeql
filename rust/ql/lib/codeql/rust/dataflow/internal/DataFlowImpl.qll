/**
 * Provides Rust-specific definitions for use in the data flow library.
 */

private import codeql.util.Void
private import codeql.util.Unit
private import codeql.util.Boolean
private import codeql.dataflow.DataFlow
private import codeql.dataflow.internal.DataFlowImpl
private import rust
private import SsaImpl as SsaImpl
private import codeql.rust.controlflow.internal.Scope as Scope
private import codeql.rust.internal.PathResolution
private import codeql.rust.controlflow.ControlFlowGraph
private import codeql.rust.controlflow.CfgNodes
private import codeql.rust.dataflow.Ssa
private import codeql.rust.dataflow.FlowSummary
private import FlowSummaryImpl as FlowSummaryImpl

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

  /**
   * Gets the underlying library callable, if any.
   */
  LibraryCallable asLibraryCallable() { this = TLibraryCallable(result) }

  /** Gets a textual representation of this callable. */
  string toString() { result = [this.asCfgScope().toString(), this.asLibraryCallable().toString()] }

  /** Gets the location of this callable. */
  Location getLocation() { result = this.asCfgScope().getLocation() }
}

final class DataFlowCall extends TDataFlowCall {
  /** Gets the underlying call in the CFG, if any. */
  CallExprCfgNode asCallExprCfgNode() { result = this.asCallBaseExprCfgNode() }

  MethodCallExprCfgNode asMethodCallExprCfgNode() { result = this.asCallBaseExprCfgNode() }

  CallExprBaseCfgNode asCallBaseExprCfgNode() { this = TCall(result) }

  predicate isSummaryCall(
    FlowSummaryImpl::Public::SummarizedCallable c, FlowSummaryImpl::Private::SummaryNode receiver
  ) {
    this = TSummaryCall(c, receiver)
  }

  DataFlowCallable getEnclosingCallable() {
    result = TCfgScope(this.asCallBaseExprCfgNode().getExpr().getEnclosingCfgScope())
    or
    exists(FlowSummaryImpl::Public::SummarizedCallable c |
      this.isSummaryCall(c, _) and
      result = TLibraryCallable(c)
    )
  }

  string toString() {
    result = this.asCallBaseExprCfgNode().toString()
    or
    exists(
      FlowSummaryImpl::Public::SummarizedCallable c, FlowSummaryImpl::Private::SummaryNode receiver
    |
      this.isSummaryCall(c, receiver) and
      result = "[summary] call to " + receiver + " in " + c
    )
  }

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

  predicate hasPosition() { exists(this.getPosition()) }

  /** Holds if this position represents the `self` position. */
  predicate isSelf() { this = TSelfParameterPosition() }

  /**
   * Holds if this position represents a reference to a closure itself. Only
   * used for tracking flow through captured variables.
   */
  predicate isClosureSelf() { this = TClosureSelfParameterPosition() }

  /** Gets a textual representation of this position. */
  string toString() {
    result = this.getPosition().toString()
    or
    result = "self" and this.isSelf()
    or
    result = "closure self" and this.isClosureSelf()
  }

  ParamBase getParameterIn(ParamList ps) {
    result = ps.getParam(this.getPosition())
    or
    result = ps.getSelfParam() and this.isSelf()
  }
}

/** Holds if `call` invokes a qualified path that resolves to a method. */
private predicate callToMethod(CallExpr call) {
  exists(Path path |
    path = call.getFunction().(PathExpr).getPath() and
    path.hasQualifier() and
    resolvePath(path).(Function).getParamList().hasSelfParam()
  )
}

/**
 * Holds if `arg` is an argument of `call` at the position `pos`.
 *
 * Note that this does not hold for the receiever expression of a method call
 * as the synthetic `ReceiverNode` is the argument for the `self` parameter.
 */
private predicate isArgumentForCall(ExprCfgNode arg, CallExprBaseCfgNode call, ParameterPosition pos) {
  if callToMethod(call.(CallExprCfgNode).getCallExpr())
  then
    // The first argument is for the `self` parameter
    arg = call.getArgument(0) and pos.isSelf()
    or
    // Succeeding arguments are shifted left
    arg = call.getArgument(pos.getPosition() + 1)
  else arg = call.getArgument(pos.getPosition())
}

/**
 * Provides the `Node` class and subclasses thereof.
 *
 * Classes with names ending in `Public` are exposed as `final` aliases in the
 * public `DataFlow` API, so they should not expose internal implementation details.
 */
module Node {
  /** An element, viewed as a node in a data flow graph. */
  abstract class NodePublic extends TNode {
    /** Gets the location of this node. */
    abstract Location getLocation();

    /** Gets a textual representation of this node. */
    abstract string toString();

    /**
     * Gets the expression that corresponds to this node, if any.
     */
    ExprCfgNode asExpr() { none() }

    /**
     * Gets the parameter that corresponds to this node, if any.
     */
    ParamBase asParameter() { result = this.(SourceParameterNode).getParameter().getParamBase() }

    /**
     * Gets the pattern that corresponds to this node, if any.
     */
    PatCfgNode asPat() { none() }
  }

  abstract class Node extends NodePublic {
    /** Gets the enclosing callable. */
    DataFlowCallable getEnclosingCallable() { result = TCfgScope(this.getCfgScope()) }

    /** Do not call: use `getEnclosingCallable()` instead. */
    abstract CfgScope getCfgScope();

    /**
     * Gets the control flow node that corresponds to this data flow node.
     */
    CfgNode getCfgNode() { none() }
  }

  /** A node type that is not implemented. */
  final class NaNode extends Node {
    NaNode() { none() }

    override CfgScope getCfgScope() { none() }

    override string toString() { result = "N/A" }

    override Location getLocation() { none() }
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
      result.asLibraryCallable() = this.getSummarizedCallable()
      or
      result.asCfgScope() = this.getCfgScope()
    }

    override Location getLocation() {
      exists(this.getSummarizedCallable()) and
      result instanceof EmptyLocation
      or
      result = this.getSourceElement().getLocation()
      or
      result = this.getSinkElement().getLocation()
    }

    override string toString() { result = this.getSummaryNode().toString() }
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

    override PatCfgNode asPat() { result = n }
  }

  /** A data flow node that corresponds to a name node in the CFG. */
  final class NameNode extends AstCfgFlowNode, TNameNode {
    override NameCfgNode n;

    NameNode() { this = TNameNode(n) }

    NameCfgNode asName() { result = n }
  }

  /**
   * The value of a parameter at function entry, viewed as a node in a data
   * flow graph.
   */
  abstract class ParameterNode extends Node {
    /** Holds if this node is a parameter of `c` at position `pos`. */
    abstract predicate isParameterOf(DataFlowCallable c, ParameterPosition pos);
  }

  final class SourceParameterNode extends AstCfgFlowNode, ParameterNode, TSourceParameterNode {
    override ParamBaseCfgNode n;

    SourceParameterNode() { this = TSourceParameterNode(n) }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      n.getAstNode() = pos.getParameterIn(c.asCfgScope().(Callable).getParamList())
    }

    /** Get the parameter position of this parameter. */
    ParameterPosition getPosition() { this.isParameterOf(_, result) }

    /** Gets the parameter in the CFG that this node corresponds to. */
    ParamBaseCfgNode getParameter() { result = n }
  }

  /** A parameter for a library callable with a flow summary. */
  final class SummaryParameterNode extends ParameterNode, FlowSummaryNode {
    private ParameterPosition pos_;

    SummaryParameterNode() {
      FlowSummaryImpl::Private::summaryParameterNode(this.getSummaryNode(), pos_)
    }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      this.getSummarizedCallable() = c.asLibraryCallable() and pos = pos_
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
    private CallExprBaseCfgNode call_;
    private RustDataFlow::ArgumentPosition pos_;

    ExprArgumentNode() { isArgumentForCall(n, call_, pos_) }

    override predicate isArgumentOf(DataFlowCall call, RustDataFlow::ArgumentPosition pos) {
      call.asCallBaseExprCfgNode() = call_ and pos = pos_
    }
  }

  /**
   * The receiver of a method call _after_ any implicit borrow or dereferencing
   * has taken place.
   */
  final class ReceiverNode extends ArgumentNode, TReceiverNode {
    private MethodCallExprCfgNode n;

    ReceiverNode() { this = TReceiverNode(n, false) }

    ExprCfgNode getReceiver() { result = n.getReceiver() }

    MethodCallExprCfgNode getMethodCall() { result = n }

    override predicate isArgumentOf(DataFlowCall call, RustDataFlow::ArgumentPosition pos) {
      call.asMethodCallExprCfgNode() = n and pos = TSelfParameterPosition()
    }

    override CfgScope getCfgScope() { result = n.getAstNode().getEnclosingCfgScope() }

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
    private CallExprCfgNode call_;

    ClosureArgumentNode() { lambdaCallExpr(call_, _, this.asExpr()) }

    override predicate isArgumentOf(DataFlowCall call, RustDataFlow::ArgumentPosition pos) {
      call.asCallExprCfgNode() = call_ and
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
    ExprReturnNode() { this.getCfgNode().getASuccessor() instanceof AnnotatedExitCfgNode }

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
    ExprOutNode() { this.asExpr() instanceof CallExprBaseCfgNode }

    /** Gets the underlying call CFG node that includes this out node. */
    override DataFlowCall getCall(ReturnKind kind) {
      result.asCallBaseExprCfgNode() = this.getCfgNode() and
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
    private ExprCfgNode n;

    ExprPostUpdateNode() { this = TExprPostUpdateNode(n) }

    override Node getPreUpdateNode() { result = TExprNode(n) }

    override CfgScope getCfgScope() { result = n.getScope() }

    override Location getLocation() { result = n.getLocation() }
  }

  final class ReceiverPostUpdateNode extends PostUpdateNode, TReceiverNode {
    private MethodCallExprCfgNode n;

    ReceiverPostUpdateNode() { this = TReceiverNode(n, true) }

    override Node getPreUpdateNode() { result = TReceiverNode(n, false) }

    override CfgScope getCfgScope() { result = n.getAstNode().getEnclosingCfgScope() }

    override Location getLocation() { result = n.getReceiver().getLocation() }
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

  final class CastNode = NaNode;
}

final class Node = Node::Node;

/** Provides logic related to SSA. */
module SsaFlow {
  private module SsaFlow = SsaImpl::DataFlowIntegration;

  private Node::ParameterNode toParameterNode(ParamCfgNode p) {
    result.(Node::SourceParameterNode).getParameter() = p
  }

  /** Converts a control flow node into an SSA control flow node. */
  SsaFlow::Node asNode(Node n) {
    n = TSsaNode(result)
    or
    result.(SsaFlow::ExprNode).getExpr() = n.asExpr()
    or
    result.(SsaFlow::ExprPostUpdateNode).getExpr() =
      n.(Node::PostUpdateNode).getPreUpdateNode().asExpr()
    or
    n = toParameterNode(result.(SsaFlow::ParameterNode).getParameter())
  }

  predicate localFlowStep(
    SsaImpl::SsaInput::SourceVariable v, Node nodeFrom, Node nodeTo, boolean isUseStep
  ) {
    SsaFlow::localFlowStep(v, asNode(nodeFrom), asNode(nodeTo), isUseStep)
  }

  predicate localMustFlowStep(Node nodeFrom, Node nodeTo) {
    SsaFlow::localMustFlowStep(_, asNode(nodeFrom), asNode(nodeTo))
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
  result = e.(MacroExprCfgNode).getMacroCall().(MacroCallCfgNode).getExpandedNode() or
  result.(BreakExprCfgNode).getTarget() = e
}

module LocalFlow {
  predicate flowSummaryLocalStep(Node nodeFrom, Node nodeTo, string model) {
    exists(FlowSummaryImpl::Public::SummarizedCallable c |
      FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom
            .(Node::FlowSummaryNode)
            .getSummaryNode(), nodeTo.(Node::FlowSummaryNode).getSummaryNode(), true, model) and
      c = nodeFrom.(Node::FlowSummaryNode).getSummarizedCallable()
    )
    or
    FlowSummaryImpl::Private::Steps::sourceLocalStep(nodeFrom
          .(Node::FlowSummaryNode)
          .getSummaryNode(), nodeTo, model)
    or
    FlowSummaryImpl::Private::Steps::sinkLocalStep(nodeFrom,
      nodeTo.(Node::FlowSummaryNode).getSummaryNode(), model)
  }

  pragma[nomagic]
  predicate localFlowStepCommon(Node nodeFrom, Node nodeTo) {
    nodeFrom.getCfgNode() = getALastEvalNode(nodeTo.getCfgNode())
    or
    // An edge from the right-hand side of a let statement to the left-hand side.
    exists(LetStmtCfgNode s |
      nodeFrom.getCfgNode() = s.getInitializer() and
      nodeTo.getCfgNode() = s.getPat()
    )
    or
    exists(IdentPatCfgNode p |
      not p.isRef() and
      nodeFrom.getCfgNode() = p and
      nodeTo.getCfgNode() = p.getName()
    )
    or
    exists(SelfParamCfgNode self |
      nodeFrom.getCfgNode() = self and
      nodeTo.getCfgNode() = self.getName()
    )
    or
    // An edge from a pattern/expression to its corresponding SSA definition.
    nodeFrom.(Node::AstCfgFlowNode).getCfgNode() =
      nodeTo.(Node::SsaNode).asDefinition().(Ssa::WriteDefinition).getControlFlowNode()
    or
    nodeFrom.(Node::SourceParameterNode).getParameter().(ParamCfgNode).getPat() = nodeTo.asPat()
    or
    exists(AssignmentExprCfgNode a |
      a.getRhs() = nodeFrom.getCfgNode() and
      a.getLhs() = nodeTo.getCfgNode()
    )
    or
    exists(MatchExprCfgNode match |
      nodeFrom.asExpr() = match.getScrutinee() and
      nodeTo.asPat() = match.getArmPat(_)
    )
    or
    nodeFrom.asPat().(OrPatCfgNode).getAPat() = nodeTo.asPat()
    or
    // Simple value step from receiver expression to receiver node, in case
    // there is no implicit deref or borrow operation.
    nodeFrom.asExpr() = nodeTo.(Node::ReceiverNode).getReceiver()
    or
    // The dual step of the above, for the post-update nodes.
    nodeFrom.(Node::PostUpdateNode).getPreUpdateNode().(Node::ReceiverNode).getReceiver() =
      nodeTo.(Node::PostUpdateNode).getPreUpdateNode().asExpr()
  }
}

/**
 * Provides temporary modeling of built-in variants, for which no source code
 * `Item`s are available.
 *
 * TODO: Remove once library code is extracted.
 */
private module VariantInLib {
  private import codeql.util.Option

  private class CrateOrigin extends string {
    CrateOrigin() { this = any(Resolvable r).getResolvedCrateOrigin() }
  }

  private class CrateOriginOption = Option<CrateOrigin>::Option;

  private CrateOriginOption langCoreCrate() { result.asSome() = "lang:core" }

  private newtype TVariantInLib =
    MkVariantInLib(CrateOriginOption crate, string path, string name) {
      crate = langCoreCrate() and
      (
        path = "crate::option::Option" and
        name = "Some"
        or
        path = "crate::result::Result" and
        name = ["Ok", "Err"]
      )
    }

  /** An enum variant from library code, represented by the enum's canonical path and the variant's name. */
  class VariantInLib extends MkVariantInLib {
    CrateOriginOption crate;
    string path;
    string name;

    VariantInLib() { this = MkVariantInLib(crate, path, name) }

    int getAPosition() {
      this = MkVariantInLib(langCoreCrate(), "crate::option::Option", "Some") and
      result = 0
      or
      this = MkVariantInLib(langCoreCrate(), "crate::result::Result", ["Ok", "Err"]) and
      result = 0
    }

    string getExtendedCanonicalPath() { result = path + "::" + name }

    string toString() { result = name }
  }

  /** A tuple variant from library code. */
  class VariantInLibTupleFieldContent extends Content, TVariantInLibTupleFieldContent {
    private VariantInLib::VariantInLib v;
    private int pos_;

    VariantInLibTupleFieldContent() { this = TVariantInLibTupleFieldContent(v, pos_) }

    VariantInLib::VariantInLib getVariantInLib(int pos) { result = v and pos = pos_ }

    string getExtendedCanonicalPath() { result = v.getExtendedCanonicalPath() }

    int getPosition() { result = pos_ }

    final override string toString() {
      // only print indices when the arity is > 1
      if exists(TVariantInLibTupleFieldContent(v, 1))
      then result = v.toString() + "(" + pos_ + ")"
      else result = v.toString()
    }

    final override Location getLocation() { result instanceof EmptyLocation }
  }

  pragma[nomagic]
  private predicate resolveExtendedCanonicalPath(Resolvable r, CrateOriginOption crate, string path) {
    path = r.getResolvedPath() and
    (
      crate.asSome() = r.getResolvedCrateOrigin()
      or
      crate.isNone() and
      not r.hasResolvedCrateOrigin()
    )
  }

  /** Holds if path `p` resolves to variant `v`. */
  private predicate pathResolveToVariantInLib(PathAstNode p, VariantInLib v) {
    exists(CrateOriginOption crate, string path, string name |
      resolveExtendedCanonicalPath(p, pragma[only_bind_into](crate), path + "::" + name) and
      v = MkVariantInLib(pragma[only_bind_into](crate), path, name)
    )
  }

  /** Holds if `p` destructs an enum variant `v`. */
  pragma[nomagic]
  private predicate tupleVariantCanonicalDestruction(TupleStructPat p, VariantInLib v) {
    pathResolveToVariantInLib(p, v)
  }

  bindingset[pos]
  predicate tupleVariantCanonicalDestruction(
    TupleStructPat pat, VariantInLibTupleFieldContent c, int pos
  ) {
    tupleVariantCanonicalDestruction(pat, c.getVariantInLib(pos))
  }

  /** Holds if `ce` constructs an enum value of type `v`. */
  pragma[nomagic]
  private predicate tupleVariantCanonicalConstruction(CallExpr ce, VariantInLib v) {
    pathResolveToVariantInLib(ce.getFunction().(PathExpr), v)
  }

  bindingset[pos]
  predicate tupleVariantCanonicalConstruction(CallExpr ce, VariantInLibTupleFieldContent c, int pos) {
    tupleVariantCanonicalConstruction(ce, c.getVariantInLib(pos))
  }
}

class VariantInLibTupleFieldContent = VariantInLib::VariantInLibTupleFieldContent;

/**
 * A path to a value contained in an object. For example a field name of a struct.
 */
abstract class Content extends TContent {
  /** Gets a textual representation of this content. */
  abstract string toString();

  /** Gets the location of this content. */
  abstract Location getLocation();
}

/** A field belonging to either a variant or a struct. */
abstract class FieldContent extends Content {
  /** Gets an access to this field. */
  pragma[nomagic]
  abstract FieldExprCfgNode getAnAccess();
}

/** A tuple field belonging to either a variant or a struct. */
class TupleFieldContent extends FieldContent, TTupleFieldContent {
  private TupleField field;

  TupleFieldContent() { this = TTupleFieldContent(field) }

  predicate isVariantField(Variant v, int pos) { field.isVariantField(v, pos) }

  predicate isStructField(Struct s, int pos) { field.isStructField(s, pos) }

  override FieldExprCfgNode getAnAccess() { field = result.getFieldExpr().getTupleField() }

  final override string toString() {
    exists(Variant v, int pos, string vname |
      this.isVariantField(v, pos) and
      vname = v.getName().getText() and
      // only print indices when the arity is > 1
      if exists(v.getTupleField(1)) then result = vname + "(" + pos + ")" else result = vname
    )
    or
    exists(Struct s, int pos, string sname |
      this.isStructField(s, pos) and
      sname = s.getName().getText() and
      // only print indices when the arity is > 1
      if exists(s.getTupleField(1)) then result = sname + "(" + pos + ")" else result = sname
    )
  }

  final override Location getLocation() { result = field.getLocation() }
}

/** A record field belonging to either a variant or a struct. */
class RecordFieldContent extends FieldContent, TRecordFieldContent {
  private RecordField field;

  RecordFieldContent() { this = TRecordFieldContent(field) }

  predicate isVariantField(Variant v, string name) { field.isVariantField(v, name) }

  predicate isStructField(Struct s, string name) { field.isStructField(s, name) }

  override FieldExprCfgNode getAnAccess() { field = result.getFieldExpr().getRecordField() }

  final override string toString() {
    exists(Variant v, string name, string vname |
      this.isVariantField(v, name) and
      vname = v.getName().getText() and
      // only print field when the arity is > 1
      if strictcount(v.getRecordField(_)) > 1 then result = vname + "." + name else result = vname
    )
    or
    exists(Struct s, string name, string sname |
      this.isStructField(s, name) and
      sname = s.getName().getText() and
      // only print field when the arity is > 1
      if strictcount(s.getRecordField(_)) > 1 then result = sname + "." + name else result = sname
    )
  }

  final override Location getLocation() { result = field.getLocation() }
}

/** A captured variable. */
private class CapturedVariableContent extends Content, TCapturedVariableContent {
  private Variable v;

  CapturedVariableContent() { this = TCapturedVariableContent(v) }

  /** Gets the captured variable. */
  Variable getVariable() { result = v }

  override string toString() { result = "captured " + v }

  override Location getLocation() { result = v.getLocation() }
}

/** A value referred to by a reference. */
final class ReferenceContent extends Content, TReferenceContent {
  override string toString() { result = "&ref" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/**
 * An element in a collection where we do not track the specific collection
 * type nor the placement of the element in the collection. Therefore the
 * collection should be one where the elements are reasonably homogeneous,
 * i.e., if one is tainted all elements are considered tainted.
 *
 * Examples include the elements of a set, array, vector, or stack.
 */
final class ElementContent extends Content, TElementContent {
  override string toString() { result = "element" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/**
 * A value that a future resolves to.
 */
final class FutureContent extends Content, TFutureContent {
  override string toString() { result = "future" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/**
 * Content stored at a position in a tuple.
 *
 * NOTE: Unlike `struct`s and `enum`s tuples are structural and not nominal,
 * hence we don't store a canonical path for them.
 */
final class TuplePositionContent extends FieldContent, TTuplePositionContent {
  private int pos;

  TuplePositionContent() { this = TTuplePositionContent(pos) }

  int getPosition() { result = pos }

  override FieldExprCfgNode getAnAccess() {
    // TODO: limit to tuple types
    result.getNameRef().getText().toInt() = pos
  }

  override string toString() { result = "tuple." + pos.toString() }

  override Location getLocation() { result instanceof EmptyLocation }
}

/**
 * A content for the index of an argument to at function call.
 *
 * Used by the model generator to create flow summaries for higher-order
 * functions.
 */
final class FunctionCallArgumentContent extends Content, TFunctionCallArgumentContent {
  private int pos;

  FunctionCallArgumentContent() { this = TFunctionCallArgumentContent(pos) }

  int getPosition() { result = pos }

  override string toString() { result = "function argument at " + pos }

  override Location getLocation() { result instanceof EmptyLocation }
}

/**
 * A content for the return value of function call.
 *
 * Used by the model generator to create flow summaries for higher-order
 * functions.
 */
final class FunctionCallReturnContent extends Content, TFunctionCallReturnContent {
  override string toString() { result = "function return" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/** A value that represents a set of `Content`s. */
abstract class ContentSet extends TContentSet {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Gets a content that may be stored into when storing into this set. */
  abstract Content getAStoreContent();

  /** Gets a content that may be read from when reading from this set. */
  abstract Content getAReadContent();
}

final class SingletonContentSet extends ContentSet, TSingletonContentSet {
  private Content c;

  SingletonContentSet() { this = TSingletonContentSet(c) }

  Content getContent() { result = c }

  override string toString() { result = c.toString() }

  override Content getAStoreContent() { result = c }

  override Content getAReadContent() { result = c }
}

class LambdaCallKind = Unit;

/** Holds if `creation` is an expression that creates a lambda of kind `kind`. */
private predicate lambdaCreationExpr(Expr creation, LambdaCallKind kind) {
  (
    creation instanceof ClosureExpr
    or
    creation instanceof Scope::AsyncBlockScope
  ) and
  exists(kind)
}

/**
 * Holds if `call` is a lambda call of kind `kind` where `receiver` is the
 * invoked expression.
 */
predicate lambdaCallExpr(CallExprCfgNode call, LambdaCallKind kind, ExprCfgNode receiver) {
  receiver = call.getFunction() and
  // All calls to complex expressions and local variable accesses are lambda call.
  exists(Expr f | f = receiver.getExpr() |
    f instanceof PathExpr implies f = any(Variable v).getAnAccess()
  ) and
  exists(kind)
}

/** Holds if `mc` implicitly borrows its receiver. */
private predicate implicitBorrow(MethodCallExpr mc) {
  // Determining whether an implicit borrow happens depends on the type of the
  // receiever as well as the target. As a heuristic we simply check if the
  // target takes `self` as a borrow and limit the approximation to cases where
  // the receiver is a simple variable.
  mc.getReceiver() instanceof VariableAccess and
  mc.getStaticTarget().getParamList().getSelfParam().isRef()
}

/** Holds if `mc` implicitly dereferences its receiver. */
private predicate implicitDeref(MethodCallExpr mc) {
  // Similarly to `implicitBorrow` this is an approximation.
  mc.getReceiver() instanceof VariableAccess and
  not mc.getStaticTarget().getParamList().getSelfParam().isRef()
}

// Defines a set of aliases needed for the `RustDataFlow` module
private module Aliases {
  class DataFlowCallableAlias = DataFlowCallable;

  class ReturnKindAlias = ReturnKind;

  class DataFlowCallAlias = DataFlowCall;

  class ParameterPositionAlias = ParameterPosition;

  class ContentAlias = Content;

  class ContentSetAlias = ContentSet;

  class LambdaCallKindAlias = LambdaCallKind;
}

module RustDataFlow implements InputSig<Location> {
  private import Aliases
  private import codeql.rust.dataflow.DataFlow

  /**
   * An element, viewed as a node in a data flow graph. Either an expression
   * (`ExprNode`) or a parameter (`ParameterNode`).
   */
  class Node = DataFlow::Node;

  final class ParameterNode = Node::ParameterNode;

  final class ArgumentNode = Node::ArgumentNode;

  final class ReturnNode = Node::ReturnNode;

  final class OutNode = Node::OutNode;

  class PostUpdateNode = DataFlow::PostUpdateNode;

  final class CastNode = Node::NaNode;

  /** Holds if `p` is a parameter of `c` at the position `pos`. */
  predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
    p.isParameterOf(c, pos)
  }

  /** Holds if `n` is an argument of `c` at the position `pos`. */
  predicate isArgumentNode(ArgumentNode n, DataFlowCall call, ArgumentPosition pos) {
    n.isArgumentOf(call, pos)
  }

  DataFlowCallable nodeGetEnclosingCallable(Node node) {
    result = node.(Node::Node).getEnclosingCallable()
  }

  DataFlowType getNodeType(Node node) { any() }

  predicate nodeIsHidden(Node node) {
    node instanceof Node::SsaNode or
    node.(Node::FlowSummaryNode).getSummaryNode().isHidden() or
    node instanceof Node::CaptureNode or
    node instanceof Node::ClosureParameterNode or
    node instanceof Node::ReceiverNode or
    node instanceof Node::ReceiverPostUpdateNode
  }

  predicate neverSkipInPathGraph(Node node) {
    node.(Node::Node).getCfgNode() = any(LetStmtCfgNode s).getPat()
    or
    node.(Node::Node).getCfgNode() = any(AssignmentExprCfgNode a).getLhs()
    or
    exists(MatchExprCfgNode match |
      node.asExpr() = match.getScrutinee() or
      node.asExpr() = match.getArmPat(_)
    )
    or
    FlowSummaryImpl::Private::Steps::sourceLocalStep(_, node, _)
    or
    FlowSummaryImpl::Private::Steps::sinkLocalStep(node, _, _)
  }

  class DataFlowExpr = ExprCfgNode;

  /** Gets the node corresponding to `e`. */
  Node exprNode(DataFlowExpr e) { result.asExpr() = e }

  final class DataFlowCall = DataFlowCallAlias;

  final class DataFlowCallable = DataFlowCallableAlias;

  final class ReturnKind = ReturnKindAlias;

  /** Gets a viable implementation of the target of the given `Call`. */
  DataFlowCallable viableCallable(DataFlowCall call) {
    result.asCfgScope() = call.asCallBaseExprCfgNode().getCallExprBase().getStaticTarget()
    or
    result.asLibraryCallable().getACall() = call.asCallBaseExprCfgNode().getCallExprBase()
  }

  /**
   * Gets a node that can read the value returned from `call` with return kind
   * `kind`.
   */
  OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) { call = result.getCall(kind) }

  // NOTE: For now we use the type `Unit` and do not benefit from type
  // information in the data flow analysis.
  final class DataFlowType extends Unit {
    string toString() { result = "" }
  }

  predicate compatibleTypes(DataFlowType t1, DataFlowType t2) { any() }

  predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) { none() }

  class Content = ContentAlias;

  class ContentSet = ContentSetAlias;

  class LambdaCallKind = LambdaCallKindAlias;

  predicate forceHighPrecision(Content c) { none() }

  final class ContentApprox = Content; // TODO: Implement if needed

  ContentApprox getContentApprox(Content c) { result = c }

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
    (
      LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
      or
      exists(SsaImpl::SsaInput::SourceVariable v, boolean isUseStep |
        SsaFlow::localFlowStep(v, nodeFrom, nodeTo, isUseStep) and
        not v instanceof VariableCapture::CapturedVariable
      |
        isUseStep = false
        or
        isUseStep = true and
        not FlowSummaryImpl::Private::Steps::prohibitsUseUseFlow(nodeFrom, _)
      )
      or
      VariableCapture::localFlowStep(nodeFrom, nodeTo)
    ) and
    model = ""
    or
    LocalFlow::flowSummaryLocalStep(nodeFrom, nodeTo, model)
  }

  /**
   * Holds if data can flow from `node1` to `node2` through a non-local step
   * that does not follow a call edge. For example, a step through a global
   * variable.
   */
  predicate jumpStep(Node node1, Node node2) {
    FlowSummaryImpl::Private::Steps::summaryJumpStep(node1.(Node::FlowSummaryNode).getSummaryNode(),
      node2.(Node::FlowSummaryNode).getSummaryNode())
  }

  pragma[nomagic]
  private predicate implicitDerefToReceiver(Node node1, Node::ReceiverNode node2, ReferenceContent c) {
    node1.asExpr() = node2.getReceiver() and
    implicitDeref(node2.getMethodCall().getMethodCallExpr()) and
    exists(c)
  }

  pragma[nomagic]
  private predicate implicitBorrowToReceiver(
    Node node1, Node::ReceiverNode node2, ReferenceContent c
  ) {
    node1.asExpr() = node2.getReceiver() and
    implicitBorrow(node2.getMethodCall().getMethodCallExpr()) and
    exists(c)
  }

  pragma[nomagic]
  private predicate referenceExprToExpr(Node node1, Node node2, ReferenceContent c) {
    node1.asExpr() = node2.asExpr().(RefExprCfgNode).getExpr() and
    exists(c)
  }

  /**
   * Holds if data can flow from `node1` to `node2` via a read of `c`.  Thus,
   * `node1` references an object with a content `c.getAReadContent()` whose
   * value ends up in `node2`.
   */
  predicate readStep(Node node1, ContentSet cs, Node node2) {
    exists(Content c | c = cs.(SingletonContentSet).getContent() |
      exists(TupleStructPatCfgNode pat, int pos |
        pat = node1.asPat() and
        node2.asPat() = pat.getField(pos)
      |
        c = TTupleFieldContent(pat.getTupleStructPat().getTupleField(pos))
        or
        VariantInLib::tupleVariantCanonicalDestruction(pat.getPat(), c, pos)
      )
      or
      exists(TuplePatCfgNode pat, int pos |
        pos = c.(TuplePositionContent).getPosition() and
        node1.asPat() = pat and
        node2.asPat() = pat.getField(pos)
      )
      or
      exists(RecordPatCfgNode pat, string field |
        pat = node1.asPat() and
        c = TRecordFieldContent(pat.getRecordPat().getRecordField(field)) and
        node2.asPat() = pat.getFieldPat(field)
      )
      or
      c instanceof ReferenceContent and
      node1.asPat().(RefPatCfgNode).getPat() = node2.asPat()
      or
      exists(FieldExprCfgNode access |
        node1.asExpr() = access.getExpr() and
        node2.asExpr() = access and
        access = c.(FieldContent).getAnAccess()
      )
      or
      exists(IndexExprCfgNode arr |
        c instanceof ElementContent and
        node1.asExpr() = arr.getBase() and
        node2.asExpr() = arr
      )
      or
      exists(ForExprCfgNode for |
        c instanceof ElementContent and
        node1.asExpr() = for.getIterable() and
        node2.asPat() = for.getPat()
      )
      or
      exists(SlicePatCfgNode pat |
        c instanceof ElementContent and
        node1.asPat() = pat and
        node2.asPat() = pat.getAPat()
      )
      or
      exists(TryExprCfgNode try |
        node1.asExpr() = try.getExpr() and
        node2.asExpr() = try and
        c.(VariantInLibTupleFieldContent).getVariantInLib(0).getExtendedCanonicalPath() =
          ["crate::option::Option::Some", "crate::result::Result::Ok"]
      )
      or
      exists(PrefixExprCfgNode deref |
        c instanceof ReferenceContent and
        deref.getOperatorName() = "*" and
        node1.asExpr() = deref.getExpr() and
        node2.asExpr() = deref
      )
      or
      // Read from function return
      exists(DataFlowCall call |
        lambdaCall(call, _, node1) and
        call = node2.(OutNode).getCall(TNormalReturnKind()) and
        c instanceof FunctionCallReturnContent
      )
      or
      exists(AwaitExprCfgNode await |
        c instanceof FutureContent and
        node1.asExpr() = await.getExpr() and
        node2.asExpr() = await
      )
      or
      referenceExprToExpr(node2.(PostUpdateNode).getPreUpdateNode(),
        node1.(PostUpdateNode).getPreUpdateNode(), c)
      or
      // Step from receiver expression to receiver node, in case of an implicit
      // dereference.
      implicitDerefToReceiver(node1, node2, c)
      or
      // A read step dual to the store step for implicit borrows.
      implicitBorrowToReceiver(node2.(PostUpdateNode).getPreUpdateNode(),
        node1.(PostUpdateNode).getPreUpdateNode(), c)
      or
      VariableCapture::readStep(node1, c, node2)
    )
    or
    FlowSummaryImpl::Private::Steps::summaryReadStep(node1.(Node::FlowSummaryNode).getSummaryNode(),
      cs, node2.(Node::FlowSummaryNode).getSummaryNode())
  }

  pragma[nomagic]
  private predicate fieldAssignment(Node node1, Node node2, FieldContent c) {
    exists(AssignmentExprCfgNode assignment, FieldExprCfgNode access |
      assignment.getLhs() = access and
      node1.asExpr() = assignment.getRhs() and
      node2.asExpr() = access.getExpr() and
      access = c.getAnAccess()
    )
  }

  pragma[nomagic]
  private predicate referenceAssignment(Node node1, Node node2, ReferenceContent c) {
    exists(AssignmentExprCfgNode assignment, PrefixExprCfgNode deref |
      assignment.getLhs() = deref and
      deref.getOperatorName() = "*" and
      node1.asExpr() = assignment.getRhs() and
      node2.asExpr() = deref.getExpr() and
      exists(c)
    )
  }

  pragma[nomagic]
  private predicate storeContentStep(Node node1, Content c, Node node2) {
    exists(CallExprCfgNode call, int pos |
      node1.asExpr() = call.getArgument(pragma[only_bind_into](pos)) and
      node2.asExpr() = call
    |
      c = TTupleFieldContent(call.getCallExpr().getTupleField(pragma[only_bind_into](pos)))
      or
      VariantInLib::tupleVariantCanonicalConstruction(call.getCallExpr(), c, pos)
    )
    or
    exists(RecordExprCfgNode re, string field |
      c = TRecordFieldContent(re.getRecordExpr().getRecordField(field)) and
      node1.asExpr() = re.getFieldExpr(field) and
      node2.asExpr() = re
    )
    or
    exists(TupleExprCfgNode tuple |
      node1.asExpr() = tuple.getField(c.(TuplePositionContent).getPosition()) and
      node2.asExpr() = tuple
    )
    or
    c instanceof ElementContent and
    node1.asExpr() =
      [
        node2.asExpr().(ArrayRepeatExprCfgNode).getRepeatOperand(),
        node2.asExpr().(ArrayListExprCfgNode).getAnExpr()
      ]
    or
    // Store from a `ref` identifier pattern into the contained name.
    exists(IdentPatCfgNode p |
      c instanceof ReferenceContent and
      p.isRef() and
      node1.asPat() = p and
      node2.(Node::NameNode).asName() = p.getName()
    )
    or
    fieldAssignment(node1, node2.(PostUpdateNode).getPreUpdateNode(), c)
    or
    referenceAssignment(node1, node2.(PostUpdateNode).getPreUpdateNode(), c)
    or
    exists(AssignmentExprCfgNode assignment, IndexExprCfgNode index |
      c instanceof ElementContent and
      assignment.getLhs() = index and
      node1.asExpr() = assignment.getRhs() and
      node2.(PostUpdateNode).getPreUpdateNode().asExpr() = index.getBase()
    )
    or
    referenceExprToExpr(node1, node2, c)
    or
    // Store in function argument
    exists(DataFlowCall call, int i |
      isArgumentNode(node1, call, TPositionalParameterPosition(i)) and
      lambdaCall(call, _, node2.(PostUpdateNode).getPreUpdateNode()) and
      c.(FunctionCallArgumentContent).getPosition() = i
    )
    or
    VariableCapture::storeStep(node1, c, node2)
    or
    // Step from receiver expression to receiver node, in case of an implicit
    // borrow.
    implicitBorrowToReceiver(node1, node2, c)
  }

  /**
   * Holds if data can flow from `node1` to `node2` via a store into `c`.  Thus,
   * `node2` references an object with a content `c.getAStoreContent()` that
   * contains the value of `node1`.
   */
  predicate storeStep(Node node1, ContentSet cs, Node node2) {
    storeContentStep(node1, cs.(SingletonContentSet).getContent(), node2)
    or
    FlowSummaryImpl::Private::Steps::summaryStoreStep(node1.(Node::FlowSummaryNode).getSummaryNode(),
      cs, node2.(Node::FlowSummaryNode).getSummaryNode())
  }

  /**
   * Holds if values stored inside content `c` are cleared at node `n`. For example,
   * any value stored inside `f` is cleared at the pre-update node associated with `x`
   * in `x.f = newValue`.
   */
  predicate clearsContent(Node n, ContentSet cs) {
    fieldAssignment(_, n, cs.(SingletonContentSet).getContent())
    or
    referenceAssignment(_, n, cs.(SingletonContentSet).getContent())
    or
    FlowSummaryImpl::Private::Steps::summaryClearsContent(n.(Node::FlowSummaryNode).getSummaryNode(),
      cs)
    or
    VariableCapture::clearsContent(n, cs.(SingletonContentSet).getContent())
  }

  /**
   * Holds if the value that is being tracked is expected to be stored inside content `c`
   * at node `n`.
   */
  predicate expectsContent(Node n, ContentSet cs) {
    FlowSummaryImpl::Private::Steps::summaryExpectsContent(n.(Node::FlowSummaryNode)
          .getSummaryNode(), cs)
  }

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
  predicate allowParameterReturnInSelf(ParameterNode p) {
    exists(DataFlowCallable c, ParameterPosition pos |
      p.isParameterOf(c, pos) and
      FlowSummaryImpl::Private::summaryAllowParameterReturnInSelf(c.asLibraryCallable(), pos)
    )
    or
    VariableCapture::Flow::heuristicAllowInstanceParameterReturnInSelf(p.(Node::ClosureParameterNode)
          .getCfgScope())
  }

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
    SsaFlow::localMustFlowStep(node1, node2)
    or
    FlowSummaryImpl::Private::Steps::summaryLocalMustFlowStep(node1
          .(Node::FlowSummaryNode)
          .getSummaryNode(), node2.(Node::FlowSummaryNode).getSummaryNode())
  }

  /** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
  predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) {
    exists(Expr e |
      e = creation.asExpr().getExpr() and lambdaCreationExpr(e, kind) and e = c.asCfgScope()
    )
  }

  /**
   * Holds if `call` is a lambda call of kind `kind` where `receiver` is the
   * invoked expression.
   */
  predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) {
    (
      receiver.asExpr() = call.asCallExprCfgNode().getFunction() and
      // All calls to complex expressions and local variable accesses are lambda call.
      exists(Expr f | f = receiver.asExpr().getExpr() |
        f instanceof PathExpr implies f = any(Variable v).getAnAccess()
      )
      or
      call.isSummaryCall(_, receiver.(Node::FlowSummaryNode).getSummaryNode())
    ) and
    exists(kind)
  }

  /** Extra data flow steps needed for lambda flow analysis. */
  predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

  predicate knownSourceModel(Node source, string model) {
    source.(Node::FlowSummaryNode).isSource(_, model)
  }

  predicate knownSinkModel(Node sink, string model) {
    sink.(Node::FlowSummaryNode).isSink(_, model)
  }

  class DataFlowSecondLevelScope = Void;
}

/** Provides logic related to captured variables. */
module VariableCapture {
  private import codeql.dataflow.VariableCapture as SharedVariableCapture

  private predicate closureFlowStep(ExprCfgNode e1, ExprCfgNode e2) {
    e1 = getALastEvalNode(e2)
    or
    exists(Ssa::Definition def |
      def.getARead() = e2 and
      def.getAnUltimateDefinition().(Ssa::WriteDefinition).assigns(e1)
    )
  }

  private module CaptureInput implements SharedVariableCapture::InputSig<Location> {
    private import rust as Ast
    private import codeql.rust.controlflow.BasicBlocks as BasicBlocks
    private import codeql.rust.elements.Variable as Variable

    class BasicBlock extends BasicBlocks::BasicBlock {
      Callable getEnclosingCallable() { result = this.getScope() }
    }

    class ControlFlowNode = CfgNode;

    BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) {
      result = bb.getImmediateDominator()
    }

    BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

    class CapturedVariable extends Variable {
      CapturedVariable() { this.isCaptured() }

      Callable getCallable() { result = this.getEnclosingCfgScope() }
    }

    final class CapturedParameter extends CapturedVariable {
      ParamBase p;

      CapturedParameter() { p = this.getParameter() }

      Node::SourceParameterNode getParameterNode() { result.getParameter().getParamBase() = p }
    }

    class Expr extends CfgNode {
      predicate hasCfgNode(BasicBlock bb, int i) { this = bb.getNode(i) }
    }

    class VariableWrite extends Expr {
      ExprCfgNode source;
      CapturedVariable v;

      VariableWrite() {
        exists(AssignmentExprCfgNode assign, Variable::VariableWriteAccess write |
          this = assign and
          v = write.getVariable() and
          assign.getLhs().getExpr() = write and
          assign.getRhs() = source
        )
        or
        exists(LetStmtCfgNode ls |
          this = ls and
          v.getPat() = ls.getPat().getPat() and
          ls.getInitializer() = source
        )
      }

      CapturedVariable getVariable() { result = v }

      ExprCfgNode getSource() { result = source }
    }

    class VariableRead extends Expr instanceof ExprCfgNode {
      CapturedVariable v;

      VariableRead() {
        exists(VariableReadAccess read | this.getExpr() = read and v = read.getVariable())
      }

      CapturedVariable getVariable() { result = v }
    }

    class ClosureExpr extends Expr instanceof ExprCfgNode {
      ClosureExpr() { lambdaCreationExpr(super.getExpr(), _) }

      predicate hasBody(Callable body) { body = super.getExpr() }

      predicate hasAliasedAccess(Expr f) { closureFlowStep+(this, f) and not closureFlowStep(f, _) }
    }

    class Callable extends CfgScope {
      predicate isConstructor() { none() }
    }
  }

  class CapturedVariable = CaptureInput::CapturedVariable;

  module Flow = SharedVariableCapture::Flow<Location, CaptureInput>;

  private Flow::ClosureNode asClosureNode(Node n) {
    result = n.(Node::CaptureNode).getSynthesizedCaptureNode()
    or
    result.(Flow::ExprNode).getExpr() = n.asExpr()
    or
    result.(Flow::VariableWriteSourceNode).getVariableWrite().getSource() = n.asExpr()
    or
    result.(Flow::ExprPostUpdateNode).getExpr() =
      n.(Node::PostUpdateNode).getPreUpdateNode().asExpr()
    or
    result.(Flow::ParameterNode).getParameter().getParameterNode() = n
    or
    result.(Flow::ThisParameterNode).getCallable() = n.(Node::ClosureParameterNode).getCfgScope()
  }

  predicate storeStep(Node node1, CapturedVariableContent c, Node node2) {
    Flow::storeStep(asClosureNode(node1), c.getVariable(), asClosureNode(node2))
  }

  predicate readStep(Node node1, CapturedVariableContent c, Node node2) {
    Flow::readStep(asClosureNode(node1), c.getVariable(), asClosureNode(node2))
  }

  predicate localFlowStep(Node node1, Node node2) {
    Flow::localFlowStep(asClosureNode(node1), asClosureNode(node2))
  }

  predicate clearsContent(Node node, CapturedVariableContent c) {
    Flow::clearsContent(asClosureNode(node), c.getVariable())
  }
}

import MakeImpl<Location, RustDataFlow>

/** A collection of cached types and predicates to be evaluated in the same stage. */
cached
private module Cached {
  private import codeql.rust.internal.CachedStages

  cached
  newtype TNode =
    TExprNode(ExprCfgNode n) { Stages::DataFlowStage::ref() } or
    TSourceParameterNode(ParamBaseCfgNode p) or
    TPatNode(PatCfgNode p) or
    TNameNode(NameCfgNode n) { n.getName() = any(Variable v).getName() } or
    TExprPostUpdateNode(ExprCfgNode e) {
      isArgumentForCall(e, _, _)
      or
      lambdaCallExpr(_, _, e)
      or
      lambdaCreationExpr(e.getExpr(), _)
      or
      // Whenever `&mut e` has a post-update node we also create one for `e`.
      // E.g., for `e` in `f(..., &mut e, ...)` or `*(&mut e) = ...`.
      e = any(RefExprCfgNode ref | ref.isMut() and exists(TExprPostUpdateNode(ref))).getExpr()
      or
      e =
        [
          any(IndexExprCfgNode i).getBase(), any(FieldExprCfgNode access).getExpr(),
          any(TryExprCfgNode try).getExpr(),
          any(PrefixExprCfgNode pe | pe.getOperatorName() = "*").getExpr(),
          any(AwaitExprCfgNode a).getExpr(), any(MethodCallExprCfgNode mc).getReceiver()
        ]
    } or
    TReceiverNode(MethodCallExprCfgNode mc, Boolean isPost) or
    TSsaNode(SsaImpl::DataFlowIntegration::SsaNode node) or
    TFlowSummaryNode(FlowSummaryImpl::Private::SummaryNode sn) or
    TClosureSelfReferenceNode(CfgScope c) { lambdaCreationExpr(c, _) } or
    TCaptureNode(VariableCapture::Flow::SynthesizedCaptureNode cn)

  cached
  newtype TDataFlowCall =
    TCall(CallExprBaseCfgNode c) or
    TSummaryCall(
      FlowSummaryImpl::Public::SummarizedCallable c, FlowSummaryImpl::Private::SummaryNode receiver
    ) {
      FlowSummaryImpl::Private::summaryCallbackRange(c, receiver)
    }

  cached
  newtype TDataFlowCallable =
    TCfgScope(CfgScope scope) or
    TLibraryCallable(LibraryCallable c)

  /** This is the local flow predicate that is exposed. */
  cached
  predicate localFlowStepImpl(Node::Node nodeFrom, Node::Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
    or
    SsaFlow::localFlowStep(_, nodeFrom, nodeTo, _)
    or
    // Simple flow through library code is included in the exposed local
    // step relation, even though flow is technically inter-procedural
    FlowSummaryImpl::Private::Steps::summaryThroughStepValue(nodeFrom, nodeTo, _)
  }

  cached
  newtype TParameterPosition =
    TPositionalParameterPosition(int i) {
      i in [0 .. max([any(ParamList l).getNumberOfParams(), any(ArgList l).getNumberOfArgs()]) - 1]
      or
      FlowSummaryImpl::ParsePositions::isParsedArgumentPosition(_, i)
      or
      FlowSummaryImpl::ParsePositions::isParsedParameterPosition(_, i)
    } or
    TClosureSelfParameterPosition() or
    TSelfParameterPosition()

  cached
  newtype TReturnKind = TNormalReturnKind()

  cached
  newtype TContent =
    TTupleFieldContent(TupleField field) or
    TRecordFieldContent(RecordField field) or
    // TODO: Remove once library types are extracted
    TVariantInLibTupleFieldContent(VariantInLib::VariantInLib v, int pos) { pos = v.getAPosition() } or
    TElementContent() or
    TFutureContent() or
    TTuplePositionContent(int pos) {
      pos in [0 .. max([
                any(TuplePat pat).getNumberOfFields(),
                any(FieldExpr access).getNameRef().getText().toInt()
              ]
          )]
    } or
    TFunctionCallReturnContent() or
    TFunctionCallArgumentContent(int pos) {
      pos in [0 .. any(CallExpr c).getArgList().getNumberOfArgs() - 1]
    } or
    TCapturedVariableContent(VariableCapture::CapturedVariable v) or
    TReferenceContent()

  cached
  newtype TContentSet = TSingletonContentSet(Content c)

  /** Holds if `n` is a flow source of kind `kind`. */
  cached
  predicate sourceNode(Node n, string kind) { n.(Node::FlowSummaryNode).isSource(kind, _) }

  /** Holds if `n` is a flow sink of kind `kind`. */
  cached
  predicate sinkNode(Node n, string kind) { n.(Node::FlowSummaryNode).isSink(kind, _) }
}

import Cached
