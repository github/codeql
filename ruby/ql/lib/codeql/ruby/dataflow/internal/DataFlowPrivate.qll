private import codeql.util.Boolean
private import codeql.util.Unit
private import codeql.ruby.AST
private import codeql.ruby.ast.internal.Synthesis
private import codeql.ruby.CFG
private import codeql.ruby.dataflow.SSA
private import DataFlowPublic
private import DataFlowDispatch
private import SsaImpl as SsaImpl
private import FlowSummaryImpl as FlowSummaryImpl
private import codeql.ruby.frameworks.data.ModelsAsData

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

/** An SSA definition into which another SSA definition may flow. */
class SsaInputDefinitionExt extends SsaImpl::DefinitionExt {
  SsaInputDefinitionExt() {
    this instanceof Ssa::PhiNode
    or
    this instanceof SsaImpl::PhiReadNode
  }

  predicate hasInputFromBlock(SsaImpl::DefinitionExt def, BasicBlock bb, int i, BasicBlock input) {
    SsaImpl::lastRefBeforeRedefExt(def, bb, i, input, this)
  }
}

/** Provides predicates related to local data flow. */
module LocalFlow {
  /**
   * Holds if `nodeFrom` is a node for SSA definition `def`, which can reach `next`.
   */
  pragma[nomagic]
  private predicate localFlowSsaInputFromDef(
    SsaDefinitionExtNode nodeFrom, SsaImpl::DefinitionExt def, SsaInputNode nodeTo
  ) {
    exists(BasicBlock bb, int i, BasicBlock input, SsaInputDefinitionExt next |
      next.hasInputFromBlock(def, bb, i, input) and
      def = nodeFrom.getDefinitionExt() and
      def.definesAt(_, bb, i, _) and
      nodeTo = TSsaInputNode(next, input)
    )
  }

  /**
   * Holds if `nodeFrom` is a last read of SSA definition `def`, which
   * can reach `nodeTo`.
   */
  pragma[nomagic]
  predicate localFlowSsaInputFromRead(SsaImpl::DefinitionExt def, Node nodeFrom, SsaInputNode nodeTo) {
    exists(
      BasicBlock bb, int i, CfgNodes::ExprCfgNode exprFrom, BasicBlock input,
      SsaInputDefinitionExt next
    |
      next.hasInputFromBlock(def, bb, i, input) and
      exprFrom = bb.getNode(i) and
      exprFrom.getExpr() instanceof VariableReadAccess and
      exprFrom = [nodeFrom.asExpr(), nodeFrom.(PostUpdateNodeImpl).getPreUpdateNode().asExpr()] and
      nodeTo = TSsaInputNode(next, input)
    )
  }

  /** Gets the SSA definition node corresponding to parameter `p`. */
  pragma[nomagic]
  SsaDefinitionExtNode getParameterDefNode(NamedParameter p) {
    exists(BasicBlock bb, int i |
      bb.getNode(i).getAstNode() = p.getDefiningAccess() and
      result.getDefinitionExt().definesAt(_, bb, i, _)
    )
  }

  /**
   * Holds if `nodeFrom` is a parameter node, and `nodeTo` is a corresponding SSA node.
   */
  pragma[nomagic]
  predicate localFlowSsaParamInput(ParameterNodeImpl nodeFrom, SsaDefinitionExtNode nodeTo) {
    nodeTo = getParameterDefNode(nodeFrom.getParameter())
    or
    nodeTo.getDefinitionExt() = nodeFrom.(SelfParameterNodeImpl).getSelfDefinition()
  }

  /**
   * Holds if there is a local use-use flow step from `nodeFrom` to `nodeTo`
   * involving SSA definition `def`.
   */
  predicate localSsaFlowStepUseUse(SsaImpl::DefinitionExt def, Node nodeFrom, Node nodeTo) {
    SsaImpl::adjacentReadPairExt(def, nodeFrom.asExpr(), nodeTo.asExpr())
  }

  /**
   * Holds if SSA definition `def` assigns `value` to the underlying variable.
   *
   * This is either a direct assignment, `x = value`, or an assignment via
   * simple pattern matching
   *
   * ```rb
   * case value
   *  in Foo => x then ...
   *  in y => then ...
   * end
   * ```
   */
  predicate ssaDefAssigns(Ssa::WriteDefinition def, CfgNodes::ExprCfgNode value) {
    def.assigns(value)
    or
    exists(CfgNodes::ExprNodes::CaseExprCfgNode case, CfgNodes::AstCfgNode pattern |
      case.getValue() = value and
      pattern = case.getBranch(_).(CfgNodes::ExprNodes::InClauseCfgNode).getPattern()
    |
      def.getWriteAccess() = pattern
      or
      def.getWriteAccess() = pattern.(CfgNodes::ExprNodes::AsPatternCfgNode).getVariableAccess()
    )
  }

  /**
   * Holds if there is a local flow step from `nodeFrom` to `nodeTo` involving
   * SSA definition `def`.
   */
  pragma[nomagic]
  predicate localSsaFlowStep(SsaImpl::DefinitionExt def, Node nodeFrom, Node nodeTo) {
    // Flow from assignment into SSA definition
    ssaDefAssigns(def, nodeFrom.asExpr()) and
    nodeTo.(SsaDefinitionExtNode).getDefinitionExt() = def
    or
    // Flow from SSA definition to first read
    def = nodeFrom.(SsaDefinitionExtNode).getDefinitionExt() and
    SsaImpl::firstReadExt(def, nodeTo.asExpr())
    or
    // Flow from post-update read to next read
    localSsaFlowStepUseUse(def, nodeFrom.(PostUpdateNodeImpl).getPreUpdateNode(), nodeTo)
    or
    // Flow into phi (read) SSA definition node from def
    localFlowSsaInputFromDef(nodeFrom, def, nodeTo)
    or
    nodeTo.(SsaDefinitionExtNode).getDefinitionExt() = def and
    def = nodeFrom.(SsaInputNode).getDefinitionExt()
    or
    localFlowSsaParamInput(nodeFrom, nodeTo) and
    def = nodeTo.(SsaDefinitionExtNode).getDefinitionExt()
  }

  pragma[nomagic]
  predicate localFlowStepCommon(Node nodeFrom, Node nodeTo) {
    nodeFrom.asExpr() = nodeTo.asExpr().(CfgNodes::ExprNodes::BlockArgumentCfgNode).getValue()
    or
    nodeFrom.asExpr() = getALastEvalNode(nodeTo.asExpr())
    or
    exists(CfgNodes::ExprCfgNode exprTo, ReturningStatementNode n |
      nodeFrom = n and
      exprTo = nodeTo.asExpr() and
      n.getReturningNode().getAstNode() instanceof BreakStmt and
      exprTo.getAstNode() instanceof Loop and
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
        op.getExpr() instanceof LogicalOrExpr and
        nodeFrom.asExpr() = op.getAnOperand()
        or
        op.getExpr() instanceof LogicalAndExpr and nodeFrom.asExpr() = op.getRightOperand()
      )
    or
    nodeTo.(ParameterNodeImpl).getParameter() =
      any(NamedParameter p |
        p.(OptionalParameter).getDefaultValue() = nodeFrom.asExpr().getExpr()
        or
        p.(KeywordParameter).getDefaultValue() = nodeFrom.asExpr().getExpr()
      )
    or
    nodeTo.(BlockArgumentNode).getParameterNode(true) = nodeFrom
  }

  predicate flowSummaryLocalStep(
    FlowSummaryNode nodeFrom, FlowSummaryNode nodeTo, FlowSummaryImpl::Public::SummarizedCallable c,
    string model
  ) {
    FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom.getSummaryNode(),
      nodeTo.getSummaryNode(), true, model) and
    c = nodeFrom.getSummarizedCallable()
  }

  predicate localMustFlowStep(Node node1, Node node2) {
    LocalFlow::localFlowSsaParamInput(node1, node2)
    or
    exists(SsaImpl::Definition def |
      def.(Ssa::WriteDefinition).assigns(node1.asExpr()) and
      node2.(SsaDefinitionExtNode).getDefinitionExt() = def
      or
      def = node1.(SsaDefinitionExtNode).getDefinitionExt() and
      node2.asExpr() = SsaImpl::getARead(def)
    )
    or
    node1.asExpr() = node2.asExpr().(CfgNodes::ExprNodes::AssignExprCfgNode).getRhs()
    or
    node1.asExpr() = node2.asExpr().(CfgNodes::ExprNodes::BlockArgumentCfgNode).getValue()
    or
    node1 = node2.(BlockArgumentNode).getParameterNode(true)
    or
    node1 =
      unique(FlowSummaryNode n1 |
        FlowSummaryImpl::Private::Steps::summaryLocalStep(n1.getSummaryNode(),
          node2.(FlowSummaryNode).getSummaryNode(), true, _)
      )
  }
}

