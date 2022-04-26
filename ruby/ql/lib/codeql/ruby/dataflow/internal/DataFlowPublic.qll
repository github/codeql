private import ruby
private import DataFlowDispatch
private import DataFlowPrivate
private import codeql.ruby.CFG
private import codeql.ruby.typetracking.TypeTracker
private import codeql.ruby.dataflow.SSA
private import FlowSummaryImpl as FlowSummaryImpl
private import SsaImpl as SsaImpl

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
  cached
  final string toString() { result = this.(NodeImpl).toStringImpl() }

  /** Gets the location of this node. */
  cached
  final Location getLocation() { result = this.(NodeImpl).getLocationImpl() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /**
   * Gets a local source node from which data may flow to this node in zero or
   * more local data-flow steps.
   */
  LocalSourceNode getALocalSource() { result.flowsTo(this) }

  /**
   * Gets a data flow node from which data may flow to this node in one local step.
   */
  Node getAPredecessor() { localFlowStep(result, this) }

  /**
   * Gets a data flow node to which data may flow from this node in one local step.
   */
  Node getASuccessor() { localFlowStep(this, result) }
}

/** A data-flow node corresponding to a call in the control-flow graph. */
class CallNode extends LocalSourceNode, ExprNode {
  private CfgNodes::ExprNodes::CallCfgNode node;

  CallNode() { node = this.getExprNode() }

  /** Gets the data-flow node corresponding to the receiver of the call corresponding to this data-flow node */
  ExprNode getReceiver() { result.getExprNode() = node.getReceiver() }

  /** Gets the data-flow node corresponding to the `n`th argument of the call corresponding to this data-flow node */
  ExprNode getArgument(int n) { result.getExprNode() = node.getArgument(n) }

  /** Gets the data-flow node corresponding to the named argument of the call corresponding to this data-flow node */
  ExprNode getKeywordArgument(string name) { result.getExprNode() = node.getKeywordArgument(name) }

  /** Gets the name of the the method called by the method call (if any) corresponding to this data-flow node */
  string getMethodName() { result = node.getExpr().(MethodCall).getMethodName() }

  /** Gets the number of arguments of this call. */
  int getNumberOfArguments() { result = node.getNumberOfArguments() }

  /** Gets the block of this call. */
  Node getBlock() { result.asExpr() = node.getBlock() }
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
class ParameterNode extends Node, TParameterNode instanceof ParameterNodeImpl {
  /** Gets the parameter corresponding to this node, if any. */
  final Parameter getParameter() { result = super.getParameter() }
}

/**
 * A data-flow node that is a source of local flow.
 */
class LocalSourceNode extends Node {
  LocalSourceNode() { isLocalSourceNode(this) }

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

  /**
   * Gets a node that may flow into this one using one heap and/or interprocedural step.
   *
   * See `TypeBackTracker` for more details about how to use this.
   */
  pragma[inline]
  LocalSourceNode backtrack(TypeBackTracker t2, TypeBackTracker t) { t2 = t.step(result, this) }
}

/**
 * A node associated with an object after an operation that might have
 * changed its state.
 *
 * This can be either the argument to a callable after the callable returns
 * (which might have mutated the argument), or the qualifier of a field after
 * an update to the field.
 *
 * Nodes corresponding to AST elements, for example `ExprNode`, usually refer
 * to the value before the update.
 */
class PostUpdateNode extends Node instanceof PostUpdateNodeImpl {
  /** Gets the node before the state update. */
  Node getPreUpdateNode() { result = super.getPreUpdateNode() }
}

cached
private predicate hasLocalSource(Node sink, Node source) {
  // Declaring `source` to be a `SourceNode` currently causes a redundant check in the
  // recursive case, so instead we check it explicitly here.
  source = sink and
  source instanceof LocalSourceNode
  or
  exists(Node mid |
    hasLocalSource(mid, source) and
    localFlowStepTypeTracker(mid, sink)
  )
}

/** Gets a node corresponding to expression `e`. */
ExprNode exprNode(CfgNodes::ExprCfgNode e) { result.getExprNode() = e }

/**
 * Gets the node corresponding to the value of parameter `p` at function entry.
 */
ParameterNode parameterNode(Parameter p) { result.getParameter() = p }

/**
 * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
predicate localFlowStep = localFlowStepImpl/2;

/**
 * Holds if data flows from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
pragma[inline]
predicate localFlow(Node source, Node sink) { localFlowStep*(source, sink) }

/**
 * Holds if data can flow from `e1` to `e2` in zero or more
 * local (intra-procedural) steps.
 */
pragma[inline]
predicate localExprFlow(CfgNodes::ExprCfgNode e1, CfgNodes::ExprCfgNode e2) {
  localFlow(exprNode(e1), exprNode(e2))
}

/** A reference contained in an object. */
class Content extends TContent {
  /** Gets a textual representation of this content. */
  string toString() { none() }

