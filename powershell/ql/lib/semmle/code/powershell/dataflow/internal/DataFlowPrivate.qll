private import codeql.util.Boolean
private import codeql.util.Unit
private import powershell
private import semmle.code.powershell.Cfg
private import semmle.code.powershell.dataflow.Ssa
private import DataFlowPublic
private import DataFlowDispatch
private import SsaImpl as SsaImpl
private import FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.powershell.frameworks.data.ModelsAsData
private import PipelineReturns as PipelineReturns

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

  /** Holds if this node should be hidden from path explanations. */
  predicate nodeIsHidden() { none() }
}

private class ExprNodeImpl extends ExprNode, NodeImpl {
  override CfgScope getCfgScope() { result = this.getExprNode().getExpr().getEnclosingScope() }

  override Location getLocationImpl() { result = this.getExprNode().getLocation() }

  override string toStringImpl() { result = this.getExprNode().toString() }
}

/** Provides logic related to SSA. */
module SsaFlow {
  private module Impl = SsaImpl::DataFlowIntegration;

  private ParameterNodeImpl toParameterNode(SsaImpl::ParameterExt p) {
    result = TNormalParameterNode(p.asParameter())
    or
    result = TThisParameterNode(p.asThis())
    or
    result = TPipelineParameterNode(p.asPipelineParameter())
    or
    result = TPipelineByPropertyNameParameterNode(p.asPipelineByPropertyNameParameter())
  }

  /** Gets the SSA node corresponding to the PowerShell node `n`. */
  Impl::Node asNode(Node n) {
    n = TSsaNode(result)
    or
    result.(Impl::ExprNode).getExpr().asExprCfgNode() = n.asExpr()
    or
    exists(CfgNodes::ProcessBlockCfgNode pb, BasicBlock bb, int i |
      n.(ProcessNode).getProcessBlock() = pb and
      bb.getNode(i) = pb and
      result
          .(Impl::SsaDefinitionNode)
          .getDefinition()
          .definesAt(pb.getPipelineIteratorVariable(), bb, i)
    )
    or
    exists(
      BasicBlock bb, int i, PipelineByPropertyNameParameter p, ProcessPropertyByNameNode pbNode
    |
      pbNode = n and
      pbNode.hasRead() and
      pbNode.getParameter() = p and
      bb.getNode(i) = pbNode.getProcessBlock() and
      result.(Impl::SsaDefinitionNode).getDefinition().definesAt(p.getIteratorVariable(), bb, i)
    )
    or
    result.(Impl::ExprPostUpdateNode).getExpr().asExprCfgNode() =
      n.(PostUpdateNode).getPreUpdateNode().asExpr()
    or
    exists(SsaImpl::ParameterExt p |
      n = toParameterNode(p) and
      p.isInitializedBy(result.(Impl::WriteDefSourceNode).getDefinition())
    )
    or
    result.(Impl::WriteDefSourceNode).getDefinition().(Ssa::WriteDefinition).assigns(n.asExpr())
    or
    exists(Scope scope, EnvVariable v |
      result.(Impl::ExprNode).getExpr().isFinalEnvVarRead(scope, v) and
      n = TFinalEnvVarRead(scope, v)
    )
  }

  predicate localFlowStep(
    SsaImpl::SsaInput::SourceVariable v, Node nodeFrom, Node nodeTo, boolean isUseStep
  ) {
    Impl::localFlowStep(v, asNode(nodeFrom), asNode(nodeTo), isUseStep)
  }

  predicate localMustFlowStep(Node nodeFrom, Node nodeTo) {
    Impl::localMustFlowStep(_, asNode(nodeFrom), asNode(nodeTo))
  }
}

private module ArrayExprFlow {
  private module Input implements PipelineReturns::InputSig {
    predicate isSource(CfgNodes::AstCfgNode source) {
      source = any(CfgNodes::ExprNodes::ArrayExprCfgNode ae).getStmtBlock()
    }
  }

  import PipelineReturns::Make<Input>
}