/** An argument of a call (including qualifier arguments and block arguments). */
private class Argument extends CfgNodes::ExprCfgNode {
  private CfgNodes::ExprNodes::CallCfgNode call;
  private ArgumentPosition arg;

  Argument() {
    exists(int i |
      this = call.getArgument(i) and
      not this.getExpr() instanceof BlockArgument and
      not this.getExpr().(Pair).getKey().getConstantValue().isSymbol(_) and
      not this.getExpr() instanceof HashSplatExpr and
      not this.getExpr() instanceof SplatExpr and
      arg.isPositional(i)
    )
    or
    exists(CfgNodes::ExprNodes::PairCfgNode p |
      p = call.getArgument(_) and
      this = p.getValue() and
      arg.isKeyword(p.getKey().getConstantValue().getSymbol())
    )
    or
    this = call.getReceiver() and
    arg.isSelf()
    or
    lambdaCallExpr(call, this) and
    arg.isLambdaSelf()
    or
    this = call.getAnArgument() and
    this.getExpr() instanceof HashSplatExpr and
    arg.isHashSplat()
    or
    exists(int pos |
      this = call.getArgument(pos) and
      this.getExpr() instanceof SplatExpr and
      arg.isSplat(pos)
    )
    or
    this = call.getAnArgument() and
    this.getExpr() instanceof BlockArgument and
    arg.isBlock()
    or
    this = call.getBlock() and
    arg.isBlock()
  }

  /** Holds if this expression is the `i`th argument of `c`. */
  predicate isArgumentOf(CfgNodes::ExprNodes::CallCfgNode c, ArgumentPosition pos) {
    c = call and pos = arg
  }
}

/** Holds if `n` is not a constant expression. */
predicate isNonConstantExpr(CfgNodes::ExprCfgNode n) {
  not exists(ConstantValue cv |
    cv = n.getConstantValue() and
    // strings are mutable in Ruby
    not cv.isString(_)
  ) and
  not n.getExpr() instanceof ConstantAccess
}

/** Provides logic related to captured variables. */
module VariableCapture {
  private import codeql.dataflow.VariableCapture as Shared

  private predicate closureFlowStep(CfgNodes::ExprCfgNode e1, CfgNodes::ExprCfgNode e2) {
    e1 = getALastEvalNode(e2)
    or
    exists(Ssa::Definition def |
      def.getARead() = e2 and
      LocalFlow::ssaDefAssigns(def.getAnUltimateDefinition(), e1)
    )
  }

  private module CaptureInput implements Shared::InputSig<Location> {
    private import ruby as R
    private import codeql.ruby.controlflow.ControlFlowGraph
    private import codeql.ruby.controlflow.BasicBlocks as BasicBlocks
    private import TaintTrackingPrivate as TaintTrackingPrivate

    class BasicBlock extends BasicBlocks::BasicBlock {
      Callable getEnclosingCallable() { result = this.getScope() }
    }

    BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) {
      result = bb.getImmediateDominator()
    }

    BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

    class CapturedVariable extends LocalVariable {
      CapturedVariable() {
        this.isCaptured() and
        TaintTrackingPrivate::forceCachingInSameStage()
      }

      Callable getCallable() {
        exists(Scope scope | scope = this.getDeclaringScope() |
          result = scope
          or
          result = scope.(ModuleBase).getCfgScope()
        )
      }
    }

    abstract class CapturedParameter extends CapturedVariable {
      abstract ParameterNode getParameterNode();
    }

    private class CapturedNamedParameter extends CapturedParameter {
      private NamedParameter p;

      CapturedNamedParameter() { this = p.getVariable() }

      override ParameterNode getParameterNode() { result.asParameter() = p }
    }

    private class CapturedSelfParameter extends CapturedParameter, SelfVariable {
      override SelfParameterNode getParameterNode() { this = result.getSelfVariable() }
    }

    class Expr extends CfgNodes::ExprCfgNode {
      predicate hasCfgNode(BasicBlock bb, int i) { this = bb.getNode(i) }
    }

    class VariableWrite extends Expr, CfgNodes::ExprNodes::AssignExprCfgNode {
      CapturedVariable v;

      VariableWrite() { v = this.getLhs().getVariable() }

      CapturedVariable getVariable() { result = v }
    }

    class VariableRead extends Expr instanceof CfgNodes::ExprNodes::LocalVariableReadAccessCfgNode {
      CapturedVariable v;

      VariableRead() { v = super.getVariable() }

      CapturedVariable getVariable() { result = v }
    }

    class ClosureExpr extends Expr {
      Callable c;

      ClosureExpr() { lambdaCreationExpr(this, _, c) }

      predicate hasBody(Callable body) { body = c }

      predicate hasAliasedAccess(Expr f) { closureFlowStep+(this, f) and not closureFlowStep(f, _) }
    }

    class Callable extends CfgScope {
      predicate isConstructor() { none() }
    }
  }

  class CapturedVariable = CaptureInput::CapturedVariable;

  class ClosureExpr = CaptureInput::ClosureExpr;

  module Flow = Shared::Flow<Location, CaptureInput>;

  private Flow::ClosureNode asClosureNode(Node n) {
    result = n.(CaptureNode).getSynthesizedCaptureNode()
    or
    result.(Flow::ExprNode).getExpr() = n.asExpr()
    or
    result.(Flow::VariableWriteSourceNode).getVariableWrite().getRhs() = n.asExpr()
    or
    result.(Flow::ExprPostUpdateNode).getExpr() = n.(PostUpdateNode).getPreUpdateNode().asExpr()
    or
    result.(Flow::ParameterNode).getParameter().getParameterNode() = n
    or
    result.(Flow::ThisParameterNode).getCallable() = n.(LambdaSelfReferenceNode).getCallable()
  }

  predicate storeStep(Node node1, Content::CapturedVariableContent c, Node node2) {
    Flow::storeStep(asClosureNode(node1), c.getVariable(), asClosureNode(node2))
  }

  predicate readStep(Node node1, Content::CapturedVariableContent c, Node node2) {
    Flow::readStep(asClosureNode(node1), c.getVariable(), asClosureNode(node2))
  }

  predicate valueStep(Node node1, Node node2) {
    Flow::localFlowStep(asClosureNode(node1), asClosureNode(node2))
  }

  predicate clearsContent(Node node, Content::CapturedVariableContent c) {
    Flow::clearsContent(asClosureNode(node), c.getVariable())
  }

  class CapturedSsaDefinitionExt extends SsaImpl::DefinitionExt {
    CapturedSsaDefinitionExt() { this.getSourceVariable() instanceof CapturedVariable }
  }

  // From an assignment or implicit initialization of a captured variable to its flow-insensitive node
  private predicate flowInsensitiveWriteStep(
    SsaDefinitionExtNode node1, CapturedVariableNode node2, CapturedVariable v
  ) {
    exists(CapturedSsaDefinitionExt def |
      def = node1.getDefinitionExt() and
      def.getSourceVariable() = v and
      (
        def instanceof Ssa::WriteDefinition
        or
        def instanceof Ssa::SelfDefinition
      ) and
      node2.getVariable() = v
    )
  }

  // From a captured variable node to its flow-sensitive capture nodes
  private predicate flowInsensitiveReadStep(
    CapturedVariableNode node1, SsaDefinitionExtNode node2, CapturedVariable v
  ) {
    exists(CapturedSsaDefinitionExt def |
      node1.getVariable() = v and
      def = node2.getDefinitionExt() and
      def.getSourceVariable() = v and
      (
        def instanceof Ssa::CapturedCallDefinition
        or
        def instanceof Ssa::CapturedEntryDefinition
      )
    )
  }

  /**
   * Holds if there is control-flow insensitive data-flow from `node1` to `node2`
   * involving a captured variable. Only used in type tracking.
   */
  predicate flowInsensitiveStep(Node node1, Node node2) {
    exists(CapturedVariable v |
      flowInsensitiveWriteStep(node1, node2, v) and
      flowInsensitiveReadStep(_, _, v)
      or
      flowInsensitiveReadStep(node1, node2, v) and
      flowInsensitiveWriteStep(_, _, v)
    )
  }
}

