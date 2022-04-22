private import ruby
private import codeql.ruby.ast.internal.Synthesis
private import codeql.ruby.CFG
private import codeql.ruby.dataflow.SSA
private import DataFlowPublic
private import DataFlowDispatch
private import SsaImpl as SsaImpl
private import FlowSummaryImpl as FlowSummaryImpl

/** Gets the callable in which this node occurs. */
DataFlowCallable nodeGetEnclosingCallable(NodeImpl n) { result = n.getEnclosingCallable() }

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
  override CfgScope getCfgScope() { result = this.getExprNode().getExpr().getCfgScope() }

  override Location getLocationImpl() { result = this.getExprNode().getLocation() }

  override string toStringImpl() { result = this.getExprNode().toString() }
}

/** Provides predicates related to local data flow. */
module LocalFlow {
  private import codeql.ruby.dataflow.internal.SsaImpl

  /**
   * Holds if `nodeFrom` is a last node referencing SSA definition `def`, which
   * can reach `next`.
   */
  private predicate localFlowSsaInput(Node nodeFrom, Ssa::Definition def, Ssa::Definition next) {
    exists(BasicBlock bb, int i | lastRefBeforeRedef(def, bb, i, next) |
      def = nodeFrom.(SsaDefinitionNode).getDefinition() and
      def.definesAt(_, bb, i)
      or
      exists(CfgNodes::ExprCfgNode e |
        e = nodeFrom.asExpr() and
        e = bb.getNode(i) and
        e.getExpr() instanceof VariableReadAccess
      )
    )
  }

  /** Gets the SSA definition node corresponding to parameter `p`. */
  SsaDefinitionNode getParameterDefNode(NamedParameter p) {
    exists(BasicBlock bb, int i |
      bb.getNode(i).getNode() = p.getDefiningAccess() and
      result.getDefinition().definesAt(_, bb, i)
    )
  }

  /** Gets the SSA definition node corresponding to the implicit `self` parameter for `m`. */
  private SsaDefinitionNode getSelfParameterDefNode(MethodBase m) {
    result.getDefinition().(Ssa::SelfDefinition).getSourceVariable().getDeclaringScope() = m
  }

  /**
   * Holds if `nodeFrom` is a parameter node, and `nodeTo` is a corresponding SSA node.
   */
  predicate localFlowSsaParamInput(Node nodeFrom, Node nodeTo) {
    nodeTo = getParameterDefNode(nodeFrom.(ParameterNode).getParameter())
    or
    nodeTo = getSelfParameterDefNode(nodeFrom.(SelfParameterNode).getMethod())
  }

  /**
   * Holds if there is a local use-use flow step from `nodeFrom` to `nodeTo`
   * involving SSA definition `def`.
   */
  predicate localSsaFlowStepUseUse(Ssa::Definition def, Node nodeFrom, Node nodeTo) {
    def.hasAdjacentReads(nodeFrom.asExpr(), nodeTo.asExpr())
  }

  /**
   * Holds if there is a local flow step from `nodeFrom` to `nodeTo` involving
   * SSA definition `def`.
   */
  private predicate localSsaFlowStep(Node nodeFrom, Node nodeTo) {
    exists(Ssa::Definition def |
      // Flow from assignment into SSA definition
      def.(Ssa::WriteDefinition).assigns(nodeFrom.asExpr()) and
      nodeTo.(SsaDefinitionNode).getDefinition() = def
      or
      // Flow from SSA definition to first read
      def = nodeFrom.(SsaDefinitionNode).getDefinition() and
      nodeTo.asExpr() = def.getAFirstRead()
      or
      // Flow from read to next read
      localSsaFlowStepUseUse(def, nodeFrom.(PostUpdateNode).getPreUpdateNode(), nodeTo)
      or
      // Flow into phi node
      exists(Ssa::PhiNode phi |
        localFlowSsaInput(nodeFrom, def, phi) and
        phi = nodeTo.(SsaDefinitionNode).getDefinition() and
        def = phi.getAnInput()
      )
    )
    // TODO
    // or
    // // Flow into uncertain SSA definition
    // exists(LocalFlow::UncertainExplicitSsaDefinition uncertain |
    //   localFlowSsaInput(nodeFrom, def, uncertain) and
    //   uncertain = nodeTo.(SsaDefinitionNode).getDefinition() and
    //   def = uncertain.getPriorDefinition()
    // )
  }

