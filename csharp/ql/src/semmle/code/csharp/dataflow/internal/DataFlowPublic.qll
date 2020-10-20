private import csharp
private import cil
private import dotnet
private import DataFlowDispatch
private import DataFlowPrivate
private import semmle.code.csharp.Caching
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
  cached
  final DotNet::Type getType() {
    Stages::DataFlowStage::forceCachingInSameStage() and result = this.(NodeImpl).getTypeImpl()
  }

  /** Gets the enclosing callable of this node. */
  cached
  final DataFlowCallable getEnclosingCallable() {
    Stages::DataFlowStage::forceCachingInSameStage() and
    result = unique(DataFlowCallable c | c = this.(NodeImpl).getEnclosingCallableImpl() | c)
  }

  /** Gets the control flow node corresponding to this node, if any. */
  cached
  final ControlFlow::Node getControlFlowNode() {
    Stages::DataFlowStage::forceCachingInSameStage() and
    result = unique(ControlFlow::Node n | n = this.(NodeImpl).getControlFlowNodeImpl() | n)
  }

  /** Gets a textual representation of this node. */
  cached
  final string toString() {
    Stages::DataFlowStage::forceCachingInSameStage() and
    result = this.(NodeImpl).toStringImpl()
  }

  /** Gets the location of this node. */
  cached
  final Location getLocation() {
    Stages::DataFlowStage::forceCachingInSameStage() and
    result = this.(NodeImpl).getLocationImpl()
  }

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
    this = TSummaryParameterNode(_, _)
  }

  /** Gets the parameter corresponding to this node, if any. */
  DotNet::Parameter getParameter() { none() }

  /**
   * Holds if this node is the parameter of callable `c` at the specified
   * (zero-based) position.
   */
  predicate isParameterOf(DataFlowCallable c, int i) { none() }
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
predicate localFlow(Node source, Node sink) { localFlowStep*(source, sink) }

/**
 * Holds if data can flow from `e1` to `e2` in zero or more
 * local (intra-procedural) steps.
 */
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

  /** Gets the type of the object containing this content. */
  deprecated Gvn::GvnType getContainerType() { none() }

  /** Gets the type of this content. */
  deprecated Gvn::GvnType getType() { none() }
}

/** A reference to a field. */
class FieldContent extends Content, TFieldContent {
  private Field f;

  FieldContent() { this = TFieldContent(f) }

  /** Gets the field that is referenced. */
  Field getField() { result = f }

  override string toString() { result = f.toString() }

  override Location getLocation() { result = f.getLocation() }

  deprecated override Gvn::GvnType getContainerType() {
    result = Gvn::getGlobalValueNumber(f.getDeclaringType())
  }

  deprecated override Gvn::GvnType getType() { result = Gvn::getGlobalValueNumber(f.getType()) }
}

/** A reference to a property. */
class PropertyContent extends Content, TPropertyContent {
  private Property p;

  PropertyContent() { this = TPropertyContent(p) }

  /** Gets the property that is referenced. */
  Property getProperty() { result = p }

  override string toString() { result = p.toString() }

  override Location getLocation() { result = p.getLocation() }

  deprecated override Gvn::GvnType getContainerType() {
    result = Gvn::getGlobalValueNumber(p.getDeclaringType())
  }

  deprecated override Gvn::GvnType getType() { result = Gvn::getGlobalValueNumber(p.getType()) }
}

/** A reference to an element in a collection. */
class ElementContent extends Content, TElementContent {
  override string toString() { result = "[]" }

  override Location getLocation() { result instanceof EmptyLocation }
}