/** Provides predicates related to local data flow. */
module LocalFlow {
  pragma[nomagic]
  predicate localFlowStepCommon(Node nodeFrom, Node nodeTo) {
    nodeFrom.asExpr() = nodeTo.asExpr().(CfgNodes::ExprNodes::ConditionalExprCfgNode).getABranch()
    or
    nodeFrom.asExpr() = nodeTo.asExpr().(CfgNodes::StmtNodes::AssignStmtCfgNode).getRightHandSide()
    or
    nodeFrom.asExpr() = nodeTo.asExpr().(CfgNodes::ExprNodes::ConvertExprCfgNode).getSubExpr()
    or
    nodeFrom.asExpr() = nodeTo.asExpr().(CfgNodes::ExprNodes::ParenExprCfgNode).getSubExpr()
    or
    nodeFrom.asExpr() = nodeTo.asExpr().(CfgNodes::ExprNodes::ArrayExprCfgNode)
    or
    nodeTo.asExpr().(CfgNodes::ExprNodes::PipelineCfgNode).getLastComponent() = nodeFrom.asExpr()
    or
    exists(CfgNodes::ExprCfgNode e |
      e = nodeFrom.(AstNode).getCfgNode() and
      isReturned(e) and
      e.getScope() = nodeTo.(PreReturnNodeImpl).getCfgScope()
    )
    or
    exists(CfgNode cfgNode |
      nodeFrom = TPreReturnNodeImpl(cfgNode, true) and
      nodeTo = TImplicitWrapNode(cfgNode, false)
    )
    or
    exists(CfgNode cfgNode |
      nodeFrom = TImplicitWrapNode(cfgNode, false) and
      nodeTo = TReturnNodeImpl(cfgNode.getScope())
    )
    or
    exists(CfgNodes::ExprCfgNode e, CfgNodes::ScriptBlockCfgNode scriptBlock |
      e = nodeFrom.(AstNode).getCfgNode() and
      isReturned(e) and
      e.getScope() = scriptBlock.getAstNode() and
      not blockMayReturnMultipleValues(scriptBlock) and
      nodeTo.(ReturnNodeImpl).getCfgScope() = scriptBlock.getAstNode()
    )
    or
    nodeTo.(PreProcessPropertyByNameNode).getAccess() = nodeFrom.asExpr()
    or
    exists(PreProcessPropertyByNameNode pbNode |
      pbNode = nodeFrom and
      nodeTo = TProcessPropertyByNameNode(pbNode.getAccess().getVariable(), false)
    )
    or
    nodeTo.(PreProcessNode).getProcessBlock().getPipelineParameterAccess() = nodeFrom.asExpr()
    or
    nodeTo.(ProcessNode).getProcessBlock() = nodeFrom.(PreProcessNode).getProcessBlock()
  }

  predicate flowSummaryLocalStep(
    FlowSummaryNode nodeFrom, FlowSummaryNode nodeTo, FlowSummaryImpl::Public::SummarizedCallable c,
    string model
  ) {
    FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom.getSummaryNode(),
      nodeTo.getSummaryNode(), true, model) and
    c = nodeFrom.getSummarizedCallable()
  }

  predicate localMustFlowStep(Node nodeFrom, Node nodeTo) {
    SsaFlow::localMustFlowStep(nodeFrom, nodeTo)
    or
    nodeFrom =
      unique(FlowSummaryNode n1 |
        FlowSummaryImpl::Private::Steps::summaryLocalStep(n1.getSummaryNode(),
          nodeTo.(FlowSummaryNode).getSummaryNode(), true, _)
      )
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
    TSsaNode(SsaImpl::DataFlowIntegration::SsaNode node) or
    TNormalParameterNode(SsaImpl::NormalParameter p) or
    TThisParameterNode(Method m) or
    TPipelineByPropertyNameParameterNode(PipelineByPropertyNameParameter p) or
    TPipelineParameterNode(PipelineParameter p) or
    TExprPostUpdateNode(CfgNodes::ExprCfgNode n) {
      n instanceof CfgNodes::ExprNodes::ArgumentCfgNode
      or
      n instanceof CfgNodes::ExprNodes::QualifierCfgNode
      or
      exists(CfgNodes::ExprNodes::MemberExprCfgNode member |
        n = member.getQualifier() and
        not member.isStatic()
      )
      or
      n = any(CfgNodes::ExprNodes::IndexExprCfgNode index).getBase()
    } or
    TFlowSummaryNode(FlowSummaryImpl::Private::SummaryNode sn) or
    TPreReturnNodeImpl(CfgNodes::ScriptBlockCfgNode scriptBlock, Boolean isArray) {
      blockMayReturnMultipleValues(scriptBlock)
    } or
    TImplicitWrapNode(CfgNodes::ScriptBlockCfgNode scriptBlock, Boolean shouldWrap) {
      blockMayReturnMultipleValues(scriptBlock)
    } or
    TReturnNodeImpl(CfgScope scope) or
    TPreProcessNode(CfgNodes::ProcessBlockCfgNode process) or
    TProcessNode(CfgNodes::ProcessBlockCfgNode process) or
    TPreProcessPropertyByNameNode(CfgNodes::ExprNodes::VarReadAccessCfgNode va) {
      any(CfgNodes::ProcessBlockCfgNode pb).getAPipelineByPropertyNameParameterAccess() = va
    } or
    TProcessPropertyByNameNode(PipelineByPropertyNameParameter p, Boolean hasRead) {
      p.getDeclaringScope() = any(ProcessBlock pb).getScriptBlock()
    } or
    TScriptBlockNode(ScriptBlock scriptBlock) or
    TForbiddenRecursionGuard() {
      none() and
      // We want to prune irrelevant models before materialising data flow nodes, so types contributed
      // directly from CodeQL must expose their pruning info without depending on data flow nodes.
      (any(ModelInput::TypeModel tm).isTypeUsed("") implies any())
    } or
    TFinalEnvVarRead(Scope scope, EnvVariable envVar) {
      exists(ExitBasicBlock exit |
        envVar.getAnAccess().getEnclosingScope() = scope and
        exit.getScope() = scope and
        SsaImpl::envVarRead(exit, _, envVar)
      )
    } or
    TEnvVarNode(EnvVariable envVar)

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
      exists(boolean isUseStep | SsaFlow::localFlowStep(_, nodeFrom, nodeTo, isUseStep) |
        isUseStep = false
        or
        isUseStep = true and
        not FlowSummaryImpl::Private::Steps::prohibitsUseUseFlow(nodeFrom, _)
      )
    ) and
    model = ""
  }

  /** This is the local flow predicate that is exposed. */
  cached
  predicate localFlowStepImpl(Node nodeFrom, Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
    or
    SsaFlow::localFlowStep(_, nodeFrom, nodeTo, _)
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
    SsaFlow::localFlowStep(_, nodeFrom, nodeTo, _)
  }

  /** Holds if `n` wraps an SSA definition without ingoing flow. */
  private predicate entrySsaDefinition(SsaDefinitionNodeImpl n) {
    n.getDefinition() =
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
      p.isInitializedBy(n.(SsaDefinitionNodeImpl).getDefinition())
    )
    or
    isStoreTargetNode(n)
    or
    TypeTrackingInput::loadStep(_, n, _)
  }

  cached
  newtype TContentSet =
    TSingletonContentSet(Content c) or
    TAnyElementContentSet() or
    TAnyPositionalContentSet() or
    TKnownOrUnknownKeyContentSet(Content::KnownKeyContent c) or
    TKnownOrUnknownPositionalContentSet(Content::KnownPositionalContent c) or
    TUnknownPositionalElementContentSet() or
    TUnknownKeyContentSet()

  cached
  newtype TContent =
    TFieldContent(string name) {
      name = any(PropertyMember member).getLowerCaseName()
      or
      name = any(MemberExpr me).getLowerCaseMemberName()
    } or
    // A known map key
    TKnownKeyContent(ConstantValue cv) { exists(cv.asString()) } or
    // A known array index
    TKnownPositionalContent(ConstantValue cv) { cv.asInt() = [0 .. 10] } or
    // An unknown key
    TUnknownKeyContent() or
    // An unknown positional element
    TUnknownPositionalContent() or
    // A unknown position or key - and we dont even know what kind it is
    TUnknownKeyOrPositionContent()

  cached
  newtype TContentApprox =
    // A field
    TNonElementContentApprox(Content c) { not c instanceof Content::ElementContent } or
    // An unknown key
    TUnkownKeyContentApprox() or
    // A known map key
    TKnownKeyContentApprox(string approx) { approx = approxKnownElementIndex(_) } or
    // A known positional element
    TKnownPositionalContentApprox() or
    // An unknown positional element
    TUnknownPositionalContentApprox() or
    TUnknownContentApprox()

  cached
  newtype TDataFlowType = TUnknownDataFlowType()
}

