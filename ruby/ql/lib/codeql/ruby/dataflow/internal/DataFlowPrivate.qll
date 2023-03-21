private import codeql.util.Boolean
private import codeql.ruby.AST
private import codeql.ruby.ast.internal.Synthesis
private import codeql.ruby.CFG
private import codeql.ruby.dataflow.SSA
private import DataFlowPublic
private import DataFlowDispatch
private import SsaImpl as SsaImpl
private import FlowSummaryImpl as FlowSummaryImpl
private import FlowSummaryImplSpecific as FlowSummaryImplSpecific
private import codeql.ruby.frameworks.data.ModelsAsData

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

/**
 * Gets a node that may execute last in `n`, and which, when it executes last,
 * will be the value of `n`.
 */
private CfgNodes::ExprCfgNode getALastEvalNode(CfgNodes::ExprCfgNode n) {
  result = n.(CfgNodes::ExprNodes::StmtSequenceCfgNode).getLastStmt()
  or
  result = n.(CfgNodes::ExprNodes::ConditionalExprCfgNode).getBranch(_)
  or
  result = n.(CfgNodes::ExprNodes::AssignExprCfgNode).getRhs()
  or
  exists(CfgNodes::AstCfgNode branch |
    branch = n.(CfgNodes::ExprNodes::CaseExprCfgNode).getBranch(_)
  |
    result = branch.(CfgNodes::ExprNodes::InClauseCfgNode).getBody()
    or
    result = branch.(CfgNodes::ExprNodes::WhenClauseCfgNode).getBody()
    or
    result = branch
  )
}

/** Gets a node for which to construct a post-update node for argument `arg`. */
CfgNodes::ExprCfgNode getAPostUpdateNodeForArg(Argument arg) {
  result = getALastEvalNode*(arg) and
  not exists(getALastEvalNode(result))
}

/** Provides predicates related to local data flow. */
module LocalFlow {
  private import codeql.ruby.dataflow.internal.SsaImpl

  /** An SSA definition into which another SSA definition may flow. */
  private class SsaInputDefinitionExtNode extends SsaDefinitionExtNode {
    SsaInputDefinitionExtNode() {
      def instanceof Ssa::PhiNode
      or
      def instanceof SsaImpl::PhiReadNode
      //TODO: or def instanceof LocalFlow::UncertainExplicitSsaDefinition
    }
  }

  /**
   * Holds if `nodeFrom` is a node for SSA definition `def`, which can reach `next`.
   */
  private predicate localFlowSsaInputFromDef(
    SsaDefinitionExtNode nodeFrom, SsaImpl::DefinitionExt def, SsaInputDefinitionExtNode next
  ) {
    exists(BasicBlock bb, int i |
      lastRefBeforeRedefExt(def, bb, i, next.getDefinitionExt()) and
      def = nodeFrom.getDefinitionExt() and
      def.definesAt(_, bb, i, _)
    )
  }

  /**
   * Holds if `exprFrom` is a last read of SSA definition `def`, which
   * can reach `next`.
   */
  predicate localFlowSsaInputFromRead(
    CfgNodes::ExprCfgNode exprFrom, SsaImpl::DefinitionExt def, SsaInputDefinitionExtNode next
  ) {
    exists(BasicBlock bb, int i |
      SsaImpl::lastRefBeforeRedefExt(def, bb, i, next.getDefinitionExt()) and
      exprFrom = bb.getNode(i) and
      exprFrom.getExpr() instanceof VariableReadAccess
    )
  }

  /** Gets the SSA definition node corresponding to parameter `p`. */
  SsaDefinitionExtNode getParameterDefNode(NamedParameter p) {
    exists(BasicBlock bb, int i |
      bb.getNode(i).getNode() = p.getDefiningAccess() and
      result.getDefinitionExt().definesAt(_, bb, i, _)
    )
  }

  /** Gets the SSA definition node corresponding to the implicit `self` parameter for `m`. */
  private SsaDefinitionExtNode getSelfParameterDefNode(MethodBase m) {
    result.getDefinitionExt().(Ssa::SelfDefinition).getSourceVariable().getDeclaringScope() = m
  }

