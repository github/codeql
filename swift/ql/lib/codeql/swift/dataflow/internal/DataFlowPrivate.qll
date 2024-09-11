private import swift
private import DataFlowPublic
private import DataFlowDispatch
private import codeql.swift.controlflow.ControlFlowGraph
private import codeql.swift.controlflow.CfgNodes
private import codeql.swift.dataflow.Ssa
private import codeql.swift.controlflow.BasicBlocks
private import codeql.swift.dataflow.FlowSummary as FlowSummary
private import codeql.swift.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.frameworks.StandardLibrary.PointerTypes
private import codeql.swift.frameworks.StandardLibrary.Array
private import codeql.swift.frameworks.StandardLibrary.Dictionary
private import codeql.dataflow.VariableCapture as VariableCapture

/** Gets the callable in which this node occurs. */
DataFlowCallable nodeGetEnclosingCallable(Node n) { result = n.(NodeImpl).getEnclosingCallable() }

/** Holds if `p` is a `ParameterNode` of `c` with position `pos`. */
predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
  p.(ParameterNodeImpl).isParameterOf(c, pos)
}

/** Holds if `arg` is an `ArgumentNode` of `c` with position `pos`. */
predicate isArgumentNode(ArgumentNode arg, DataFlowCall c, ArgumentPosition pos) {
  arg.argumentOf(c, pos)
}

abstract class NodeImpl extends Node {
  abstract DataFlowCallable getEnclosingCallable();

  /** Do not call: use `getLocation()` instead. */
  abstract Location getLocationImpl();

  /** Do not call: use `toString()` instead. */
  abstract string toStringImpl();
}

private class ExprNodeImpl extends ExprNode, NodeImpl {
  override Location getLocationImpl() { result = expr.getLocation() }

  override string toStringImpl() { result = expr.toString() }

  override DataFlowCallable getEnclosingCallable() { result = TDataFlowFunc(n.getScope()) }
}

private class KeyPathComponentNodeImpl extends TKeyPathComponentNode, NodeImpl {
  KeyPathComponent component;

  KeyPathComponentNodeImpl() { this = TKeyPathComponentNode(component) }

  override Location getLocationImpl() { result = component.getLocation() }

  override string toStringImpl() { result = component.toString() }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = component.getKeyPathExpr()
  }

  KeyPathComponent getComponent() { result = component }
}

private class KeyPathComponentPostUpdateNode extends TKeyPathComponentPostUpdateNode, NodeImpl,
  PostUpdateNodeImpl
{
  KeyPathComponent component;

  KeyPathComponentPostUpdateNode() { this = TKeyPathComponentPostUpdateNode(component) }

  override Location getLocationImpl() { result = component.getLocation() }

  override string toStringImpl() { result = "[post] " + component.toString() }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = component.getKeyPathExpr()
  }

  override KeyPathComponentNodeImpl getPreUpdateNode() {
    result.getComponent() = this.getComponent()
  }

  KeyPathComponent getComponent() { result = component }
}

private class PatternNodeImpl extends PatternNode, NodeImpl {
  override Location getLocationImpl() { result = pattern.getLocation() }

  override string toStringImpl() { result = pattern.toString() }

  override DataFlowCallable getEnclosingCallable() { result = TDataFlowFunc(n.getScope()) }
}

private class SsaDefinitionNodeImpl extends SsaDefinitionNode, NodeImpl {
  override Location getLocationImpl() { result = def.getLocation() }

  override string toStringImpl() { result = def.toString() }

  override DataFlowCallable getEnclosingCallable() {
    result = TDataFlowFunc(def.getBasicBlock().getScope())
  }
}

private class CaptureNodeImpl extends CaptureNode, NodeImpl {
  override Location getLocationImpl() { result = this.getSynthesizedCaptureNode().getLocation() }

  override string toStringImpl() { result = this.getSynthesizedCaptureNode().toString() }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = this.getSynthesizedCaptureNode().getEnclosingCallable()
  }
}

private predicate localFlowSsaInput(Node nodeFrom, Ssa::Definition def, Ssa::Definition next) {
  exists(BasicBlock bb, int i | def.lastRefRedef(bb, i, next) |
    def.definesAt(_, bb, i) and
    def = nodeFrom.asDefinition()
  )
}

/** A collection of cached types and predicates to be evaluated in the same stage. */
cached
private module Cached {
  cached
  newtype TNode =
    TExprNode(CfgNode n, Expr e) { hasExprNode(n, e) } or
    TPatternNode(CfgNode n, Pattern p) { hasPatternNode(n, p) } or
    TSsaDefinitionNode(Ssa::Definition def) or
    TInoutReturnNode(ParamDecl param) { modifiableParam(param) } or
    TFlowSummaryNode(FlowSummaryImpl::Private::SummaryNode sn) or
    TSourceParameterNode(ParamDecl param) or
    TKeyPathParameterNode(EntryNode entry) { entry.getScope() instanceof KeyPathExpr } or
    TKeyPathReturnNode(ExitNode exit) { exit.getScope() instanceof KeyPathExpr } or
    TKeyPathComponentNode(KeyPathComponent component) or
    TKeyPathParameterPostUpdateNode(EntryNode entry) { entry.getScope() instanceof KeyPathExpr } or
    TKeyPathReturnPostUpdateNode(ExitNode exit) { exit.getScope() instanceof KeyPathExpr } or
    TKeyPathComponentPostUpdateNode(KeyPathComponent component) or
    TExprPostUpdateNode(CfgNode n) {
      // Obviously, the base of setters needs a post-update node
      n = any(PropertySetterCfgNode setter).getBase()
      or
      // The base of getters and observers needs a post-update node to support reverse reads.
      n = any(PropertyGetterCfgNode getter).getBase()
      or
      n = any(PropertyObserverCfgNode getter).getBase()
      or
      n = any(KeyPathApplicationExprCfgNode expr).getBase()
      or
      // Arguments that are `inout` expressions needs a post-update node,
      // as well as any class-like argument (since a field can be modified).
      // Finally, qualifiers and bases of member reference need post-update nodes to support reverse reads.
      hasExprNode(n,
        [
          any(Argument arg | modifiable(arg)).getExpr(), any(MemberRefExpr ref).getBase(),
          any(ApplyExpr apply).getQualifier(), any(TupleElementExpr te).getSubExpr(),
          any(SubscriptExpr se).getBase(),
          any(ApplyExpr apply | not exists(apply.getStaticTarget())).getFunction()
        ])
    } or
    TDictionarySubscriptNode(SubscriptExpr e) {
      e.getBase().getType().getCanonicalType() instanceof CanonicalDictionaryType
    } or
    TCaptureNode(CaptureFlow::SynthesizedCaptureNode cn) or
    TClosureSelfParameterNode(ClosureExpr closure)