class TKnownElementContent = TKnownKeyContent or TKnownPositionalContent;

class TKnownKindContent = TUnknownPositionalContent or TUnknownKeyContent;

class TUnknownElementContent = TKnownKindContent or TUnknownKeyOrPositionContent;

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
predicate nodeIsHidden(Node n) { n.(NodeImpl).nodeIsHidden() }

/**
 * Holds if `n` should never be skipped over in the `PathGraph` and in path
 * explanations.
 */
predicate neverSkipInPathGraph(Node n) {
  isReturned(n.(AstNode).getCfgNode())
  or
  n = any(SsaDefinitionNodeImpl def | not def.nodeIsHidden())
}

/** An SSA node. */
class SsaNode extends NodeImpl, TSsaNode {
  SsaImpl::DataFlowIntegration::SsaNode node;

  SsaNode() { this = TSsaNode(node) }

  /** Gets the underlying variable. */
  Variable getVariable() { result = node.getSourceVariable() }

  override CfgScope getCfgScope() { result = node.getBasicBlock().getScope() }

  override Location getLocationImpl() { result = node.getLocation() }

  override string toStringImpl() { result = node.toString() }
}

class SsaDefinitionNodeImpl extends SsaNode {
  override SsaImpl::DataFlowIntegration::SsaDefinitionNode node;

  Ssa::Definition getDefinition() { result = node.getDefinition() }

  override predicate nodeIsHidden() {
    exists(SsaImpl::Definition def | def = this.getDefinition() |
      not def instanceof Ssa::WriteDefinition
      or
      def = SsaImpl::getParameterDef(_)
    )
  }
}

private string getANamedArgument(CfgNodes::ExprNodes::CallExprCfgNode c) {
  exists(c.getNamedArgument(result))
}

private module NamedSetModule =
  QlBuiltins::InternSets<CfgNodes::ExprNodes::CallExprCfgNode, string, getANamedArgument/1>;

private newtype NamedSet0 =
  TEmptyNamedSet() or
  TNonEmptyNamedSet(NamedSetModule::Set ns)

/** A (possiby empty) set of argument names. */
class NamedSet extends NamedSet0 {
  /** Gets the non-empty set of names, if any. */
  NamedSetModule::Set asNonEmpty() { this = TNonEmptyNamedSet(result) }

  /** Gets the `i`'th name in this set according to some ordering. */
  private string getRankedName(int i) {
    result = rank[i + 1](string s | s = this.getALowerCaseName() | s)
  }

  /** Holds if this is the empty set. */
  predicate isEmpty() { this = TEmptyNamedSet() }

  int getSize() {
    result = strictcount(this.getALowerCaseName())
    or
    this.isEmpty() and
    result = 0
  }

  /** Gets a lower-case name in this set. */
  string getALowerCaseName() { this.asNonEmpty().contains(result) }

  /** Gets the textual representation of this set. */
  string toString() {
    result = "{" + strictconcat(this.getALowerCaseName(), ", ") + "}"
    or
    this.isEmpty() and
    result = "{}"
  }