  predicate localFlowStepCommon(Node nodeFrom, Node nodeTo) {
    localSsaFlowStep(nodeFrom, nodeTo)
    or
    nodeFrom.asExpr() = nodeTo.asExpr().(CfgNodes::ExprNodes::AssignExprCfgNode).getRhs()
    or
    nodeFrom.asExpr() = nodeTo.asExpr().(CfgNodes::ExprNodes::BlockArgumentCfgNode).getValue()
    or
    nodeFrom.asExpr() = nodeTo.asExpr().(CfgNodes::ExprNodes::StmtSequenceCfgNode).getLastStmt()
    or
    nodeFrom.asExpr() = nodeTo.asExpr().(CfgNodes::ExprNodes::ConditionalExprCfgNode).getBranch(_)
    or
    exists(CfgNodes::AstCfgNode branch |
      branch = nodeTo.asExpr().(CfgNodes::ExprNodes::CaseExprCfgNode).getBranch(_)
    |
      nodeFrom.asExpr() = branch.(CfgNodes::ExprNodes::InClauseCfgNode).getBody()
      or
      nodeFrom.asExpr() = branch.(CfgNodes::ExprNodes::WhenClauseCfgNode).getBody()
      or
      nodeFrom.asExpr() = branch
    )
    or
    exists(CfgNodes::ExprCfgNode exprTo, ReturningStatementNode n |
      nodeFrom = n and
      exprTo = nodeTo.asExpr() and
      n.getReturningNode().getNode() instanceof BreakStmt and
      exprTo.getNode() instanceof Loop and
      nodeTo.asExpr().getAPredecessor(any(SuccessorTypes::BreakSuccessor s)) = n.getReturningNode()
    )
    or
    nodeFrom.asExpr() = nodeTo.(ReturningStatementNode).getReturningNode().getReturnedValueNode()
    or
    nodeTo.asExpr() =
      any(CfgNodes::ExprNodes::ForExprCfgNode for |
        exists(SuccessorType s |
          not s instanceof SuccessorTypes::BreakSuccessor and
          exists(for.getAPredecessor(s))
        ) and
        nodeFrom.asExpr() = for.getValue()
      )
  }
}

/** An argument of a call (including qualifier arguments, excluding block arguments). */
private class Argument extends CfgNodes::ExprCfgNode {
  private CfgNodes::ExprNodes::CallCfgNode call;
  private ArgumentPosition arg;

  Argument() {
    exists(int i |
      this = call.getArgument(i) and
      not this.getExpr() instanceof BlockArgument and
      not exists(this.getExpr().(Pair).getKey().getConstantValue().getSymbol()) and
      arg.isPositional(i)
    )
    or
    exists(CfgNodes::ExprNodes::PairCfgNode p |
      p = call.getArgument(_) and
      this = p.getValue() and
      arg.isKeyword(p.getKey().getConstantValue().getSymbol())
    )
    or
    this = call.getReceiver() and arg.isSelf()
  }

  /** Holds if this expression is the `i`th argument of `c`. */
  predicate isArgumentOf(CfgNodes::ExprNodes::CallCfgNode c, ArgumentPosition pos) {
    c = call and pos = arg
  }
}