  /**
   * Holds if `nodeFrom` is a parameter node, and `nodeTo` is a corresponding SSA node.
   */
  predicate localFlowSsaParamInput(Node nodeFrom, Node nodeTo) {
    nodeTo = getParameterDefNode(nodeFrom.(ParameterNodeImpl).getParameter())
    or
    nodeTo = getSelfParameterDefNode(nodeFrom.(SelfParameterNode).getMethod())
  }

  /**
   * Holds if `nodeFrom -> nodeTo` is a step from a parameter to a capture entry node for
   * that parameter.
   *
   * This is intended to recover from flow not currently recognised by ordinary capture flow.
   */
  predicate localFlowSsaParamCaptureInput(Node nodeFrom, Node nodeTo) {
    exists(Ssa::CapturedEntryDefinition def |
      nodeFrom.asParameter().(NamedParameter).getVariable() = def.getSourceVariable()
      or
      nodeFrom.(SelfParameterNode).getSelfVariable() = def.getSourceVariable()
    |
      nodeTo.(SsaDefinitionExtNode).getDefinitionExt() = def
    )
  }

  /**
   * Holds if there is a local use-use flow step from `nodeFrom` to `nodeTo`
   * involving SSA definition `def`.
   */
  predicate localSsaFlowStepUseUse(SsaImpl::DefinitionExt def, Node nodeFrom, Node nodeTo) {
    SsaImpl::adjacentReadPairExt(def, nodeFrom.asExpr(), nodeTo.asExpr())
  }