  private CfgNodes::ExprNodes::CallExprCfgNode getABindingCallRec(int i) {
    exists(string name | name = this.getRankedName(i) and exists(result.getNamedArgument(name)) |
      i = 0
      or
      result = this.getABindingCallRec(i - 1)
    )
  }

  /**
   * Gets a `CfgNodes::CallCfgNode` that provides a named parameter for every name in `this`.
   *
   * NOTE: The `CfgNodes::CallCfgNode` may also provide more names.
   */
  CfgNodes::ExprNodes::CallExprCfgNode getABindingCall() {
    result = this.getABindingCallRec(this.getSize() - 1)
    or
    this.isEmpty() and
    exists(result)
  }

  /**
   * Gets a `Cmd` that provides exactly the named parameters represented by
   * this set.
   */
  CfgNodes::ExprNodes::CallExprCfgNode getAnExactBindingCall() {
    result = this.getABindingCallRec(this.getSize() - 1) and
    strictcount(string name | result.hasNamedArgument(name)) = this.getSize()
    or
    this.isEmpty() and
    not exists(result.getNamedArgument(_))
  }

  pragma[nomagic]
  private Function getAFunctionRec(int i) {
    i = 0 and
    result.getAParameter().getLowerCaseName() = this.getRankedName(0)
    or
    exists(string name |
      pragma[only_bind_into](name) = this.getRankedName(i) and
      result.getAParameter().getLowerCaseName() = pragma[only_bind_into](name) and
      result = this.getAFunctionRec(i - 1)
    )
  }

  /** Gets a function that has a parameter for each name in this set. */
  Function getAFunction() {
    result = this.getAFunctionRec(this.getSize() - 1)
    or
    this.isEmpty() and
    exists(result)
  }
}

NamedSet emptyNamedSet() { result.isEmpty() }

SsaImpl::NormalParameter getNormalParameter(FunctionBase f, int index) {
  result.getFunction() = f and
  result.getIndexExcludingPipelines() = index
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

  bindingset[p]
  pragma[inline_late]
  private predicate namedSetHasParameter(NamedSet ns, Parameter p) {
    ns.getALowerCaseName() = p.getLowerCaseName()
  }

  /**
   * The value of a normal parameter at function entry, viewed as a node in a data
   * flow graph.
   */
  class NormalParameterNode extends ParameterNodeImpl, TNormalParameterNode {
    SsaImpl::NormalParameter parameter;

    NormalParameterNode() { this = TNormalParameterNode(parameter) }

    override Parameter getParameter() { result = parameter }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      parameter.getEnclosingScope() = c.asCfgScope() and
      (
        pos.isKeyword(parameter.getLowerCaseName())
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
        exists(int i, int j, string name, NamedSet ns, FunctionBase f |
          pos.isPositional(j, ns) and
          parameter.getIndexExcludingPipelines() = i and
          f = parameter.getFunction() and
          f = ns.getAFunction() and
          name = parameter.getLowerCaseName() and
          not name = ns.getALowerCaseName() and
          j =
            i -
              count(int k, Parameter p |
                k < i and
                p = getNormalParameter(f, k) and
                namedSetHasParameter(ns, p)
              )
        )
      )
    }

    override CfgScope getCfgScope() { result.getAParameter() = parameter }

    override Location getLocationImpl() { result = parameter.getLocation() }

    override string toStringImpl() { result = parameter.toString() }
  }

  class ThisParameterNode extends ParameterNodeImpl, TThisParameterNode {
    Method m;

    ThisParameterNode() { this = TThisParameterNode(m) }

    override Parameter getParameter() { result = m.getThisParameter() }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      m.getBody() = c.asCfgScope() and
      pos.isThis()
    }

    override CfgScope getCfgScope() { result = m.getBody() }

    override Location getLocationImpl() { result = m.getLocation() }

    override string toStringImpl() { result = "this" }
  }

  class PipelineParameterNode extends ParameterNodeImpl, TPipelineParameterNode {
    private PipelineParameter parameter;

    PipelineParameterNode() { this = TPipelineParameterNode(parameter) }

    override PipelineParameter getParameter() { result = parameter }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      pos.isPipeline() and // what about when it is applied as a normal parameter?
      c.asCfgScope() = parameter.getEnclosingScope()
    }

    override CfgScope getCfgScope() { result = parameter.getEnclosingScope() }

    override Location getLocationImpl() { result = this.getParameter().getLocation() }

    override string toStringImpl() { result = this.getParameter().toString() }
  }

  class PipelineByPropertyNameParameterNode extends ParameterNodeImpl,
    TPipelineByPropertyNameParameterNode
  {
    private PipelineByPropertyNameParameter parameter;

    PipelineByPropertyNameParameterNode() { this = TPipelineByPropertyNameParameterNode(parameter) }

    override PipelineByPropertyNameParameter getParameter() { result = parameter }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      pos.isPipeline() and
      c.asCfgScope() = parameter.getEnclosingScope()
    }

    override CfgScope getCfgScope() { result = parameter.getEnclosingScope() }

    override Location getLocationImpl() { result = this.getParameter().getLocation() }

    override string toStringImpl() { result = this.getParameter().toString() }

    string getPropertyName() { result = parameter.getLowerCaseName() }
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

  abstract predicate sourceArgumentOf(
    CfgNodes::ExprNodes::CallExprCfgNode call, ArgumentPosition pos
  );

  /** Gets the call in which this node is an argument. */
  final DataFlowCall getCall() { this.argumentOf(result, _) }
}