/** A collection of cached types and predicates to be evaluated in the same stage. */
cached
private module Cached {
  cached
  newtype TNode =
    TExprNode(CfgNodes::ExprCfgNode n) or
    TReturningNode(CfgNodes::ReturningCfgNode n) or
    TSynthReturnNode(CfgScope scope, ReturnKind kind) {
      exists(ReturningNode ret |
        ret.(NodeImpl).getCfgScope() = scope and
        ret.getKind() = kind
      )
    } or
    TSsaDefinitionNode(Ssa::Definition def) or
    TNormalParameterNode(Parameter p) {
      p instanceof SimpleParameter or
      p instanceof OptionalParameter or
      p instanceof KeywordParameter
    } or
    TSelfParameterNode(MethodBase m) or
    TBlockParameterNode(MethodBase m) or
    TExprPostUpdateNode(CfgNodes::ExprCfgNode n) { n instanceof Argument } or
    TSummaryNode(
      FlowSummaryImpl::Public::SummarizedCallable c,
      FlowSummaryImpl::Private::SummaryNodeState state
    ) {
      FlowSummaryImpl::Private::summaryNodeRange(c, state)
    } or
    TSummaryParameterNode(FlowSummaryImpl::Public::SummarizedCallable c, ParameterPosition pos) {
      FlowSummaryImpl::Private::summaryParameterNodeRange(c, pos)
    }

  class TParameterNode =
    TNormalParameterNode or TBlockParameterNode or TSelfParameterNode or TSummaryParameterNode;

  private predicate defaultValueFlow(NamedParameter p, ExprNode e) {
    p.(OptionalParameter).getDefaultValue() = e.getExprNode().getExpr()
    or
    p.(KeywordParameter).getDefaultValue() = e.getExprNode().getExpr()
  }

  /**
   * This is the local flow predicate that is used as a building block in global
   * data flow.
   */
  cached
  predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
    or
    defaultValueFlow(nodeTo.(ParameterNode).getParameter(), nodeFrom)
    or
    LocalFlow::localFlowSsaParamInput(nodeFrom, nodeTo)
    or
    nodeTo.(SynthReturnNode).getAnInput() = nodeFrom
    or
    LocalFlow::localSsaFlowStepUseUse(_, nodeFrom, nodeTo) and
    not FlowSummaryImpl::Private::Steps::summaryClearsContentArg(nodeFrom, _)
    or
    FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom, nodeTo, true)
  }

  /** This is the local flow predicate that is exposed. */
  cached
  predicate localFlowStepImpl(Node nodeFrom, Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
    or
    defaultValueFlow(nodeTo.(ParameterNode).getParameter(), nodeFrom)
    or
    LocalFlow::localFlowSsaParamInput(nodeFrom, nodeTo)
    or
    LocalFlow::localSsaFlowStepUseUse(_, nodeFrom, nodeTo)
    or
    // Simple flow through library code is included in the exposed local
    // step relation, even though flow is technically inter-procedural
    FlowSummaryImpl::Private::Steps::summaryThroughStep(nodeFrom, nodeTo, true)
  }

  /** This is the local flow predicate that is used in type tracking. */
  cached
  predicate localFlowStepTypeTracker(Node nodeFrom, Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
    or
    exists(NamedParameter p |
      defaultValueFlow(p, nodeFrom) and
      nodeTo = LocalFlow::getParameterDefNode(p)
    )
    or
    LocalFlow::localSsaFlowStepUseUse(_, nodeFrom, nodeTo)
  }

  private predicate entrySsaDefinition(SsaDefinitionNode n) {
    n = LocalFlow::getParameterDefNode(_)
    or
    exists(Ssa::Definition def | def = n.getDefinition() |
      def instanceof Ssa::SelfDefinition
      or
      def instanceof Ssa::CapturedEntryDefinition
    )
  }

  cached
  predicate isLocalSourceNode(Node n) {
    n instanceof ParameterNode
    or
    n instanceof PostUpdateNodes::ExprPostUpdateNode
    or
    // Expressions that can't be reached from another entry definition or expression.
    not localFlowStepTypeTracker+(any(Node n0 |
        n0 instanceof ExprNode
        or
        entrySsaDefinition(n0)
      ), n.(ExprNode))
    or
    // Ensure all entry SSA definitions are local sources -- for parameters, this
    // is needed by type tracking. Note that when the parameter has a default value,
    // it will be reachable from an expression (the default value) and therefore
    // won't be caught by the rule above.
    entrySsaDefinition(n)
  }

  cached
  newtype TContentSet =
    TSingletonContent(Content c) or
    TAnyArrayElementContent()

  cached
  newtype TContent =
    TKnownArrayElementContent(int i) { i in [0 .. 10] } or
    TUnknownArrayElementContent()

  /**
   * Holds if `e` is an `ExprNode` that may be returned by a call to `c`.
   */
  cached
  predicate exprNodeReturnedFromCached(ExprNode e, Callable c) {
    exists(ReturningNode r |
      nodeGetEnclosingCallable(r).asCallable() = c and
      (
        r.(ExplicitReturnNode).getReturningNode().getReturnedValueNode() = e.asExpr() or
        r.(ExprReturnNode) = e
      )
    )
  }
}