  private predicate localSsaFlowStepUseUse(Ssa::Definition def, Node nodeFrom, Node nodeTo) {
    def.adjacentReadPair(nodeFrom.getCfgNode(), nodeTo.getCfgNode()) and
    (
      nodeTo instanceof InoutReturnNodeImpl
      implies
      nodeTo.(InoutReturnNodeImpl).getParameter() = def.getSourceVariable().asVarDecl()
    )
  }

  private SsaDefinitionNode getParameterDefNode(ParamDecl p) {
    exists(BasicBlock bb, int i |
      bb.getNode(i).getNode().asAstNode() = p and
      result.asDefinition().definesAt(_, bb, i)
    )
  }

  /**
   * Holds if `nodeFrom` is a parameter node, and `nodeTo` is a corresponding SSA node.
   */
  private predicate localFlowSsaParamInput(Node nodeFrom, Node nodeTo) {
    nodeTo = getParameterDefNode(nodeFrom.asParameter())
  }

  private predicate localFlowStepCommon(Node nodeFrom, Node nodeTo, string model) {
    (
      exists(Ssa::Definition def |
        // Step from assignment RHS to def
        def.(Ssa::WriteDefinition).assigns(nodeFrom.getCfgNode()) and
        nodeTo.asDefinition() = def
        or
        // step from def to first read
        nodeFrom.asDefinition() = def and
        nodeTo.getCfgNode() = def.getAFirstRead() and
        (
          nodeTo instanceof InoutReturnNodeImpl
          implies
          nodeTo.(InoutReturnNodeImpl).getParameter() = def.getSourceVariable().asVarDecl()
        )
        or
        // use-use flow
        localSsaFlowStepUseUse(def, nodeFrom, nodeTo)
        or
        localSsaFlowStepUseUse(def, nodeFrom.(PostUpdateNode).getPreUpdateNode(), nodeTo)
        or
        // step from previous read to Phi node
        localFlowSsaInput(nodeFrom, def, nodeTo.asDefinition())
      )
      or
      localFlowSsaParamInput(nodeFrom, nodeTo)
      or
      // flow through `&` (inout argument)
      nodeFrom.asExpr() = nodeTo.asExpr().(InOutExpr).getSubExpr()
      or
      // reverse flow through `&` (inout argument)
      nodeFrom.(PostUpdateNode).getPreUpdateNode().asExpr().(InOutExpr).getSubExpr() =
        nodeTo.(PostUpdateNode).getPreUpdateNode().asExpr()
      or
      // flow through `try!` and similar constructs
      nodeFrom.asExpr() = nodeTo.asExpr().(AnyTryExpr).getSubExpr()
      or
      // flow through `!`
      // note: there's a case in `readStep` that handles when the source is the
      //   `OptionalSomeContentSet` within the RHS. This case is for when the
      //   `Optional` itself is tainted (which it usually shouldn't be, but
      //   retaining this case increases robustness of flow).
      nodeFrom.asExpr() = nodeTo.asExpr().(ForceValueExpr).getSubExpr()
      or
      // read of an optional .some member via `let x: T = y: T?` pattern matching
      // note: similar to `ForceValueExpr` this is ideally a content `readStep` but
      //   in practice we sometimes have taint on the optional itself.
      nodeTo.asPattern() = nodeFrom.asPattern().(OptionalSomePattern).getSubPattern()
      or
      // flow through `?` and `?.`
      nodeFrom.asExpr() = nodeTo.asExpr().(BindOptionalExpr).getSubExpr()
      or
      nodeFrom.asExpr() = nodeTo.asExpr().(OptionalEvaluationExpr).getSubExpr()
      or
      // flow through unary `+` (which does nothing)
      nodeFrom.asExpr() = nodeTo.asExpr().(UnaryPlusExpr).getOperand()
      or
      // flow through varargs expansions (that wrap an `ArrayExpr` where varargs enter a call)
      nodeFrom.asExpr() = nodeTo.asExpr().(VarargExpansionExpr).getSubExpr()
      or
      // flow through nil-coalescing operator `??`
      exists(BinaryExpr nco |
        nco.getOperator().(FreeFunction).getName() = "??(_:_:)" and
        nodeTo.asExpr() = nco
      |
        // value argument
        nodeFrom.asExpr() = nco.getAnOperand()
        or
        // unpack closure (the second argument is an `AutoClosureExpr` argument)
        nodeFrom.asExpr() = nco.getAnOperand().(AutoClosureExpr).getExpr()
      )
      or
      // flow through ternary operator `? :`
      exists(IfExpr ie |
        nodeTo.asExpr() = ie and
        nodeFrom.asExpr() = ie.getBranch(_)
      )
      or
      // flow through OpenExistentialExpr (compiler generated expression wrapper)
      nodeFrom.asExpr() = nodeTo.asExpr().(OpenExistentialExpr).getSubExpr()
      or
      // flow from Expr to Pattern
      exists(Expr e, Pattern p |
        nodeFrom.asExpr() = e and
        nodeTo.asPattern() = p and
        p.getImmediateMatchingExpr() = e
      )
      or
      // flow from Pattern to an identity-preserving sub-Pattern:
      nodeTo.asPattern() =
        [
          nodeFrom.asPattern().(IsPattern).getSubPattern(),
          nodeFrom.asPattern().(TypedPattern).getSubPattern()
        ]
      or
      // Flow from the last component in a key path chain to
      // the return node for the key path.
      exists(KeyPathExpr keyPath |
        nodeFrom.(KeyPathComponentNodeImpl).getComponent() =
          keyPath.getComponent(keyPath.getNumberOfComponents() - 1) and
        nodeTo.(KeyPathReturnNodeImpl).getKeyPathExpr() = keyPath
      )
      or
      exists(KeyPathExpr keyPath |
        nodeTo.(KeyPathComponentPostUpdateNode).getComponent() =
          keyPath.getComponent(keyPath.getNumberOfComponents() - 1) and
        nodeFrom.(KeyPathReturnPostUpdateNode).getKeyPathExpr() = keyPath
      )
      or
      // Flow to the result of a keypath assignment
      exists(KeyPathApplicationExpr apply, AssignExpr assign |
        apply = assign.getDest() and
        nodeTo.asExpr() = apply and
        nodeFrom.asExpr() = assign.getSource()
      )
      or
      // flow step according to the closure capture library
      captureValueStep(nodeFrom, nodeTo)
    ) and
    model = ""
    or
    // flow through a flow summary (extension of `SummaryModelCsv`)
    FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom.(FlowSummaryNode).getSummaryNode(),
      nodeTo.(FlowSummaryNode).getSummaryNode(), true, model)
  }

  /**
   * This is the local flow predicate that is used as a building block in global
   * data flow.
   */
  cached
  predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo, string model) {
    localFlowStepCommon(nodeFrom, nodeTo, model)
  }

  /** This is the local flow predicate that is exposed. */
  cached
  predicate localFlowStepImpl(Node nodeFrom, Node nodeTo) {
    localFlowStepCommon(nodeFrom, nodeTo, _)
    or
    // models-as-data summarized flow
    FlowSummaryImpl::Private::Steps::summaryThroughStepValue(nodeFrom, nodeTo, _)
  }

  cached
  newtype TContentSet = TSingletonContent(Content c)

  cached
  newtype TContent =
    TFieldContent(FieldDecl f) or
    TTupleContent(int index) { exists(any(TupleExpr te).getElement(index)) } or
    TEnumContent(ParamDecl f) { exists(EnumElementDecl d | d.getAParam() = f) } or
    TCollectionContent() or
    TCapturedVariableContent(CapturedVariable v)
}

