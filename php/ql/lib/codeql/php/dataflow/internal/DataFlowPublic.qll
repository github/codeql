/**
 * Provides PHP-specific data flow public API.
 */

private import codeql.php.AST
private import DataFlowPrivate

/**
 * An element, viewed as a node in a data flow graph. Either an expression
 * (`ExprNode`) or a parameter (`ParameterNode`).
 */
class Node extends TNode {
  /** Gets the expression corresponding to this node, if any. */
  Expr asExpr() { this = TExprNode(result) }

  /** Gets the parameter corresponding to this node, if any. */
  Parameter asParameter() { this = TParameterNode(result) }

  /** Gets a textual representation of this node. */
  string toString() {
    result = this.asExpr().toString()
    or
    result = this.asParameter().toString()
    or
    this instanceof TSsaNode and result = "SSA node"
    or
    this instanceof TPostUpdateNode and
    result = "[post] " + this.(PostUpdateNode).getPreUpdateNode().toString()
  }

  /** Gets the location of this node. */
  Location getLocation() {
    result = this.asExpr().getLocation()
    or
    result = this.asParameter().getLocation()
    or
    exists(Expr e | this = TPostUpdateNode(e) | result = e.getLocation())
    or
    this instanceof TSsaNode and result instanceof EmptyLocation
  }

  /**
   * Gets a local source node from which data may flow to this node in zero or
   * more local data-flow steps.
   */
  Node getALocalSource() { localFlowStep*(result, this) }

  /**
   * Gets a data flow node from which data may flow to this node in one local step.
   */
  Node getAPredecessor() { simpleLocalFlowStep(result, this, _) }

  /**
   * Gets a data flow node to which data may flow from this node in one local step.
   */
  Node getASuccessor() { simpleLocalFlowStep(this, result, _) }
}

/** A data flow node corresponding to an expression. */
class ExprNode extends Node, TExprNode {
  Expr expr;

  ExprNode() { this = TExprNode(expr) }

  /** Gets the underlying expression. */
  Expr getExpr() { result = expr }
}

/** A data flow node corresponding to a parameter. */
class ParameterNode extends Node, TParameterNode {
  Parameter param;

  ParameterNode() { this = TParameterNode(param) }

  /** Gets the underlying parameter. */
  Parameter getParameter() { result = param }
}

/**
 * A node associated with an object after an operation that might have
 * changed its state.
 */
class PostUpdateNode extends Node, TPostUpdateNode {
  Expr expr;

  PostUpdateNode() { this = TPostUpdateNode(expr) }

  /** Gets the node before the state change. */
  Node getPreUpdateNode() { result = TExprNode(expr) }
}

/** Gets the node corresponding to `e`. */
ExprNode exprNode(DataFlowExpr e) { result.getExpr() = e }

/** Gets the node corresponding to the value of parameter `p` at function entry. */
ParameterNode parameterNode(Parameter p) { result.getParameter() = p }

/**
 * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
predicate localFlowStep(Node nodeFrom, Node nodeTo) { simpleLocalFlowStep(nodeFrom, nodeTo, _) }

/**
 * Holds if data flows from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
predicate localFlow(Node source, Node sink) { localFlowStep*(source, sink) }

/**
 * A reference to a local source of data flow.
 */
class LocalSourceNode extends Node {
  LocalSourceNode() {
    not localFlowStep(_, this)
    or
    this instanceof ParameterNode
  }

  /** Holds if this `LocalSourceNode` flows to `sink` in zero or more local steps. */
  predicate flowsTo(Node sink) { localFlow(this, sink) }
}

/** A content set for use in data flow. */
class ContentSet instanceof Content {
  /** Gets a content that may be stored into when storing into this set. */
  Content getAStoreContent() { result = this }

  /** Gets a content that may be read from when reading from this set. */
  Content getAReadContent() { result = this }

  /** Gets a textual representation of this content set. */
  string toString() { result = super.toString() }
}
