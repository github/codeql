private import swift
private import DataFlowPublic
private import DataFlowDispatch
private import codeql.swift.controlflow.ControlFlowGraph
private import codeql.swift.controlflow.CfgNodes
private import codeql.swift.dataflow.Ssa
private import codeql.swift.controlflow.BasicBlocks
private import codeql.swift.dataflow.FlowSummary as FlowSummary
private import codeql.swift.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl

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
    TSsaDefinitionNode(Ssa::Definition def) or
    TInoutReturnNode(ParamDecl param) { param.isInout() } or
    TInOutUpdateNode(Argument arg) { arg.getExpr() instanceof InOutExpr } or
    TSummaryNode(FlowSummary::SummarizedCallable c, FlowSummaryImpl::Private::SummaryNodeState state)

  private predicate hasExprNode(CfgNode n, Expr e) {
    n.(ExprCfgNode).getExpr() = e
    or
    n.(PropertyGetterCfgNode).getRef() = e
    or
    n.(PropertySetterCfgNode).getAssignExpr() = e
  }

  private predicate localSsaFlowStepUseUse(Ssa::Definition def, Node nodeFrom, Node nodeTo) {
    def.adjacentReadPair(nodeFrom.getCfgNode(), nodeTo.getCfgNode()) and
    (
      nodeTo instanceof InoutReturnNode
      implies
      nodeTo.(InoutReturnNode).getParameter() = def.getSourceVariable()
    )
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
        nodeTo.(InoutReturnNode).getParameter() = def.getSourceVariable()
      )
      or
      // use-use flow
      localSsaFlowStepUseUse(def, nodeFrom, nodeTo)
      or
      //localSsaFlowStepUseUse(def, nodeFrom.(PostUpdateNode).getPreUpdateNode(), nodeTo)
      //or
      // step from previous read to Phi node
      localFlowSsaInput(nodeFrom, def, nodeTo.asDefinition())
    )
    or
    // flow through writes to inout parameters
    exists(ParamReturnKind kind, ExprCfgNode arg |
      arg = nodeFrom.(InOutUpdateNode).getCall(kind).asCall().getArgument(kind.getIndex()) and
      nodeTo.asDefinition().(Ssa::WriteDefinition).isInoutDef(arg)
    )
    or
    // flow through `&` (inout argument)
    nodeFrom.asExpr() = nodeTo.asExpr().(InOutExpr).getSubExpr()
    or
    // flow through `try!` and similar constructs
    nodeFrom.asExpr() = nodeTo.asExpr().(AnyTryExpr).getSubExpr()
    or
    // flow through `!`
    nodeFrom.asExpr() = nodeTo.asExpr().(ForceValueExpr).getSubExpr()
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
  predicate localFlowStepImpl(Node nodeFrom, Node nodeTo) { localFlowStepCommon(nodeFrom, nodeTo) }

  cached
  newtype TContentSet = TODO_TContentSet()

  cached
  newtype TContent = TODO_Content()
}

import Cached

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) { none() }

private module ParameterNodes {
  abstract class ParameterNodeImpl extends NodeImpl {
    predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) { none() }
  }

  class NormalParameterNode extends ParameterNodeImpl, SsaDefinitionNodeImpl {
    ParamDecl param;

    NormalParameterNode() {
      exists(BasicBlock bb, int i |
        super.asDefinition().definesAt(param, bb, i) and
        bb.getNode(i).getNode().asAstNode() = param
      )
    }

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
  }
}

import ParameterNodes

/** A data-flow node used to model flow summaries. */
class SummaryNode extends NodeImpl, TSummaryNode {
  private FlowSummaryImpl::Public::SummarizedCallable c;
  private FlowSummaryImpl::Private::SummaryNodeState state;

  SummaryNode() { this = TSummaryNode(c, state) }

  override DataFlowCallable getEnclosingCallable() { result = TDataFlowFunc(c) }

  override UnknownLocation getLocationImpl() { any() }

  override string toStringImpl() { result = "[summary] " + state + " in " + c }
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
      // TODO: This should be an rvalue representing the `getBase` when
      // `observer` a `didSet` observer.
      observer.getSource() = this.getCfgNode()
    }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      call.(PropertySetterCall).getSetter() = observer and
      (
        pos = TThisArgument() and
        observer.getBase() = this.getCfgNode()
        or
        // TODO: See the comment above for `didSet` observers.
        pos.(PositionalArgumentPosition).getIndex() = 0 and
        observer.getSource() = this.getCfgNode()
      )
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
  class CallOutNode extends OutNode, ExprNodeImpl {
    ApplyExprCfgNode apply;

    CallOutNode() { apply = this.getCfgNode() }

    override DataFlowCall getCall(ReturnKind kind) {
      result.asCall() = apply and kind instanceof NormalReturnKind
    }
  }

  class InOutUpdateNode extends OutNode, TInOutUpdateNode, NodeImpl {
    Argument arg;

    InOutUpdateNode() { this = TInOutUpdateNode(arg) }

    override DataFlowCall getCall(ReturnKind kind) {
      result.asCall().getExpr() = arg.getApplyExpr() and
      kind.(ParamReturnKind).getIndex() = arg.getIndex()
    }

    override DataFlowCallable getEnclosingCallable() {
      result = this.getCall(_).getEnclosingCallable()
    }

    override Location getLocationImpl() { result = arg.getLocation() }

    override string toStringImpl() { result = arg.toString() }
  }
}

import OutNodes

predicate jumpStep(Node pred, Node succ) { none() }

predicate storeStep(Node node1, ContentSet c, Node node2) { none() }

predicate readStep(Node node1, ContentSet c, Node node2) { none() }

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

private newtype TDataFlowType = TODO_DataFlowType()

class DataFlowType extends TDataFlowType {
  string toString() { result = "" }
}

/** Gets the type of `n` used for type pruning. */
DataFlowType getNodeType(NodeImpl n) {
  any() // return the singleton DataFlowType until we support type pruning for Swift
}

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

private module PostUpdateNodes { }

private import PostUpdateNodes

/** A node that performs a type cast. */
class CastNode extends Node {
  CastNode() { none() }
}

class DataFlowExpr = Expr;

class DataFlowParameter = ParamDecl;

int accessPathLimit() { result = 5 }

/**
 * Holds if access paths with `c` at their head always should be tracked at high
 * precision. This disables adaptive access path precision for such access paths.
 */
predicate forceHighPrecision(Content c) { none() }

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