/**
 * Holds if `arg` can be modified (by overwriting the content completely),
 * or if any of its fields can be overwritten by a function call.
 */
private predicate modifiable(Argument arg) {
  arg.getExpr() instanceof InOutExpr
  or
  arg.getExpr().getType() instanceof NominalOrBoundGenericNominalType
}

predicate modifiableParam(ParamDecl param) {
  param.isInout()
  or
  param instanceof SelfParamDecl
}

private predicate hasExprNode(CfgNode n, Expr e) {
  n.(ExprCfgNode).getExpr() = e
  or
  n.(PropertyGetterCfgNode).getRef() = e
  or
  n.(PropertySetterCfgNode).getAssignExpr() = e
  or
  n.(PropertyObserverCfgNode).getAssignExpr() = e
}

private predicate hasPatternNode(PatternCfgNode n, Pattern p) {
  n.getPattern() = p and
  p = p.resolve() // no need to turn hidden-AST patterns (`let`s, parens) into data flow nodes
}

import Cached

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) {
  n instanceof FlowSummaryNode or n instanceof ClosureSelfParameterNode
}

/**
 * The intermediate node for a dictionary subscript operation `dict[key]`. In a write, this is used
 * as the destination of the `storeStep`s that add `TupleContent`s and the source of the storeStep
 * that adds `CollectionContent`. In a read, this is the destination of the `readStep` that pops
 * `CollectionContent` and the source of the `readStep` that pops `TupleContent[0]`
 */
private class DictionarySubscriptNode extends NodeImpl, TDictionarySubscriptNode {
  SubscriptExpr expr;

  DictionarySubscriptNode() { this = TDictionarySubscriptNode(expr) }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = expr.getEnclosingCallable()
  }

  override string toStringImpl() { result = "DictionarySubscriptNode" }

  override Location getLocationImpl() { result = expr.getLocation() }

  SubscriptExpr getExpr() { result = expr }
}

private module ParameterNodes {
  abstract class ParameterNodeImpl extends NodeImpl {
    predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) { none() }

    /** Gets the parameter associated with this node, if any. */
    ParamDecl getParameter() { none() }
  }

  class SourceParameterNode extends ParameterNodeImpl, TSourceParameterNode {
    ParamDecl param;

    SourceParameterNode() { this = TSourceParameterNode(param) }

    override Location getLocationImpl() { result = param.getLocation() }

    override string toStringImpl() { result = param.toString() }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      exists(Callable f | c = TDataFlowFunc(f) |
        exists(int index | f.getParam(index) = param and pos = TPositionalParameter(index))
        or
        f.getSelfParam() = param and pos = TThisParameter()
      )
    }

    override DataFlowCallable getEnclosingCallable() { this.isParameterOf(result, _) }

    override ParamDecl getParameter() { result = param }
  }

  class ClosureSelfParameterNode extends ParameterNodeImpl, TClosureSelfParameterNode {
    ClosureExpr closure;

    ClosureSelfParameterNode() { this = TClosureSelfParameterNode(closure) }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      c.asSourceCallable() = closure and
      pos instanceof TThisParameter
    }

    override Location getLocationImpl() { result = closure.getLocation() }

    override string toStringImpl() { result = "closure self parameter" }

    override DataFlowCallable getEnclosingCallable() { this.isParameterOf(result, _) }

    ClosureExpr getClosure() { result = closure }
  }

  class SummaryParameterNode extends ParameterNodeImpl, FlowSummaryNode {
    SummaryParameterNode() {
      FlowSummaryImpl::Private::summaryParameterNode(this.getSummaryNode(), _)
    }

    private ParameterPosition getPosition() {
      FlowSummaryImpl::Private::summaryParameterNode(this.getSummaryNode(), result)
    }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition p) {
      c.getUnderlyingCallable() = this.getSummarizedCallable() and
      p = this.getPosition()
    }
  }

  class KeyPathParameterNode extends ParameterNodeImpl, TKeyPathParameterNode {
    private EntryNode entry;

    KeyPathParameterNode() { this = TKeyPathParameterNode(entry) }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      c.asSourceCallable() = entry.getScope() and pos = TThisParameter()
    }

    override Location getLocationImpl() { result = entry.getLocation() }

    override string toStringImpl() { result = entry.toString() }

    override DataFlowCallable getEnclosingCallable() { this.isParameterOf(result, _) }

    KeyPathComponent getComponent(int i) { result = entry.getScope().(KeyPathExpr).getComponent(i) }

    KeyPathComponent getAComponent() { result = this.getComponent(_) }

    KeyPathExpr getKeyPathExpr() { result = entry.getScope() }
  }
}

import ParameterNodes

/** A data-flow node used to model flow summaries. */
class FlowSummaryNode extends NodeImpl, TFlowSummaryNode {
  FlowSummaryImpl::Private::SummaryNode getSummaryNode() { this = TFlowSummaryNode(result) }

  FlowSummary::SummarizedCallable getSummarizedCallable() {
    result = this.getSummaryNode().getSummarizedCallable()
  }

