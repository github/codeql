private import csharp
private import cil
private import dotnet
private import DataFlowPrivate
private import semmle.code.csharp.Caching

/**
 * An element, viewed as a node in a data flow graph. Either an expression
 * (`ExprNode`) or a parameter (`ParameterNode`).
 */
class Node extends TNode {
  /** Gets the expression corresponding to this node, if any. */
  DotNet::Expr asExpr() { result = this.(ExprNode).getExpr() }

  /**
   * Gets the expression corresponding to this node, at control flow node `cfn`,
   * if any.
   */
  Expr asExprAtNode(ControlFlow::Nodes::ElementNode cfn) {
    this = TExprNode(cfn) and
    result = cfn.getElement()
  }

  /** Gets the parameter corresponding to this node, if any. */
  DotNet::Parameter asParameter() { result = this.(ParameterNode).getParameter() }

  /** Gets the type of this node. */
  cached
  DotNet::Type getType() { none() }

  /** Gets an upper bound on the type of this node. */
  DotNet::Type getTypeBound() { result = this.getType() } // stub implementation

  /** Gets the enclosing callable of this node. */
  cached
  DotNet::Callable getEnclosingCallable() { none() }

  /** Gets the control flow node corresponding to this node, if any. */
  cached
  ControlFlow::Node getControlFlowNode() { none() }

  /** Gets a textual representation of this node. */
  cached
  string toString() { none() }

  /** Gets the location of this node. */
  cached
  Location getLocation() { none() }
}

/**
 * An expression, viewed as a node in a data flow graph.
 *
 * Note that because of control-flow splitting, one `Expr` may correspond
 * to multiple `ExprNode`s, just like it may correspond to multiple
 * `ControlFlow::Node`s.
 */
class ExprNode extends Node {
  ExprNode() { this = TExprNode(_) or this = TCilExprNode(_) }

  /** Gets the expression corresponding to this node. */
  DotNet::Expr getExpr() {
    result = this.getExprAtNode(_)
    or
    this = TCilExprNode(result)
  }

  /**
   * Gets the expression corresponding to this node, at control flow node `cfn`,
   * if any.
   */
  Expr getExprAtNode(ControlFlow::Nodes::ElementNode cfn) {
    this = TExprNode(cfn) and
    result = cfn.getElement()
  }

  override DotNet::Callable getEnclosingCallable() {
    Stages::DataFlowStage::forceCachingInSameStage() and
    result = this.getExpr().getEnclosingCallable()
  }

  override ControlFlow::Nodes::ElementNode getControlFlowNode() {
    Stages::DataFlowStage::forceCachingInSameStage() and this = TExprNode(result)
  }

  override DotNet::Type getType() {
    Stages::DataFlowStage::forceCachingInSameStage() and result = this.getExpr().getType()
  }

  override Location getLocation() {
    Stages::DataFlowStage::forceCachingInSameStage() and result = this.getExpr().getLocation()
  }

  override string toString() {
    Stages::DataFlowStage::forceCachingInSameStage() and
    result = this.getControlFlowNode().toString()
    or
    this = TCilExprNode(_) and
    result = "CIL expression"
  }
}

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph.
 */
class ParameterNode extends Node {
  ParameterNode() {
    // charpred needed to avoid making `ParameterNode` abstract
    explicitParameterNode(this, _) or
    this.(SsaDefinitionNode).getDefinition() instanceof
      ImplicitCapturedParameterNodeImpl::SsaCapturedEntryDefinition or
    this = TInstanceParameterNode(_) or
    this = TCilParameterNode(_) or
    this = TTaintedParameterNode(_)
  }

  /** Gets the parameter corresponding to this node, if any. */
  DotNet::Parameter getParameter() { none() }

  /**
   * Holds if this node is the parameter of callable `c` at the specified
   * (zero-based) position.
   */
  predicate isParameterOf(DotNet::Callable c, int i) { none() }
}

/** Gets a node corresponding to expression `e`. */
ExprNode exprNode(DotNet::Expr e) { result.getExpr() = e }

/**
 * Gets the node corresponding to the value of parameter `p` at function entry.
 */
ParameterNode parameterNode(DotNet::Parameter p) { result.getParameter() = p }

predicate localFlowStep = localFlowStepImpl/2;

/**
 * Holds if data flows from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
predicate localFlow(Node source, Node sink) { localFlowStep*(source, sink) }

/**
 * A data flow node that jumps between callables. This can be extended in
 * framework code to add additional data flow steps.
 */
abstract class NonLocalJumpNode extends Node {
  /** Gets a successor node that is potentially in another callable. */
  abstract Node getAJumpSuccessor(boolean preservesValue);
}