private predicate splatParameterAt(Callable c, int pos) {
  c.getParameter(pos) instanceof SplatParameter
}

private predicate splatArgumentAt(CfgNodes::ExprNodes::CallCfgNode c, int pos) {
  exists(Argument arg, ArgumentPosition apos | arg.isArgumentOf(c, apos) and apos.isSplat(pos))
}

/** A collection of cached types and predicates to be evaluated in the same stage. */
cached
private module Cached {
  private import codeql.ruby.typetracking.internal.TypeTrackingImpl

  cached
  newtype TNode =
    TExprNode(CfgNodes::ExprCfgNode n) or
    TReturningNode(CfgNodes::ReturningCfgNode n) { exists(n.getReturnedValueNode()) } or
    TSsaDefinitionExtNode(SsaImpl::DefinitionExt def) or
    TSsaInputNode(SsaInputDefinitionExt def, BasicBlock input) {
      def.hasInputFromBlock(_, _, _, input)
    } or
    TCapturedVariableNode(VariableCapture::CapturedVariable v) or
    TNormalParameterNode(Parameter p) {
      p instanceof SimpleParameter or
      p instanceof OptionalParameter or
      p instanceof KeywordParameter or
      p instanceof HashSplatParameter or
      p instanceof SplatParameter
    } or
    TSelfMethodParameterNode(MethodBase m) or
    TSelfToplevelParameterNode(Toplevel t) or
    TLambdaSelfReferenceNode(Callable c) { lambdaCreationExpr(_, _, c) } or
    TBlockParameterNode(MethodBase m) or
    TBlockArgumentNode(CfgNodes::ExprNodes::CallCfgNode yield) {
      yield = any(BlockParameterNode b).getAYieldCall()
    } or
    TSynthHashSplatParameterNode(DataFlowCallable c) {
      isParameterNode(_, c, any(ParameterPosition p | p.isKeyword(_)))
    } or
    TSynthSplatParameterNode(DataFlowCallable c) {
      exists(c.asCfgScope()) and // exclude library callables (for now)
      isParameterNode(_, c, any(ParameterPosition p | p.isPositional(_)))
    } or
    TSynthSplatParameterShiftNode(DataFlowCallable c, int splatPos, int n) {
      splatPos = unique(int i | splatParameterAt(c.asCfgScope(), i) and i > 0) and
      n in [0 .. 10]
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
    TFlowSummaryNode(FlowSummaryImpl::Private::SummaryNode sn) or
    TSynthHashSplatArgumentNode(CfgNodes::ExprNodes::CallCfgNode c) {
      ArgumentNodes::synthHashSplatStore(c, _, _)
    } or
    TSynthSplatArgumentNode(CfgNodes::ExprNodes::CallCfgNode c) {
      ArgumentNodes::synthSplatStore(c, _, _)
    } or
    TSynthSplatArgumentShiftNode(CfgNodes::ExprNodes::CallCfgNode c, int splatPos, int n) {
      // we use -1 to represent data at an unknown index
      n in [-1 .. 10] and
      splatPos = unique(int i | splatArgumentAt(c, i) and i > 0)
    } or
    TCaptureNode(VariableCapture::Flow::SynthesizedCaptureNode cn) or
    TForbiddenRecursionGuard() {
      none() and
      // We want to prune irrelevant models before materialising data flow nodes, so types contributed
      // directly from CodeQL must expose their pruning info without depending on data flow nodes.
      (any(ModelInput::TypeModel tm).isTypeUsed("") implies any())
    }

  class TSelfParameterNode = TSelfMethodParameterNode or TSelfToplevelParameterNode;

  class TSourceParameterNode =
    TNormalParameterNode or TBlockParameterNode or TSelfParameterNode or
        TSynthHashSplatParameterNode or TSynthSplatParameterNode;

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
      exists(SsaImpl::DefinitionExt def |
        // captured variables are handled by the shared `VariableCapture` library
        not def instanceof VariableCapture::CapturedSsaDefinitionExt
      |
        LocalFlow::localSsaFlowStep(def, nodeFrom, nodeTo)
        or
        LocalFlow::localSsaFlowStepUseUse(def, nodeFrom, nodeTo) and
        not FlowSummaryImpl::Private::Steps::prohibitsUseUseFlow(nodeFrom, _)
        or
        LocalFlow::localFlowSsaInputFromRead(def, nodeFrom, nodeTo) and
        not FlowSummaryImpl::Private::Steps::prohibitsUseUseFlow(nodeFrom, _)
      )
      or
      VariableCapture::valueStep(nodeFrom, nodeTo)
    ) and
    model = ""
    or
    LocalFlow::flowSummaryLocalStep(nodeFrom, nodeTo, _, model)
  }

  /** This is the local flow predicate that is exposed. */
  cached
  predicate localFlowStepImpl(Node nodeFrom, Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
    or
    LocalFlow::localSsaFlowStep(_, nodeFrom, nodeTo)
    or
    LocalFlow::localSsaFlowStepUseUse(_, nodeFrom, nodeTo)
    or
    // Simple flow through library code is included in the exposed local
    // step relation, even though flow is technically inter-procedural
    FlowSummaryImpl::Private::Steps::summaryThroughStepValue(nodeFrom, nodeTo, _)
  }

  /**
   * This is the local flow predicate that is used in type tracking.
   */
  cached
  predicate localFlowStepTypeTracker(Node nodeFrom, Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
    or
    LocalFlow::localSsaFlowStep(_, nodeFrom, nodeTo)
    or
    LocalFlow::localSsaFlowStepUseUse(_, nodeFrom, nodeTo)
    or
    LocalFlow::localFlowSsaInputFromRead(_, nodeFrom, nodeTo)
    or
    VariableCapture::flowInsensitiveStep(nodeFrom, nodeTo)
    or
    LocalFlow::flowSummaryLocalStep(nodeFrom, nodeTo, any(LibraryCallableToIncludeInTypeTracking c),
      _)
  }

  /** Holds if `n` wraps an SSA definition without ingoing flow. */
  private predicate entrySsaDefinition(SsaDefinitionExtNode n) {
    n.getDefinitionExt() = any(SsaImpl::WriteDefinition def | not LocalFlow::ssaDefAssigns(def, _))
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
    n instanceof TSourceParameterNode
    or
    n instanceof SummaryParameterNode
    or
    // Expressions that can't be reached from another entry definition or expression
    n instanceof ExprNode and
    not reachedFromExprOrEntrySsaDef(n)
    or
    // Ensure all entry SSA definitions are local sources, except those that correspond
    // to parameters (which are themselves local sources)
    entrySsaDefinition(n) and
    not LocalFlow::localFlowSsaParamInput(_, n)
    or
    isStoreTargetNode(n)
    or
    TypeTrackingInput::loadStep(_, n, _)
    or
    n instanceof BlockArgumentNode
  }

  cached
  newtype TOptionalContentSet =
    TSingletonContent(Content c) or
    TAnyElementContent() or
    TAnyContent() or
    TKnownOrUnknownElementContent(Content::KnownElementContent c) or
    TElementLowerBoundContent(int lower, boolean includeUnknown) {
      FlowSummaryImpl::ParsePositions::isParsedElementLowerBoundPosition(_, includeUnknown, lower)
    } or
    TElementContentOfTypeContent(string type, Boolean includeUnknown) {
      type = any(Content::KnownElementContent content).getIndex().getValueType()
    } or
    deprecated TNoContentSet() // Only used by type-tracking

  cached
  class TContentSet =
    TSingletonContent or TAnyElementContent or TAnyContent or TKnownOrUnknownElementContent or
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
        ModelOutput::relevantSummaryModel(_, _, input, output, _, _)
      |
        name = [input, output].regexpFind("(?<=(^|\\.)Field\\[)[^\\]]+(?=\\])", _, _).trim()
      )
    } or
    TSplatContent(int i, Boolean shifted) { i in [0 .. 10] } or
    THashSplatContent(ConstantValue::ConstantSymbolValue cv) or
    TCapturedVariableContent(VariableCapture::CapturedVariable v) or
    // Only used by type-tracking
    TAttributeName(string name) { name = any(SetterMethodCall c).getTargetName() }

  /**
   * Holds if `e` is an `ExprNode` that may be returned by a call to `c`.
   */
  cached
  predicate exprNodeReturnedFromCached(ExprNode e, Callable c) {
    exists(ReturnNode r |
      nodeGetEnclosingCallable(r).asCfgScope() = c and
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
    TSplatContentApprox(Boolean shifted) or
    THashSplatContentApprox(string approx) { approx = approxKnownElementIndex(_) } or
    TNonElementContentApprox(Content c) { not c instanceof Content::ElementContent } or
    TCapturedVariableContentApprox(VariableCapture::CapturedVariable v)

  cached
  newtype TDataFlowType =
    TLambdaDataFlowType(Callable c) { c = any(LambdaSelfReferenceNode n).getCallable() } or
    // In order to reduce the set of cons-candidates, we annotate all implicit (hash) splat
    // creations with the name of the method that they are passed into. This includes
    // array/hash literals as well (where the name is simply `[]`), because of how they
    // are modeled (see `Array.qll` and `Hash.qll`).
    TSynthHashSplatArgumentType(string methodName) {
      methodName = any(SynthHashSplatArgumentNode n).getMethodName()
    } or
    TSynthSplatArgumentType(string methodName) {
      methodName = any(SynthSplatArgumentNode n).getMethodName()
    } or
    TUnknownDataFlowType()
}

class TElementContent =
  TKnownElementContent or TUnknownElementContent or TSplatContent or THashSplatContent;

import Cached

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) {
  n.(SsaDefinitionExtNode).isHidden()
  or
  n instanceof SsaInputNode
  or
  n = LocalFlow::getParameterDefNode(_)
  or
  exists(AstNode desug |
    isDesugarNode(desug) and
    desug.isSynthesized() and
    not desug = [any(ArrayLiteral al).getDesugared(), any(HashLiteral hl).getDesugared()]
  |
    desug = n.asExpr().getExpr()
    or
    desug = n.(PostUpdateNode).getPreUpdateNode().asExpr().getExpr()
    or
    desug = n.(ParameterNode).getParameter()
  )
  or
  n instanceof FlowSummaryNode
  or
  n instanceof SynthHashSplatParameterNode
  or
  n instanceof SynthHashSplatArgumentNode
  or
  n instanceof SynthSplatParameterNode
  or
  n instanceof SynthSplatArgumentNode
  or
  n instanceof SynthSplatParameterShiftNode
  or
  n instanceof SynthSplatArgumentShiftNode
  or
  n instanceof LambdaSelfReferenceNode
  or
  n instanceof CaptureNode
  or
  n instanceof BlockArgumentNode
}

