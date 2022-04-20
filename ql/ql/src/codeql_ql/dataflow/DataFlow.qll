/**
 * Experimental library for reasoning about data flow.
 *
 * Current limitations:
 * - Global flow does not reason about subclassing, overriding, and dispatch
 * - `this`, `result`, and local field variables are treated less precisely
 *   than regular variables (see VarScoping.qll)
 * - Polarity is not tracked, that is, global flow does not care about negation at all.
 */

private import codeql_ql.ast.Ast
private import internal.NodesInternal
private import internal.DataFlowNumbering
private import internal.LocalFlow as LocalFlow
private import internal.GlobalFlow as GlobalFlow

/**
 * An expression or variable in a formula, including some additional nodes
 * that are not part of the AST.
 *
 * Nodes that are locally bound together by equalities are clustered into a "super node",
 * which can be accessed using `getSuperNode()`. There is usually no reason to use `Node` directly
 * other than to reason about what kind of node is contained in a super node.
 *
 * To reason about global data flow, use `SuperNode.track()`.
 */
class Node extends TNode {
  /** Gets a string representation of this element. */
  string toString() { none() } // overridden in subclasses

  /** Gets the location of element. */
  Location getLocation() { none() } // overridden in subclasses

  /**
   * Gets the underlying `Expr` or `VarDef` node, if this is an `AstNodeNode`.
   */
  AstNode asAstNode() { astNode(result) = this }

  /**
   * Gets the predicate containing this data-flow node.
   *
   * All data-flow nodes belong in exactly one predicate.
   * TODO: select clauses
   */
  Predicate getEnclosingPredicate() { none() } // overridden in subclasses

  /**
   * Gets the collection of data-flow nodes locally bound by equalities, represented
   * by a "super node".
   *
   * Super nodes are the medium through which to propagate data-flow information globally.
   */
  SuperNode getSuperNode() { result.getANode() = this }
}

/**
 * A data-flow node based an `Expr` or `VarDef` AST node.
 */
class AstNodeNode extends Node, MkAstNodeNode {
  private AstNode ast;

  AstNodeNode() { this = MkAstNodeNode(ast) }

  override string toString() { result = ast.toString() }

  override Location getLocation() { result = ast.getLocation() }

  /** Gets the AST node. */
  AstNode getAstNode() { result = ast }

  override Predicate getEnclosingPredicate() { result = ast.getEnclosingPredicate() }
}

/**
 * Gets the data-flow node correspoinding to the given AST node.
 */
pragma[inline]
Node astNode(AstNode node) { result = MkAstNodeNode(node) }

/**
 * A data-flow node representing a variable within a specific scope.
 */
class ScopedVariableNode extends Node, MkScopedVariable {
  private VarDef var;
  private AstNode scope;

  ScopedVariableNode() { this = MkScopedVariable(var, scope) }

  override string toString() {
    result =
      "Variable '" + var.getName() + "' scoped to " + scope.getLocation().getStartLine() + ":" +
        scope.getLocation().getStartColumn()
  }

  override Location getLocation() { result = scope.getLocation() }

  /** Gets the variable being refined to a specific scope. */
  VarDef getVariable() { result = var }

  /** Gets the scope to which this variable has been refined. */
  AstNode getScope() { result = scope }

  override Predicate getEnclosingPredicate() { result = var.getEnclosingPredicate() }
}

/**
 * Gets the data-flow node corresponding to `var` restricted to `scope`.
 */
pragma[inline]
Node scopedVariable(VarDef var, AstNode scope) { result = MkScopedVariable(var, scope) }

/**
 * A data-flow node representing `this` within a class predicate, charpred, or newtype branch.
 */
class ThisNode extends Node, MkThisNode {
  private Predicate pred;

  ThisNode() { this = MkThisNode(pred) }

  override string toString() { result = "'this' in " + pred.getName() }

  override Location getLocation() { result = pred.getLocation() }

  /** Gets the class predicate, charpred, or newtype branch whose 'this' parameter is represented by this node. */
  Predicate getPredicate() { result = pred }

  override Predicate getEnclosingPredicate() { result = pred }
}

/**
 * Gets the data-flow node representing `this` within the given class predicate, charpred, or newtype branch.
 */
pragma[inline]
Node thisNode(Predicate pred) { result = MkThisNode(pred) }