  /**
   * Holds if there is a local flow step from `nodeFrom` to `nodeTo` involving
   * SSA definition `def`.
   */
  private predicate localSsaFlowStep(Node nodeFrom, Node nodeTo) {
    exists(SsaImpl::DefinitionExt def |
      // Flow from assignment into SSA definition
      def.(Ssa::WriteDefinition).assigns(nodeFrom.asExpr()) and
      nodeTo.(SsaDefinitionExtNode).getDefinitionExt() = def
      or
      // Flow from SSA definition to first read
      def = nodeFrom.(SsaDefinitionExtNode).getDefinitionExt() and
      firstReadExt(def, nodeTo.asExpr())
      or
      // Flow from read to next read
      localSsaFlowStepUseUse(def, nodeFrom.(PostUpdateNode).getPreUpdateNode(), nodeTo)
      or
      // Flow into phi (read) SSA definition node from def
      localFlowSsaInputFromDef(nodeFrom, def, nodeTo)
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
    nodeFrom.asExpr() = nodeTo.asExpr().(CfgNodes::ExprNodes::BlockArgumentCfgNode).getValue()
    or
    nodeFrom.asExpr() = getALastEvalNode(nodeTo.asExpr())
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
    or
    nodeTo.asExpr() =
      any(CfgNodes::ExprNodes::BinaryOperationCfgNode op |
        op.getExpr() instanceof BinaryLogicalOperation and
        nodeFrom.asExpr() = op.getAnOperand()
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
      not this.getExpr().(Pair).getKey().getConstantValue().isSymbol(_) and
      not this.getExpr() instanceof HashSplatExpr and
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
    or
    this = call.getAnArgument() and
    this.getExpr() instanceof HashSplatExpr and
    arg.isHashSplat()
    or
    this = call.getArgument(0) and
    this.getExpr() instanceof SplatExpr and
    arg.isSplatAll()
  }

  /** Holds if this expression is the `i`th argument of `c`. */
  predicate isArgumentOf(CfgNodes::ExprNodes::CallCfgNode c, ArgumentPosition pos) {
    c = call and pos = arg
  }
}

/** Holds if `n` is not a constant expression. */
predicate isNonConstantExpr(CfgNodes::ExprCfgNode n) {
  not exists(n.getConstantValue()) and
  not n.getExpr() instanceof ConstantAccess
}

/** A collection of cached types and predicates to be evaluated in the same stage. */
cached
private module Cached {
  private import TaintTrackingPrivate as TaintTrackingPrivate
  private import codeql.ruby.typetracking.TypeTrackerSpecific as TypeTrackerSpecific

  cached
  newtype TNode =
    TExprNode(CfgNodes::ExprCfgNode n) { TaintTrackingPrivate::forceCachingInSameStage() } or
    TReturningNode(CfgNodes::ReturningCfgNode n) or
    TSynthReturnNode(CfgScope scope, ReturnKind kind) {
      exists(ReturningNode ret |
        ret.(NodeImpl).getCfgScope() = scope and
        ret.getKind() = kind
      )
    } or
    TSsaDefinitionExtNode(SsaImpl::DefinitionExt def) or
    TNormalParameterNode(Parameter p) {
      p instanceof SimpleParameter or
      p instanceof OptionalParameter or
      p instanceof KeywordParameter or
      p instanceof HashSplatParameter or
      p instanceof SplatParameter
    } or
    TSelfParameterNode(MethodBase m) or
    TBlockParameterNode(MethodBase m) or
    TSynthHashSplatParameterNode(DataFlowCallable c) {
      isParameterNode(_, c, any(ParameterPosition p | p.isKeyword(_)))
    } or
    TExprPostUpdateNode(CfgNodes::ExprCfgNode n) {
      // filter out nodes that clearly don't need post-update nodes
      isNonConstantExpr(n) and
      (
        n = getAPostUpdateNodeForArg(_)
        or
        n = any(CfgNodes::ExprNodes::InstanceVariableAccessCfgNode v).getReceiver()
      )
    } or
    TSummaryNode(
      FlowSummaryImpl::Public::SummarizedCallable c,
      FlowSummaryImpl::Private::SummaryNodeState state
    ) {
      FlowSummaryImpl::Private::summaryNodeRange(c, state)
    } or
    TSummaryParameterNode(FlowSummaryImpl::Public::SummarizedCallable c, ParameterPosition pos) {
      FlowSummaryImpl::Private::summaryParameterNodeRange(c, pos)
    } or
    TSynthHashSplatArgumentNode(CfgNodes::ExprNodes::CallCfgNode c) {
      exists(Argument arg | arg.isArgumentOf(c, any(ArgumentPosition pos | pos.isKeyword(_))))
      or
      c.getAnArgument() instanceof CfgNodes::ExprNodes::PairCfgNode
    }

  class TParameterNode =
    TNormalParameterNode or TBlockParameterNode or TSelfParameterNode or
        TSynthHashSplatParameterNode or TSummaryParameterNode;

  private predicate defaultValueFlow(NamedParameter p, ExprNode e) {
    p.(OptionalParameter).getDefaultValue() = e.getExprNode().getExpr()
    or
    p.(KeywordParameter).getDefaultValue() = e.getExprNode().getExpr()
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
  predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
    or
    defaultValueFlow(nodeTo.(ParameterNodeImpl).getParameter(), nodeFrom)
    or
    LocalFlow::localFlowSsaParamInput(nodeFrom, nodeTo)
    or
    nodeTo.(SynthReturnNode).getAnInput() = nodeFrom
    or
    LocalFlow::localSsaFlowStepUseUse(_, nodeFrom, nodeTo) and
    not FlowSummaryImpl::Private::Steps::prohibitsUseUseFlow(nodeFrom, _)
    or
    // Flow into phi node from read
    exists(CfgNodes::ExprCfgNode exprFrom |
      LocalFlow::localFlowSsaInputFromRead(exprFrom, _, nodeTo)
    |
      exprFrom = nodeFrom.asExpr() and
      not FlowSummaryImpl::Private::Steps::prohibitsUseUseFlow(nodeFrom, _)
      or
      exprFrom = nodeFrom.(PostUpdateNode).getPreUpdateNode().asExpr()
    )
    or
    FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom, nodeTo, true)
  }

  /** This is the local flow predicate that is exposed. */
  cached
  predicate localFlowStepImpl(Node nodeFrom, Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
    or
    defaultValueFlow(nodeTo.(ParameterNodeImpl).getParameter(), nodeFrom)
    or
    LocalFlow::localFlowSsaParamInput(nodeFrom, nodeTo)
    or
    LocalFlow::localSsaFlowStepUseUse(_, nodeFrom, nodeTo)
    or
    // Simple flow through library code is included in the exposed local
    // step relation, even though flow is technically inter-procedural
    FlowSummaryImpl::Private::Steps::summaryThroughStepValue(nodeFrom, nodeTo, _)
  }

  /**
   * This is the local flow predicate that is used in type tracking.
   *
   * This needs to exclude `localFlowSsaParamInput` due to a performance trick
   * in type tracking, where such steps are treated as call steps.
   */
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
    or
    // Flow into phi node from read
    exists(CfgNodes::ExprCfgNode exprFrom |
      LocalFlow::localFlowSsaInputFromRead(exprFrom, _, nodeTo) and
      exprFrom = [nodeFrom.asExpr(), nodeFrom.(PostUpdateNode).getPreUpdateNode().asExpr()]
    )
  }

