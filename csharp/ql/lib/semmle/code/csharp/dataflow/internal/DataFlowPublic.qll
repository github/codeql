private import csharp
private import DataFlowDispatch
private import DataFlowPrivate
private import semmle.code.csharp.controlflow.Guards
private import semmle.code.csharp.Unification
private import semmle.code.csharp.frameworks.system.linq.Expressions

/**
 * An element, viewed as a node in a data flow graph. Either an expression
 * (`ExprNode`) or a parameter (`ParameterNode`).
 */
class Node extends TNode {
  /** Gets the expression corresponding to this node, if any. */
  Expr asExpr() { result = this.(ExprNode).getExpr() }

  /**
   * Gets the expression corresponding to this node, at control flow node `cfn`,
   * if any.
   */
  Expr asExprAtNode(ControlFlow::Nodes::ElementNode cfn) {
    result = this.(ExprNode).getExprAtNode(cfn)
  }

  /** Gets the parameter corresponding to this node, if any. */
  Parameter asParameter() { result = this.(ParameterNode).getParameter() }

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
  final Type getType() { result = this.(NodeImpl).getTypeImpl() }

  /** Gets the enclosing callable of this node. */
  final Callable getEnclosingCallable() {
    result = this.(NodeImpl).getEnclosingCallableImpl().asCallable(_)
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
  deprecated predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/**
 * An expression, viewed as a node in a data flow graph.
 *
 * Note that because of control-flow splitting, one `Expr` may correspond
 * to multiple `ExprNode`s, just like it may correspond to multiple
 * `ControlFlow::Node`s.
 */
class ExprNode extends Node, TExprNode {
  /** Gets the expression corresponding to this node. */
  Expr getExpr() { result = this.getExprAtNode(_) }

  /**
   * Gets the expression corresponding to this node, at control flow node `cfn`,
   * if any.
   */
  Expr getExprAtNode(ControlFlow::Nodes::ElementNode cfn) {
    this = TExprNode(cfn) and
    result = cfn.getAstNode()
  }
}

pragma[nomagic]
private predicate isParameterOf0(DataFlowCallable c, ParameterPosition ppos, Parameter p) {
  p.getCallable() = c.asCallable(_) and
  p.getPosition() = ppos.getPosition()
}

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph.
 */
class ParameterNode extends Node instanceof ParameterNodeImpl {
  /** Gets the parameter corresponding to this node, if any. */
  Parameter getParameter() {
    exists(DataFlowCallable c, ParameterPosition ppos |
      super.isParameterOf(c, ppos) and
      isParameterOf0(c, ppos, result)
    )
  }
}

/** A definition, viewed as a node in a data flow graph. */
class AssignableDefinitionNode extends Node instanceof AssignableDefinitionNodeImpl {
  /** Gets the underlying definition. */
  AssignableDefinition getDefinition() { result = super.getDefinition() }

  /** Gets the underlying definition, at control flow node `cfn`, if any. */
  AssignableDefinition getDefinitionAtNode(ControlFlow::Node cfn) {
    result = super.getDefinitionAtNode(cfn)
  }
}

/** Gets a node corresponding to expression `e`. */
ExprNode exprNode(Expr e) { result.getExpr() = e }

/**
 * Gets the node corresponding to the value of parameter `p` at function entry.
 */
ParameterNode parameterNode(Parameter p) { result.getParameter() = p }

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
 * Holds if the guard `g` validates the expression `e` upon evaluating to `v`.
 *
 * The expression `e` is expected to be a syntactic part of the guard `g`.
 * For example, the guard `g` might be a call `isSafe(x)` and the expression `e`
 * the argument `x`.
 */
signature predicate guardChecksSig(Guard g, Expr e, AbstractValue v);

/**
 * Provides a set of barrier nodes for a guard that validates an expression.
 *
 * This is expected to be used in `isBarrier`/`isSanitizer` definitions
 * in data flow and taint tracking.
 */
module BarrierGuard<guardChecksSig/3 guardChecks> {
  private import SsaImpl as SsaImpl

  /** Gets a node that is safely guarded by the given guard check. */
  pragma[nomagic]
  Node getABarrierNode() {
    SsaFlow::asNode(result) =
      SsaImpl::DataFlowIntegration::BarrierGuard<guardChecks/3>::getABarrierNode()
    or
    exists(Guard g, Expr e, AbstractValue v |
      guardChecks(g, e, v) and
      g.controlsNode(result.getControlFlowNode(), e, v)
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

/** A reference to a dynamic property. */
class DynamicPropertyContent extends Content, TDynamicPropertyContent {
  private DynamicProperty name;

  DynamicPropertyContent() { this = TDynamicPropertyContent(name) }

  /** Gets an access of this dynamic property. */
  DynamicMemberAccess getAnAccess() { result = name.getAnAccess() }

  override string toString() { result = "dynamic property " + name }

  override EmptyLocation getLocation() { any() }

  /** Gets the name that is referenced. */
  string getName() { result = name }
}

/**
 * A reference to the index of an argument of a delegate call.
 */
class DelegateCallArgumentContent extends Content, TDelegateCallArgumentContent {
  private int i;

  DelegateCallArgumentContent() { this = TDelegateCallArgumentContent(i) }

  override string toString() { result = "delegate argument at position " + i }

  override Location getLocation() { result instanceof EmptyLocation }
}

/**
 * A reference to the return of a delegate call.
 */
class DelegateCallReturnContent extends Content, TDelegateCallReturnContent {
  DelegateCallReturnContent() { this = TDelegateCallReturnContent() }

  override string toString() { result = "delegate return" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/**
 * A reference to a synthetic field corresponding to a
 * primary constructor parameter.
 */
class PrimaryConstructorParameterContent extends Content, TPrimaryConstructorParameterContent {
  private Parameter p;

  PrimaryConstructorParameterContent() { this = TPrimaryConstructorParameterContent(p) }

  /** Gets the underlying parameter. */
  Parameter getParameter() { result = p }

  override string toString() { result = "parameter " + p.getName() }

  override Location getLocation() { result = p.getLocation() }
}

/** A reference to an element in a collection. */
class ElementContent extends Content, TElementContent {
  override string toString() { result = "element" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/** A captured variable. */
class CapturedVariableContent extends Content, TCapturedVariableContent {
  private VariableCapture::CapturedVariable v;

  CapturedVariableContent() { this = TCapturedVariableContent(v) }

  override string toString() { result = "captured " + v }

  override Location getLocation() { result = v.getLocation() }
}

/** Holds if property `p1` overrides or implements source declaration property `p2`. */
private predicate overridesOrImplementsSourceDecl(Property p1, Property p2) {
  p1.getOverridee*().getUnboundDeclaration() = p2
  or
  p1.getAnUltimateImplementee().getUnboundDeclaration() = p2
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

  /**
   * Holds if this content set represents the property `p`.
   *
   *
   * For `getAReadContent`, this set represents all properties that may
   * (reflexively and transitively) override/implement `p` (or vice versa).
   */
  predicate isProperty(Property p) { this = TPropertyContentSet(p) }

  /** Holds if this content set represents the dynamic property `name`. */
  predicate isDynamicProperty(string name) { this = TDynamicPropertyContentSet(name) }

  /**
   * Holds if this content set represents the `i`th argument of a delegate call.
   */
  predicate isDelegateCallArgument(int i) { this.isSingleton(TDelegateCallArgumentContent(i)) }

  /**
   * Holds if this content set represents the return of a delegate call.
   */
  predicate isDelegateCallReturn() { this.isSingleton(TDelegateCallReturnContent()) }

  /** Holds if this content set represents the field `f`. */
  predicate isField(Field f) { this.isSingleton(TFieldContent(f)) }

  /** Holds if this content set represents the synthetic field `s`. */
  predicate isSyntheticField(string s) { this.isSingleton(TSyntheticFieldContent(s)) }

  /** Holds if this content set represents an element in a collection. */
  predicate isElement() { this.isSingleton(TElementContent()) }

  /** Gets a content that may be stored into when storing into this set. */
  Content getAStoreContent() {
    this.isSingleton(result)
    or
    this.isProperty(result.(PropertyContent).getProperty())
    or
    this.isDynamicProperty(result.(DynamicPropertyContent).getName())
  }

  /** Gets a content that may be read from when reading from this set. */
  Content getAReadContent() {
    this.isSingleton(result)
    or
    exists(Property p1, Property p2 |
      this.isProperty(p1) and
      p2 = result.(PropertyContent).getProperty()
    |
      overridesOrImplementsSourceDecl(p2, p1)
      or
      overridesOrImplementsSourceDecl(p1, p2)
    )
    or
    exists(FieldOrProperty p |
      this = p.getContentSet() and
      result.(DynamicPropertyContent).getName() = p.getName()
    )
    or
    this.isDynamicProperty([
        result.(DynamicPropertyContent).getName(),
        result.(PropertyContent).getProperty().getName(),
        result.(FieldContent).getField().getName()
      ])
  }

  /** Gets a textual representation of this content set. */
  string toString() {
    exists(Content c |
      this.isSingleton(c) and
      result = c.toString()
    )
    or
    exists(Property p |
      this.isProperty(p) and
      result = "property " + p.getName()
    )
    or
    exists(string name |
      this.isDynamicProperty(name) and
      result = "dynamic property " + name
    )
  }

  /** Gets the location of this content set. */
  Location getLocation() {
    exists(Content c |
      this.isSingleton(c) and
      result = c.getLocation()
    )
    or
    exists(Property p |
      this.isProperty(p) and
      result = p.getLocation()
    )
    or
    this.isDynamicProperty(_) and
    result instanceof EmptyLocation
  }
}