  override DataFlowCallable getEnclosingCallable() {
    result.asSummarizedCallable() = this.getSummarizedCallable()
  }

  override Location getLocationImpl() { result = this.getSummarizedCallable().getLocation() }

  override string toStringImpl() { result = this.getSummaryNode().toString() }
}

class KeyPathParameterPostUpdateNode extends NodeImpl, ReturnNode, PostUpdateNodeImpl,
  TKeyPathParameterPostUpdateNode
{
  private EntryNode entry;

  KeyPathParameterPostUpdateNode() { this = TKeyPathParameterPostUpdateNode(entry) }

  override KeyPathParameterNode getPreUpdateNode() {
    result.getKeyPathExpr() = this.getKeyPathExpr()
  }

  override Location getLocationImpl() { result = entry.getLocation() }

  override string toStringImpl() { result = "[post] " + entry.toString() }

  override DataFlowCallable getEnclosingCallable() { result.asSourceCallable() = entry.getScope() }

  KeyPathComponent getComponent(int i) { result = entry.getScope().(KeyPathExpr).getComponent(i) }

  KeyPathComponent getAComponent() { result = this.getComponent(_) }

  KeyPathExpr getKeyPathExpr() { result = entry.getScope() }

  override ReturnKind getKind() { result.(ParamReturnKind).getIndex() = -1 }
}

class KeyPathReturnPostUpdateNode extends NodeImpl, ParameterNodeImpl, PostUpdateNodeImpl,
  TKeyPathReturnPostUpdateNode
{
  private ExitNode exit;

  KeyPathReturnPostUpdateNode() { this = TKeyPathReturnPostUpdateNode(exit) }

  override KeyPathReturnNodeImpl getPreUpdateNode() {
    result.getKeyPathExpr() = this.getKeyPathExpr()
  }

  override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
    c.asSourceCallable() = this.getKeyPathExpr() and pos = TPositionalParameter(0)
  }

  override Location getLocationImpl() { result = exit.getLocation() }

  override string toStringImpl() { result = "[post] " + exit.toString() }

  override DataFlowCallable getEnclosingCallable() { result.asSourceCallable() = exit.getScope() }

  KeyPathExpr getKeyPathExpr() { result = exit.getScope() }
}

/** A data-flow node that represents a call argument. */
abstract class ArgumentNode extends Node {
  /** Holds if this argument occurs at the given position in the given call. */
  abstract predicate argumentOf(DataFlowCall call, ArgumentPosition pos);

  /** Gets the call in which this node is an argument. */
  final DataFlowCall getCall() { this.argumentOf(result, _) }
}

private module ArgumentNodes {
  class NormalArgumentNode extends ExprNode, ArgumentNode {
    NormalArgumentNode() { exists(DataFlowCall call | call.getAnArgument() = this.getCfgNode()) }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      call.getArgument(pos.(PositionalArgumentPosition).getIndex()) = this.getCfgNode()
      or
      pos = TThisArgument() and
      call.getArgument(-1) = this.getCfgNode()
    }
  }

  class PropertyGetterArgumentNode extends ExprNode, ArgumentNode {
    private PropertyGetterCfgNode getter;

    PropertyGetterArgumentNode() { getter.getBase() = this.getCfgNode() }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      call.(PropertyGetterCall).getGetter() = getter and
      pos = TThisArgument()
    }
  }

  class SetterArgumentNode extends ExprNode, ArgumentNode {
    private PropertySetterCfgNode setter;

    SetterArgumentNode() {
      setter.getBase() = this.getCfgNode() or
      setter.getSource() = this.getCfgNode()
    }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      call.(PropertySetterCall).getSetter() = setter and
      (
        pos = TThisArgument() and
        setter.getBase() = this.getCfgNode()
        or
        pos.(PositionalArgumentPosition).getIndex() = 0 and
        setter.getSource() = this.getCfgNode()
      )
    }
  }

  class ObserverArgumentNode extends ExprNode, ArgumentNode {
    private PropertyObserverCfgNode observer;

    ObserverArgumentNode() {
      observer.getBase() = this.getCfgNode()
      or
      observer.getSource() = this.getCfgNode()
    }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      call.(PropertySetterCall).getSetter() = observer and
      (
        pos = TThisArgument() and
        observer.getBase() = this.getCfgNode()
        or
        pos.(PositionalArgumentPosition).getIndex() = 0 and
        observer.getSource() = this.getCfgNode()
      )
    }
  }

  class SummaryArgumentNode extends FlowSummaryNode, ArgumentNode {
    private SummaryCall call_;
    private ArgumentPosition pos_;

    SummaryArgumentNode() {
      FlowSummaryImpl::Private::summaryArgumentNode(call_.getReceiver(), this.getSummaryNode(), pos_)
    }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      call = call_ and
      pos = pos_
    }
  }

  class KeyPathArgumentNode extends ExprNode, ArgumentNode {
    private KeyPathApplicationExprCfgNode keyPath;

    KeyPathArgumentNode() { keyPath.getBase() = this.getCfgNode() }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      call.asKeyPath() = keyPath and
      pos = TThisArgument()
    }
  }

  class KeyPathAssignmentArgumentNode extends ArgumentNode {
    private KeyPathApplicationExprCfgNode keyPath;

    KeyPathAssignmentArgumentNode() {
      keyPath = this.getCfgNode() and
      exists(AssignExpr assign | assign.getDest() = keyPath.getNode().asAstNode())
    }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      call.asKeyPath() = keyPath and
      pos = TPositionalArgument(0)
    }
  }

  class SelfClosureArgumentNode extends ExprNode, ArgumentNode {
    ApplyExprCfgNode apply;

    SelfClosureArgumentNode() { n = apply.getFunction() }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      apply = call.asCall() and
      not exists(apply.getStaticTarget()) and
      pos instanceof ThisArgumentPosition
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
  class ReturnReturnNode extends ReturnNode, ExprNode {
    ReturnReturnNode() { exists(ReturnStmt stmt | stmt.getResult() = this.asExpr()) }

    override ReturnKind getKind() { result instanceof NormalReturnKind }
  }

  /**
   * A data-flow node that represents the `self` value in an initializer being
   * implicitly returned as the newly-constructed object
   */
  class SelfReturnNode extends InoutReturnNodeImpl {
    SelfReturnNode() {
      exit.getScope() instanceof Initializer and
      param instanceof SelfParamDecl
    }

    override ReturnKind getKind() { result instanceof NormalReturnKind }
  }

  class InoutReturnNodeImpl extends ReturnNode, TInoutReturnNode, NodeImpl {
    ParamDecl param;
    ControlFlowNode exit;

    InoutReturnNodeImpl() {
      this = TInoutReturnNode(param) and
      exit instanceof ExitNode and
      exit.getScope() = param.getDeclaringFunction()
    }

    override ReturnKind getKind() { result.(ParamReturnKind).getIndex() = param.getIndex() }

    override ControlFlowNode getCfgNode() { result = exit }

    override DataFlowCallable getEnclosingCallable() {
      result = TDataFlowFunc(param.getDeclaringFunction())
    }

    ParamDecl getParameter() { result = param }

    override Location getLocationImpl() { result = exit.getLocation() }

    override string toStringImpl() { result = param.toString() + "[return]" }
  }

  private class SummaryReturnNode extends FlowSummaryNode, ReturnNode {
    private ReturnKind rk;

    SummaryReturnNode() { FlowSummaryImpl::Private::summaryReturnNode(this.getSummaryNode(), rk) }

    override ReturnKind getKind() { result = rk }
  }

  class KeyPathReturnNodeImpl extends ReturnNode, TKeyPathReturnNode, NodeImpl {
    ExitNode exit;

    KeyPathReturnNodeImpl() { this = TKeyPathReturnNode(exit) }

    override ReturnKind getKind() { result instanceof NormalReturnKind }

    override ControlFlowNode getCfgNode() { result = exit }

    override DataFlowCallable getEnclosingCallable() { result.asSourceCallable() = exit.getScope() }

    override Location getLocationImpl() { result = exit.getLocation() }

    override string toStringImpl() { result = exit.toString() }

    KeyPathExpr getKeyPathExpr() { result = exit.getScope() }
  }
}

