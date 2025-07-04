private import powershell
private import DataFlowDispatch
private import DataFlowPrivate
private import semmle.code.powershell.typetracking.internal.TypeTrackingImpl
private import semmle.code.powershell.ApiGraphs
private import semmle.code.powershell.Cfg

/**
 * An element, viewed as a node in a data flow graph. Either an expression
 * (`ExprNode`) or a parameter (`ParameterNode`).
 */
class Node extends TNode {
  /** Gets the expression corresponding to this node, if any. */
  CfgNodes::ExprCfgNode asExpr() { result = this.(ExprNode).getExprNode() }

  ScriptBlock asCallable() { result = this.(CallableNode).asCallableAstNode() }

  /** Gets the parameter corresponding to this node, if any. */
  Parameter asParameter() { result = this.(ParameterNode).getParameter() }

  /** Gets a textual representation of this node. */
  final string toString() { result = toString(this) }

  /** Gets the location of this node. */
  final Location getLocation() { result = getLocation(this) }

  /**
   * Gets a data flow node from which data may flow to this node in one local step.
   */
  Node getAPredecessor() { localFlowStep(result, this) }

  /**
   * Gets a local source node from which data may flow to this node in zero or
   * more local data-flow steps.
   */
  LocalSourceNode getALocalSource() { result.flowsTo(this) }

  /**
   * Gets a data flow node to which data may flow from this node in one local step.
   */
  Node getASuccessor() { localFlowStep(this, result) }
}

/** A control-flow node, viewed as a node in a data flow graph. */
abstract private class AbstractAstNode extends Node {
  CfgNodes::AstCfgNode n;

  /** Gets the control-flow node corresponding to this node. */
  CfgNodes::AstCfgNode getCfgNode() { result = n }
}

final class AstNode = AbstractAstNode;

/**
 * An expression, viewed as a node in a data flow graph.
 *
 * Note that because of control-flow splitting, one `Expr` may correspond
 * to multiple `ExprNode`s, just like it may correspond to multiple
 * `ControlFlow::Node`s.
 */
class ExprNode extends AbstractAstNode, TExprNode {
  override CfgNodes::ExprCfgNode n;

  ExprNode() { this = TExprNode(n) }

  /** Gets the expression corresponding to this node. */
  CfgNodes::ExprCfgNode getExprNode() { result = n }
}

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph.
 */
class ParameterNode extends Node {
  ParameterNode() { exists(getParameterPosition(this, _)) }

  /** Gets the parameter corresponding to this node, if any. */
  final Parameter getParameter() { result = getParameter(this) }
}

/**
 * A data flow node corresponding to a method, block, or lambda expression.
 */
class CallableNode extends Node instanceof ScriptBlockNode {
  private ParameterPosition getParameterPosition(ParameterNodeImpl node) {
    exists(DataFlowCallable c |
      c.asCfgScope() = this.asCallableAstNode() and
      result = getParameterPosition(node, c)
    )
  }

  /** Gets the underlying AST node as a `Callable`. */
  ScriptBlock asCallableAstNode() { result = super.getScriptBlock() }

  /** Gets the `n`th positional parameter. */
  ParameterNode getParameter(int n) {
    this.getParameterPosition(result).isPositional(n, emptyNamedSet())
  }

  /** Gets the number of positional parameters of this callable. */
  final int getNumberOfParameters() { result = count(this.getParameter(_)) }

  /** Gets the keyword parameter of the given name. */
  ParameterNode getKeywordParameter(string name) {
    this.getParameterPosition(result).isKeyword(name)
  }

  /**
   * Gets a data flow node whose value is about to be returned by this callable.
   */
  Node getAReturnNode() { result = getAReturnNode(this.asCallableAstNode()) }
}

/**
 * A data-flow node that is a source of local flow.
 */
class LocalSourceNode extends Node {
  LocalSourceNode() { isLocalSourceNode(this) }

  /** Starts tracking this node forward using API graphs. */
  pragma[inline]
  API::Node track() { result = API::Internal::getNodeForForwardTracking(this) }

  /** Holds if this `LocalSourceNode` can flow to `nodeTo` in one or more local flow steps. */
  pragma[inline]
  predicate flowsTo(Node nodeTo) { flowsTo(this, nodeTo) }

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
  LocalSourceNode backtrack(TypeBackTracker t2, TypeBackTracker t) { t = t2.step(result, this) }