  private predicate entrySsaDefinition(SsaDefinitionExtNode n) {
    n = LocalFlow::getParameterDefNode(_)
    or
    exists(SsaImpl::DefinitionExt def | def = n.getDefinitionExt() |
      def instanceof Ssa::SelfDefinition
      or
      def instanceof Ssa::CapturedEntryDefinition
    )
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

  cached
  predicate isLocalSourceNode(Node n) {
    n instanceof TParameterNode
    or
    // Expressions that can't be reached from another entry definition or expression
    n instanceof ExprNode and
    not reachedFromExprOrEntrySsaDef(n)
    or
    // Ensure all entry SSA definitions are local sources -- for parameters, this
    // is needed by type tracking
    entrySsaDefinition(n)
    or
    // Needed for flow out in type tracking
    n instanceof SynthReturnNode
    or
    // Needed for stores in type tracking
    TypeTrackerSpecific::storeStepIntoSourceNode(_, n, _)
  }

  cached
  newtype TOptionalContentSet =
    TSingletonContent(Content c) or
    TAnyElementContent() or
    TKnownOrUnknownElementContent(Content::KnownElementContent c) or
    TElementLowerBoundContent(int lower, boolean includeUnknown) {
      FlowSummaryImplSpecific::ParsePositions::isParsedElementLowerBoundPosition(_, includeUnknown,
        lower)
    } or
    TElementContentOfTypeContent(string type, Boolean includeUnknown) {
      type = any(Content::KnownElementContent content).getIndex().getValueType()
    } or
    TNoContentSet() // Only used by type-tracking

  cached
  class TContentSet =
    TSingletonContent or TAnyElementContent or TKnownOrUnknownElementContent or
        TElementLowerBoundContent or TElementContentOfTypeContent;

  private predicate trackKnownValue(ConstantValue cv) {
    not cv.isFloat(_) and
    not cv.isComplex(_, _) and
    (
      not cv.isInt(_) or
      cv.getInt() in [0 .. 10]
    )
  }

  cached
  newtype TContent =
    TKnownElementContent(ConstantValue cv) { trackKnownValue(cv) } or
    TUnknownElementContent() or
    TFieldContent(string name) {
      name = any(InstanceVariable v).getName()
      or
      name = "@" + any(SetterMethodCall c).getTargetName()
      or
      // The following equation unfortunately leads to a non-monotonic recursion error:
      //    name = any(AccessPathToken a).getAnArgument("Field")
      // Therefore, we use the following instead to extract the field names from the
      // external model data. This, unfortunately, does not included any field names used
      // in models defined in QL code.
      exists(string input, string output |
        ModelOutput::relevantSummaryModel(_, _, input, output, _)
      |
        name = [input, output].regexpFind("(?<=(^|\\.)Field\\[)[^\\]]+(?=\\])", _, _).trim()
      )
    } or
    // Only used by type-tracking
    TAttributeName(string name) { name = any(SetterMethodCall c).getTargetName() }

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

  cached
  newtype TContentApprox =
    TUnknownElementContentApprox() or
    TKnownIntegerElementContentApprox() or
    TKnownElementContentApprox(string approx) { approx = approxKnownElementIndex(_) } or
    TNonElementContentApprox(Content c) { not c instanceof Content::ElementContent }
}

class TElementContent = TKnownElementContent or TUnknownElementContent;

import Cached

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) {
  exists(SsaImpl::DefinitionExt def | def = n.(SsaDefinitionExtNode).getDefinitionExt() |
    def instanceof Ssa::PhiNode or
    def instanceof SsaImpl::PhiReadNode or
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
  or
  n instanceof SynthHashSplatParameterNode
  or
  n instanceof SynthHashSplatArgumentNode
}

/** An SSA definition, viewed as a node in a data flow graph. */
class SsaDefinitionExtNode extends NodeImpl, TSsaDefinitionExtNode {
  SsaImpl::DefinitionExt def;

  SsaDefinitionExtNode() { this = TSsaDefinitionExtNode(def) }

  /** Gets the underlying SSA definition. */
  SsaImpl::DefinitionExt getDefinitionExt() { result = def }

  /** Gets the underlying variable. */
  Variable getVariable() { result = def.getSourceVariable() }

  override CfgScope getCfgScope() { result = def.getBasicBlock().getScope() }

  override Location getLocationImpl() { result = def.getLocation() }

  override string toStringImpl() { result = def.toString() }
}

/** An SSA definition for a `self` variable. */
class SsaSelfDefinitionNode extends LocalSourceNode, SsaDefinitionExtNode {
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

    abstract predicate isParameterOf(DataFlowCallable c, ParameterPosition pos);

    final predicate isSourceParameterOf(Callable c, ParameterPosition pos) {
      exists(DataFlowCallable callable |
        this.isParameterOf(callable, pos) and
        c = callable.asCallable()
      )
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

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      exists(Callable callable | callable = c.asCallable() |
        exists(int i | pos.isPositional(i) and callable.getParameter(i) = parameter |
          parameter instanceof SimpleParameter
          or
          parameter instanceof OptionalParameter
        )
        or
        parameter =
          any(KeywordParameter kp |
            callable.getAParameter() = kp and
            pos.isKeyword(kp.getName())
          )
        or
        parameter = callable.getAParameter().(HashSplatParameter) and
        pos.isHashSplat()
        or
        parameter = callable.getParameter(0).(SplatParameter) and
        pos.isSplatAll()
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

    /** Gets the underlying `self` variable. */
    final SelfVariable getSelfVariable() { result.getDeclaringScope() = method }

    override Parameter getParameter() { none() }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      method = c.asCallable() and pos.isSelf()
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

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      c.asCallable() = method and pos.isBlock()
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

  /**
   * For all methods containing keyword parameters, we construct a synthesized
   * (hidden) parameter node to contain all keyword arguments. This allows us
   * to handle cases like
   *
   * ```rb
   * def foo(p1:, p2:)
   *   sink(p1)
   *   sink(p2)
   * end
   *
   * args = {:p1 => taint(1), :p2 => taint(2) }
   * foo(**args)
   * ```
   *
   * by adding read steps out of the synthesized parameter node to the relevant
   * keyword parameters.
   *
   * Note that this will introduce a bit of redundancy in cases like
   *
   * ```rb
   * foo(p1: taint(1), p2: taint(2))
   * ```
   *
   * where direct keyword matching is possible, since we construct a synthesized hash
   * splat argument (`SynthHashSplatArgumentNode`) at the call site, which means that
   * `taint(1)` will flow into `p1` both via normal keyword matching and via the synthesized
   * nodes (and similarly for `p2`). However, this redundancy is OK since
   *  (a) it means that type-tracking through keyword arguments also works in most cases,
   *  (b) read/store steps can be avoided when direct keyword matching is possible, and
   *      hence access path limits are not a concern, and
   *  (c) since the synthesized nodes are hidden, the reported data-flow paths will be
   *      collapsed anyway.
   */
  class SynthHashSplatParameterNode extends ParameterNodeImpl, TSynthHashSplatParameterNode {
    private DataFlowCallable callable;

    SynthHashSplatParameterNode() { this = TSynthHashSplatParameterNode(callable) }

    /**
     * Gets a keyword parameter that will be the result of reading `c` out of this
     * synthesized node.
     */
    ParameterNode getAKeywordParameter(ContentSet c) {
      exists(string name |
        isParameterNode(result, callable, any(ParameterPosition p | p.isKeyword(name)))
      |
        c = getKeywordContent(name) or
        c.isSingleton(TUnknownElementContent())
      )
    }

    final override Parameter getParameter() { none() }

    final override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      c = callable and pos.isSynthHashSplat()
    }

    final override CfgScope getCfgScope() { result = callable.asCallable() }

    final override DataFlowCallable getEnclosingCallable() { result = callable }

    final override Location getLocationImpl() { result = callable.getLocation() }

    final override string toStringImpl() { result = "**kwargs" }
  }

  /** A parameter for a library callable with a flow summary. */
  class SummaryParameterNode extends ParameterNodeImpl, TSummaryParameterNode {
    private FlowSummaryImpl::Public::SummarizedCallable sc;
    private ParameterPosition pos_;

    SummaryParameterNode() { this = TSummaryParameterNode(sc, pos_) }

    override Parameter getParameter() { none() }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      sc = c.asLibraryCallable() and pos = pos_
    }

    override CfgScope getCfgScope() { none() }

    override DataFlowCallable getEnclosingCallable() { result.asLibraryCallable() = sc }

    override EmptyLocation getLocationImpl() { any() }

    override string toStringImpl() { result = "parameter " + pos_ + " of " + sc }
  }
}

import ParameterNodes

/** A data-flow node used to model flow summaries. */
class SummaryNode extends NodeImpl, TSummaryNode {
  FlowSummaryImpl::Public::SummarizedCallable c;
  FlowSummaryImpl::Private::SummaryNodeState state;

  SummaryNode() { this = TSummaryNode(c, state) }

  /** Gets the summarized callable that this node belongs to. */
  FlowSummaryImpl::Public::SummarizedCallable getSummarizedCallable() { result = c }

  override CfgScope getCfgScope() { none() }

  override DataFlowCallable getEnclosingCallable() { result.asLibraryCallable() = c }

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
        exists(CfgNodes::ExprCfgNode arg |
          arg = call.getAnArgument() and
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

  /**
   * A data-flow node that represents all keyword arguments wrapped in a hash.
   *
   * The callee is responsible for filtering out the keyword arguments that are
   * part of the method signature, such that those cannot end up in the hash-splat
   * parameter.
   */
  class SynthHashSplatArgumentNode extends ArgumentNode, TSynthHashSplatArgumentNode {
    CfgNodes::ExprNodes::CallCfgNode c;

    SynthHashSplatArgumentNode() { this = TSynthHashSplatArgumentNode(c) }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      this.sourceArgumentOf(call.asCall(), pos)
    }

    override predicate sourceArgumentOf(CfgNodes::ExprNodes::CallCfgNode call, ArgumentPosition pos) {
      call = c and
      pos.isHashSplat()
    }
  }

  private class SynthHashSplatArgumentNodeImpl extends NodeImpl, TSynthHashSplatArgumentNode {
    CfgNodes::ExprNodes::CallCfgNode c;

    SynthHashSplatArgumentNodeImpl() { this = TSynthHashSplatArgumentNode(c) }

    override CfgScope getCfgScope() { result = c.getExpr().getCfgScope() }

    override Location getLocationImpl() { result = c.getLocation() }

    override string toStringImpl() { result = "**" }
  }
}

import ArgumentNodes

/** A call to `new`. */
private class NewCall extends DataFlowCall {
  NewCall() { this.asCall().getExpr().(MethodCall).getMethodName() = "new" }
}

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
      else
        exists(CfgScope scope | scope = this.getCfgScope() |
          if isUserDefinedNew(scope)
          then result instanceof NewReturnKind
          else result instanceof NormalReturnKind
        )
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

    override ReturnKind getKind() {
      exists(CfgScope scope | scope = this.(NodeImpl).getCfgScope() |
        if isUserDefinedNew(scope)
        then result instanceof NewReturnKind
        else result instanceof NormalReturnKind
      )
    }
  }

  /**
   * A `self` node inside an `initialize` method through which data may return.
   *
   * For example, in
   *
   * ```rb
   * class C
   *   def initialize(x)
   *     @x = x
   *   end
   * end
   * ```
   *
   * the implicit `self` reference in `@x` will return data stored in the field
   * `x` out to the call `C.new`.
   */
  class InitializeReturnNode extends ExprPostUpdateNode, ReturningNode {
    InitializeReturnNode() {
      exists(Method initialize |
        this.getCfgScope() = initialize and
        initialize.getName() = "initialize" and
        initialize = any(ClassDeclaration c).getAMethod() and
        this.getPreUpdateNode().asExpr().getExpr() instanceof SelfVariableReadAccess
      )
    }

    override ReturnKind getKind() { result instanceof NewReturnKind }
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

    override ReturnKind getKind() {
      result = rk
      or
      exists(NewCall new |
        TLibraryCallable(c) = viableLibraryCallable(new) and
        result instanceof NewReturnKind
      )
    }
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
      if call instanceof NewCall
      then kind instanceof NewReturnKind
      else kind instanceof NormalReturnKind
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
  SsaImpl::captureFlowIn(_, pred.(SsaDefinitionExtNode).getDefinitionExt(),
    succ.(SsaDefinitionExtNode).getDefinitionExt())
  or
  SsaImpl::captureFlowOut(_, pred.(SsaDefinitionExtNode).getDefinitionExt(),
    succ.(SsaDefinitionExtNode).getDefinitionExt())
  or
  succ.asExpr().getExpr().(ConstantReadAccess).getValue() = pred.asExpr().getExpr()
  or
  FlowSummaryImpl::Private::Steps::summaryJumpStep(pred, succ)
  or
  any(AdditionalJumpStep s).step(pred, succ)
}

