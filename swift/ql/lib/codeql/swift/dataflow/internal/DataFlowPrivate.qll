private import swift
private import DataFlowPublic
private import DataFlowDispatch
private import codeql.swift.controlflow.CfgNodes
private import codeql.swift.dataflow.Ssa

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
  DataFlowCallable getEnclosingCallable() { none() }

  /** Do not call: use `getLocation()` instead. */
  abstract Location getLocationImpl();

  /** Do not call: use `toString()` instead. */
  abstract string toStringImpl();
}

private class ExprNodeImpl extends ExprNode, NodeImpl {
  override Location getLocationImpl() { result = expr.getLocation() }

  override string toStringImpl() { result = expr.toString() }
}

private class SsaDefinitionNodeImpl extends SsaDefinitionNode, NodeImpl {
  override Location getLocationImpl() { result = def.getLocation() }

  override string toStringImpl() { result = def.toString() }
}

/** A collection of cached types and predicates to be evaluated in the same stage. */
cached
private module Cached {
  cached
  newtype TNode =
    TExprNode(ExprCfgNode e) or
    TNormalParameterNode(ParamDecl p) or
    TSsaDefinitionNode(Ssa::Definition def)

  private predicate localFlowStepCommon(Node nodeFrom, Node nodeTo) {
    exists(Ssa::Definition def |
      // Step from assignment RHS to def
      def.(Ssa::WriteDefinition).assigns(nodeFrom.getCfgNode()) and
      nodeTo.asDefinition() = def
      or
      // step from def to first read
      nodeFrom.asDefinition() = def and
      nodeTo.getCfgNode() = def.getAFirstRead()
      or
      // use-use flow
      def.adjacentReadPair(nodeFrom.getCfgNode(), nodeTo.getCfgNode())
    )
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

  class NormalParameterNode extends ParameterNodeImpl, TNormalParameterNode {
    ParamDecl param;

    NormalParameterNode() { this = TNormalParameterNode(param) }

    override Location getLocationImpl() { result = param.getLocation() }

    override string toStringImpl() { result = param.toString() }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      none() // TODO
    }
  }
}

import ParameterNodes

/** A data-flow node that represents a call argument. */
abstract class ArgumentNode extends Node {
  /** Holds if this argument occurs at the given position in the given call. */
  abstract predicate argumentOf(DataFlowCall call, ArgumentPosition pos);

  /** Gets the call in which this node is an argument. */
  final DataFlowCall getCall() { this.argumentOf(result, _) }
}

private module ArgumentNodes { }

import ArgumentNodes

/** A data-flow node that represents a value returned by a callable. */
abstract class ReturnNode extends Node {
  /** Gets the kind of this return node. */
  abstract ReturnKind getKind();
}

private module ReturnNodes { }

import ReturnNodes

/** A data-flow node that represents the output of a call. */
abstract class OutNode extends Node {
  /** Gets the underlying call, where this node is a corresponding output of kind `kind`. */
  abstract DataFlowCall getCall(ReturnKind kind);
}

private module OutNodes { }

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
DataFlowType getNodeType(NodeImpl n) { none() }

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

newtype LambdaCallKind = TODO_TLambdaCallKind()

/** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) { none() }

/** Holds if `call` is a lambda call of kind `kind` where `receiver` is the lambda expression. */
predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) { none() }

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