  /**
   * Gets a node to which data may flow from this node in zero or
   * more local data-flow steps.
   */
  pragma[inline]
  Node getALocalUse() { flowsTo(this, result) }

  /** Gets a method call where this node flows to the receiver. */
  CallNode getAMethodCall() { Cached::hasMethodCall(this, result, _) }

  /** Gets a call to a method named `name`, where this node flows to the receiver. */
  CallNode getAMethodCall(string name) { Cached::hasMethodCall(this, result, name) }
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
class PostUpdateNode extends Node {
  private Node pre;

  PostUpdateNode() { pre = getPreUpdateNode(this) }

  /** Gets the node before the state update. */
  Node getPreUpdateNode() { result = pre }
}

cached
private module Cached {
  cached
  predicate hasMethodCall(LocalSourceNode source, CallNode call, string name) {
    source.flowsTo(call.getQualifier()) and
    call.getLowerCaseName() = name
  }

  cached
  CfgScope getCfgScope(NodeImpl node) { result = node.getCfgScope() }

  cached
  ReturnNode getAReturnNode(ScriptBlock scriptBlock) { getCfgScope(result) = scriptBlock }

  cached
  Parameter getParameter(ParameterNodeImpl param) { result = param.getParameter() }

  cached
  ParameterPosition getParameterPosition(ParameterNodeImpl param, DataFlowCallable c) {
    param.isParameterOf(c, result)
  }

  cached
  ParameterPosition getSourceParameterPosition(ParameterNodeImpl param, ScriptBlock c) {
    param.isSourceParameterOf(c, result)
  }

  cached
  Node getPreUpdateNode(PostUpdateNodeImpl node) { result = node.getPreUpdateNode() }

  cached
  predicate forceCachingInSameStage() { any() }
}

private import Cached

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
  /** An element in a collection, for example an element in an array or in a hash. */
  class ElementContent extends Content, TElementContent { }

  abstract class KnownElementContent extends ElementContent, TKnownElementContent {
    ConstantValue cv;

    /** Gets the index in the collection. */
    final ConstantValue getIndex() { result = cv }

    override string toString() { result = "element " + cv }
  }

  /** An element in a collection at a known index. */
  class KnownKeyContent extends KnownElementContent, TKnownKeyContent {
    KnownKeyContent() { this = TKnownKeyContent(cv) }
  }

  /** An element in a collection at a known index. */
  class KnownPositionalContent extends KnownElementContent, TKnownPositionalContent {
    KnownPositionalContent() { this = TKnownPositionalContent(cv) }
  }

  class UnknownElementContent extends ElementContent, TUnknownElementContent { }

  class UnknownKeyContent extends UnknownElementContent, TUnknownKeyContent {
    UnknownKeyContent() { this = TUnknownKeyContent() }

    override string toString() { result = "unknown map key" }
  }

  class UnknownPositionalContent extends UnknownElementContent, TUnknownPositionalContent {
    UnknownPositionalContent() { this = TUnknownPositionalContent() }

    override string toString() { result = "unknown index" }
  }

  class UnknownKeyOrPositionContent extends UnknownElementContent, TUnknownKeyOrPositionContent {
    UnknownKeyOrPositionContent() { this = TUnknownKeyOrPositionContent() }

    override string toString() { result = "unknown" }
  }

  /** A field of an object. */
  class FieldContent extends Content, TFieldContent {
    private string name;

    FieldContent() { this = TFieldContent(name) }

    /** Gets the name of the field. */
    string getLowerCaseName() { result = name }

    override string toString() { result = name }
  }

  /** Gets the element content corresponding to constant value `cv`. */
  KnownElementContent getKnownElementContent(ConstantValue cv) {
    result = TKnownPositionalContent(cv)
    or
    result = TKnownKeyContent(cv)
  }