/**
 * A data-flow node representing `result` within a predicate that has a result.
 */
class ResultNode extends Node, MkResultNode {
  private Predicate pred;

  ResultNode() { this = MkResultNode(pred) }

  override string toString() { result = "'result' in " + pred.getName() }

  override Location getLocation() { result = pred.getLocation() }

  /** Gets the predicate whose 'result' parameter is represented by this node. */
  Predicate getPredicate() { result = pred }

  override Predicate getEnclosingPredicate() { result = pred }
}

/**
 * Gets the data-flow node representing `result` within the given predicate.
 */
pragma[inline]
Node resultNode(Predicate pred) { result = MkResultNode(pred) }

/**
 * A data-flow node representing the view of a field in the enclosing class, as seen
 * from a charpred or class predicate.
 */
class FieldNode extends Node, MkFieldNode {
  private Predicate pred;
  private FieldDecl fieldDecl;

  FieldNode() { this = MkFieldNode(pred, fieldDecl) }

  /** Gets the member predicate or charpred for which this node represents access to the field. */
  Predicate getPredicate() { result = pred }

  /** Gets the declaration of the field. */
  FieldDecl getFieldDeclaration() { result = fieldDecl }

  /** Gets the name of the field. */
  string getFieldName() { result = fieldDecl.getName() }

  override string toString() { result = "'" + this.getFieldName() + "' in " + pred.getName() }

  override Location getLocation() { result = pred.getLocation() }

  override Predicate getEnclosingPredicate() { result = pred }
}

/**
 * Gets the data-flow node representing the given predicate's view of the given field
 * in the enclosing class.
 */
pragma[inline]
Node fieldNode(Predicate pred, FieldDecl fieldDecl) { result = MkFieldNode(pred, fieldDecl) }

/**
 * A collection of data-flow nodes in the same predicate, locally bound by equalities.
 *
 * To reason about global data flow, use `SuperNode.track()`.
 */
class SuperNode extends LocalFlow::TSuperNode {
  private int repr;

  SuperNode() { this = LocalFlow::MkSuperNode(repr) }

  /** Gets a data-flow node that is part of this super node. */
  Node getANode() { LocalFlow::getRepr(result) = repr }

  /** Gets an AST node from any of the nodes in this super node. */
  AstNode asAstNode() { result = getANode().asAstNode() }

  /**
   * Gets a single node from this super node.
   *
   * The node is arbitrary and the caller should not rely on how the node is chosen.
   * The node is currently chosen such that:
   * - An `AstNodeNode` is preferred over other nodes.
   * - A node occuring earlier is preferred over one occurring later.
   */
  Node getArbitraryRepr() { result = min(Node n | n = getANode() | n order by getInternalId(n)) }

  /**
   * Gets the predicate containing all nodes that are part of this super node.
   */
  Predicate getEnclosingPredicate() { result = getANode().getEnclosingPredicate() }

  /** Gets a string representation of this super node. */
  string toString() {
    exists(int c |
      c = strictcount(getANode()) and
      result = "Super node of " + c + " nodes in " + getEnclosingPredicate().getName()
    )
  }

  /** Gets the location of an arbitrary node in this super node. */
  Location getLocation() { result = getArbitraryRepr().getLocation() }

  /** Gets any member call whose receiver is in the same super node. */
  MemberCall getALocalMemberCall() { superNode(result.getBase()) = this }

  /** Gets any member call whose receiver is in the same super node. */
  MemberCall getALocalMemberCall(string name) {
    result = this.getALocalMemberCall() and
    result.getMemberName() = name
  }

  /**
   * Gets a node that this node may "flow to" after one step.
   *
   * Basic usage of `track()` to track some expressions looks like this:
   * ```
   * DataFlow::SuperNode myThing(DataFlow::Tracker t) {
   *   t.start() and
   *   result = DataFlow::superNode(< some ast node >)
   *   or
   *   exists (DataFlow::Tracker t2 |
   *     result = myThing(t2).track(t2, t)
   *   )
   * }
   *
   * DataFlow::SuperNode myThing() { result = myThing(DataFlow::Tracker::end()) }
   * ```
   */
  pragma[inline]
  SuperNode track(Tracker t1, Tracker t2) {
    // Return state -> return state
    // Store the return edge in t2
    not t1.hasCall() and
    GlobalFlow::directedEdgeSuper(result, this, t2)
    or
    // Call state or initial state -> call state
    t1.hasCallOrIsStart() and
    t2.hasCall() and
    GlobalFlow::directedEdgeSuper(this, result, _)
    or
    // Return state -> call state
    // The last-used return edge must not be used as the initial call edge
    // (doing so would allow returning out of a disjunction and into another branch of that disjunction)
    not t1.hasCall() and
    t2.hasCall() and
    exists(GlobalFlow::EdgeLabel edge |
      GlobalFlow::directedEdgeSuper(this, result, edge) and
      edge != t1
    )
  }