class TArrayElementContent = TKnownArrayElementContent or TUnknownArrayElementContent;

import Cached

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) {
  exists(Ssa::Definition def | def = n.(SsaDefinitionNode).getDefinition() |
    def instanceof Ssa::PhiNode or
    def instanceof Ssa::CapturedEntryDefinition or
    def instanceof Ssa::CapturedCallDefinition
  )
  or
  n = LocalFlow::getParameterDefNode(_)
  or
  isDesugarNode(n.(ExprNode).getExprNode().getExpr())
  or
  n instanceof SummaryNode
  or
  n instanceof SummaryParameterNode
  or
  n instanceof SynthReturnNode
}

/** An SSA definition, viewed as a node in a data flow graph. */
class SsaDefinitionNode extends NodeImpl, TSsaDefinitionNode {
  Ssa::Definition def;

  SsaDefinitionNode() { this = TSsaDefinitionNode(def) }

  /** Gets the underlying SSA definition. */
  Ssa::Definition getDefinition() { result = def }

  override CfgScope getCfgScope() { result = def.getBasicBlock().getScope() }

  override Location getLocationImpl() { result = def.getLocation() }

  override string toStringImpl() { result = def.toString() }
}

/** An SSA definition for a `self` variable. */
class SsaSelfDefinitionNode extends LocalSourceNode, SsaDefinitionNode {
  private SelfVariable self;

  SsaSelfDefinitionNode() { self = def.getSourceVariable() }

  /** Gets the scope in which the `self` variable is declared. */
  Scope getSelfScope() { result = self.getDeclaringScope() }
}

/**
 * A value returning statement, viewed as a node in a data flow graph.
 *
 * Note that because of control-flow splitting, one `ReturningStmt` may correspond
 * to multiple `ReturningStatementNode`s, just like it may correspond to multiple
 * `ControlFlow::Node`s.
 */
class ReturningStatementNode extends NodeImpl, TReturningNode {
  CfgNodes::ReturningCfgNode n;

  ReturningStatementNode() { this = TReturningNode(n) }

  /** Gets the expression corresponding to this node. */
  CfgNodes::ReturningCfgNode getReturningNode() { result = n }

  override CfgScope getCfgScope() { result = n.getScope() }

  override Location getLocationImpl() { result = n.getLocation() }

  override string toStringImpl() { result = n.toString() }
}

private module ParameterNodes {
  abstract class ParameterNodeImpl extends NodeImpl {
    abstract Parameter getParameter();

    abstract predicate isSourceParameterOf(Callable c, ParameterPosition pos);

    predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      this.isSourceParameterOf(c.asCallable(), pos)
    }
  }

  /**
   * The value of a normal parameter at function entry, viewed as a node in a data
   * flow graph.
   */
  class NormalParameterNode extends ParameterNodeImpl, TNormalParameterNode {
    private Parameter parameter;

    NormalParameterNode() { this = TNormalParameterNode(parameter) }

    override Parameter getParameter() { result = parameter }

    override predicate isSourceParameterOf(Callable c, ParameterPosition pos) {
      exists(int i | pos.isPositional(i) and c.getParameter(i) = parameter |
        parameter instanceof SimpleParameter
        or
        parameter instanceof OptionalParameter
      )
      or
      parameter =
        any(KeywordParameter kp |
          c.getAParameter() = kp and
          pos.isKeyword(kp.getName())
        )
    }

    override CfgScope getCfgScope() { result = parameter.getCallable() }

    override Location getLocationImpl() { result = parameter.getLocation() }

    override string toStringImpl() { result = parameter.toString() }
  }

  /**
   * The value of the `self` parameter at function entry, viewed as a node in a data
   * flow graph.
   */
  class SelfParameterNode extends ParameterNodeImpl, TSelfParameterNode {
    private MethodBase method;

    SelfParameterNode() { this = TSelfParameterNode(method) }

    final MethodBase getMethod() { result = method }

    override Parameter getParameter() { none() }

    override predicate isSourceParameterOf(Callable c, ParameterPosition pos) {
      method = c and pos.isSelf()
    }

    override CfgScope getCfgScope() { result = method }

    override Location getLocationImpl() { result = method.getLocation() }

    override string toStringImpl() { result = "self in " + method.toString() }
  }

  /**
   * The value of a block parameter at function entry, viewed as a node in a data
   * flow graph.
   */
  class BlockParameterNode extends ParameterNodeImpl, TBlockParameterNode {
    private MethodBase method;

    BlockParameterNode() { this = TBlockParameterNode(method) }

    final MethodBase getMethod() { result = method }

    override Parameter getParameter() {
      result = method.getAParameter() and result instanceof BlockParameter
    }

    override predicate isSourceParameterOf(Callable c, ParameterPosition pos) {
      c = method and pos.isBlock()
    }

    override CfgScope getCfgScope() { result = method }

    override Location getLocationImpl() {
      result = this.getParameter().getLocation()
      or
      not exists(this.getParameter()) and result = method.getLocation()
    }

    override string toStringImpl() {
      result = this.getParameter().toString()
      or
      not exists(this.getParameter()) and result = "&block"
    }
  }

  /** A parameter for a library callable with a flow summary. */
  class SummaryParameterNode extends ParameterNodeImpl, TSummaryParameterNode {
    private FlowSummaryImpl::Public::SummarizedCallable sc;
    private ParameterPosition pos_;

    SummaryParameterNode() { this = TSummaryParameterNode(sc, pos_) }

    override Parameter getParameter() { none() }

    override predicate isSourceParameterOf(Callable c, ParameterPosition pos) { none() }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      sc = c and pos = pos_
    }

    override CfgScope getCfgScope() { none() }

    override DataFlowCallable getEnclosingCallable() { result = sc }

    override EmptyLocation getLocationImpl() { any() }

    override string toStringImpl() { result = "parameter " + pos_ + " of " + sc }
  }
}

import ParameterNodes

/** A data-flow node used to model flow summaries. */
class SummaryNode extends NodeImpl, TSummaryNode {
  private FlowSummaryImpl::Public::SummarizedCallable c;
  private FlowSummaryImpl::Private::SummaryNodeState state;

  SummaryNode() { this = TSummaryNode(c, state) }

  override CfgScope getCfgScope() { none() }

  override DataFlowCallable getEnclosingCallable() { result = c }

  override EmptyLocation getLocationImpl() { any() }

  override string toStringImpl() { result = "[summary] " + state + " in " + c }
}

/** A data-flow node that represents a call argument. */
abstract class ArgumentNode extends Node {
  /** Holds if this argument occurs at the given position in the given call. */
  abstract predicate argumentOf(DataFlowCall call, ArgumentPosition pos);

  abstract predicate sourceArgumentOf(CfgNodes::ExprNodes::CallCfgNode call, ArgumentPosition pos);

  /** Gets the call in which this node is an argument. */
  final DataFlowCall getCall() { this.argumentOf(result, _) }
}