/** An SSA definition, viewed as a node in a data flow graph. */
class SsaDefinitionExtNode extends NodeImpl, TSsaDefinitionExtNode {
  SsaImpl::DefinitionExt def;

  SsaDefinitionExtNode() { this = TSsaDefinitionExtNode(def) }

  /** Gets the underlying SSA definition. */
  SsaImpl::DefinitionExt getDefinitionExt() { result = def }

  /** Gets the underlying variable. */
  Variable getVariable() { result = def.getSourceVariable() }

  /** Holds if this node should be hidden from path explanations. */
  predicate isHidden() {
    not def instanceof Ssa::WriteDefinition
    or
    isDesugarNode(def.(Ssa::WriteDefinition).getWriteAccess().getExpr())
  }

  override CfgScope getCfgScope() { result = def.getBasicBlock().getScope() }

  override Location getLocationImpl() { result = def.getLocation() }

  override string toStringImpl() { result = def.toString() }
}

/**
 * A node that represents an input to an SSA phi (read) definition.
 *
 * This allows for barrier guards to filter input to phi nodes. For example, in
 *
 * ```rb
 * x = taint
 * if x != "safe" then
 *     x = "safe"
 * end
 * sink x
 * ```
 *
 * the `false` edge out of `x != "safe"` guards the input from `x = taint` into the
 * `phi` node after the condition.
 *
 * It is also relevant to filter input into phi read nodes:
 *
 * ```rb
 * x = taint
 * if b then
 *     if x != "safe1" then
 *         return
 *     end
 * else
 *     if x != "safe2" then
 *         return
 *     end
 * end
 *
 * sink x
 * ```
 *
 * both inputs into the phi read node after the outer condition are guarded.
 */
class SsaInputNode extends NodeImpl, TSsaInputNode {
  SsaImpl::DefinitionExt def;
  BasicBlock input;

  SsaInputNode() { this = TSsaInputNode(def, input) }

  /** Gets the underlying SSA definition. */
  SsaImpl::DefinitionExt getDefinitionExt() { result = def }

  override CfgScope getCfgScope() { result = input.getScope() }

  override Location getLocationImpl() { result = input.getLastNode().getLocation() }

  override string toStringImpl() { result = "[input] " + def }
}

/** An SSA definition for a `self` variable. */
class SsaSelfDefinitionNode extends SsaDefinitionExtNode {
  private SelfVariable self;

  SsaSelfDefinitionNode() { self = def.getSourceVariable() }

  /** Gets the scope in which the `self` variable is declared. */
  Scope getSelfScope() { result = self.getDeclaringScope() }
}

/** A data flow node representing a captured variable. Only used in type tracking. */
class CapturedVariableNode extends NodeImpl, TCapturedVariableNode {
  private VariableCapture::CapturedVariable variable;

  CapturedVariableNode() { this = TCapturedVariableNode(variable) }

  /** Gets the captured variable represented by this node. */
  VariableCapture::CapturedVariable getVariable() { result = variable }

  override CfgScope getCfgScope() { result = variable.getCallable() }

  override Location getLocationImpl() { result = variable.getLocation() }

  override string toStringImpl() { result = "captured " + variable.getName() }
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

/**
 * A synthesized data flow node representing a closure object that tracks
 * captured variables.
 */
class CaptureNode extends NodeImpl, TCaptureNode {
  private VariableCapture::Flow::SynthesizedCaptureNode cn;

  CaptureNode() { this = TCaptureNode(cn) }

  VariableCapture::Flow::SynthesizedCaptureNode getSynthesizedCaptureNode() { result = cn }

  override CfgScope getCfgScope() { result = cn.getEnclosingCallable() }

  override Location getLocationImpl() { result = cn.getLocation() }

  override string toStringImpl() { result = cn.toString() }
}

private module ParameterNodes {
  abstract class ParameterNodeImpl extends NodeImpl {
    abstract Parameter getParameter();

    abstract predicate isParameterOf(DataFlowCallable c, ParameterPosition pos);