module ArgumentNodes {
  class ExplicitArgumentNode extends ArgumentNode {
    CfgNodes::ExprNodes::ArgumentCfgNode arg;

    ExplicitArgumentNode() { this.asExpr() = arg }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      this.sourceArgumentOf(call.asCall(), pos)
    }

    override predicate sourceArgumentOf(
      CfgNodes::ExprNodes::CallExprCfgNode call, ArgumentPosition pos
    ) {
      arg.getCall() = call and
      (
        pos.isKeyword(arg.getLowerCaseName())
        or
        exists(NamedSet ns, int i |
          i = arg.getPosition() and
          ns.getAnExactBindingCall() = call and
          pos.isPositional(i, ns)
        )
      )
    }
  }

  class ThisArgumentNode extends ArgumentNode {
    CfgNodes::ExprNodes::QualifierCfgNode qual;

    ThisArgumentNode() { this.asExpr() = qual }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      this.sourceArgumentOf(call.asCall(), pos)
    }

    override predicate sourceArgumentOf(
      CfgNodes::ExprNodes::CallExprCfgNode call, ArgumentPosition pos
    ) {
      qual.getCall() = call and
      pos.isThis()
    }
  }

  class PipelineArgumentNode extends ArgumentNode instanceof ExprNode {
    PipelineArgumentNode() {
      this.getExprNode() instanceof CfgNodes::ExprNodes::PipelineArgumentCfgNode
    }

    CfgNodes::ExprNodes::PipelineArgumentCfgNode getPipelineArgument() {
      result = super.getExprNode()
    }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      this.sourceArgumentOf(call.asCall(), pos)
    }

    override predicate sourceArgumentOf(
      CfgNodes::ExprNodes::CallExprCfgNode call, ArgumentPosition pos
    ) {
      call = this.getPipelineArgument().getCall() and
      pos.isPipeline()
    }
  }

  private class SummaryArgumentNode extends FlowSummaryNode, ArgumentNode {
    private FlowSummaryImpl::Private::SummaryNode receiver;
    private ArgumentPosition pos_;

    SummaryArgumentNode() {
      FlowSummaryImpl::Private::summaryArgumentNode(receiver, this.getSummaryNode(), pos_)
    }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      call.(SummaryCall).getReceiver() = receiver and pos = pos_
    }

    override predicate sourceArgumentOf(
      CfgNodes::ExprNodes::CallExprCfgNode call, ArgumentPosition pos
    ) {
      none()
    }
  }
}

import ArgumentNodes

/** A data-flow node that represents a value returned by a callable. */
abstract class ReturnNode extends Node {
  /** Gets the kind of this return node. */
  abstract ReturnKind getKind();
}

private class SummaryReturnNode extends FlowSummaryNode, ReturnNode {
  private ReturnKind rk;

  SummaryReturnNode() { FlowSummaryImpl::Private::summaryReturnNode(this.getSummaryNode(), rk) }

  override ReturnKind getKind() { result = rk }
}

private module ReturnNodes {
  private CfgNodes::NamedBlockCfgNode getAReturnBlock(CfgNodes::ScriptBlockCfgNode sb) {
    result = sb.getBeginBlock()
    or
    result = sb.getEndBlock()
    or
    result = sb.getProcessBlock()
  }

  private module CfgScopeReturn implements PipelineReturns::InputSig {
    predicate isSource(CfgNodes::AstCfgNode source) { source = getAReturnBlock(_) }
  }

  private module P = PipelineReturns::Make<CfgScopeReturn>;

  /**
   * Holds if `n` may be returned, and there are possibly
   * more than one return value from the function.
   */
  predicate blockMayReturnMultipleValues(CfgNodes::ScriptBlockCfgNode scriptBlock) {
    P::mayReturnMultipleValues(getAReturnBlock(scriptBlock))
  }

  /**
   * Holds if `n` may be returned.
   */
  predicate isReturned(CfgNodes::AstCfgNode n) { n = P::getAReturn(_) }

  class NormalReturnNode extends ReturnNode instanceof ReturnNodeImpl {
    final override NormalReturnKind getKind() { any() }
  }
}

import ReturnNodes

/** A data-flow node that represents the output of a call. */
abstract class OutNode extends Node {
  /** Gets the underlying call, where this node is a corresponding output of kind `kind`. */
  abstract DataFlowCall getCall(ReturnKind kind);
}