private module ArgumentNodes {
  /** A data-flow node that represents an explicit call argument. */
  class ExplicitArgumentNode extends ArgumentNode {
    Argument arg;

    ExplicitArgumentNode() { this.asExpr() = arg }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      this.sourceArgumentOf(call.asCall(), pos)
    }

    override predicate sourceArgumentOf(CfgNodes::ExprNodes::CallCfgNode call, ArgumentPosition pos) {
      arg.isArgumentOf(call, pos)
    }
  }

  /** A data-flow node that represents the `self` argument of a call. */
  class SelfArgumentNode extends ExplicitArgumentNode {
    SelfArgumentNode() { arg.isArgumentOf(_, any(ArgumentPosition pos | pos.isSelf())) }
  }

  /** A data-flow node that represents a block argument. */
  class BlockArgumentNode extends ArgumentNode {
    BlockArgumentNode() {
      this.asExpr().getExpr() instanceof BlockArgument or
      exists(CfgNodes::ExprNodes::CallCfgNode c | c.getBlock() = this.asExpr())
    }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      this.sourceArgumentOf(call.asCall(), pos)
    }

    override predicate sourceArgumentOf(CfgNodes::ExprNodes::CallCfgNode call, ArgumentPosition pos) {
      pos.isBlock() and
      (
        this.asExpr() = call.getBlock()
        or
        exists(CfgNodes::ExprCfgNode arg, int n |
          arg = call.getArgument(n) and
          this.asExpr() = arg and
          arg.getExpr() instanceof BlockArgument
        )
      )
    }
  }

  private class SummaryArgumentNode extends SummaryNode, ArgumentNode {
    SummaryArgumentNode() { FlowSummaryImpl::Private::summaryArgumentNode(_, this, _) }

    override predicate sourceArgumentOf(CfgNodes::ExprNodes::CallCfgNode call, ArgumentPosition pos) {
      none()
    }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      FlowSummaryImpl::Private::summaryArgumentNode(call, this, pos)
    }
  }
}

import ArgumentNodes

/** A data-flow node that represents a value syntactically returned by a callable. */
abstract class ReturningNode extends Node {
  /** Gets the kind of this return node. */
  abstract ReturnKind getKind();
}

/** A data-flow node that represents a value returned by a callable. */
abstract class ReturnNode extends Node {
  /** Gets the kind of this return node. */
  abstract ReturnKind getKind();
}

private module ReturnNodes {
  private predicate isValid(CfgNodes::ReturningCfgNode node) {
    exists(ReturningStmt stmt, Callable scope |
      stmt = node.getNode() and
      scope = node.getScope()
    |
      stmt instanceof ReturnStmt and
      (scope instanceof Method or scope instanceof SingletonMethod or scope instanceof Lambda)
      or
      stmt instanceof NextStmt and
      (scope instanceof Block or scope instanceof Lambda)
      or
      stmt instanceof BreakStmt and
      (scope instanceof Block or scope instanceof Lambda)
    )
  }

  /**
   * A data-flow node that represents an expression explicitly returned by
   * a callable.
   */
  class ExplicitReturnNode extends ReturningNode, ReturningStatementNode {
    ExplicitReturnNode() {
      isValid(n) and
      n.getASuccessor().(CfgNodes::AnnotatedExitNode).isNormal() and
      n.getScope() instanceof Callable
    }

    override ReturnKind getKind() {
      if n.getNode() instanceof BreakStmt
      then result instanceof BreakReturnKind
      else result instanceof NormalReturnKind
    }
  }

  pragma[noinline]
  private AstNode implicitReturn(Callable c, ExprNode n) {
    exists(CfgNodes::ExprCfgNode en |
      en = n.getExprNode() and
      en.getASuccessor().(CfgNodes::AnnotatedExitNode).isNormal() and
      n.(NodeImpl).getCfgScope() = c and
      result = en.getExpr()
    )
    or
    result = implicitReturn(c, n).getParent()
  }