    final predicate isSourceParameterOf(CfgScope c, ParameterPosition pos) {
      exists(DataFlowCallable callable |
        this.isParameterOf(callable, pos) and
        c = callable.asCfgScope()
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
      exists(Callable callable | callable = c.asCfgScope() |
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
        exists(int n |
          parameter = callable.getParameter(n).(SplatParameter) and
          pos.isSplat(n) and
          // There are no positional parameters after the splat
          not exists(SimpleParameter p, int m | m > n | p = callable.getParameter(m))
        )
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
  abstract class SelfParameterNodeImpl extends ParameterNodeImpl, TSelfParameterNode {
    /** Gets the corresponding SSA `self` definition, if any. */
    abstract Ssa::SelfDefinition getSelfDefinition();

    /** Gets the underlying `self` variable. */
    abstract SelfVariable getSelfVariable();

    final override Parameter getParameter() { none() }

    final override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      c = TCfgScope(this.getCfgScope()) and pos.isSelf()
    }

    final override string toStringImpl() { result = "self in " + this.getCfgScope() }
  }

  /**
   * The value of the `self` parameter at method entry, viewed as a node in a data
   * flow graph.
   */
  class SelfMethodParameterNodeImpl extends SelfParameterNodeImpl, TSelfMethodParameterNode {
    private MethodBase method;

    SelfMethodParameterNodeImpl() { this = TSelfMethodParameterNode(method) }

    final MethodBase getMethod() { result = method }

    override Ssa::SelfDefinition getSelfDefinition() {
      result.getSourceVariable().getDeclaringScope() = method
    }

    final override SelfVariable getSelfVariable() { result.getDeclaringScope() = method }

    override CfgScope getCfgScope() { result = method }

    override Location getLocationImpl() { result = method.getLocation() }
  }

  /**
   * The value of the `self` parameter at top-level entry, viewed as a node in a data
   * flow graph.
   */
  class SelfToplevelParameterNodeImpl extends SelfParameterNodeImpl, TSelfToplevelParameterNode {
    private Toplevel t;

    SelfToplevelParameterNodeImpl() { this = TSelfToplevelParameterNode(t) }

    final Toplevel getToplevel() { result = t }

    override Ssa::SelfDefinition getSelfDefinition() {
      result.getSourceVariable().getDeclaringScope() = t
    }

    final override SelfVariable getSelfVariable() { result.getDeclaringScope() = t }

    override CfgScope getCfgScope() { result = t }

    override Location getLocationImpl() { result = t.getLocation() }
  }

  /**
   * The value of a lambda itself at function entry, viewed as a node in a data
   * flow graph.
   *
   * This is used for tracking flow through captured variables, and we use a
   * separate node and parameter/argument positions in order to distinguish
   * "lambda self" from "normal self", as lambdas may also access outer `self`
   * variables (through variable capture).
   */
  class LambdaSelfReferenceNode extends ParameterNodeImpl, TLambdaSelfReferenceNode {
    private Callable callable;

    LambdaSelfReferenceNode() { this = TLambdaSelfReferenceNode(callable) }

    final Callable getCallable() { result = callable }

    override Parameter getParameter() { none() }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      callable = c.asCfgScope() and pos.isLambdaSelf()
    }

    override CfgScope getCfgScope() { result = callable }

    override Location getLocationImpl() { result = callable.getLocation() }

    override string toStringImpl() { result = "lambda self in " + callable }
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
      c.asCfgScope() = method and pos.isBlock()
    }

    CfgNodes::ExprNodes::CallCfgNode getAYieldCall() {
      this.getMethod() = result.getExpr().(YieldCall).getEnclosingMethod()
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
   * A synthetic data-flow node to allow for flow into keyword parameters from
   * hash-splat arguments.
   *
   * For all methods containing keyword parameters, we construct a synthesized
   * (hidden) parameter node to contain all keyword arguments. This allows us
   * to handle cases like
   *
   * ```rb
   * def foo(p1:, p2:); end
   *
   * args = {:p1 => taint(1), :p2 => taint(2) }
   * foo(**args)
   * ```
   *
   * by adding read steps out of the synthesized parameter node to the relevant
   * keyword parameters.
   *
   * In order to avoid redundancy (and improve performance) in cases like
   *
   * ```rb
   * foo(p1: taint(1), p2: taint(2))
   * ```
   *
   * where direct keyword matching is possible, we use a special `HashSplatContent`
   * (instead of reusing `KnownElementContent`) when we construct a synthesized hash
   * splat argument (`SynthHashSplatArgumentNode`) at the call site, and then only
   * add read steps out of this node for actual hash-splat arguments (which will use
   * a normal `KnownElementContent`).
   */
  class SynthHashSplatParameterNode extends ParameterNodeImpl, TSynthHashSplatParameterNode {
    private DataFlowCallable callable;

    SynthHashSplatParameterNode() { this = TSynthHashSplatParameterNode(callable) }

    /** Holds if a read-step should be added into parameter `p`. */
    predicate readInto(ParameterNode p, ContentSet c) {
      exists(string name |
        isParameterNode(p, callable, any(ParameterPosition pos | pos.isKeyword(name)))
      |
        // Important: do not include `HashSplatContent` here, as normal parameter matching is possible
        exists(ConstantValue::ConstantSymbolValue key |
          c.isSingleton(TKnownElementContent(key)) and
          key.isSymbol(name)
        )
        or
        c.isSingleton(TUnknownElementContent())
      )
    }

    final override Parameter getParameter() { none() }

    final override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      c = callable and pos.isSynthHashSplat()
    }

    final override CfgScope getCfgScope() { result = callable.asCfgScope() }

    final override DataFlowCallable getEnclosingCallable() { result = callable }

    final override Location getLocationImpl() { result = callable.getLocation() }

    final override string toStringImpl() { result = "synthetic hash-splat parameter" }
  }

  /**
   * A synthetic data-flow node to allow for flow into positional parameters from
   * splat arguments.
   *
   * For all methods containing positional parameters, we construct a synthesized
   * (hidden) parameter node to contain all positional arguments. This allows us
   * to handle cases like
   *
   * ```rb
   * def foo(x, y, z); end
   *
   * foo(a, *[b, c])
   * ```
   *
   * by adding read steps out of the synthesized parameter node to the relevant
   * positional parameters.
   *
   * In order to avoid redundancy (and improve performance) in cases like
   *
   * ```rb
   * foo(a, b, c)
   * ```
   *
   * where direct positional matching is possible, we use a special `SplatContent`
   * (instead of reusing `KnownElementContent`) when we construct a synthesized
   * splat argument (`SynthSplatArgumentNode`) at the call site, and then only
   * add read steps out of this node for actual splat arguments (which will use
   * `KnownElementContent` or `TSplatContent(_, true)`).
   *
   * We don't yet correctly handle cases where a positional argument follows the
   * splat argument, e.g. in
   *
   * ```rb
   * foo(a, *[b], c)
   * ```
   *
   * but this appears to be rare in practice.
   */
  class SynthSplatParameterNode extends ParameterNodeImpl, TSynthSplatParameterNode {
    private DataFlowCallable callable;

    SynthSplatParameterNode() { this = TSynthSplatParameterNode(callable) }

    /** Holds if a read-step should be added into parameter `p`. */
    predicate readInto(ParameterNode p, ContentSet c) {
      exists(int n |
        isParameterNode(p, callable, any(ParameterPosition pos | pos.isPositional(n))) and
        not exists(int i | splatParameterAt(callable.asCfgScope(), i) and i < n)
      |
        // Important: do not include `TSplatContent(_, false)` here, as normal parameter matching is possible
        c = getSplatContent(n, true)
        or
        c = getArrayContent(n)
        or
        c.isSingleton(TUnknownElementContent())
      )
    }

    final override Parameter getParameter() { none() }

    final override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      c = callable and pos.isSynthSplat()
    }

    final override CfgScope getCfgScope() { result = callable.asCfgScope() }

    final override DataFlowCallable getEnclosingCallable() { result = callable }

    final override Location getLocationImpl() { result = callable.getLocation() }

    final override string toStringImpl() { result = "synthetic splat parameter" }
  }

  /**
   * A data-flow node that holds data from values inside the synthetic splat parameter,
   * which need to have their indices shifted before being passed onto real splat
   * parameters.
   *
   * For example, in
   *
   * ```rb
   * def foo(a, b, *rest); end
   * ```
   *
   * the elements of the synthetic splat parameter (`SynthSplatParameterNode`) need to
   * have their indices shifted by `2` before being passed into `rest`.
   */
  class SynthSplatParameterShiftNode extends NodeImpl, TSynthSplatParameterShiftNode {
    private DataFlowCallable callable;
    private int splatPos;
    private int pos;

    SynthSplatParameterShiftNode() { this = TSynthSplatParameterShiftNode(callable, splatPos, pos) }

    /**
     * Holds if a read-step should be added from synthetic splat parameter `synthSplat`
     * into this node.
     */
    predicate readFrom(SynthSplatParameterNode synthSplat, ContentSet cs) {
      synthSplat.isParameterOf(callable, _) and
      (
        cs = getSplatContent(pos + splatPos, _)
        or
        cs = getArrayContent(pos + splatPos)
      )
    }