import ReturnNodes

/** A data-flow node that represents the output of a call. */
abstract class OutNode extends Node {
  /** Gets the underlying call, where this node is a corresponding output of kind `kind`. */
  abstract DataFlowCall getCall(ReturnKind kind);
}

private module OutNodes {
  class CallOutNode extends OutNode, ExprNodeImpl {
    ApplyExprCfgNode apply;

    CallOutNode() { apply = this.getCfgNode() }

    override DataFlowCall getCall(ReturnKind kind) {
      result.asCall() = apply and kind instanceof NormalReturnKind
    }
  }

  class KeyPathOutNode extends OutNode, ExprNodeImpl {
    KeyPathApplicationExprCfgNode keyPath;

    KeyPathOutNode() { keyPath = this.getCfgNode() }

    override DataFlowCall getCall(ReturnKind kind) {
      result.asKeyPath() = keyPath and kind instanceof NormalReturnKind
    }
  }

  class SummaryOutNode extends OutNode, FlowSummaryNode {
    private SummaryCall call;
    private ReturnKind kind_;

    SummaryOutNode() {
      FlowSummaryImpl::Private::summaryOutNode(call.getReceiver(), this.getSummaryNode(), kind_)
    }

    override DataFlowCall getCall(ReturnKind kind) {
      result = call and
      kind = kind_
    }
  }

  class InOutUpdateArgNode extends OutNode, ExprPostUpdateNode {
    Argument arg;

    InOutUpdateArgNode() {
      modifiable(arg) and
      hasExprNode(n, arg.getExpr())
    }

    override DataFlowCall getCall(ReturnKind kind) {
      result.getAnArgument() = n and
      kind.(ParamReturnKind).getIndex() = arg.getIndex()
    }
  }

  class InOutUpdateQualifierNode extends OutNode, ExprPostUpdateNode {
    InOutUpdateQualifierNode() { hasExprNode(n, any(ApplyExpr apply).getQualifier()) }

    override DataFlowCall getCall(ReturnKind kind) {
      result.getAnArgument() = n and
      kind.(ParamReturnKind).getIndex() = -1
    }
  }

  class PropertySetterOutNode extends OutNode, ExprNodeImpl {
    PropertySetterCfgNode setter;

    PropertySetterOutNode() { setter = this.getCfgNode() }

    override DataFlowCall getCall(ReturnKind kind) {
      result.(PropertySetterCall).getSetter() = setter and kind.(ParamReturnKind).getIndex() = -1
    }
  }

  class PropertyGetterOutNode extends OutNode, ExprNodeImpl {
    PropertyGetterCfgNode getter;

    PropertyGetterOutNode() { getter = this.getCfgNode() }

    override DataFlowCall getCall(ReturnKind kind) {
      result.(PropertyGetterCall).getGetter() = getter and kind instanceof NormalReturnKind
    }
  }

  class PropertyObserverOutNode extends OutNode, ExprNodeImpl {
    PropertyObserverCfgNode observer;

    PropertyObserverOutNode() { observer = this.getCfgNode() }

    override DataFlowCall getCall(ReturnKind kind) {
      result.(PropertyGetterCall).getGetter() = observer and kind.(ParamReturnKind).getIndex() = -1
    }
  }
}

import OutNodes

/**
 * Holds if there is a data flow step from `e1` to `e2` that only steps from
 * child to parent in the AST.
 */
private predicate simpleAstFlowStep(Expr e1, Expr e2) {
  e2.(IfExpr).getBranch(_) = e1
  or
  e2.(AssignExpr).getSource() = e1
  or
  e2.(ArrayExpr).getAnElement() = e1
}

private predicate closureFlowStep(CaptureInput::Expr e1, CaptureInput::Expr e2) {
  simpleAstFlowStep(e1, e2)
  or
  exists(Ssa::WriteDefinition def |
    def.getARead().getNode().asAstNode() = e2 and
    def.assigns(any(CfgNode cfg | cfg.getNode().asAstNode() = e1))
  )
  or
  e2.(Pattern).getImmediateMatchingExpr() = e1
}

private module CaptureInput implements VariableCapture::InputSig<Location> {
  private import swift as S
  private import codeql.swift.controlflow.ControlFlowGraph as Cfg
  private import codeql.swift.controlflow.BasicBlocks as B

  class BasicBlock instanceof B::BasicBlock {
    string toString() { result = super.toString() }

    ControlFlowNode getNode(int i) { result = super.getNode(i) }

    int length() { result = super.length() }

    Callable getEnclosingCallable() { result = super.getScope() }

    Location getLocation() { result = super.getLocation() }
  }

  class ControlFlowNode = Cfg::ControlFlowNode;

  BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) {
    result.(B::BasicBlock).immediatelyDominates(bb)
  }

  BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.(B::BasicBlock).getASuccessor() }

  class CapturedVariable instanceof S::VarDecl {
    CapturedVariable() {
      any(S::CapturedDecl capturedDecl).getDecl() = this and
      exists(this.getEnclosingCallable())
    }

    string toString() { result = super.toString() }

    Callable getCallable() { result = super.getEnclosingCallable() }

    Location getLocation() { result = super.getLocation() }
  }

  class CapturedParameter extends CapturedVariable instanceof S::ParamDecl { }

  class Expr instanceof S::AstNode {
    string toString() { result = super.toString() }

    Location getLocation() { result = super.getLocation() }

    predicate hasCfgNode(BasicBlock bb, int i) {
      this = bb.(B::BasicBlock).getNode(i).getNode().asAstNode()
    }
  }

  class VariableWrite extends Expr {
    CapturedVariable variable;
    Expr source;

    VariableWrite() {
      exists(S::Assignment a | this = a |
        a.getDest().(DeclRefExpr).getDecl() = variable and
        source = a.getSource()
      )
      or
      exists(S::NamedPattern np | this = np |
        variable = np.getVarDecl() and
        source = np.getMatchingExpr()
      )
    }

    CapturedVariable getVariable() { result = variable }

    Expr getSource() { result = source }
  }

  class VariableRead extends Expr instanceof S::DeclRefExpr {
    CapturedVariable v;

    VariableRead() { this.getDecl() = v and not isLValue(this) }

    CapturedVariable getVariable() { result = v }
  }

  class ClosureExpr extends Expr instanceof S::Callable {
    ClosureExpr() { any(S::CapturedDecl c).getScope() = this }

    predicate hasBody(Callable body) { this = body }

    predicate hasAliasedAccess(Expr f) { closureFlowStep+(this, f) and not closureFlowStep(f, _) }
  }

  class Callable extends S::Callable {
    predicate isConstructor() {
      // A class declaration cannot capture a variable in Swift. Consider this hypothetical example:
      // ```
      // protocol Interface { }
      // func foo() -> Interface {
      //   let y = 42
      //   class Impl : Interface {
      //     let x : Int
      //     init() {
      //         x = y
      //     }
      //   }
      //   let object = Impl()
      //   return object
      // }
      // ```
      // The Swift compiler will reject this with an error message such as
      // ```
      // error: class declaration cannot close over value 'y' defined in outer scope
      //          x = y
      //              ^
      // ```
      none()
    }
  }
}

class CapturedVariable = CaptureInput::CapturedVariable;

class CapturedParameter = CaptureInput::CapturedParameter;

module CaptureFlow = VariableCapture::Flow<Location, CaptureInput>;

private CaptureFlow::ClosureNode asClosureNode(Node n) {
  result = n.(CaptureNode).getSynthesizedCaptureNode()
  or
  result.(CaptureFlow::ExprNode).getExpr() = n.asExpr()
  or
  result.(CaptureFlow::ExprPostUpdateNode).getExpr() =
    n.(PostUpdateNode).getPreUpdateNode().asExpr()
  or
  result.(CaptureFlow::ParameterNode).getParameter() = n.asParameter()
  or
  result.(CaptureFlow::ThisParameterNode).getCallable() = n.(ClosureSelfParameterNode).getClosure()
  or
  exists(CaptureInput::VariableWrite write |
    result.(CaptureFlow::VariableWriteSourceNode).getVariableWrite() = write and
    n.asExpr() = write.getSource()
  )
}

private predicate captureStoreStep(Node node1, Content::CapturedVariableContent c, Node node2) {
  CaptureFlow::storeStep(asClosureNode(node1), c.getVariable(), asClosureNode(node2))
}

private predicate captureReadStep(Node node1, Content::CapturedVariableContent c, Node node2) {
  CaptureFlow::readStep(asClosureNode(node1), c.getVariable(), asClosureNode(node2))
}

predicate captureValueStep(Node node1, Node node2) {
  CaptureFlow::localFlowStep(asClosureNode(node1), asClosureNode(node2))
}

predicate jumpStep(Node pred, Node succ) {
  // models-as-data summarized flow
  FlowSummaryImpl::Private::Steps::summaryJumpStep(pred.(FlowSummaryNode).getSummaryNode(),
    succ.(FlowSummaryNode).getSummaryNode())
}