  /**
   * Gets node containing a string flowing to this node via `t`.
   */
  cached
  private string getAStringValue(Tracker t) {
    t.start() and
    result = asAstNode().(String).getValue()
    or
    exists(SuperNode pred, Tracker t2 |
      this = pred.track(t2, t) and
      result = pred.getAStringValue(t2)
    )
    or
    // Step through calls to a few built-ins that don't cause a blow-up
    exists(SuperNode pred, string methodName, string oldValue |
      this.asAstNode() = pred.getALocalMemberCall(methodName) and
      oldValue = pred.getAStringValue(t)
    |
      methodName = "toLowerCase" and
      result = oldValue.toLowerCase()
      or
      methodName = "toUpperCase" and
      result = oldValue.toUpperCase()
    )
  }

  /** Gets a string constant that may flow here (possibly from a caller context). */
  pragma[inline]
  string getAStringValue() { result = this.getAStringValue(Tracker::end()) }

  /** Gets a string constant that may flow here, possibly out of callees, but not from caller contexts. */
  pragma[inline]
  string getAStringValueNoCall() { result = this.getAStringValue(Tracker::endNoCall()) }

  /**
   * Gets a string constant that may flow here, which can safely be combined with another
   * value that was tracked here with `otherT`.
   *
   * This is under-approximate and will fail to accept valid matches when both values
   * came in from the same chain of calls.
   */
  bindingset[otherT]
  string getAStringValueForContext(Tracker otherT) {
    exists(Tracker stringT |
      result = this.getAStringValue(stringT) and
      otherT.isSafeToCombineWith(stringT)
    )
  }
}

/** Gets the super node for the given AST node. */
pragma[inline]
SuperNode superNode(AstNode node) { result = astNode(node).getSuperNode() }

/**
 * A summary of the steps needed to reach a node in the global data flow graph,
 * to be used in combination with `SuperNode.track`.
 */
class Tracker extends GlobalFlow::TEdgeLabelOrTrackerState {
  /** Holds if this is the starting point, that is, the summary of the empty path. */
  predicate start() { this = GlobalFlow::MkNoEdge() }

  /** Holds if a call step has been used (possibly preceeded by return steps). */
  predicate hasCall() { this = GlobalFlow::MkHasCall() }

  /** Holds if either `start()` or `hasCall()` holds */
  predicate hasCallOrIsStart() { this.start() or this.hasCall() }

  /**
   * Holds if the two trackers are safe to combine, in the sense that
   * they don't make contradictory assumptions what context they're in.
   *
   * This is approximate and will reject any pair of trackers that have
   * both used a call or locally came from the same disjunction.
   */
  pragma[inline]
  predicate isSafeToCombineWith(Tracker other) {
    not (
      // Both values came from a call, they could come from different call sites.
      this.hasCall() and
      other.hasCall()
      or
      // Both values came from the same disjunction, they could come from different branches.
      this = other and
      this instanceof GlobalFlow::MkDisjunction
    )
  }

  /** Gets a string representation of this element. */
  string toString() {
    this instanceof GlobalFlow::MkNoEdge and
    result = "Tracker in initial state"
    or
    this instanceof GlobalFlow::MkHasCall and
    result = "Tracker with calls"
    or
    this instanceof GlobalFlow::EdgeLabel and
    result = "Tracker with return step out of " + this.(GlobalFlow::EdgeLabel).toString()
  }
}

module Tracker {
  /** Gets a valid end-point for tracking. */
  Tracker end() { any() }

  /** Gets a valid end-point for tracking where no calls were used. */
  Tracker endNoCall() { not result.hasCall() }
}