private module OutNodes {
  /** A data-flow node that reads a value returned directly by a callable */
  class CallOutNode extends OutNode instanceof CallNode {
    override DataFlowCall getCall(ReturnKind kind) {
      result.asCall() = super.getCallNode() and
      kind instanceof NormalReturnKind
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
  // final env read -> env variable node
  pred.(FinalEnvVarRead).getVariable() = succ.(EnvVarNode).getVariable()
  or
  // env variable node -> initial env def
  exists(SsaImpl::Definition def |
    succ.(SsaDefinitionNodeImpl).getDefinition() = def and
    def.definesAt(pred.(EnvVarNode).getVariable(), any(EntryBasicBlock entry), -1)
  )
  or
  FlowSummaryImpl::Private::Steps::summaryJumpStep(pred.(FlowSummaryNode).getSummaryNode(),
    succ.(FlowSummaryNode).getSummaryNode())
}

private predicate arrayExprStore(Node node1, ContentSet cs, Node node2, CfgNodes::ExprCfgNode e) {
  exists(CfgNodes::ExprNodes::ArrayExprCfgNode ae, CfgNodes::StmtNodes::StmtBlockCfgNode block |
    e = node1.(AstNode).getCfgNode() and
    ae = node2.asExpr() and
    block = ae.getStmtBlock()
  |
    exists(Content::KnownElementContent ec, int index |
      e = ArrayExprFlow::getReturn(block, index) and
      cs.isKnownOrUnknownElement(ec) and
      index = ec.getIndex().asInt()
    )
    or
    not ArrayExprFlow::eachValueIsReturnedOnce(block) and
    e = ArrayExprFlow::getAReturn(block) and
    cs.isAnyElement()
  )
}

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to
 * content `c`.
 */
predicate storeStep(Node node1, ContentSet c, Node node2) {
  exists(CfgNodes::ExprNodes::MemberExprWriteAccessCfgNode var, Content::FieldContent fc |
    node2.(PostUpdateNode).getPreUpdateNode().asExpr() = var.getQualifier() and
    node1.asExpr() = var.getAssignStmt().getRightHandSide() and
    fc.getLowerCaseName() = var.getLowerCaseMemberName() and
    c.isSingleton(fc)
  )
  or
  exists(CfgNodes::ExprNodes::IndexExprWriteAccessCfgNode var, CfgNodes::ExprCfgNode e |
    node2.(PostUpdateNode).getPreUpdateNode().asExpr() = var.getBase() and
    node1.asExpr() = var.getAssignStmt().getRightHandSide() and
    e = var.getIndex()
  |
    exists(Content::KnownElementContent ec |
      c.isKnownOrUnknownElement(ec) and
      e.getValue() = ec.getIndex()
    )
    or
    not exists(Content::KnownElementContent ec | ec.getIndex() = e.getValue()) and
    c.isAnyElement()
  )
  or
  exists(Content::KnownElementContent ec, int index, CfgNodes::ExprCfgNode e |
    e = node1.asExpr() and
    not arrayExprStore(node1, _, _, e) and
    node2.asExpr().(CfgNodes::ExprNodes::ArrayLiteralCfgNode).getExpr(index) = e and
    c.isKnownOrUnknownPositional(ec) and
    index = ec.getIndex().asInt()
  )
  or
  exists(CfgNodes::ExprCfgNode key |
    node2.asExpr().(CfgNodes::ExprNodes::HashTableExprCfgNode).getValueFromKey(key) = node1.asExpr()
  |
    exists(Content::KnownElementContent ec |
      c.isKnownOrUnknownKeyContent(ec) and
      key.getValue() = ec.getIndex()
    )
    or
    not exists(Content::KnownKeyContent ec | ec.getIndex() = key.getValue()) and
    c.isUnknownKeyContent()
  )
  or
  arrayExprStore(node1, c, node2, _)
  or
  c.isUnknownPositionalContent() and
  exists(CfgNode cfgNode |
    node1 = TPreReturnNodeImpl(cfgNode, false) and
    node2.(ReturnNodeImpl).getCfgScope() = cfgNode.getScope()
  )
  or
  c.isUnknownPositionalContent() and
  exists(CfgNode cfgNode |
    node1 = TImplicitWrapNode(cfgNode, true) and
    node2.(ReturnNodeImpl).getCfgScope() = cfgNode.getScope()
  )
  or
  c.isUnknownPositionalContent() and
  exists(CfgNodes::ProcessBlockCfgNode process |
    node1 = TPreProcessNode(process) and
    node2 = TProcessNode(process)
  )
  or
  FlowSummaryImpl::Private::Steps::summaryStoreStep(node1.(FlowSummaryNode).getSummaryNode(), c,
    node2.(FlowSummaryNode).getSummaryNode())
}

/**
 * Holds if there is a read step of content `c` from `node1` to `node2`.
 */
predicate readStep(Node node1, ContentSet c, Node node2) {
  exists(CfgNodes::ExprNodes::MemberExprReadAccessCfgNode var, Content::FieldContent fc |
    node2.asExpr() = var and
    node1.asExpr() = var.getQualifier() and
    fc.getLowerCaseName() = var.getLowerCaseMemberName() and
    c.isSingleton(fc)
  )
  or
  exists(CfgNodes::ExprNodes::IndexExprReadAccessCfgNode var, CfgNodes::ExprCfgNode e |
    node2.asExpr() = var and
    node1.asExpr() = var.getBase() and
    e = var.getIndex()
  |
    exists(Content::KnownElementContent ec |
      c.isKnownOrUnknownElement(ec) and
      e.getValue() = ec.getIndex()
    )
    or
    not exists(Content::KnownElementContent ec | ec.getIndex() = e.getValue()) and
    c.isAnyElement()
  )
  or
  exists(CfgNode cfgNode |
    node1 = TPreReturnNodeImpl(cfgNode, true) and
    node2 = TImplicitWrapNode(cfgNode, true) and
    c.isSingleton(any(Content::KnownElementContent ec | exists(ec.getIndex().asInt())))
  )
  or
  c.isAnyPositional() and
  exists(CfgNodes::ProcessBlockCfgNode processBlock |
    processBlock.getPipelineParameterAccess() = node1.asExpr() and
    node2 = TProcessNode(processBlock)
  )
  or
  c.isAnyPositional() and
  exists(CfgNodes::ProcessBlockCfgNode pb, CfgNodes::ExprNodes::VarReadAccessCfgNode va |
    va = pb.getAPipelineByPropertyNameParameterAccess() and
    node1.asExpr() = va and
    node2 = TProcessPropertyByNameNode(va.getVariable(), false)
  )
  or
  exists(PipelineByPropertyNameParameter p, Content::KnownElementContent ec |
    c.isKnownOrUnknownElement(ec) and
    ec.getIndex().asString() = p.getLowerCaseName() and
    node1 = TProcessPropertyByNameNode(p, false) and
    node2 = TProcessPropertyByNameNode(p, true)
  )
  or
  FlowSummaryImpl::Private::Steps::summaryReadStep(node1.(FlowSummaryNode).getSummaryNode(), c,
    node2.(FlowSummaryNode).getSummaryNode())
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`. For example,
 * any value stored inside `f` is cleared at the pre-update node associated with `x`
 * in `x.f = newValue`.
 */
predicate clearsContent(Node n, ContentSet c) {
  FlowSummaryImpl::Private::Steps::summaryClearsContent(n.(FlowSummaryNode).getSummaryNode(), c)
  or
  c.isSingleton(any(Content::FieldContent fc)) and
  n = any(PostUpdateNode pun | storeStep(_, c, pun)).getPreUpdateNode()
  or
  n = TPreReturnNodeImpl(_, false) and
  c.isAnyElement()
  or
  c.isAnyPositional() and
  n instanceof PreProcessPropertyByNameNode
  or
  c.isAnyPositional() and
  n instanceof PreProcessNode
}

/**
 * Holds if the value that is being tracked is expected to be stored inside content `c`
 * at node `n`.
 */
predicate expectsContent(Node n, ContentSet c) {
  FlowSummaryImpl::Private::Steps::summaryExpectsContent(n.(FlowSummaryNode).getSummaryNode(), c)
  or
  n = TPreReturnNodeImpl(_, true) and
  c.isKnownOrUnknownElement(any(Content::KnownElementContent ec | exists(ec.getIndex().asInt())))
  or
  n = TImplicitWrapNode(_, false) and
  c.isSingleton(any(Content::UnknownElementContent ec))
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

  private class SummaryPostUpdateNode extends FlowSummaryNode, PostUpdateNodeImpl {
    private FlowSummaryNode pre;

    SummaryPostUpdateNode() {
      FlowSummaryImpl::Private::summaryPostUpdateNode(this.getSummaryNode(), pre.getSummaryNode())
    }

    override Node getPreUpdateNode() { result = pre }
  }
}

private import PostUpdateNodes

/**
 * A node that performs implicit array unwrapping when an expression
 * (or statement) is being returned from a function.
 */
private class ImplicitWrapNode extends TImplicitWrapNode, NodeImpl {
  private CfgNodes::ScriptBlockCfgNode n;
  private boolean shouldWrap;

  ImplicitWrapNode() { this = TImplicitWrapNode(n, shouldWrap) }

  CfgNodes::ScriptBlockCfgNode getScriptBlock() { result = n }

  predicate shouldWrap() { shouldWrap = true }

  override CfgScope getCfgScope() { result = n.getScope() }

  override Location getLocationImpl() { result = n.getLocation() }

  override string toStringImpl() { result = "implicit unwrapping of " + n.toString() }

  override predicate nodeIsHidden() { any() }
}

/**
 * A node that represents the return value before any array-unwrapping
 * has been performed.
 */
private class PreReturnNodeImpl extends TPreReturnNodeImpl, NodeImpl {
  private CfgNodes::ScriptBlockCfgNode n;
  private boolean isArray;

  PreReturnNodeImpl() { this = TPreReturnNodeImpl(n, isArray) }

  CfgNodes::AstCfgNode getScriptBlock() { result = n }

  override CfgScope getCfgScope() { result = n.getScope() }

  override Location getLocationImpl() { result = n.getLocation() }

  override string toStringImpl() { result = "pre-return value for " + n.toString() }

  override predicate nodeIsHidden() { any() }
}

/** The node that represents the return value of a function. */
private class ReturnNodeImpl extends TReturnNodeImpl, NodeImpl {
  CfgScope scope;

  ReturnNodeImpl() { this = TReturnNodeImpl(scope) }

  override CfgScope getCfgScope() { result = scope }

  override Location getLocationImpl() { result = scope.getLocation() }

  override string toStringImpl() { result = "return value for " + scope.toString() }

  override predicate nodeIsHidden() { any() }
}

private class PreProcessNode extends TPreProcessNode, NodeImpl {
  CfgNodes::ProcessBlockCfgNode process;

  PreProcessNode() { this = TPreProcessNode(process) }

  override CfgScope getCfgScope() { result = process.getScope() }

  override Location getLocationImpl() { result = process.getLocation() }

  override string toStringImpl() { result = "pre-process node for " + process.toString() }

  override predicate nodeIsHidden() { any() }

  CfgNodes::ProcessBlockCfgNode getProcessBlock() { result = process }
}

private class ProcessNode extends TProcessNode, NodeImpl {
  CfgNodes::ProcessBlockCfgNode process;

  ProcessNode() { this = TProcessNode(process) }

  override CfgScope getCfgScope() { result = process.getScope() }

  override Location getLocationImpl() { result = process.getLocation() }

  override string toStringImpl() { result = "process node for " + process.toString() }

  override predicate nodeIsHidden() { any() }

  PipelineIteratorVariable getPipelineIteratorVariable() {
    result = process.getPipelineIteratorVariable()
  }

  CfgNodes::ProcessBlockCfgNode getProcessBlock() { result = process }
}

private class PreProcessPropertyByNameNode extends TPreProcessPropertyByNameNode, NodeImpl {
  private CfgNodes::ExprNodes::VarReadAccessCfgNode va;

  PreProcessPropertyByNameNode() { this = TPreProcessPropertyByNameNode(va) }

  CfgNodes::ExprNodes::VarReadAccessCfgNode getAccess() { result = va }

  override CfgScope getCfgScope() { result = va.getScope() }

  override Location getLocationImpl() { result = this.getProcessBlock().getLocation() }

  override string toStringImpl() { result = "pre-process node for " + va.toString() }

  override predicate nodeIsHidden() { any() }

  CfgNodes::ProcessBlockCfgNode getProcessBlock() {
    result.getAPipelineByPropertyNameParameterAccess() = va
  }
}

private class ProcessPropertyByNameNode extends TProcessPropertyByNameNode, NodeImpl {
  private PipelineByPropertyNameParameter p;
  private boolean hasRead;

  ProcessPropertyByNameNode() { this = TProcessPropertyByNameNode(p, hasRead) }

  PipelineByPropertyNameParameter getParameter() { result = p }

  override CfgScope getCfgScope() { result = p.getDeclaringScope() }

  override Location getLocationImpl() { result = this.getProcessBlock().getLocation() }

  override string toStringImpl() {
    hasRead = false and
    result = "process node for " + p.toString()
    or
    hasRead = true and
    result = "[has read] process node for " + p.toString()
  }

  override predicate nodeIsHidden() { any() }

  CfgNodes::ProcessBlockCfgNode getProcessBlock() { result.getScope().getAParameter() = p }

  predicate hasRead() { hasRead = true }
}

class ScriptBlockNode extends TScriptBlockNode, NodeImpl {
  private ScriptBlock scriptBlock;

  ScriptBlockNode() { this = TScriptBlockNode(scriptBlock) }

  ScriptBlock getScriptBlock() { result = scriptBlock }

  override CfgScope getCfgScope() { result = scriptBlock }

  override Location getLocationImpl() { result = scriptBlock.getLocation() }

  override string toStringImpl() { result = scriptBlock.toString() }

  override predicate nodeIsHidden() { any() }
}

class EnvVarNode extends TEnvVarNode, NodeImpl {
  private EnvVariable v;

  EnvVarNode() { this = TEnvVarNode(v) }

  EnvVariable getVariable() { result = v }

  override CfgScope getCfgScope() { result = v.getEnclosingScope() }

  override Location getLocationImpl() { result = v.getLocation() }

  override string toStringImpl() { result = v.toString() }

  override predicate nodeIsHidden() { any() }
}

class FinalEnvVarRead extends TFinalEnvVarRead, NodeImpl {
  Scope scope;
  private EnvVariable v;

  FinalEnvVarRead() { this = TFinalEnvVarRead(scope, v) }

  EnvVariable getVariable() { result = v }

  override CfgScope getCfgScope() { result = scope }

  override Location getLocationImpl() { result = scope.getLocation() }

  override string toStringImpl() { result = v.toString() + " after " + scope }

  override predicate nodeIsHidden() { any() }
}

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

private class CmdName extends CfgNodes::ExprNodes::StringLiteralExprCfgNode {
  CmdName() { this = any(CfgNodes::ExprNodes::CallExprCfgNode c).getCallee() }

  string getName() { result = this.getValueString() }
}

/** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) {
  exists(kind) and
  exists(FunctionBase f |
    f.getBody() = c.asCfgScope() and
    creation.asExpr().(CmdName).getName() = f.getLowerCaseName()
  )
}

/**
 * Holds if `call` is a (from-source or from-summary) lambda call of kind `kind`
 * where `receiver` is the lambda expression.
 */
predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) {
  call.asCall().getCallee() = receiver.asExpr() and exists(kind)
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
  c instanceof Content::KnownPositionalContent and
  result = TKnownPositionalContentApprox()
  or
  result = TKnownKeyContentApprox(approxKnownElementIndex(c.(Content::KnownKeyContent).getIndex()))
  or
  result = TNonElementContentApprox(c)
  or
  c instanceof Content::UnknownKeyContent and
  result = TUnkownKeyContentApprox()
  or
  c instanceof Content::UnknownPositionalContent and
  result = TUnknownPositionalContentApprox()
  or
  c instanceof Content::UnknownKeyOrPositionContent and
  result = TUnknownContentApprox()
}