private ContentSet getKeywordContent(string name) {
  exists(ConstantValue::ConstantSymbolValue key |
    result.isSingleton(TKnownElementContent(key)) and
    key.isSymbol(name)
  )
}

/**
 * Subset of `storeStep` that should be shared with type-tracking.
 */
predicate storeStepCommon(Node node1, ContentSet c, Node node2) {
  // Wrap all key-value arguments in a synthesized hash-splat argument node
  exists(CfgNodes::ExprNodes::CallCfgNode call | node2 = TSynthHashSplatArgumentNode(call) |
    // symbol key
    exists(ArgumentPosition keywordPos, string name |
      node1.asExpr().(Argument).isArgumentOf(call, keywordPos) and
      keywordPos.isKeyword(name) and
      c = getKeywordContent(name)
    )
    or
    // non-symbol key
    exists(CfgNodes::ExprNodes::PairCfgNode pair, CfgNodes::ExprCfgNode key, ConstantValue cv |
      node1.asExpr() = pair.getValue() and
      pair = call.getAnArgument() and
      key = pair.getKey() and
      cv = key.getConstantValue() and
      not cv.isSymbol(_) and
      c.isSingleton(TKnownElementContent(cv))
    )
  )
}

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to
 * content `c`.
 */
predicate storeStep(Node node1, ContentSet c, Node node2) {
  // Instance variable assignment, `@var = src`
  node2.(PostUpdateNode).getPreUpdateNode().asExpr() =
    any(CfgNodes::ExprNodes::InstanceVariableWriteAccessCfgNode var |
      exists(CfgNodes::ExprNodes::AssignExprCfgNode assign |
        var = assign.getLhs() and
        node1.asExpr() = assign.getRhs()
      |
        c.isSingleton(any(Content::FieldContent ct |
            ct.getName() = var.getExpr().getVariable().getName()
          ))
      )
    ).getReceiver()
  or
  // Attribute assignment, `receiver.property = value`
  node2.(PostUpdateNode).getPreUpdateNode().asExpr() =
    any(CfgNodes::ExprNodes::MethodCallCfgNode call |
      node1.asExpr() = call.getArgument(0) and
      call.getNumberOfArguments() = 1 and
      c.isSingleton(any(Content::FieldContent ct |
          ct.getName() = "@" + call.getExpr().(SetterMethodCall).getTargetName()
        ))
    ).getReceiver()
  or
  FlowSummaryImpl::Private::Steps::summaryStoreStep(node1, c, node2)
  or
  storeStepCommon(node1, c, node2)
}