  /**
   * A data-flow node that represents an expression implicitly returned by
   * a callable. An implicit return happens when an expression can be the
   * last thing that is evaluated in the body of the callable.
   */
  class ExprReturnNode extends ReturningNode, ExprNode {
    ExprReturnNode() { exists(Callable c | implicitReturn(c, this) = c.getAStmt()) }

    override ReturnKind getKind() { result instanceof NormalReturnKind }
  }

  /**
   * A synthetic data-flow node for joining flow from different syntactic
   * returns into a single node.
   *
   * This node only exists to avoid computing the product of a large fan-in
   * with a large fan-out.
   */
  class SynthReturnNode extends NodeImpl, ReturnNode, TSynthReturnNode {
    private CfgScope scope;
    private ReturnKind kind;

    SynthReturnNode() { this = TSynthReturnNode(scope, kind) }

    /** Gets a syntactic return node that flows into this synthetic node. */
    ReturningNode getAnInput() {
      result.(NodeImpl).getCfgScope() = scope and
      result.getKind() = kind
    }

    override ReturnKind getKind() { result = kind }

    override CfgScope getCfgScope() { result = scope }

    override Location getLocationImpl() { result = scope.getLocation() }

    override string toStringImpl() { result = "return " + kind + " in " + scope }
  }

  private class SummaryReturnNode extends SummaryNode, ReturnNode {
    private ReturnKind rk;

    SummaryReturnNode() { FlowSummaryImpl::Private::summaryReturnNode(this, rk) }

    override ReturnKind getKind() { result = rk }
  }
}

import ReturnNodes

/** A data-flow node that represents the output of a call. */
abstract class OutNode extends Node {
  /** Gets the underlying call, where this node is a corresponding output of kind `kind`. */
  abstract DataFlowCall getCall(ReturnKind kind);
}

private module OutNodes {
  /**
   * A data-flow node that reads a value returned directly by a callable,
   * either via a call or a `yield` of a block.
   */
  class ExprOutNode extends OutNode, ExprNode {
    private DataFlowCall call;

    ExprOutNode() { call.asCall() = this.getExprNode() }

    override DataFlowCall getCall(ReturnKind kind) {
      result = call and
      kind instanceof NormalReturnKind
    }
  }

  private class SummaryOutNode extends SummaryNode, OutNode {
    SummaryOutNode() { FlowSummaryImpl::Private::summaryOutNode(_, this, _) }

    override DataFlowCall getCall(ReturnKind kind) {
      FlowSummaryImpl::Private::summaryOutNode(result, this, kind)
    }
  }
}

import OutNodes

predicate jumpStep(Node pred, Node succ) {
  SsaImpl::captureFlowIn(_, pred.(SsaDefinitionNode).getDefinition(),
    succ.(SsaDefinitionNode).getDefinition())
  or
  SsaImpl::captureFlowOut(_, pred.(SsaDefinitionNode).getDefinition(),
    succ.(SsaDefinitionNode).getDefinition())
  or
  succ.asExpr().getExpr().(ConstantReadAccess).getValue() = pred.asExpr().getExpr()
}

predicate storeStep(Node node1, ContentSet c, Node node2) {
  FlowSummaryImpl::Private::Steps::summaryStoreStep(node1, c, node2)
}

