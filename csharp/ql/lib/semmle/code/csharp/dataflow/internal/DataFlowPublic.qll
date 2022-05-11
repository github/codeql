private import csharp
private import cil
private import dotnet
private import DataFlowDispatch
private import DataFlowPrivate
private import semmle.code.csharp.controlflow.Guards
private import semmle.code.csharp.Unification

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
    result = this.(ExprNode).getExprAtNode(cfn)
  }

  /** Gets the parameter corresponding to this node, if any. */
  DotNet::Parameter asParameter() { result = this.(ParameterNode).getParameter() }

  /** Gets the definition corresponding to this node, if any. */
  AssignableDefinition asDefinition() { result = this.asDefinitionAtNode(_) }

  /**
   * Gets the definition corresponding to this node, at control flow node `cfn`,
   * if any.
   */
  AssignableDefinition asDefinitionAtNode(ControlFlow::Node cfn) {
    result = this.(AssignableDefinitionNode).getDefinitionAtNode(cfn)
  }

  /** Gets the type of this node. */
  final DotNet::Type getType() { result = this.(NodeImpl).getTypeImpl() }

  /** Gets the enclosing callable of this node. */
  final DataFlowCallable getEnclosingCallable() {
    result = this.(NodeImpl).getEnclosingCallableImpl()
  }

  /** Gets the control flow node corresponding to this node, if any. */
  final ControlFlow::Node getControlFlowNode() { result = this.(NodeImpl).getControlFlowNodeImpl() }

  /** Gets a textual representation of this node. */
  final string toString() { result = this.(NodeImpl).toStringImpl() }

  /** Gets the location of this node. */
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
}

private class TExprNode_ = TExprNode or TCilExprNode;

/**
 * An expression, viewed as a node in a data flow graph.
 *
 * Note that because of control-flow splitting, one `Expr` may correspond
 * to multiple `ExprNode`s, just like it may correspond to multiple
 * `ControlFlow::Node`s.
 */
class ExprNode extends Node, TExprNode_ {
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
}

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph.
 */
class ParameterNode extends Node instanceof ParameterNodeImpl {
  /** Gets the parameter corresponding to this node, if any. */
  DotNet::Parameter getParameter() {
    exists(DataFlowCallable c, ParameterPosition ppos |
      super.isParameterOf(c, ppos) and
      result = c.getParameter(ppos.getPosition())
    )
  }

  /**
   * DEPRECATED
   *
   * Holds if this node is the parameter of callable `c` at the specified
   * (zero-based) position.
   */
  deprecated predicate isParameterOf(DataFlowCallable c, int i) {
    super.isParameterOf(c, any(ParameterPosition pos | i = pos.getPosition()))
  }
}

/** A definition, viewed as a node in a data flow graph. */
class AssignableDefinitionNode extends Node, TSsaDefinitionNode {
  private Ssa::ExplicitDefinition edef;

  AssignableDefinitionNode() { this = TSsaDefinitionNode(edef) }

  /** Gets the underlying definition. */
  AssignableDefinition getDefinition() { result = this.getDefinitionAtNode(_) }

  /** Gets the underlying definition, at control flow node `cfn`, if any. */
  AssignableDefinition getDefinitionAtNode(ControlFlow::Node cfn) {
    result = edef.getADefinition() and
    cfn = edef.getControlFlowNode()
  }
}

/** Gets a node corresponding to expression `e`. */
ExprNode exprNode(DotNet::Expr e) { result.getExpr() = e }

/**
 * Gets the node corresponding to the value of parameter `p` at function entry.
 */
ParameterNode parameterNode(DotNet::Parameter p) { result.getParameter() = p }

/** Gets a node corresponding to the definition `def`. */
AssignableDefinitionNode assignableDefinitionNode(AssignableDefinition def) {
  result.getDefinition() = def
}

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
predicate localExprFlow(Expr e1, Expr e2) { localFlow(exprNode(e1), exprNode(e2)) }

/**
 * A data flow node that jumps between callables. This can be extended in
 * framework code to add additional data flow steps.
 */
abstract class NonLocalJumpNode extends Node {
  /** Gets a successor node that is potentially in another callable. */
  abstract Node getAJumpSuccessor(boolean preservesValue);
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
class BarrierGuard extends Guard {
  /** Holds if this guard validates `e` upon evaluating to `v`. */
  abstract predicate checks(Expr e, AbstractValue v);

  /** Gets a node guarded by this guard. */
  final ExprNode getAGuardedNode() {
    exists(Expr e, AbstractValue v |
      this.checks(e, v) and
      this.controlsNode(result.getControlFlowNode(), e, v)
    )
  }
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

/** A reference to a field. */
class FieldContent extends Content, TFieldContent {
  private Field f;

  FieldContent() { this = TFieldContent(f) }

  /** Gets the field that is referenced. */
  Field getField() { result = f }

  override string toString() { result = "field " + f.getName() }

  override Location getLocation() { result = f.getLocation() }
}

/** A reference to a synthetic field. */
class SyntheticFieldContent extends Content, TSyntheticFieldContent {
  private SyntheticField f;

  SyntheticFieldContent() { this = TSyntheticFieldContent(f) }

  /** Gets the underlying synthetic field. */
  SyntheticField getField() { result = f }

  override string toString() { result = "synthetic " + f.toString() }
}

/** A reference to a property. */
class PropertyContent extends Content, TPropertyContent {
  private Property p;

  PropertyContent() { this = TPropertyContent(p) }

  /** Gets the property that is referenced. */
  Property getProperty() { result = p }

  override string toString() { result = "property " + p.getName() }

  override Location getLocation() { result = p.getLocation() }
}

/** A reference to an element in a collection. */
class ElementContent extends Content, TElementContent {
  override string toString() { result = "element" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/**
 * An entity that represents a set of `Content`s.
 *
 * The set may be interpreted differently depending on whether it is
 * stored into (`getAStoreContent`) or read from (`getAReadContent`).
 */
class ContentSet instanceof Content {
  /** Gets a content that may be stored into when storing into this set. */
  Content getAStoreContent() { result = this }

  /** Gets a content that may be read from when reading from this set. */
  Content getAReadContent() { result = this }

  /** Gets a textual representation of this content set. */
  string toString() { result = super.toString() }

  /** Gets the location of this content set. */
  Location getLocation() { result = super.getLocation() }
}
