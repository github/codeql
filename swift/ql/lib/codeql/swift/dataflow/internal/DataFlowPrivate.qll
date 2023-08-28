private import swift
private import DataFlowPublic
private import DataFlowDispatch
private import codeql.swift.controlflow.ControlFlowGraph
private import codeql.swift.controlflow.CfgNodes
private import codeql.swift.dataflow.Ssa
private import codeql.swift.controlflow.BasicBlocks
private import codeql.swift.dataflow.FlowSummary as FlowSummary
private import codeql.swift.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import codeql.swift.frameworks.StandardLibrary.PointerTypes
private import codeql.swift.frameworks.StandardLibrary.Array

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
    TExprPostUpdateNode(CfgNode n) {
      // Obviously, the base of setters needs a post-update node
      n = any(PropertySetterCfgNode setter).getBase()
      or
      // The base of getters and observers needs a post-update node to support reverse reads.
      n = any(PropertyGetterCfgNode getter).getBase()
      or
      n = any(PropertyObserverCfgNode getter).getBase()
      or
      // Arguments that are `inout` expressions needs a post-update node,
      // as well as any class-like argument (since a field can be modified).
      // Finally, qualifiers and bases of member reference need post-update nodes to support reverse reads.
      hasExprNode(n,
        [
          any(Argument arg | modifiable(arg)).getExpr(), any(MemberRefExpr ref).getBase(),
          any(ApplyExpr apply).getQualifier(), any(TupleElementExpr te).getSubExpr(),
          any(SubscriptExpr se).getBase()
        ])
    }

  private predicate localSsaFlowStepUseUse(Ssa::Definition def, Node nodeFrom, Node nodeTo) {
    def.adjacentReadPair(nodeFrom.getCfgNode(), nodeTo.getCfgNode()) and
    (
      nodeTo instanceof InoutReturnNode
      implies
      nodeTo.(InoutReturnNode).getParameter() = def.getSourceVariable().asVarDecl()
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
    nodeTo = getParameterDefNode(nodeFrom.(ParameterNode).getParameter())
  }

  private predicate localFlowStepCommon(Node nodeFrom, Node nodeTo) {
    exists(Ssa::Definition def |
      // Step from assignment RHS to def
      def.(Ssa::WriteDefinition).assigns(nodeFrom.getCfgNode()) and
      nodeTo.asDefinition() = def
      or
      // step from def to first read
      nodeFrom.asDefinition() = def and
      nodeTo.getCfgNode() = def.getAFirstRead() and
      (
        nodeTo instanceof InoutReturnNode
        implies
        nodeTo.(InoutReturnNode).getParameter() = def.getSourceVariable().asVarDecl()
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
    // flow through `?` and `?.`
    nodeFrom.asExpr() = nodeTo.asExpr().(BindOptionalExpr).getSubExpr()
    or
    nodeFrom.asExpr() = nodeTo.asExpr().(OptionalEvaluationExpr).getSubExpr()
    or
    // flow through unary `+` (which does nothing)
    nodeFrom.asExpr() = nodeTo.asExpr().(UnaryPlusExpr).getOperand()
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
    // Flow from the unique parameter of a key path expression to
    // the first component in the chain.
    nodeTo.(KeyPathComponentNodeImpl).getComponent() =
      nodeFrom.(KeyPathParameterNode).getComponent(0)
    or
    // flow through a flow summary (extension of `SummaryModelCsv`)
    FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom.(FlowSummaryNode).getSummaryNode(),
      nodeTo.(FlowSummaryNode).getSummaryNode(), true)
  }

  /**
   * This is the local flow predicate that is used as a building block in global
   * data flow.
   */
  cached
  predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
    localFlowStepCommon(nodeFrom, nodeTo)
  }

  /** This is the local flow predicate that is exposed. */
  cached
  predicate localFlowStepImpl(Node nodeFrom, Node nodeTo) {
    localFlowStepCommon(nodeFrom, nodeTo) or
    FlowSummaryImpl::Private::Steps::summaryThroughStepValue(nodeFrom, nodeTo, _)
  }

  cached
  newtype TContentSet = TSingletonContent(Content c)

  cached
  newtype TContent =
    TFieldContent(FieldDecl f) or
    TTupleContent(int index) { exists(any(TupleExpr te).getElement(index)) } or
    TEnumContent(ParamDecl f) { exists(EnumElementDecl d | d.getAParam() = f) } or
    TArrayContent() or
    TCollectionContent()
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
predicate nodeIsHidden(Node n) { n instanceof FlowSummaryNode }

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
    SummaryArgumentNode() {
      FlowSummaryImpl::Private::summaryArgumentNode(_, this.getSummaryNode(), _)
    }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      FlowSummaryImpl::Private::summaryArgumentNode(call, this.getSummaryNode(), pos)
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
    SummaryOutNode() { FlowSummaryImpl::Private::summaryOutNode(_, this.getSummaryNode(), _) }

    override DataFlowCall getCall(ReturnKind kind) {
      FlowSummaryImpl::Private::summaryOutNode(result, this.getSummaryNode(), kind)
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

predicate jumpStep(Node pred, Node succ) {
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
    c.isSingleton(any(Content::ArrayContent ac))
  )
  or
  // array assignment `a[n] = x`
  exists(AssignExpr assign, SubscriptExpr subscript |
    node1.asExpr() = assign.getSource() and
    node2.(PostUpdateNode).getPreUpdateNode().asExpr() = subscript.getBase() and
    subscript = assign.getDest() and
    subscript.getBase().getType() instanceof ArrayType and
    c.isSingleton(any(Content::ArrayContent ac))
  )
  or
  // creation of an optional via implicit wrapping keypath component
  exists(KeyPathComponent component |
    component.isOptionalWrapping() and
    node1.(KeyPathComponentNodeImpl).getComponent() = component and
    node2.(KeyPathReturnNodeImpl).getKeyPathExpr() = component.getKeyPathExpr() and
    c instanceof OptionalSomeContentSet
  )
  or
  FlowSummaryImpl::Private::Steps::summaryStoreStep(node1.(FlowSummaryNode).getSummaryNode(), c,
    node2.(FlowSummaryNode).getSummaryNode())
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
    component = node1.(KeyPathComponentNodeImpl).getComponent() and
    (
      c.isSingleton(any(Content::FieldContent ct | ct.getField() = component.getDeclRef()))
      or
      c.isSingleton(any(Content::ArrayContent ac)) and
      component.isSubscript()
      or
      c instanceof OptionalSomeContentSet and
      (
        component.isOptionalForcing()
        or
        component.isOptionalChaining()
      )
    )
  |
    // the next node is either the next element in the chain
    node2.(KeyPathComponentNodeImpl).getComponent() = component.getNextComponent()
    or
    // or the return node, if this is the last component in the chain
    not exists(component.getNextComponent()) and
    node2.(KeyPathReturnNodeImpl).getKeyPathExpr() = component.getKeyPathExpr()
  )
  or
  // read of an array member via subscript operator
  exists(SubscriptExpr subscript |
    subscript.getBase() = node1.asExpr() and
    subscript = node2.asExpr() and
    (
      subscript.getBase().getType() instanceof ArrayType and
      c.isSingleton(any(Content::ArrayContent ac))
      or
      c.isSingleton(any(Content::CollectionContent ac))
    )
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
  n = any(PostUpdateNode pun | storeStep(_, c, pun)).getPreUpdateNode()
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

/** Gets the type of `n` used for type pruning. */
DataFlowType getNodeType(Node n) {
  any() // return the singleton DataFlowType until we support type pruning for Swift
}

/** Gets a string representation of a `DataFlowType`. */
string ppReprType(DataFlowType t) { none() }

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
predicate forceHighPrecision(Content c) {
  c instanceof Content::ArrayContent or c instanceof Content::CollectionContent
}

/**
 * Holds if the node `n` is unreachable when the call context is `call`.
 */
predicate isUnreachableInCall(Node n, DataFlowCall call) { none() }

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

/**
 * Holds if flow is allowed to pass from parameter `p` and back to itself as a
 * side-effect, resulting in a summary from `p` to itself.
 *
 * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
 * by default as a heuristic.
 */
predicate allowParameterReturnInSelf(ParameterNode p) { none() }

/** An approximated `Content`. */
class ContentApprox = Unit;

/** Gets an approximated value for content `c`. */
pragma[inline]
ContentApprox getContentApprox(Content c) { any() }

/**
 * Gets an additional term that is added to the `join` and `branch` computations to reflect
 * an additional forward or backwards branching factor that is not taken into account
 * when calculating the (virtual) dispatch cost.
 *
 * Argument `arg` is part of a path from a source to a sink, and `p` is the target parameter.
 */
int getAdditionalFlowIntoCallNodeTerm(ArgumentNode arg, ParameterNode p) { none() }