predicate readStep(Node node1, ContentSet c, Node node2) {
  FlowSummaryImpl::Private::Steps::summaryReadStep(node1, c, node2)
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`. For example,
 * any value stored inside `f` is cleared at the pre-update node associated with `x`
 * in `x.f = newValue`.
 */
predicate clearsContent(Node n, ContentSet c) {
  FlowSummaryImpl::Private::Steps::summaryClearsContent(n, c)
}

private newtype TDataFlowType =
  TTodoDataFlowType() or
  TTodoDataFlowType2() // Add a dummy value to prevent bad functionality-induced joins arising from a type of size 1.

class DataFlowType extends TDataFlowType {
  string toString() { result = "" }
}

/** Gets the type of `n` used for type pruning. */
DataFlowType getNodeType(NodeImpl n) { result = TTodoDataFlowType() and exists(n) }

/** Gets a string representation of a `DataFlowType`. */
string ppReprType(DataFlowType t) { result = t.toString() }

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
pragma[inline]
predicate compatibleTypes(DataFlowType t1, DataFlowType t2) { any() }

abstract class PostUpdateNodeImpl extends Node {
  /** Gets the node before the state update. */
  abstract Node getPreUpdateNode();
}

private module PostUpdateNodes {
  class ExprPostUpdateNode extends PostUpdateNodeImpl, NodeImpl, TExprPostUpdateNode {
    private CfgNodes::ExprCfgNode e;

    ExprPostUpdateNode() { this = TExprPostUpdateNode(e) }

    override ExprNode getPreUpdateNode() { e = result.getExprNode() }

    override CfgScope getCfgScope() { result = e.getExpr().getCfgScope() }

    override Location getLocationImpl() { result = e.getLocation() }

    override string toStringImpl() { result = "[post] " + e.toString() }
  }

  private class SummaryPostUpdateNode extends SummaryNode, PostUpdateNodeImpl {
    private Node pre;

    SummaryPostUpdateNode() { FlowSummaryImpl::Private::summaryPostUpdateNode(this, pre) }

    override Node getPreUpdateNode() { result = pre }
  }
}

private import PostUpdateNodes

/** A node that performs a type cast. */
class CastNode extends Node {
  CastNode() { this instanceof ReturningNode }
}

class DataFlowExpr = CfgNodes::ExprCfgNode;

int accessPathLimit() { result = 5 }

/**
 * Holds if access paths with `c` at their head always should be tracked at high
 * precision. This disables adaptive access path precision for such access paths.
 */
predicate forceHighPrecision(Content c) { c instanceof Content::ArrayElementContent }

/** The unit type. */
private newtype TUnit = TMkUnit()

/** The trivial type with a single element. */
class Unit extends TUnit {
  /** Gets a textual representation of this element. */
  string toString() { result = "unit" }
}

/**
 * Holds if the node `n` is unreachable when the call context is `call`.
 */
predicate isUnreachableInCall(Node n, DataFlowCall call) { none() }

newtype LambdaCallKind =
  TYieldCallKind() or
  TLambdaCallKind()

/** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) {
  kind = TYieldCallKind() and
  creation.asExpr().getExpr() = c.asCallable().(Block)
  or
  kind = TLambdaCallKind() and
  (
    creation.asExpr().getExpr() = c.asCallable().(Lambda)
    or
    creation.asExpr() =
      any(CfgNodes::ExprNodes::MethodCallCfgNode mc |
        c.asCallable() = mc.getBlock().getExpr() and
        mc.getExpr().getMethodName() = "lambda"
      )
  )
}

/** Holds if `call` is a lambda call of kind `kind` where `receiver` is the lambda expression. */
predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) {
  kind = TYieldCallKind() and
  receiver.(BlockParameterNode).getMethod() =
    call.asCall().getExpr().(YieldCall).getEnclosingMethod()
  or
  kind = TLambdaCallKind() and
  call.asCall() =
    any(CfgNodes::ExprNodes::MethodCallCfgNode mc |
      receiver.asExpr() = mc.getReceiver() and
      mc.getExpr().getMethodName() = "call"
    )
  or
  receiver = call.(SummaryCall).getReceiver() and
  if receiver.(ParameterNodeImpl).isParameterOf(_, any(ParameterPosition pos | pos.isBlock()))
  then kind = TYieldCallKind()
  else kind = TLambdaCallKind()
}

/** Extra data-flow steps needed for lambda flow analysis. */
predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

/**
 * Holds if flow is allowed to pass from parameter `p` and back to itself as a
 * side-effect, resulting in a summary from `p` to itself.
 *
 * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
 * by default as a heuristic.
 */
predicate allowParameterReturnInSelf(ParameterNode p) {
  FlowSummaryImpl::Private::summaryAllowParameterReturnInSelf(p)
}