/**
 * Holds if there is a read step of content `c` from `node1` to `node2`.
 */
predicate readStep(Node node1, ContentSet c, Node node2) {
  // Instance variable read access, `@var`
  node2.asExpr() =
    any(CfgNodes::ExprNodes::InstanceVariableReadAccessCfgNode var |
      node1.asExpr() = var.getReceiver() and
      c.isSingleton(any(Content::FieldContent ct |
          ct.getName() = var.getExpr().getVariable().getName()
        ))
    )
  or
  // Attribute read, `receiver.field`. Note that we do not check whether
  // the `field` method is really an attribute reader. This is probably fine
  // because the read step has only effect if there exists a matching store step
  // (instance variable assignment or setter method call).
  node2.asExpr() =
    any(CfgNodes::ExprNodes::MethodCallCfgNode call |
      node1.asExpr() =
        any(CfgNodes::ExprCfgNode e | e = call.getReceiver() and isNonConstantExpr(e)) and
      call.getNumberOfArguments() = 0 and
      c.isSingleton(any(Content::FieldContent ct |
          ct.getName() = "@" + call.getExpr().getMethodName()
        ))
    )
  or
  node2 = node1.(SynthHashSplatParameterNode).getAKeywordParameter(c)
  or
  FlowSummaryImpl::Private::Steps::summaryReadStep(node1, c, node2)
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`. For example,
 * any value stored inside `f` is cleared at the pre-update node associated with `x`
 * in `x.f = newValue`.
 */
predicate clearsContent(Node n, ContentSet c) {
  FlowSummaryImpl::Private::Steps::summaryClearsContent(n, c)
  or
  // Filter out keyword arguments that are part of the method signature from
  // the hash-splat parameter
  exists(
    DataFlowCallable callable, HashSplatParameter hashSplatParam, ParameterNodeImpl keywordParam,
    ParameterPosition keywordPos, string name
  |
    n = TNormalParameterNode(hashSplatParam) and
    callable.asCallable() = hashSplatParam.getCallable() and
    keywordParam.isParameterOf(callable, keywordPos) and
    keywordPos.isKeyword(name) and
    c = getKeywordContent(name)
  )
}

/**
 * Holds if the value that is being tracked is expected to be stored inside content `c`
 * at node `n`.
 */
predicate expectsContent(Node n, ContentSet c) {
  FlowSummaryImpl::Private::Steps::summaryExpectsContent(n, c)
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

    override ExprNode getPreUpdateNode() {
      // For compound arguments, such as `m(if b then x else y)`, we want the leaf nodes
      // `[post] x` and `[post] y` to have two pre-update nodes: (1) the compound argument,
      // `if b then x else y`; and the (2) the underlying expressions; `x` and `y`,
      // respectively.
      //
      // This ensures that we get flow out of the call into both leafs (1), while still
      // maintaining the invariant that the underlying expression is a pre-update node (2).
      e = getAPostUpdateNodeForArg(result.getExprNode())
      or
      e = result.getExprNode()
    }

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
class CastNode extends Node instanceof ReturningNode { }

class DataFlowExpr = CfgNodes::ExprCfgNode;

int accessPathLimit() { result = 5 }

/**
 * Holds if access paths with `c` at their head always should be tracked at high
 * precision. This disables adaptive access path precision for such access paths.
 */
predicate forceHighPrecision(Content c) { c instanceof Content::ElementContent }

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
        mc.getExpr().getMethodName() = ["lambda", "proc"]
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

/** An approximated `Content`. */
class ContentApprox extends TContentApprox {
  string toString() {
    this = TUnknownElementContentApprox() and
    result = "element"
    or
    this = TKnownIntegerElementContentApprox() and
    result = "approximated integer element"
    or
    exists(string approx |
      this = TKnownElementContentApprox(approx) and
      result = "approximated element " + approx
    )
    or
    exists(Content c |
      this = TNonElementContentApprox(c) and
      result = c.toString()
    )
  }
}

/**
 * Gets a string for approximating known element indices.
 *
 * We take two characters from the serialized index as the projection,
 * since for symbols this will include the first character.
 */
private string approxKnownElementIndex(Content::KnownElementContent c) {
  not c.getIndex().isInt(_) and
  exists(string s | s = c.getIndex().serialize() |
    s.length() < 2 and
    result = s
    or
    result = s.prefix(2)
    or
    // workaround for `prefix` not working with Unicode characters
    s.length() >= 2 and
    not exists(s.prefix(2)) and
    result = s
  )
}

/** Gets an approximated value for content `c`. */
ContentApprox getContentApprox(Content c) {
  c instanceof Content::UnknownElementContent and
  result = TUnknownElementContentApprox()
  or
  c.(Content::KnownElementContent).getIndex().isInt(_) and
  result = TKnownIntegerElementContentApprox()
  or
  result = TKnownElementContentApprox(approxKnownElementIndex(c))
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

/**
 * Gets an additional term that is added to the `join` and `branch` computations to reflect
 * an additional forward or backwards branching factor that is not taken into account
 * when calculating the (virtual) dispatch cost.
 *
 * Argument `arg` is part of a path from a source to a sink, and `p` is the target parameter.
 */
int getAdditionalFlowIntoCallNodeTerm(ArgumentNode arg, ParameterNode p) { none() }