    /**
     * Holds if a store-step should be added from this node into splat parameter `splat`.
     */
    predicate storeInto(NormalParameterNode splat, ContentSet cs) {
      splat.isParameterOf(callable, any(ParameterPosition p | p.isSplat(splatPos))) and
      cs = getArrayContent(pos)
    }

    final override CfgScope getCfgScope() { result = callable.asCfgScope() }

    final override DataFlowCallable getEnclosingCallable() { result = callable }

    final override Location getLocationImpl() { result = callable.getLocation() }

    final override string toStringImpl() {
      result = "synthetic splat parameter shift [" + pos + "]"
    }
  }

  /** A parameter for a library callable with a flow summary. */
  class SummaryParameterNode extends ParameterNodeImpl, FlowSummaryNode {
    private ParameterPosition pos_;

    SummaryParameterNode() {
      FlowSummaryImpl::Private::summaryParameterNode(this.getSummaryNode(), pos_)
    }

    override Parameter getParameter() { none() }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      this.getSummarizedCallable() = c.asLibraryCallable() and pos = pos_
    }
  }
}

import ParameterNodes

/** A data-flow node used to model flow summaries. */
class FlowSummaryNode extends NodeImpl, TFlowSummaryNode {
  FlowSummaryImpl::Private::SummaryNode getSummaryNode() { this = TFlowSummaryNode(result) }

  /** Gets the summarized callable that this node belongs to. */
  FlowSummaryImpl::Public::SummarizedCallable getSummarizedCallable() {
    result = this.getSummaryNode().getSummarizedCallable()
  }

  override CfgScope getCfgScope() { none() }

  override DataFlowCallable getEnclosingCallable() {
    result.asLibraryCallable() = this.getSummarizedCallable()
  }

  override EmptyLocation getLocationImpl() { any() }

  override string toStringImpl() { result = this.getSummaryNode().toString() }
}

/** A data-flow node that represents a call argument. */
abstract class ArgumentNode extends Node {
  /** Holds if this argument occurs at the given position in the given call. */
  abstract predicate argumentOf(DataFlowCall call, ArgumentPosition pos);

  abstract predicate sourceArgumentOf(CfgNodes::ExprNodes::CallCfgNode call, ArgumentPosition pos);

  /** Gets the call in which this node is an argument. */
  final DataFlowCall getCall() { this.argumentOf(result, _) }
}

module ArgumentNodes {
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

  class BlockArgumentNode extends NodeImpl, ArgumentNode, TBlockArgumentNode {
    CfgNodes::ExprNodes::CallCfgNode yield;

    BlockArgumentNode() { this = TBlockArgumentNode(yield) }

    CfgNodes::ExprNodes::CallCfgNode getYieldCall() { result = yield }

    pragma[nomagic]
    BlockParameterNode getParameterNode(boolean inSameScope) {
      result.getAYieldCall() = yield and
      if nodeGetEnclosingCallable(this) = nodeGetEnclosingCallable(result)
      then inSameScope = true
      else inSameScope = false
    }

    // needed for variable capture flow
    override predicate sourceArgumentOf(CfgNodes::ExprNodes::CallCfgNode call, ArgumentPosition pos) {
      call = yield and
      pos.isLambdaSelf()
    }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      this.sourceArgumentOf(call.asCall(), pos)
    }

    override CfgScope getCfgScope() { result = yield.getScope() }

    override Location getLocationImpl() { result = yield.getLocation() }

    override string toStringImpl() { result = "yield block argument" }
  }

  private class SummaryArgumentNode extends FlowSummaryNode, ArgumentNode {
    private FlowSummaryImpl::Private::SummaryNode receiver;
    private ArgumentPosition pos_;

    SummaryArgumentNode() {
      FlowSummaryImpl::Private::summaryArgumentNode(receiver, this.getSummaryNode(), pos_)
    }

    override predicate sourceArgumentOf(CfgNodes::ExprNodes::CallCfgNode call, ArgumentPosition pos) {
      none()
    }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      call.(SummaryCall).getReceiver() = receiver and pos = pos_
    }
  }

  abstract class SynthHashSplatOrSplatArgumentNode extends ArgumentNode, NodeImpl {
    CfgNodes::ExprNodes::CallCfgNode call_;

    final string getMethodName() {
      result = call_.(CfgNodes::ExprNodes::MethodCallCfgNode).getMethodName()
      or
      not call_ instanceof CfgNodes::ExprNodes::MethodCallCfgNode and
      result = call_.getExpr().getEnclosingMethod().getName() + "_yield"
    }

    final override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      this.sourceArgumentOf(call.asCall(), pos)
    }

    final override CfgScope getCfgScope() { result = call_.getExpr().getCfgScope() }

    final override Location getLocationImpl() { result = call_.getLocation() }
  }

  /**
   * Holds if a store-step should be added from keyword argument `arg`, belonging to
   * `call`, into a synthetic hash splat argument.
   */
  predicate synthHashSplatStore(
    CfgNodes::ExprNodes::CallCfgNode call, CfgNodes::ExprCfgNode arg, ContentSet c
  ) {
    exists(ConstantValue cv |
      // symbol key
      exists(ArgumentPosition keywordPos, string name |
        arg.(Argument).isArgumentOf(call, keywordPos) and
        keywordPos.isKeyword(name) and
        cv.isSymbol(name)
      )
      or
      // non-symbol key
      exists(CfgNodes::ExprNodes::PairCfgNode pair, CfgNodes::ExprCfgNode key |
        arg = pair.getValue() and
        pair = call.getAnArgument() and
        key = pair.getKey() and
        cv = key.getConstantValue() and
        not cv.isSymbol(_)
      )
    |
      if call instanceof CfgNodes::ExprNodes::HashLiteralCfgNode
      then
        /*
         * Needed for cases like
         *
         * ```rb
         * hash = { a: taint, b: safe }
         *
         * def foo(a:, b:)
         *   sink(a)
         * end
         *
         * foo(**hash)
         * ```
         */

        c.isSingleton(Content::getElementContent(cv))
      else c.isSingleton(THashSplatContent(cv))
    )
  }

  /**
   * A data-flow node that represents all keyword arguments wrapped in a hash.
   *
   * The callee is responsible for filtering out the keyword arguments that are
   * part of the method signature, such that those cannot end up in the hash-splat
   * parameter. See also `SynthHashSplatParameterNode`.
   */
  class SynthHashSplatArgumentNode extends SynthHashSplatOrSplatArgumentNode,
    TSynthHashSplatArgumentNode
  {
    SynthHashSplatArgumentNode() { this = TSynthHashSplatArgumentNode(call_) }

    /**
     * Holds if a store-step should be added from argument `arg` into this synthetic
     * hash-splat argument.
     */
    predicate storeFrom(Node arg, ContentSet c) { synthHashSplatStore(call_, arg.asExpr(), c) }

    override predicate sourceArgumentOf(CfgNodes::ExprNodes::CallCfgNode call, ArgumentPosition pos) {
      call = call_ and
      pos.isSynthHashSplat()
    }

    override string toStringImpl() { result = "synthetic hash-splat argument" }
  }

  /**
   * Holds if a store-step should be added from positional argument `arg`, belonging to
   * `call`, into a synthetic splat argument.
   */
  predicate synthSplatStore(CfgNodes::ExprNodes::CallCfgNode call, Argument arg, ContentSet c) {
    exists(int n |
      exists(ArgumentPosition pos |
        arg.isArgumentOf(call, pos) and
        pos.isPositional(n) and
        not exists(int i | splatArgumentAt(call, i) and i < n)
      )
    |
      if call instanceof CfgNodes::ExprNodes::ArrayLiteralCfgNode
      then
        /*
         * Needed for cases like
         *
         * ```rb
         * arr = [taint, safe]
         *
         * def foo(a, b)
         *   sink(a)
         * end
         *
         * foo(*arr)
         * ```
         */

        c = getArrayContent(n)
      else c = getSplatContent(n, false)
    )
  }

  /**
   * A data-flow node that represents all positional arguments wrapped in an array.
   *
   * The callee is responsible for filtering out the positional arguments that are
   * part of the method signature, such that those cannot end up in the splat
   * parameter. See also `SynthSplatParameterNode`.
   */
  class SynthSplatArgumentNode extends SynthHashSplatOrSplatArgumentNode, TSynthSplatArgumentNode {
    SynthSplatArgumentNode() { this = TSynthSplatArgumentNode(call_) }

    /**
     * Holds if a store-step should be added from argument `arg` into this synthetic
     * splat argument.
     */
    predicate storeFrom(Node arg, ContentSet c) { synthSplatStore(call_, arg.asExpr(), c) }

    override predicate sourceArgumentOf(CfgNodes::ExprNodes::CallCfgNode call, ArgumentPosition pos) {
      call = call_ and
      pos.isSynthSplat()
    }

    override string toStringImpl() { result = "synthetic splat argument" }
  }

  /**
   * A data-flow node that holds data from values inside splat arguments, which
   * need to have their indices shifted.
   *
   * For example, in the following call
   *
   * ```rb
   * foo(a, b, *[c, d])
   * ```
   *
   * `c` and `d` need to have their indices shifted by `2`.
   */
  class SynthSplatArgumentShiftNode extends NodeImpl, TSynthSplatArgumentShiftNode {
    CfgNodes::ExprNodes::CallCfgNode c;
    int splatPos;
    int n;

    SynthSplatArgumentShiftNode() { this = TSynthSplatArgumentShiftNode(c, splatPos, n) }

    /**
     * Holds if a read-step should be added from splat argument `splatArg` into this node.
     */
    predicate readFrom(Node splatArg, ContentSet cs) {
      splatArg.asExpr().(Argument).isArgumentOf(c, any(ArgumentPosition p | p.isSplat(splatPos))) and
      (
        cs = getSplatContent(n - splatPos, _)
        or
        cs = getArrayContent(n - splatPos)
        or
        n = -1 and
        cs.isSingleton(TUnknownElementContent())
      )
    }

    /**
     * Holds if a store-step should be added from this node into synthetic splat
     * argument `synthSplat`.
     */
    predicate storeInto(SynthSplatArgumentNode synthSplat, ContentSet cs) {
      synthSplat = TSynthSplatArgumentNode(c) and
      (
        cs = getSplatContent(n, true)
        or
        n = -1 and
        cs.isSingleton(TUnknownElementContent())
      )
    }

    override CfgScope getCfgScope() { result = c.getExpr().getCfgScope() }

    override Location getLocationImpl() { result = c.getLocation() }

    override string toStringImpl() { result = "synthetic splat argument shift [" + n + "]" }
  }
}

