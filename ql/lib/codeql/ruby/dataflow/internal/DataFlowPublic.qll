private import ruby
private import DataFlowDispatch
private import DataFlowPrivate
private import codeql.ruby.CFG
private import codeql.ruby.typetracking.TypeTracker
private import codeql.ruby.dataflow.SSA

/**
 * An element, viewed as a node in a data flow graph. Either an expression
 * (`ExprNode`) or a parameter (`ParameterNode`).
 */
class Node extends TNode {
  /** Gets the expression corresponding to this node, if any. */
  CfgNodes::ExprCfgNode asExpr() { result = this.(ExprNode).getExprNode() }

  /** Gets the parameter corresponding to this node, if any. */
  Parameter asParameter() { result = this.(ParameterNode).getParameter() }

  /** Gets a textual representation of this node. */
  // TODO: cache
  final string toString() { result = this.(NodeImpl).toStringImpl() }

  /** Gets the location of this node. */
  // TODO: cache
  final Location getLocation() { result = this.(NodeImpl).getLocationImpl() }

  final DataFlowCallable getEnclosingCallable() { result = this.(NodeImpl).getCfgScope() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /**
   * Gets a local source node from which data may flow to this node in zero or more local data-flow steps.
   */
  LocalSourceNode getALocalSource() { result.flowsTo(this) }
}

/** A data-flow node corresponding to a call in the control-flow graph. */
class CallNode extends LocalSourceNode {
  private CfgNodes::ExprNodes::CallCfgNode node;

  CallNode() { node = this.asExpr() }

  /** Gets the data-flow node corresponding to the receiver of the call corresponding to this data-flow node */
  Node getReceiver() { result.asExpr() = node.getReceiver() }

  /** Gets the data-flow node corresponding to the `n`th argument of the call corresponding to this data-flow node */
  Node getArgument(int n) { result.asExpr() = node.getArgument(n) }

  /** Gets the data-flow node corresponding to the named argument of the call corresponding to this data-flow node */
  Node getKeywordArgument(string name) { result.asExpr() = node.getKeywordArgument(name) }
}

/**
 * An expression, viewed as a node in a data flow graph.
 *
 * Note that because of control-flow splitting, one `Expr` may correspond
 * to multiple `ExprNode`s, just like it may correspond to multiple
 * `ControlFlow::Node`s.
 */
class ExprNode extends Node, TExprNode {
  private CfgNodes::ExprCfgNode n;

  ExprNode() { this = TExprNode(n) }

  /** Gets the expression corresponding to this node. */
  CfgNodes::ExprCfgNode getExprNode() { result = n }
}

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph.
 */
class ParameterNode extends Node, TParameterNode {
  /** Gets the parameter corresponding to this node, if any. */
  Parameter getParameter() { none() }

  /**
   * Holds if this node is the parameter of callable `c` at the specified
   * (zero-based) position.
   */
  predicate isParameterOf(Callable c, int i) { none() }
}

/**
 * A data-flow node that is a source of local flow.
 */
class LocalSourceNode extends Node {
  LocalSourceNode() { not simpleLocalFlowStep+(any(ExprNode n), this) }

  /** Holds if this `LocalSourceNode` can flow to `nodeTo` in one or more local flow steps. */
  pragma[inline]
  predicate flowsTo(Node nodeTo) { hasLocalSource(nodeTo, this) }

  /**
   * Gets a node that this node may flow to using one heap and/or interprocedural step.
   *
   * See `TypeTracker` for more details about how to use this.
   */
  pragma[inline]
  LocalSourceNode track(TypeTracker t2, TypeTracker t) { t = t2.step(this, result) }
}

predicate hasLocalSource(Node sink, Node source) {
  // Declaring `source` to be a `SourceNode` currently causes a redundant check in the
  // recursive case, so instead we check it explicitly here.
  source = sink and
  source instanceof LocalSourceNode
  or
  exists(Node mid |
    hasLocalSource(mid, source) and
    simpleLocalFlowStep(mid, sink)
  )
}

/** Gets a node corresponding to expression `e`. */
ExprNode exprNode(CfgNodes::ExprCfgNode e) { result.getExprNode() = e }

/**
 * Gets the node corresponding to the value of parameter `p` at function entry.
 */
ParameterNode parameterNode(Parameter p) { result.getParameter() = p }

predicate localFlowStep = simpleLocalFlowStep/2;

/**
 * Holds if data flows from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
predicate localFlow(Node source, Node sink) { localFlowStep*(source, sink) }

/**
 * Holds if data can flow from `e1` to `e2` in zero or more
 * local (intra-procedural) steps.
 */
predicate localExprFlow(CfgNodes::ExprCfgNode e1, CfgNodes::ExprCfgNode e2) {
  localFlow(exprNode(e1), exprNode(e2))
}

/**
 * A reference contained in an object. This is either a field, a property,
 * or an element in a collection.
 */
class Content extends TContent {
  /** Gets a textual representation of this content. */
  string toString() { none() }

  /** Gets the location of this content. */
  Location getLocation() { none() }
}

/**
 * A node that controls whether other nodes are evaluated.
 */
class GuardNode extends CfgNodes::ExprCfgNode {
  ConditionBlock conditionBlock;

  GuardNode() { this = conditionBlock.getLastNode() }

  /** Holds if this guard controls block `b` upon evaluating to `branch`. */
  predicate controlsBlock(BasicBlock bb, boolean branch) {
    exists(SuccessorTypes::BooleanSuccessor s | s.getValue() = branch |
      conditionBlock.controls(bb, s)
    )
  }
}

/**
 * A guard that validates some expression.
 *
 * To use this in a configuration, extend the class and provide a
 * characteristic predicate precisely specifying the guard, and override
 * `checks` to specify what is being validated and in which branch.
 *
 * It is important that all extending classes in scope are disjoint.
 */
abstract class BarrierGuard extends GuardNode {
  /**
   * Holds if this guard validates `expr` upon evaluating to `branch`.
   * For example, the following code validates `foo` when the condition
   * `foo == "foo"` is true.
   * ```ruby
   * if foo == "foo"
   *   do_something
   *  else
   *   do_something_else
   * end
   * ```
   */
  abstract predicate checks(CfgNode expr, boolean branch);

  final Node getAGuardedNode() {
    exists(boolean branch, CfgNodes::ExprCfgNode testedNode, Ssa::Definition def |
      def.getARead() = testedNode and
      def.getARead() = result.asExpr() and
      this.checks(testedNode, branch) and
      this.controlsBlock(result.asExpr().getBasicBlock(), branch)
    )
  }
}