  /**
   * Gets the constant value of `e`, which corresponds to a valid known
   * element index.
   */
  ConstantValue getKnownElementIndex(Expr e) {
    result = getKnownElementContent(e.getValue()).getIndex()
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
  predicate isSingleton(Content c) { this = TSingletonContentSet(c) }

  predicate isKnownOrUnknownKeyContent(Content::KnownKeyContent c) {
    this = TKnownOrUnknownKeyContentSet(c)
  }

  predicate isKnownOrUnknownPositional(Content::KnownPositionalContent c) {
    this = TKnownOrUnknownPositionalContentSet(c)
  }

  predicate isKnownOrUnknownElement(Content::KnownElementContent c) {
    this.isKnownOrUnknownKeyContent(c)
    or
    this.isKnownOrUnknownPositional(c)
  }

  predicate isUnknownPositionalContent() { this = TUnknownPositionalElementContentSet() }

  predicate isUnknownKeyContent() { this = TUnknownKeyContentSet() }

  predicate isAnyElement() { this = TAnyElementContentSet() }

  predicate isAnyPositional() { this = TAnyPositionalContentSet() }

  // predicate isPipelineContentSet() { this = TPipelineContentSet() }
  /** Gets a textual representation of this content set. */
  string toString() {
    exists(Content c |
      this.isSingleton(c) and
      result = c.toString()
    )
    or
    exists(Content::KnownElementContent c |
      this.isKnownOrUnknownElement(c) and
      result = c.toString() + " or unknown"
    )
    or
    this.isUnknownPositionalContent() and
    result = "unknown positional"
    or
    this.isUnknownKeyContent() and
    result = "unknown key"
    or
    this.isAnyPositional() and
    result = "any positional"
    or
    this.isAnyElement() and
    result = "any element"
  }

  /** Gets a content that may be stored into when storing into this set. */
  Content getAStoreContent() {
    this.isSingleton(result)
    or
    // For reverse stores, `a[unknown][0] = x`, it is important that the read-step
    // from `a` to `a[unknown]` (which can read any element), gets translated into
    // a reverse store step that store only into `?`
    this.isAnyElement() and
    result = TUnknownKeyOrPositionContent()
    or
    // For reverse stores, `a[1][0] = x`, it is important that the read-step
    // from `a` to `a[1]` (which can read both elements stored at exactly index `1`
    // and elements stored at unknown index), gets translated into a reverse store
    // step that store only into `1`
    this.isKnownOrUnknownElement(result)
    or
    this.isUnknownPositionalContent() and
    result = TUnknownPositionalContent()
    or
    this.isUnknownKeyContent() and
    result = TUnknownKeyContent()
    or
    this.isAnyPositional() and
    (
      result instanceof Content::KnownPositionalContent
      or
      result = TUnknownPositionalContent()
    )
  }

  /** Gets a content that may be read from when reading from this set. */
  Content getAReadContent() {
    this.isSingleton(result)
    or
    this.isAnyElement() and
    result instanceof Content::ElementContent
    or
    exists(Content::KnownElementContent c |
      this.isKnownOrUnknownKeyContent(c) and
      (
        result = c
        or
        result = TUnknownKeyContent()
        or
        result = TUnknownKeyOrPositionContent()
      )
      or
      this.isKnownOrUnknownPositional(c) and
      (
        result = c or
        result = TUnknownPositionalContent() or
        result = TUnknownKeyOrPositionContent()
      )
    )
    or
    this.isUnknownPositionalContent() and
    result = TUnknownPositionalContent()
    or
    this.isUnknownKeyContent() and
    result = TUnknownKeyContent()
    or
    this.isAnyPositional() and
    (
      result instanceof Content::KnownPositionalContent
      or
      result = TUnknownPositionalContent()
    )
  }
}

/**
 * Holds if the guard `g` validates the expression `e` upon evaluating to `branch`.
 *
 * The expression `e` is expected to be a syntactic part of the guard `g`.
 * For example, the guard `g` might be a call `isSafe(x)` and the expression `e`
 * the argument `x`.
 */
signature predicate guardChecksSig(CfgNodes::AstCfgNode g, CfgNode e, boolean branch);

/**
 * Provides a set of barrier nodes for a guard that validates an expression.
 *
 * This is expected to be used in `isBarrier`/`isSanitizer` definitions
 * in data flow and taint tracking.
 */
module BarrierGuard<guardChecksSig/3 guardChecks> {
  /** Gets a node that is safely guarded by the given guard check. */
  Node getABarrierNode() {
    none() // TODO
  }
}

/**
 * A dataflow node that represents the creation of an object.
 *
 * For example, `[Foo]::new()` or `New-Object Foo`.
 */
class ObjectCreationNode extends ExprNode {
  CfgNodes::ExprNodes::ObjectCreationCfgNode objectCreation;