import ArgumentNodes

/** A call to `new`. */
private class NewCall extends NormalCall {
  NewCall() { this.asCall().getExpr().(MethodCall).getMethodName() = "new" }
}

/** A data-flow node that represents a value returned by a callable. */
abstract class ReturnNode extends Node {
  /** Gets the kind of this return node. */
  abstract ReturnKind getKind();
}

/** A data-flow node that represents a value returned by a callable. */
abstract class SourceReturnNode extends ReturnNode {
  /** Gets the kind of this return node. */
  abstract ReturnKind getKindSource(); // only exists to avoid spurious negative recursion

  final override ReturnKind getKind() { result = this.getKindSource() }

  pragma[nomagic]
  predicate hasKind(ReturnKind kind, CfgScope scope) {
    kind = this.getKindSource() and
    scope = this.(NodeImpl).getCfgScope()
  }
}

private module ReturnNodes {
  private predicate isValid(CfgNodes::ReturningCfgNode node) {
    exists(ReturningStmt stmt, Callable scope |
      stmt = node.getAstNode() and
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
  class ExplicitReturnNode extends SourceReturnNode, ReturningStatementNode {
    ExplicitReturnNode() {
      isValid(n) and
      n.getASuccessor().(CfgNodes::AnnotatedExitNode).isNormal() and
      n.getScope() instanceof Callable
    }

    override ReturnKind getKindSource() {
      if n.getAstNode() instanceof BreakStmt
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
  class ExprReturnNode extends SourceReturnNode, ExprNode {
    ExprReturnNode() { exists(Callable c | implicitReturn(c, this) = c.getAStmt()) }

    override ReturnKind getKindSource() {
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
  class InitializeReturnNode extends ExprPostUpdateNode, ReturnNode {
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

  private class SummaryReturnNode extends FlowSummaryNode, ReturnNode {
    private ReturnKind rk;

    SummaryReturnNode() { FlowSummaryImpl::Private::summaryReturnNode(this.getSummaryNode(), rk) }

    override ReturnKind getKind() {
      result = rk
      or
      exists(NewCall new |
        TLibraryCallable(this.getSummarizedCallable()) = viableLibraryCallable(new) and
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

  private class SummaryOutNode extends FlowSummaryNode, OutNode {
    private SummaryCall call;
    private ReturnKind kind_;

    SummaryOutNode() {
      FlowSummaryImpl::Private::summaryOutNode(call.getReceiver(), this.getSummaryNode(), kind_)
    }

    override DataFlowCall getCall(ReturnKind kind) { result = call and kind = kind_ }
  }
}

import OutNodes

predicate jumpStep(Node pred, Node succ) {
  succ.asExpr().getExpr().(ConstantReadAccess).getValue() = pred.asExpr().getExpr()
  or
  FlowSummaryImpl::Private::Steps::summaryJumpStep(pred.(FlowSummaryNode).getSummaryNode(),
    succ.(FlowSummaryNode).getSummaryNode())
  or
  any(AdditionalJumpStep s).step(pred, succ)
  or
  succ.(BlockArgumentNode).getParameterNode(false) = pred
}

private ContentSet getArrayContent(int n) {
  exists(ConstantValue::ConstantIntegerValue i |
    result.isSingleton(TKnownElementContent(i)) and
    i.isInt(n)
  )
}

private ContentSet getSplatContent(int n, boolean adjusted) {
  result.isSingleton(TSplatContent(n, adjusted))
}

/**
 * Subset of `storeStep` that should be shared with type-tracking.
 */
predicate storeStepCommon(Node node1, ContentSet c, Node node2) {
  node2.(SynthHashSplatArgumentNode).storeFrom(node1, c)
  or
  node2.(SynthSplatArgumentNode).storeFrom(node1, c)
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
  FlowSummaryImpl::Private::Steps::summaryStoreStep(node1.(FlowSummaryNode).getSummaryNode(), c,
    node2.(FlowSummaryNode).getSummaryNode())
  or
  node1.(SynthSplatParameterShiftNode).storeInto(node2, c)
  or
  node1.(SynthSplatArgumentShiftNode).storeInto(node2, c)
  or
  storeStepCommon(node1, c, node2)
  or
  VariableCapture::storeStep(node1, any(Content::CapturedVariableContent v | c.isSingleton(v)),
    node2)
}

/**
 * Subset of `readStep` that should be shared with type-tracking.
 */
predicate readStepCommon(Node node1, ContentSet c, Node node2) {
  node1.(SynthHashSplatParameterNode).readInto(node2, c)
  or
  node1.(SynthSplatParameterNode).readInto(node2, c)
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
  FlowSummaryImpl::Private::Steps::summaryReadStep(node1.(FlowSummaryNode).getSummaryNode(), c,
    node2.(FlowSummaryNode).getSummaryNode())
  or
  VariableCapture::readStep(node1, any(Content::CapturedVariableContent v | c.isSingleton(v)), node2)
  or
  node2.(SynthSplatParameterShiftNode).readFrom(node1, c)
  or
  node2.(SynthSplatArgumentShiftNode).readFrom(node1, c)
  or
  readStepCommon(node1, c, node2)
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`. For example,
 * any value stored inside `f` is cleared at the pre-update node associated with `x`
 * in `x.f = newValue`.
 */
predicate clearsContent(Node n, ContentSet c) {
  FlowSummaryImpl::Private::Steps::summaryClearsContent(n.(FlowSummaryNode).getSummaryNode(), c)
  or
  // Filter out keyword arguments that are part of the method signature from
  // the hash-splat parameter
  exists(
    DataFlowCallable callable, HashSplatParameter hashSplatParam, ParameterNodeImpl keywordParam,
    ParameterPosition keywordPos, ConstantValue::ConstantSymbolValue cv, string name
  |
    n = TNormalParameterNode(hashSplatParam) and
    callable.asCfgScope() = hashSplatParam.getCallable() and
    keywordParam.isParameterOf(callable, keywordPos) and
    keywordPos.isKeyword(name) and
    c.isKnownOrUnknownElement(TKnownElementContent(cv)) and
    cv.isSymbol(name)
  )
  or
  VariableCapture::clearsContent(n, any(Content::CapturedVariableContent v | c.isSingleton(v)))
}

/**
 * Holds if the value that is being tracked is expected to be stored inside content `c`
 * at node `n`.
 */
predicate expectsContent(Node n, ContentSet c) {
  FlowSummaryImpl::Private::Steps::summaryExpectsContent(n.(FlowSummaryNode).getSummaryNode(), c)
}

class DataFlowType extends TDataFlowType {
  string toString() { result = "" }
}

predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) {
  t1 != TUnknownDataFlowType() and
  t2 = TUnknownDataFlowType()
}

private predicate mustHaveLambdaType(ExprNode n, Callable c) {
  exists(VariableCapture::ClosureExpr ce, CfgNodes::ExprCfgNode e |
    e = n.asExpr() and ce.hasBody(c)
  |
    e = ce or
    ce.hasAliasedAccess(e)
  )
}

predicate localMustFlowStep(Node node1, Node node2) { none() }

/** Gets the type of `n` used for type pruning. */
DataFlowType getNodeType(Node n) {
  result = TLambdaDataFlowType(n.(LambdaSelfReferenceNode).getCallable())
  or
  exists(Callable c |
    mustHaveLambdaType(n, c) and
    result = TLambdaDataFlowType(c)
  )
  or
  result = TSynthHashSplatArgumentType(n.(SynthHashSplatArgumentNode).getMethodName())
  or
  result = TSynthSplatArgumentType(n.(SynthSplatArgumentNode).getMethodName())
  or
  not n instanceof LambdaSelfReferenceNode and
  not mustHaveLambdaType(n, _) and
  not n instanceof SynthHashSplatOrSplatArgumentNode and
  result = TUnknownDataFlowType()
}

/** Gets a string representation of a `DataFlowType`. */
string ppReprType(DataFlowType t) { none() }

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

  private class SummaryPostUpdateNode extends FlowSummaryNode, PostUpdateNodeImpl {
    private FlowSummaryNode pre;

    SummaryPostUpdateNode() {
      FlowSummaryImpl::Private::summaryPostUpdateNode(this.getSummaryNode(), pre.getSummaryNode())
    }

    override Node getPreUpdateNode() { result = pre }
  }

  private class CapturePostUpdateNode extends PostUpdateNodeImpl, CaptureNode {
    private CaptureNode pre;

    CapturePostUpdateNode() {
      VariableCapture::Flow::capturePostUpdateNode(this.getSynthesizedCaptureNode(),
        pre.getSynthesizedCaptureNode())
    }

    override Node getPreUpdateNode() { result = pre }
  }
}

private import PostUpdateNodes

/** A node that performs a type cast. */
class CastNode extends Node {
  CastNode() { none() }
}

/**
 * Holds if `n` should never be skipped over in the `PathGraph` and in path
 * explanations.
 */
predicate neverSkipInPathGraph(Node n) {
  // ensure that all variable assignments are included in the path graph
  n =
    any(SsaDefinitionExtNode def |
      def.getDefinitionExt() instanceof Ssa::WriteDefinition and
      not def.isHidden()
    )
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

  int totalOrder() { result = 1 }
}

/**
 * Holds if the nodes in `nr` are unreachable when the call context is `call`.
 */
predicate isUnreachableInCall(NodeRegion nr, DataFlowCall call) { none() }

newtype LambdaCallKind =
  TYieldCallKind() or
  TLambdaCallKind()

/** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
private predicate lambdaCreationExpr(CfgNodes::ExprCfgNode creation, LambdaCallKind kind, Callable c) {
  kind = TYieldCallKind() and
  creation.getExpr() = c.(Block)
  or
  kind = TLambdaCallKind() and
  (
    creation.getExpr() = c.(Lambda)
    or
    creation =
      any(CfgNodes::ExprNodes::MethodCallCfgNode mc |
        c = mc.getBlock().getExpr() and
        isProcCreationCall(mc.getExpr())
      )
  )
}

/** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) {
  lambdaCreationExpr(creation.asExpr(), kind, c.asCfgScope())
}

/** Holds if `call` is a call to `lambda`, `proc`, or `Proc.new` */
pragma[nomagic]
private predicate isProcCreationCall(MethodCall call) {
  call.getMethodName() = ["proc", "lambda"]
  or
  call.getMethodName() = "new" and
  call.getReceiver().(ConstantReadAccess).getAQualifiedName() = "Proc"
}

/** Holds if `mc` is a call to `receiver.call`. */
private predicate lambdaCallExpr(
  CfgNodes::ExprNodes::MethodCallCfgNode mc, CfgNodes::ExprCfgNode receiver
) {
  receiver = mc.getReceiver() and
  mc.getExpr().getMethodName() = "call"
}

/**
 * Holds if `call` is a from-source lambda call of kind `kind` where `receiver`
 * is the lambda expression.
 */
predicate lambdaSourceCall(CfgNodes::ExprNodes::CallCfgNode call, LambdaCallKind kind, Node receiver) {
  kind = TYieldCallKind() and
  call = receiver.(BlockArgumentNode).getYieldCall()
  or
  kind = TLambdaCallKind() and
  lambdaCallExpr(call, receiver.asExpr())
}

/**
 * Holds if `call` is a (from-source or from-summary) lambda call of kind `kind`
 * where `receiver` is the lambda expression.
 */
predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) {
  lambdaSourceCall(call.asCall(), kind, receiver)
  or
  receiver.(FlowSummaryNode).getSummaryNode() = call.(SummaryCall).getReceiver() and
  if receiver.(ParameterNodeImpl).isParameterOf(_, any(ParameterPosition pos | pos.isBlock()))
  then kind = TYieldCallKind()
  else kind = TLambdaCallKind()
}

/** Extra data-flow steps needed for lambda flow analysis. */
predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

predicate knownSourceModel(Node source, string model) {
  source = ModelOutput::getASourceNode(_, model).asSource()
}

predicate knownSinkModel(Node sink, string model) {
  sink = ModelOutput::getASinkNode(_, model).asSink()
}

class DataFlowSecondLevelScope = Unit;

/**
 * Holds if flow is allowed to pass from parameter `p` and back to itself as a
 * side-effect, resulting in a summary from `p` to itself.
 *
 * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
 * by default as a heuristic.
 */
predicate allowParameterReturnInSelf(ParameterNodeImpl p) {
  exists(DataFlowCallable c, ParameterPosition pos |
    p.isParameterOf(c, pos) and
    FlowSummaryImpl::Private::summaryAllowParameterReturnInSelf(c.asLibraryCallable(), pos)
  )
  or
  VariableCapture::Flow::heuristicAllowInstanceParameterReturnInSelf(p.(LambdaSelfReferenceNode)
        .getCallable())
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
    exists(boolean shifted, string s |
      this = TSplatContentApprox(shifted) and
      (if shifted = true then s = " (shifted)" else s = "") and
      result = "approximated splat position" + s
    )
    or
    exists(string s |
      this = THashSplatContentApprox(s) and
      result = "approximated hash-splat position " + s
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
private string approxKnownElementIndex(ConstantValue cv) {
  not cv.isInt(_) and
  exists(string s | s = cv.serialize() |
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
  result =
    TKnownElementContentApprox(approxKnownElementIndex(c.(Content::KnownElementContent).getIndex()))
  or
  exists(boolean shifted |
    c = TSplatContent(_, shifted) and
    result = TSplatContentApprox(shifted)
  )
  or
  result = THashSplatContentApprox(approxKnownElementIndex(c.(Content::HashSplatContent).getKey()))
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
