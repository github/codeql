private import swift
private import DataFlowDispatch
private import DataFlowPrivate
private import codeql.swift.controlflow.ControlFlowGraph
private import codeql.swift.controlflow.BasicBlocks
private import codeql.swift.controlflow.CfgNodes
private import codeql.swift.dataflow.Ssa

/**
 * An element, viewed as a node in a data flow graph. Either an expression
 * (`ExprNode`) or a parameter (`ParameterNode`).
 */
class Node extends TNode {
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
   * Gets this node's underlying expression, if any.
   */
  Expr asExpr() { none() }

  /**
   * Gets this node's underlying pattern, if any.
   */
  Pattern asPattern() { none() }

  /**
   * Gets this data flow node's corresponding control flow node.
   */
  ControlFlowNode getCfgNode() { none() }

  /**
   * Gets this node's underlying SSA definition, if any.
   */
  Ssa::Definition asDefinition() { none() }
}

/**
 * An expression, viewed as a node in a data flow graph.
 *
 * Note that because of control-flow splitting, one `Expr` may correspond
 * to multiple `ExprNode`s, just like it may correspond to multiple
 * `ControlFlow::Node`s.
 */
class ExprNode extends Node, TExprNode {
  CfgNode n;
  Expr expr;

  ExprNode() { this = TExprNode(n, expr) }

  override Expr asExpr() { result = expr }

  override ControlFlowNode getCfgNode() { result = n }
}

/**
 * A pattern, viewed as a node in a data flow graph.
 */
class PatternNode extends Node, TPatternNode {
  CfgNode n;
  Pattern pattern;

  PatternNode() { this = TPatternNode(n, pattern) }

  override Pattern asPattern() { result = pattern }

  override ControlFlowNode getCfgNode() { result = n }
}

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph.
 */
class ParameterNode extends Node instanceof ParameterNodeImpl {
  override ControlFlowNode getCfgNode() { result = this.(ParameterNodeImpl).getCfgNode() }

  DataFlowCallable getDeclaringFunction() {
    result = this.(ParameterNodeImpl).getEnclosingCallable()
  }

  ParamDecl getParameter() { result = this.(ParameterNodeImpl).getParameter() }
}

/**
 */
class SsaDefinitionNode extends Node, TSsaDefinitionNode {
  Ssa::Definition def;

  SsaDefinitionNode() { this = TSsaDefinitionNode(def) }

  override Ssa::Definition asDefinition() { result = def }
}

class InoutReturnNode extends Node instanceof InoutReturnNodeImpl {
  ParamDecl getParameter() { result = super.getParameter() }
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

/** Gets a node corresponding to expression `e`. */
ExprNode exprNode(DataFlowExpr e) { result.asExpr() = e }

/**
 * Gets the node corresponding to the value of parameter `p` at function entry.
 */
ParameterNode parameterNode(DataFlowParameter p) { result.getParameter() = p }

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
predicate localExprFlow(DataFlowExpr e1, DataFlowExpr e2) { localFlow(exprNode(e1), exprNode(e2)) }

/** A reference contained in an object. */
class Content extends TContent {
  /** Gets a textual representation of this content. */
  string toString() { none() }

  /** Gets the location of this content. */
  Location getLocation() { none() }
}

module Content {
  /** A field of an object, for example an instance variable. */
  class FieldContent extends Content, TFieldContent {
    private FieldDecl f;

    FieldContent() { this = TFieldContent(f) }

    /** Gets the name of the field. */
    FieldDecl getField() { result = f }

    override string toString() { result = f.toString() }
  }

  /** An element of a tuple at a specific index. */
  class TupleContent extends Content, TTupleContent {
    private int index;

    TupleContent() { this = TTupleContent(index) }

    /** Gets the index for this tuple element. */
    int getIndex() { result = index }

    override string toString() { result = "Tuple element at index " + index.toString() }
  }

  /** A parameter of an enum element. */
  class EnumContent extends Content, TEnumContent {
    private ParamDecl p;

    EnumContent() { this = TEnumContent(p) }

    /** Gets the declaration of the enum parameter. */
    ParamDecl getParam() { result = p }

    override string toString() {
      exists(EnumElementDecl d, int pos | d.getParam(pos) = p | result = d.toString() + ":" + pos)
    }
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

  /** Gets a textual representation of this content set. */
  string toString() {
    exists(Content c |
      this.isSingleton(c) and
      result = c.toString()
    )
  }

  /** Gets a content that may be stored into when storing into this set. */
  Content getAStoreContent() { this.isSingleton(result) }

  /** Gets a content that may be read from when reading from this set. */
  Content getAReadContent() { this.isSingleton(result) }
}

/**
 * DEPRECATED: Do not use.
 */
abstract deprecated class BarrierGuard extends DataFlowExpr {
  BarrierGuard() { none() }

  final Node getAGuardedNode() { none() }
}
