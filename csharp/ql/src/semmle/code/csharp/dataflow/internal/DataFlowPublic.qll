private import csharp
private import cil
private import dotnet
private import DataFlowPrivate
private import DataFlowPrivateCached as C

/**
 * An element, viewed as a node in a data flow graph. Either an expression
 * (`ExprNode`) or a parameter (`ParameterNode`).
 */
class Node extends C::TNode {
  /** Gets the expression corresponding to this node, if any. */
  DotNet::Expr asExpr() { result = this.(ExprNode).getExpr() }

  /**
   * Gets the expression corresponding to this node, at control flow node `cfn`,
   * if any.
   */
  Expr asExprAtNode(ControlFlow::Nodes::ElementNode cfn) {
    this = C::TExprNode(cfn) and
    result = cfn.getElement()
  }

  /** Gets the parameter corresponding to this node, if any. */
  DotNet::Parameter asParameter() { result = this.(ParameterNode).getParameter() }

  /** Gets the type of this node. */
  final Type getType() { result = C::getType(this) }

  /** Gets an upper bound on the type of this node. */
  Type getTypeBound() { result = this.getType() } // stub implementation

  /** Gets the enclosing callable of this node. */
  final DotNet::Callable getEnclosingCallable() { result = C::getEnclosingCallable(this) }

  /** Gets the control flow node corresponding to this node, if any. */
  ControlFlow::Node getControlFlowNode() { none() }

  /** Gets a textual representation of this node. */
  string toString() { none() }

  /** Gets the location of this node. */
  final Location getLocation() { result = C::getLocation(this) }
}

/** An expression, viewed as a node in a data flow graph. */
class ExprNode extends Node {
  ExprNode() { this = C::TExprNode(_) or this = C::TCilExprNode(_) }

  /** Gets the expression corresponding to this node. */
  DotNet::Expr getExpr() {
    result = this.getExprAtNode(_)
    or
    this = C::TCilExprNode(result)
  }

  /**
   * Gets the expression corresponding to this node, at control flow node `cfn`,
   * if any.
   */
  Expr getExprAtNode(ControlFlow::Nodes::ElementNode cfn) {
    this = C::TExprNode(cfn) and
    result = cfn.getElement()
  }

  override ControlFlow::Nodes::ElementNode getControlFlowNode() { this = C::TExprNode(result) }

  override string toString() {
    exists(ControlFlow::Nodes::ElementNode cfn | this = C::TExprNode(cfn) | result = cfn.toString())
    or
    this = C::TCilExprNode(_) and
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
    this = C::TCilParameterNode(_) or
    this = C::TTaintedParameterNode(_)
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

/**
 * Holds if data flows from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
predicate localFlow(Node source, Node sink) { localFlowStep*(source, sink) }

predicate localFlowStep = C::localFlowStepImpl/2;

private class FieldLike extends Assignable, Modifiable {
  FieldLike() {
    this instanceof Field or
    this = any(TrivialProperty p | not p.isOverridableOrImplementable())
  }
}

private class FieldLikeRead extends AssignableRead {
  FieldLikeRead() { this.getTarget() instanceof FieldLike }
}

/**
 * Holds if the field-like read `flr` is not completely determined
 * by explicit SSA updates.
 */
private predicate hasNonlocalValue(FieldLikeRead flr) {
  flr = any(Ssa::ImplicitUntrackedDefinition udef).getARead()
  or
  exists(Ssa::Definition def, Ssa::ImplicitDefinition idef |
    def.getARead() = flr and
    idef = def.getAnUltimateDefinition()
  |
    idef instanceof Ssa::ImplicitEntryDefinition or
    idef instanceof Ssa::ImplicitCallDefinition
  )
}

/**
 * A data flow node that jumps between callables. This can be extended in
 * framework code to add additional data flow steps.
 */
abstract class NonLocalJumpNode extends Node {
  /** Gets a successor node that is potentially in another callable. */
  abstract Node getAJumpSuccessor(boolean preservesValue);
}

/** A write to a static field/property. */
private class StaticFieldLikeJumpNode extends NonLocalJumpNode, ExprNode {
  FieldLike fl;

  FieldLikeRead flr;

  ExprNode succ;

  StaticFieldLikeJumpNode() {
    fl.isStatic() and
    fl.getAnAssignedValue() = this.getExpr() and
    fl.getAnAccess() = flr and
    flr = succ.getExpr() and
    hasNonlocalValue(flr)
  }

  override ExprNode getAJumpSuccessor(boolean preservesValue) {
    result = succ and preservesValue = true
  }
}

/**
 * A node associated with an object after an operation that might have
 * changed its state.
 *
 * This can be either the argument to a callable after the callable returns
 * (which might have mutated the argument), or the qualifier of a field after
 * an update to the field.
 */
class PostUpdateNode extends Node {
  PostUpdateNode() { none() } // stub implementation

  /** Gets the node before the state update. */
  Node getPreUpdateNode() { none() } // stub implementation
}