predicate storeStep(Node node1, ContentSet c, Node node2) {
  // assignment to a member variable `obj.member = value`
  exists(MemberRefExpr ref, AssignExpr assign |
    ref = assign.getDest() and
    node1.asExpr() = assign.getSource() and
    node2.(PostUpdateNode).getPreUpdateNode().asExpr() = ref.getBase() and
    c.isSingleton(any(Content::FieldContent ct | ct.getField() = ref.getMember()))
  )
  or
  // creation of a tuple `(v1, v2)`
  exists(TupleExpr tuple, int pos |
    node1.asExpr() = tuple.getElement(pos) and
    node2.asExpr() = tuple and
    c.isSingleton(any(Content::TupleContent tc | tc.getIndex() = pos))
  )
  or
  // assignment to a tuple member `tuple.index = value`
  exists(TupleElementExpr tuple, AssignExpr assign |
    tuple = assign.getDest() and
    node1.asExpr() = assign.getSource() and
    node2.(PostUpdateNode).getPreUpdateNode().asExpr() = tuple.getSubExpr() and
    c.isSingleton(any(Content::TupleContent tc | tc.getIndex() = tuple.getIndex()))
  )
  or
  // creation of an enum `.variant(v1, v2)`
  exists(EnumElementExpr enum, int pos |
    node1.asExpr() = enum.getArgument(pos).getExpr() and
    node2.asExpr() = enum and
    c.isSingleton(any(Content::EnumContent ec | ec.getParam() = enum.getElement().getParam(pos)))
  )
  or
  // creation of an optional via implicit conversion,
  // i.e. from `f(x)` where `x: T` into `f(.some(x))` where the context `f` expects a `T?`.
  exists(InjectIntoOptionalExpr e |
    e.convertsFrom(node1.asExpr()) and
    node2 = node1 and // TODO: we should ideally have a separate Node case for the (hidden) InjectIntoOptionalExpr
    c instanceof OptionalSomeContentSet
  )
  or
  // creation of an optional by returning from a failable initializer (`init?`)
  exists(Initializer init |
    node1.asExpr().(CallExpr).getStaticTarget() = init and
    node2 = node1 and // TODO: again, we should ideally have a separate Node case here, and not reuse the CallExpr
    c instanceof OptionalSomeContentSet and
    init.isFailable()
  )
  or
  // assignment to an optional via `!`, e.g. `optional! = ...`
  exists(ForceValueExpr fve, AssignExpr assign |
    fve = assign.getDest() and
    node1.asExpr() = assign.getSource() and
    node2.asExpr() = fve.getSubExpr() and
    c instanceof OptionalSomeContentSet
  )
  or
  // creation of an array `[v1,v2]`
  exists(ArrayExpr arr |
    node1.asExpr() = arr.getAnElement() and
    node2.asExpr() = arr and
    c.isSingleton(any(Content::CollectionContent ac))
  )
  or
  // subscript assignment `a[n] = x`
  exists(AssignExpr assign, SubscriptExpr subscript |
    node1.asExpr() = assign.getSource() and
    node2.(PostUpdateNode).getPreUpdateNode().asExpr() = subscript.getBase() and
    subscript = assign.getDest() and
    not any(DictionarySubscriptNode n).getExpr() = subscript and
    c.isSingleton(any(Content::CollectionContent ac))
  )
  or
  // creation of an optional via implicit wrapping keypath component
  exists(KeyPathComponent component |
    component.isOptionalWrapping() and
    node1.(KeyPathComponentNodeImpl).getComponent().getNextComponent() = component and
    node2.(KeyPathComponentNodeImpl).getComponent() = component and
    c instanceof OptionalSomeContentSet
  )
  or
  // assignment to a dictionary value via subscript operator, with intermediate step
  // `dict[key] = value`
  exists(AssignExpr assign, SubscriptExpr subscript |
    subscript = assign.getDest() and
    (
      subscript.getArgument(0).getExpr() = node1.asExpr() and
      node2.(DictionarySubscriptNode).getExpr() = subscript and
      c.isSingleton(any(Content::TupleContent tc | tc.getIndex() = 0))
      or
      assign.getSource() = node1.asExpr() and
      node2.(DictionarySubscriptNode).getExpr() = subscript and
      c.isSingleton(any(Content::TupleContent tc | tc.getIndex() = 1))
      or
      node1.(DictionarySubscriptNode).getExpr() = subscript and
      node2.(PostUpdateNode).getPreUpdateNode().asExpr() = subscript.getBase() and
      c.isSingleton(any(Content::CollectionContent cc))
    )
  )
  or
  // creation of a dictionary `[key: value, ...]`
  exists(DictionaryExpr dict |
    node1.asExpr() = dict.getAnElement() and
    node2.asExpr() = dict and
    c.isSingleton(any(Content::CollectionContent cc))
  )
  or
  // models-as-data summarized flow
  FlowSummaryImpl::Private::Steps::summaryStoreStep(node1.(FlowSummaryNode).getSummaryNode(), c,
    node2.(FlowSummaryNode).getSummaryNode())
  or
  captureStoreStep(node1, any(Content::CapturedVariableContent cvc | c.isSingleton(cvc)), node2)
}

predicate isLValue(Expr e) { any(AssignExpr assign).getDest() = e }