  /** Gets the location of this content. */
  Location getLocation() { none() }
}

/** Provides different sub classes of `Content`. */
module Content {
  /** An element in an array. */
  class ArrayElementContent extends Content, TArrayElementContent { }

  /** An element in an array at a known index. */
  class KnownArrayElementContent extends ArrayElementContent, TKnownArrayElementContent {
    private int i;

    KnownArrayElementContent() { this = TKnownArrayElementContent(i) }

    /** Gets the index in the array. */
    int getIndex() { result = i }

    override string toString() { result = "array element " + i }
  }

  /** An element in an array at an unknown index. */
  class UnknownArrayElementContent extends ArrayElementContent, TUnknownArrayElementContent {
    override string toString() { result = "array element" }
  }
}

/**
 * An entity that represents a set of `Content`s.
 *
 * The set may be interpreted differently depending on whether it is
 * stored into (`getAStoreContent`) or read from (`getAReadContent`).
 */
class ContentSet extends TContentSet {
  /** Holds if this content set is the singleton `{c}`. */
  predicate isSingleton(Content c) { this = TSingletonContent(c) }

  /** Holds if this content set represent all `ArrayElementContent`s. */
  predicate isAnyArrayElement() { this = TAnyArrayElementContent() }

  /** Gets a textual representation of this content set. */
  string toString() {
    exists(Content c |
      this.isSingleton(c) and
      result = c.toString()
    )
    or
    this.isAnyArrayElement() and
    result = "any array element"
  }

  /** Gets a content that may be stored into when storing into this set. */
  Content getAStoreContent() {
    this.isSingleton(result)
    or
    this.isAnyArrayElement() and
    result = TUnknownArrayElementContent()
  }

  /** Gets a content that may be read from when reading from this set. */
  Content getAReadContent() {
    this.isSingleton(result)
    or
    this.isAnyArrayElement() and
    result instanceof Content::ArrayElementContent
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
abstract class BarrierGuard extends CfgNodes::ExprCfgNode {
  private ConditionBlock conditionBlock;

  BarrierGuard() { this = conditionBlock.getLastNode() }

  /** Holds if this guard controls block `b` upon evaluating to `branch`. */
  private predicate controlsBlock(BasicBlock bb, boolean branch) {
    exists(SuccessorTypes::BooleanSuccessor s | s.getValue() = branch |
      conditionBlock.controls(bb, s)
    )
  }

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

  /**
   * Gets an implicit entry definition for a captured variable that
   * may be guarded, because a call to the capturing callable is guarded.
   *
   * This is restricted to calls where the variable is captured inside a
   * block.
   */
  private Ssa::Definition getAMaybeGuardedCapturedDef() {
    exists(
      boolean branch, CfgNodes::ExprCfgNode testedNode, Ssa::Definition def,
      CfgNodes::ExprNodes::CallCfgNode call
    |
      def.getARead() = testedNode and
      this.checks(testedNode, branch) and
      SsaImpl::captureFlowIn(call, def, result) and
      this.controlsBlock(call.getBasicBlock(), branch) and
      result.getBasicBlock().getScope() = call.getExpr().(MethodCall).getBlock()
    )
  }

  final Node getAGuardedNode() {
    exists(boolean branch, CfgNodes::ExprCfgNode testedNode, Ssa::Definition def |
      def.getARead() = testedNode and
      def.getARead() = result.asExpr() and
      this.checks(testedNode, branch) and
      this.controlsBlock(result.asExpr().getBasicBlock(), branch)
    )
    or
    result.asExpr() = this.getAMaybeGuardedCapturedDef().getARead()
  }
}