  ObjectCreationNode() { this.getExprNode() = objectCreation }

  final CfgNodes::ExprNodes::ObjectCreationCfgNode getObjectCreationNode() {
    result = objectCreation
  }

  /**
   * Gets the node corresponding to the expression that decides which type
   * to allocate.
   *
   * For example, in `[Foo]::new()`, this would be `Foo`, and in
   * `New-Object Foo`, this would be `Foo`.
   */
  Node getConstructedTypeNode() { result.asExpr() = objectCreation.getConstructedTypeExpr() }

  string getConstructedTypeName() { result = this.getObjectCreationNode().getConstructedTypeName() }
}

/** A call, viewed as a node in a data flow graph. */
class CallNode extends ExprNode {
  CfgNodes::ExprNodes::CallExprCfgNode call;

  CallNode() { call = this.getCfgNode() }

  CfgNodes::ExprNodes::CallExprCfgNode getCallNode() { result = call }

  string getLowerCaseName() { result = call.getLowerCaseName() }

  bindingset[name]
  pragma[inline_late]
  final predicate matchesName(string name) { this.getLowerCaseName() = name.toLowerCase() }

  bindingset[result]
  pragma[inline_late]
  final string getAName() { result.toLowerCase() = this.getLowerCaseName() }

  Node getQualifier() { result.asExpr() = call.getQualifier() }

  /** Gets the i'th argument to this call. */
  Node getArgument(int i) { result.asExpr() = call.getArgument(i) }

  /** Gets the i'th positional argument to this call. */
  Node getPositionalArgument(int i) { result.asExpr() = call.getPositionalArgument(i) }

  /** Gets the argument with the name `name`, if any. */
  Node getNamedArgument(string name) { result.asExpr() = call.getNamedArgument(name) }

  /** Holds if an argument with name `name` is provided to this call. */
  predicate hasNamedArgument(string name) { call.hasNamedArgument(name) }

  /**
   * Gets any argument of this call.
   *
   * Note that this predicate doesn't get the pipeline argument, if any.
   */
  Node getAnArgument() { result.asExpr() = call.getAnArgument() }

  Node getCallee() { result.asExpr() = call.getCallee() }
}

/** A call to operator `&`, viwed as a node in a data flow graph. */
class CallOperatorNode extends CallNode {
  override CfgNodes::ExprNodes::CallOperatorCfgNode call;

  Node getCommand() { result.asExpr() = call.getCommand() } // TODO: Alternatively, we could remap calls to & as command expressions.
}

/**
 * A call to `ToString`, viewed as a node in a data flow graph.
 */
class ToStringCallNode extends CallNode {
  override CfgNodes::ExprNodes::ToStringCallCfgNode call;
}

/** A use of a type name, viewed as a node in a data flow graph. */
class TypeNameNode extends ExprNode {
  override CfgNodes::ExprNodes::TypeNameExprCfgNode n;

  override CfgNodes::ExprNodes::TypeNameExprCfgNode getExprNode() { result = n }

  string getName() { result = n.getName() }

  predicate isQualified() { n.isQualified() }

  predicate hasQualifiedName(string namespace, string typename) {
    n.hasQualifiedName(namespace, typename)
  }

  string getNamespace() { result = n.getNamespace() }

  string getPossiblyQualifiedName() { result = n.getPossiblyQualifiedName() }
}

/** A use of a qualified type name, viewed as a node in a data flow graph. */
class QualifiedTypeNameNode extends TypeNameNode {
  override CfgNodes::ExprNodes::QualifiedTypeNameExprCfgNode n;

  final override CfgNodes::ExprNodes::QualifiedTypeNameExprCfgNode getExprNode() { result = n }
}

/** A use of an automatic variable, viewed as a node in a data flow graph. */
class AutomaticVariableNode extends ExprNode {
  override CfgNodes::ExprNodes::AutomaticVariableCfgNode n;

  final override CfgNodes::ExprNodes::AutomaticVariableCfgNode getExprNode() { result = n }

  string getName() { result = n.getName() }
}