predicate readStep(Node node1, ContentSet c, Node node2) {
  // read of a member variable `obj.member`
  exists(MemberRefExpr ref |
    not isLValue(ref) and
    node1.asExpr() = ref.getBase() and
    node2.asExpr() = ref and
    c.isSingleton(any(Content::FieldContent ct | ct.getField() = ref.getMember()))
  )
  or
  // read of a tuple member `tuple.index`
  exists(TupleElementExpr tuple |
    node1.asExpr() = tuple.getSubExpr() and
    node2.asExpr() = tuple and
    c.isSingleton(any(Content::TupleContent tc | tc.getIndex() = tuple.getIndex()))
  )
  or
  // read of an enum member via `case let .variant(v1, v2)` pattern matching
  exists(EnumElementPattern enumPat, ParamDecl enumParam, Pattern subPat |
    node1.asPattern() = enumPat and
    node2.asPattern() = subPat and
    c.isSingleton(any(Content::EnumContent ec | ec.getParam() = enumParam))
  |
    exists(int idx |
      enumPat.getElement().getParam(idx) = enumParam and
      enumPat.getSubPattern(idx) = subPat
    )
  )
  or
  // read of an enum (`Optional.Some`) member via `!`
  node1.asExpr() = node2.asExpr().(ForceValueExpr).getSubExpr() and
  c instanceof OptionalSomeContentSet
  or
  // read of a tuple member via `case let (v1, v2)` pattern matching
  exists(TuplePattern tupPat, int idx, Pattern subPat |
    node1.asPattern() = tupPat and
    node2.asPattern() = subPat and
    c.isSingleton(any(Content::TupleContent tc | tc.getIndex() = idx))
  |
    tupPat.getElement(idx) = subPat
  )
  or
  // read of an optional .some member via `let x: T = y: T?` pattern matching
  exists(OptionalSomePattern pat |
    node1.asPattern() = pat and
    node2.asPattern() = pat.getSubPattern() and
    c instanceof OptionalSomeContentSet
  )
  or
  // read of a component in a key-path expression chain
  exists(KeyPathComponent component |
    // the first node is either the previous element in the chain
    node1.(KeyPathComponentNodeImpl).getComponent().getNextComponent() = component
    or
    // or the start node, if this is the first component in the chain
    component = node1.(KeyPathParameterNode).getComponent(0)
  |
    component = node2.(KeyPathComponentNodeImpl).getComponent() and
    (
      c.isSingleton(any(Content::FieldContent ct | ct.getField() = component.getDeclRef()))
      or
      c.isSingleton(any(Content::CollectionContent ac)) and
      component.isSubscript()
      or
      c instanceof OptionalSomeContentSet and
      (
        component.isOptionalForcing()
        or
        component.isOptionalChaining()
      )
    )
  )
  or
  // read of array or collection content via subscript operator
  exists(SubscriptExpr subscript |
    subscript.getBase() = node1.asExpr() and
    subscript = node2.asExpr() and
    c.isSingleton(any(Content::CollectionContent ac))
  )
  or
  // read of a dictionary value via subscript operator
  exists(SubscriptExpr subscript |
    subscript.getBase() = node1.asExpr() and
    node2.(DictionarySubscriptNode).getExpr() = subscript and
    c.isSingleton(any(Content::CollectionContent cc))
    or
    subscript = node2.asExpr() and
    node1.(DictionarySubscriptNode).getExpr() = subscript and
    c.isSingleton(any(Content::TupleContent tc | tc.getIndex() = 1))
  )
  or
  // read of an optional into the loop variable via foreach
  exists(ForEachStmt for |
    node1.asExpr() = for.getNextCall() and
    node2.asPattern() = for.getPattern() and
    c instanceof OptionalSomeContentSet
  )
  or
  // models-as-data summarized flow
  FlowSummaryImpl::Private::Steps::summaryReadStep(node1.(FlowSummaryNode).getSummaryNode(), c,
    node2.(FlowSummaryNode).getSummaryNode())
  or
  captureReadStep(node1, any(Content::CapturedVariableContent cvc | c.isSingleton(cvc)), node2)
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`. For example,
 * any value stored inside `f` is cleared at the pre-update node associated with `x`
 * in `x.f = newValue`.
 */
predicate clearsContent(Node n, ContentSet c) {
  n = any(PostUpdateNode pun | storeStep(_, c, pun)).getPreUpdateNode() and
  (
    c.isSingleton(any(Content::FieldContent fc)) or
    c.isSingleton(any(Content::TupleContent tc)) or
    c.isSingleton(any(Content::EnumContent ec))
  )
}

/**
 * Holds if the value that is being tracked is expected to be stored inside content `c`
 * at node `n`.
 */
predicate expectsContent(Node n, ContentSet c) { none() }

/**
 * The global singleton `Optional.some` content set.
 */
private class OptionalSomeContentSet extends ContentSet {
  OptionalSomeContentSet() {
    exists(EnumDecl optional, EnumElementDecl some |
      some.getDeclaringDecl() = optional and
      some.getName() = "some" and
      optional.getName() = "Optional" and
      optional.getModule().getName() = "Swift"
    |
      this.isSingleton(any(Content::EnumContent ec | ec.getParam() = some.getParam(0)))
    )
  }
}

private newtype TDataFlowType = TODO_DataFlowType()

class DataFlowType extends TDataFlowType {
  string toString() { result = "" }
}

predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) { none() }

predicate localMustFlowStep(Node node1, Node node2) { none() }

/** Gets the type of `n` used for type pruning. */
DataFlowType getNodeType(Node n) {
  any() // return the singleton DataFlowType until we support type pruning for Swift
}

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
predicate compatibleTypes(DataFlowType t1, DataFlowType t2) { any() }

abstract class PostUpdateNodeImpl extends Node {
  /** Gets the node before the state update. */
  abstract Node getPreUpdateNode();
}

private module PostUpdateNodes {
  class ExprPostUpdateNode extends PostUpdateNodeImpl, NodeImpl, TExprPostUpdateNode {
    CfgNode n;

    ExprPostUpdateNode() { this = TExprPostUpdateNode(n) }

    override ExprNode getPreUpdateNode() { n = result.getCfgNode() }

    override Location getLocationImpl() { result = n.getLocation() }

    override string toStringImpl() { result = "[post] " + n.toString() }

    override DataFlowCallable getEnclosingCallable() { result = TDataFlowFunc(n.getScope()) }
  }

  class SummaryPostUpdateNode extends FlowSummaryNode, PostUpdateNodeImpl {
    SummaryPostUpdateNode() {
      FlowSummaryImpl::Private::summaryPostUpdateNode(this.getSummaryNode(), _)
    }

    override Node getPreUpdateNode() {
      FlowSummaryImpl::Private::summaryPostUpdateNode(this.getSummaryNode(),
        result.(FlowSummaryNode).getSummaryNode())
    }
  }

  class CapturePostUpdateNode extends PostUpdateNodeImpl, CaptureNode {
    private CaptureNode pre;

    CapturePostUpdateNode() {
      CaptureFlow::capturePostUpdateNode(this.getSynthesizedCaptureNode(),
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

class DataFlowExpr = Expr;

/**
 * Holds if access paths with `c` at their head always should be tracked at high
 * precision. This disables adaptive access path precision for such access paths.
 */
predicate forceHighPrecision(Content c) { c instanceof Content::CollectionContent }

class NodeRegion instanceof Unit {
  string toString() { result = "NodeRegion" }

  predicate contains(Node n) { none() }
}

/**
 * Holds if the nodes in `nr` are unreachable when the call context is `call`.
 */
predicate isUnreachableInCall(NodeRegion nr, DataFlowCall call) { none() }

newtype LambdaCallKind = TLambdaCallKind()

/** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) {
  kind = TLambdaCallKind() and
  (
    // Closures
    c.getUnderlyingCallable() = creation.asExpr()
    or
    // Reference to a function declaration
    creation.asExpr().(DeclRefExpr).getDecl() = c.getUnderlyingCallable()
  )
}

/** Holds if `call` is a lambda call of kind `kind` where `receiver` is the lambda expression. */
predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) {
  kind = TLambdaCallKind() and
  receiver.asExpr() = call.asCall().getExpr().(ApplyExpr).getFunction()
  or
  kind = TLambdaCallKind() and
  receiver.(FlowSummaryNode).getSummaryNode() = call.(SummaryCall).getReceiver()
  or
  kind = TLambdaCallKind() and
  receiver.asExpr() = call.asKeyPath().getExpr().(KeyPathApplicationExpr).getKeyPath()
}

/** Extra data-flow steps needed for lambda flow analysis. */
predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

predicate knownSourceModel(Node source, string model) { sourceNode(source, _, model) }

predicate knownSinkModel(Node sink, string model) { sinkNode(sink, _, model) }

class DataFlowSecondLevelScope = Unit;

/**
 * Holds if flow is allowed to pass from parameter `p` and back to itself as a
 * side-effect, resulting in a summary from `p` to itself.
 *
 * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
 * by default as a heuristic.
 */
predicate allowParameterReturnInSelf(ParameterNode p) {
  exists(Callable c |
    c = p.(ParameterNodeImpl).getEnclosingCallable().asSourceCallable() and
    CaptureFlow::heuristicAllowInstanceParameterReturnInSelf(c)
  )
  or
  exists(DataFlowCallable c, ParameterPosition pos |
    p.(ParameterNodeImpl).isParameterOf(c, pos) and
    FlowSummaryImpl::Private::summaryAllowParameterReturnInSelf(c.asSummarizedCallable(), pos)
  )
}

/** An approximated `Content`. */
class ContentApprox = Unit;

/** Gets an approximated value for content `c`. */
pragma[inline]
ContentApprox getContentApprox(Content c) { any() }
