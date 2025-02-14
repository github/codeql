private import codeql.ruby.AST
private import DataFlowDispatch
private import DataFlowPrivate
private import codeql.ruby.CFG
private import codeql.ruby.typetracking.internal.TypeTrackingImpl
private import codeql.ruby.dataflow.SSA
private import FlowSummaryImpl as FlowSummaryImpl
private import codeql.ruby.ApiGraphs
private import SsaImpl as SsaImpl

/**
 * An element, viewed as a node in a data flow graph. Either an expression
 * (`ExprNode`) or a parameter (`ParameterNode`).
 */
class Node extends TNode {
  /** Starts backtracking from this node using API graphs. */
  pragma[inline]
  API::Node backtrack() { result = API::Internal::getNodeForBacktracking(this) }

  /** Gets the expression corresponding to this node, if any. */
  CfgNodes::ExprCfgNode asExpr() { result = this.(ExprNode).getExprNode() }

  /** Gets the parameter corresponding to this node, if any. */
  Parameter asParameter() { result = this.(ParameterNode).getParameter() }

  /** Gets a textual representation of this node. */
  final string toString() { result = toString(this) }

  /** Gets the location of this node. */
  final Location getLocation() { result = getLocation(this) }

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

  /** Gets the constant value of this expression, if any. */
  ConstantValue getConstantValue() { result = this.asExpr().getConstantValue() }

  /**
   * Gets the callable corresponding to this block, lambda expression, or call to `proc` or `lambda`.
   *
   * For example, gets the callable in each of the following cases:
   * ```rb
   * { |x| x }        # block expression
   * ->(x) { x }      # lambda expression
   * proc { |x| x }   # call to 'proc'
   * lambda { |x| x } # call to 'lambda'
   * ```
   */
  pragma[noinline]
  CallableNode asCallable() {
    result = this
    or
    exists(DataFlowCallable c |
      lambdaCreation(this, _, c) and
      result.asCallableAstNode() = c.asCfgScope()
    )
  }

  /** Gets the enclosing method, if any. */
  MethodNode getEnclosingMethod() {
    result.asCallableAstNode() = this.asExpr().getExpr().getEnclosingMethod()
  }
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

  /**
   * Gets the `n`th positional argument of this call.
   * Unlike `getArgument`, this excludes keyword arguments.
   */
  final ExprNode getPositionalArgument(int n) {
    result.getExprNode() = node.getPositionalArgument(n)
  }

  /** Gets the name of the method called by the method call (if any) corresponding to this data-flow node */
  string getMethodName() { result = node.getExpr().(MethodCall).getMethodName() }

  /** Gets the number of arguments of this call. */
  int getNumberOfArguments() { result = node.getNumberOfArguments() }

  /** Gets the block of this call. */
  Node getBlock() { result.asExpr() = node.getBlock() }

  /**
   * Gets the data-flow node corresponding to the named argument of the call
   * corresponding to this data-flow node, also including values passed with (pre Ruby
   * 2.0) hash arguments.
   *
   * Such hash arguments are tracked back to their source location within functions, but
   * no inter-procedural analysis occurs.
   *
   * This means all 3 variants below will be handled by this predicate:
   *
   * ```ruby
   * foo(..., some_option: 42)
   * foo(..., { some_option: 42 })
   * options = { some_option: 42 }
   * foo(..., options)
   * ```
   */
  Node getKeywordArgumentIncludeHashArgument(string name) {
    // to reduce number of computed tuples, I have put bindingset on both this and name,
    // meaning we only do the local backwards tracking for known calls and known names.
    // (not because a performance problem was seen, it just seemed right).
    result = this.getKeywordArgument(name)
    or
    exists(CfgNodes::ExprNodes::PairCfgNode pair |
      pair =
        this.getArgument(_)
            .getALocalSource()
            .asExpr()
            .(CfgNodes::ExprNodes::HashLiteralCfgNode)
            .getAKeyValuePair() and
      pair.getKey().getConstantValue().isStringlikeValue(name) and
      result.asExpr() = pair.getValue()
    )
  }

  /**
   * Gets a potential target of this call, if any.
   */
  final CallableNode getATarget() {
    result.asCallableAstNode() = this.asExpr().getExpr().(Call).getATarget()
  }

  /**
   * Holds if this is a `super` call.
   */
  final predicate isSuperCall() { this.asExpr().getExpr() instanceof SuperCall }
}

/**
 * A call to a setter method.
 *
 * For example,
 * ```rb
 * self.foo = 10
 * a[0] = 10
 * ```
 */
class SetterCallNode extends CallNode {
  SetterCallNode() { this.getExprNode().getExpr() instanceof SetterMethodCall }

  /**
   * Gets the name of the method being called without the trailing `=`. For example, in the following
   * two statements the target name is `value`:
   * ```rb
   * foo.value=(1)
   * foo.value = 1
   * ```
   */
  final string getTargetName() {
    result = this.getExprNode().getExpr().(SetterMethodCall).getTargetName()
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
  private CfgNodes::ExprCfgNode n;

  ExprNode() { this = TExprNode(n) }

  /** Gets the expression corresponding to this node. */
  CfgNodes::ExprCfgNode getExprNode() { result = n }
}

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph.
 */
class ParameterNode extends LocalSourceNode {
  ParameterNode() { exists(getParameterPosition(this, _)) }

  /** Gets the parameter corresponding to this node, if any. */
  final Parameter getParameter() { result = getParameter(this) }

  /** Gets the callable that this parameter belongs to. */
  final Callable getCallable() { result = getCfgScope(this) }

  /** Gets the name of the parameter, if any. */
  final string getName() { result = this.getParameter().(NamedParameter).getName() }
}

/**
 * The value of an implicit `self` parameter at function entry, viewed as a node in a data
 * flow graph.
 */
class SelfParameterNode extends ParameterNode instanceof SelfParameterNodeImpl {
  /** Gets the underlying `self` variable. */
  final SelfVariable getSelfVariable() { result = super.getSelfVariable() }
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

  /** Gets a call `obj.name` with no arguments, where this node flows to `obj`. */
  CallNode getAnAttributeRead(string name) {
    result = this.getAMethodCall(name) and
    result.getNumberOfArguments() = 0
  }

  /**
   * Gets a value assigned to `name` on this object, such as the `x` in `obj.name = x`.
   *
   * Concretely, this gets the argument of any call to `name=` where this node flows to the receiver.
   */
  Node getAnAttributeWriteValue(string name) {
    result = this.getAMethodCall(name + "=").getArgument(0)
  }

  /**
   * Gets an access to an element on this node, such as `obj[key]`.
   *
   * Concretely this gets a call to `[]` with 1 argument, where this node flows to the receiver.
   */
  CallNode getAnElementRead() {
    result = this.getAMethodCall("[]") and result.getNumberOfArguments() = 1
  }

  /**
   * Gets an access to the element `key` on this node, such as `obj[:key]`.
   *
   * Concretely this gets a call to `[]` where this node flows to the receiver
   * and the first and only argument has the constant value `key`.
   */
  CallNode getAnElementRead(ConstantValue key) {
    result = this.getAnElementRead() and
    key = result.getArgument(0).getConstantValue()
  }

  private CallNode getAnElementWriteCall() {
    result = this.getAMethodCall("[]=") and
    result.getNumberOfArguments() = 2
  }

  /**
   * Gets a value stored as an element on this node, such as the `x` in `obj[key] = x`.
   *
   * Concretely, this gets the second argument from any call to `[]=` where this node flows to the receiver.
   */
  Node getAnElementWriteValue() { result = this.getAnElementWriteCall().getArgument(1) }

  /**
   * Gets the `x` in `obj[key] = x`, where this node flows to `obj`.
   *
   * Concretely, this gets the second argument from any call to `[]=` where this node flows to the receiver
   * and the first argument has constant value `key`.
   */
  Node getAnElementWriteValue(ConstantValue key) {
    exists(CallNode call |
      call = this.getAnElementWriteCall() and
      call.getArgument(0).getConstantValue() = key and
      result = call.getArgument(1)
    )
  }
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

/** An SSA definition, viewed as a node in a data flow graph. */
class SsaDefinitionNode extends Node instanceof SsaDefinitionNodeImpl {
  /** Gets the underlying SSA definition. */
  Ssa::Definition getDefinition() { result = super.getDefinitionExt() }

  /** Gets the underlying variable. */
  Variable getVariable() { result = this.getDefinition().getSourceVariable() }
}

cached
private module Cached {
  cached
  predicate hasMethodCall(LocalSourceNode source, CallNode call, string name) {
    source.flowsTo(call.getReceiver()) and
    call.getMethodName() = name
  }

  cached
  predicate hasYieldCall(BlockParameterNode block, CallNode yield) {
    exists(MethodBase method, YieldCall call |
      block.getMethod() = method and
      call.getEnclosingMethod() = method and
      yield.asExpr().getExpr() = call
    )
  }

  cached
  CfgScope getCfgScope(NodeImpl node) { result = node.getCfgScope() }

  cached
  ReturnNode getAReturnNode(Callable callable) { getCfgScope(result) = callable }

  cached
  Parameter getParameter(ParameterNodeImpl param) { result = param.getParameter() }

  cached
  ParameterPosition getParameterPosition(ParameterNodeImpl param, DataFlowCallable c) {
    param.isParameterOf(c, result)
  }

  cached
  ParameterPosition getSourceParameterPosition(ParameterNodeImpl param, Callable c) {
    param.isSourceParameterOf(c, result)
  }

  cached
  Node getPreUpdateNode(PostUpdateNodeImpl node) { result = node.getPreUpdateNode() }

  cached
  predicate methodHasSuperCall(MethodNode method, CallNode call) {
    call.isSuperCall() and method = call.getEnclosingMethod()
  }

  /**
   * A place in which a named constant can be looked up during constant lookup.
   */
  cached
  newtype TConstLookupScope =
    /** Look up in a qualified constant name `base::`. */
    MkQualifiedLookup(ConstantAccess base) or
    /** Look up in the ancestors of `mod`. */
    MkAncestorLookup(Module mod) or
    /** Look up in a module syntactically nested in a declaration of `mod`. */
    MkNestedLookup(Module mod) or
    /** Pseudo-scope for accesses that are known to resolve to `mod`. */
    MkExactLookup(Module mod)

  /**
   * Gets a `LocalSourceNode` to represent the constant read or written by `access`.
   */
  cached
  LocalSourceNode getConstantAccessNode(ConstantAccess access) {
    // Namespaces don't evaluate to the constant being accessed, they return the value of their last statement.
    // Use the definition of 'self' in the namespace as the representative in this case.
    result.(SsaDefinitionExtNode).getDefinitionExt().(Ssa::SelfDefinition).getSourceVariable() =
      access.(Namespace).getModuleSelfVariable()
    or
    not access instanceof Namespace and
    result.asExpr().getExpr() = access
  }

  /**
   * Gets a module for which `constRef` is the reference to an ancestor module.
   *
   * For example, `M` is the ancestry target of `C` in the following examples:
   * ```rb
   * class M < C {}
   *
   * module M
   *   include C
   * end
   *
   * module M
   *   prepend C
   * end
   * ```
   */
  private ModuleNode getAncestryTarget(ConstRef constRef) { result.getAnAncestorExpr() = constRef }

  /**
   * Gets a scope in which a constant lookup may access the contents of the module referenced by `constRef`.
   */
  cached
  TConstLookupScope getATargetScope(ConstRef constRef) {
    result = MkAncestorLookup(getAncestryTarget(constRef).getAnImmediateDescendent*())
    or
    constRef.asConstantAccess() = any(ConstantAccess ac).getScopeExpr() and
    result = MkQualifiedLookup(constRef.asConstantAccess())
    or
    result = MkNestedLookup(getAncestryTarget(constRef))
    or
    result = MkExactLookup(constRef.asConstantAccess().(Namespace).getModule())
  }

  cached
  predicate forceCachingInSameStage() { any() }

  cached
  predicate forceCachingBackref() { exists(any(ConstRef const).getConstant(_)) }
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

  /** An element in a collection at a known index. */
  class KnownElementContent extends ElementContent, TKnownElementContent {
    private ConstantValue cv;

    KnownElementContent() { this = TKnownElementContent(cv) }

    /** Gets the index in the collection. */
    ConstantValue getIndex() { result = cv }

    override string toString() { result = "element " + cv }
  }

  /** An element in a collection at an unknown index. */
  class UnknownElementContent extends ElementContent, TUnknownElementContent {
    override string toString() { result = "element" }
  }

  /** A field of an object, for example an instance variable. */
  class FieldContent extends Content, TFieldContent {
    private string name;

    FieldContent() { this = TFieldContent(name) }

    /** Gets the name of the field. */
    string getName() { result = name }

    override string toString() { result = name }
  }

  /** Gets the element content corresponding to constant value `cv`. */
  ElementContent getElementContent(ConstantValue cv) {
    result = TKnownElementContent(cv)
    or
    not exists(TKnownElementContent(cv)) and
    result = TUnknownElementContent()
  }

  /**
   * Gets the constant value of `e`, which corresponds to a valid known
   * element index. Unlike calling simply `e.getConstantValue()`, this
   * excludes negative array indices.
   */
  ConstantValue getKnownElementIndex(Expr e) {
    result = getElementContent(e.getConstantValue()).(KnownElementContent).getIndex()
  }

  /**
   * INTERNAL: Do not use.
   *
   * An element inside a synthetic splat argument. All positional arguments
   * (including splat arguments) are implicitly stored inside a synthetic
   * splat argument. For example, in
   *
   * ```rb
   * foo(1, 2, 3)
   * ```
   *
   * we have an implicit splat argument containing `[1, 2, 3]`.
   */
  deprecated class SplatContent extends Content, TSplatContent {
    private int i;
    private boolean shifted;

    SplatContent() { this = TSplatContent(i, shifted) }

    /** Gets the position of this splat element. */
    int getPosition() { result = i }

    /**
     * Holds if this element represents a value from an actual splat argument
     * that had its index shifted. For example, in
     *
     * ```rb
     * foo(x, *args)
     * ```
     *
     * the elements of `args` will have their index shifted by 1 before being
     * put into the synthetic splat argument.
     */
    predicate isShifted() { shifted = true }

    override string toString() {
      exists(string s |
        (if this.isShifted() then s = " (shifted)" else s = "") and
        result = "splat position " + i + s
      )
    }
  }

  /**
   * INTERNAL: Do not use.
   *
   * An element inside a synthetic hash-splat argument. All keyword arguments
   * are implicitly stored inside a synthetic hash-splat argument. For example,
   * in
   *
   * ```rb
   * foo(a: 1, b: 2, c: 3)
   * ```
   *
   * we have an implicit hash-splat argument containing `{:a => 1, :b => 2, :c => 3}`.
   */
  deprecated class HashSplatContent extends Content, THashSplatContent {
    private ConstantValue::ConstantSymbolValue cv;

    HashSplatContent() { this = THashSplatContent(cv) }

    /** Gets the hash key. */
    ConstantValue::ConstantSymbolValue getKey() { result = cv }

    override string toString() { result = "hash-splat position " + cv }
  }

  /**
   * A value stored behind a getter/setter pair.
   *
   * This is used (only) by type-tracking, as a heuristic since getter/setter pairs tend to operate
   * on similar types of objects (i.e. the type flowing into a setter will likely flow out of the getter).
   */
  class AttributeNameContent extends Content, TAttributeName {
    private string name;

    AttributeNameContent() { this = TAttributeName(name) }

    override string toString() { result = "attribute " + name }

    /** Gets the attribute name. */
    string getName() { result = name }
  }

  /** Gets `AttributeNameContent` of the given name. */
  AttributeNameContent getAttributeName(string name) { result.getName() = name }

  /** A captured variable. */
  class CapturedVariableContent extends Content, TCapturedVariableContent {
    private LocalVariable v;

    CapturedVariableContent() { this = TCapturedVariableContent(v) }

    /** Gets the captured variable. */
    LocalVariable getVariable() { result = v }

    override string toString() { result = "captured " + v }
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

  /** Holds if this content set represents all `ElementContent`s. */
  predicate isAnyElement() { this = TAnyElementContent() }

  /** Holds if this content set represents all contents. */
  predicate isAny() { this = TAnyContent() }

  /**
   * Holds if this content set represents a specific known element index, or an
   * unknown element index.
   */
  predicate isKnownOrUnknownElement(Content::KnownElementContent c) {
    this = TKnownOrUnknownElementContent(c)
  }

  /**
   * Holds if this content set represents all `KnownElementContent`s where
   * the index is an integer greater than or equal to `lower`.
   */
  predicate isElementLowerBound(int lower) { this = TElementLowerBoundContent(lower, false) }

  /**
   * Holds if this content set represents `UnknownElementContent` unioned with
   * all `KnownElementContent`s where the index is an integer greater than or
   * equal to `lower`.
   */
  predicate isElementLowerBoundOrUnknown(int lower) {
    this = TElementLowerBoundContent(lower, true)
  }

  /**
   * Holds if this content set represents all `KnownElementContent`s where
   * the index is of type `type`, as per `ConstantValue::getValueType/0`.
   */
  predicate isElementOfType(string type) { this = TElementContentOfTypeContent(type, false) }

  /**
   * Holds if this content set represents `UnknownElementContent` unioned with
   * all `KnownElementContent`s where the index is of type `type`, as per
   * `ConstantValue::getValueType/0`.
   */
  predicate isElementOfTypeOrUnknown(string type) {
    this = TElementContentOfTypeContent(type, true)
  }

  /**
   * Holds if this content set represents an element in a collection (array or hash).
   */
  predicate isElement() {
    this.isSingleton(any(Content::ElementContent c))
    or
    this.isAnyElement()
    or
    this.isKnownOrUnknownElement(any(Content::KnownElementContent c))
    or
    this.isElementLowerBound(_)
    or
    this.isElementLowerBoundOrUnknown(_)
    or
    this.isElementOfType(_)
    or
    this.isElementOfTypeOrUnknown(_)
  }

  /** Gets a textual representation of this content set. */
  string toString() {
    exists(Content c |
      this.isSingleton(c) and
      result = c.toString()
    )
    or
    this.isAnyElement() and
    result = "any element"
    or
    this.isAny() and
    result = "any"
    or
    exists(Content::KnownElementContent c |
      this.isKnownOrUnknownElement(c) and
      result = c + " or unknown"
    )
    or
    exists(int lower, boolean includeUnknown |
      this = TElementLowerBoundContent(lower, includeUnknown)
    |
      includeUnknown = false and
      result = lower + "..!"
      or
      includeUnknown = true and
      result = lower + ".."
    )
    or
    exists(string type, boolean includeUnknown |
      this = TElementContentOfTypeContent(type, includeUnknown)
    |
      includeUnknown = false and
      result = "any(" + type + ")!"
      or
      includeUnknown = true and
      result = "any(" + type + ")"
    )
  }

  /** Gets a content that may be stored into when storing into this set. */
  Content getAStoreContent() {
    this.isSingleton(result)
    or
    // For reverse stores, `a[unknown][0] = x`, it is important that the read-step
    // from `a` to `a[unknown]` (which can read any element), gets translated into
    // a reverse store step that store only into `?`
    this.isAnyElement() and
    result = TUnknownElementContent()
    or
    // For reverse stores, `a[1][0] = x`, it is important that the read-step
    // from `a` to `a[1]` (which can read both elements stored at exactly index `1`
    // and elements stored at unknown index), gets translated into a reverse store
    // step that store only into `1`
    this.isKnownOrUnknownElement(result)
    or
    // These reverse stores are not as accurate as they could be, but making
    // them more accurate would result in a large fan-out
    (
      this.isElementLowerBound(_) or
      this.isElementLowerBoundOrUnknown(_) or
      this.isElementOfType(_) or
      this.isElementOfTypeOrUnknown(_)
    ) and
    result = TUnknownElementContent()
  }

  pragma[nomagic]
  private Content getAnElementReadContent() {
    exists(Content::KnownElementContent c | this.isKnownOrUnknownElement(c) |
      result = c or
      result = TUnknownElementContent()
    )
    or
    exists(int lower, boolean includeUnknown |
      this = TElementLowerBoundContent(lower, includeUnknown)
    |
      exists(int i | result.(Content::KnownElementContent).getIndex().isInt(i) | i >= lower)
      or
      includeUnknown = true and
      result = TUnknownElementContent()
    )
    or
    exists(string type, boolean includeUnknown |
      this = TElementContentOfTypeContent(type, includeUnknown)
    |
      type = result.(Content::KnownElementContent).getIndex().getValueType()
      or
      includeUnknown = true and
      result = TUnknownElementContent()
    )
  }

  /** Gets a content that may be read from when reading from this set. */
  Content getAReadContent() {
    this.isSingleton(result)
    or
    this.isAnyElement() and
    result instanceof Content::ElementContent
    or
    this.isAny() and
    exists(result)
    or
    exists(Content elementContent | elementContent = this.getAnElementReadContent() |
      result = elementContent
      or
      // Do not distinguish symbol keys from string keys. This allows us to
      // give more precise summaries for something like `with_indifferent_access`,
      // and the amount of false-positive flow arising from this should be very
      // limited.
      elementContent =
        any(Content::KnownElementContent known, ConstantValue cv |
          cv = known.getIndex() and
          result.(Content::KnownElementContent).getIndex() =
            any(ConstantValue cv2 |
              cv2.(ConstantValue::ConstantSymbolValue).getStringlikeValue() =
                cv.(ConstantValue::ConstantStringValue).getStringlikeValue()
              or
              cv2.(ConstantValue::ConstantStringValue).getStringlikeValue() =
                cv.(ConstantValue::ConstantSymbolValue).getStringlikeValue()
            )
        |
          known
        )
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

bindingset[def1, def2]
pragma[inline_late]
private predicate sameSourceVariable(Ssa::Definition def1, Ssa::Definition def2) {
  def1.getSourceVariable() = def2.getSourceVariable()
}

/**
 * Provides a set of barrier nodes for a guard that validates an expression.
 *
 * This is expected to be used in `isBarrier`/`isSanitizer` definitions
 * in data flow and taint tracking.
 */
module BarrierGuard<guardChecksSig/3 guardChecks> {
  private import codeql.ruby.controlflow.internal.Guards

  /**
   * Gets an implicit entry definition for a captured variable that
   * may be guarded, because a call to the capturing callable is guarded.
   *
   * This is restricted to calls where the variable is captured inside a
   * block.
   */
  pragma[nomagic]
  private Ssa::CapturedEntryDefinition getAMaybeGuardedCapturedDef() {
    exists(
      CfgNodes::ExprCfgNode g, boolean branch, CfgNodes::ExprCfgNode testedNode,
      Ssa::Definition def, CfgNodes::ExprNodes::CallCfgNode call
    |
      def.getARead() = testedNode and
      guardChecks(g, testedNode, branch) and
      guardControlsBlock(g, call.getBasicBlock(), branch) and
      result.getBasicBlock().getScope() = call.getExpr().(MethodCall).getBlock() and
      sameSourceVariable(def, result)
    )
  }

  /** Gets a node that is safely guarded by the given guard check. */
  Node getABarrierNode() {
    SsaFlow::asNode(result) =
      SsaImpl::DataFlowIntegration::BarrierGuard<guardChecks/3>::getABarrierNode()
    or
    result.asExpr() = getAMaybeGuardedCapturedDef().getARead()
  }
}

/**
 * A representation of a run-time module or class.
 *
 * This is equivalent to the type `Ast::Module` but provides data-flow specific methods.
 */
class ModuleNode instanceof Module {
  /** Gets a declaration of this module, if any. */
  final ModuleBase getADeclaration() { result = super.getADeclaration() }

  /** Gets the super class of this module, if any. */
  final ModuleNode getSuperClass() { result = super.getSuperClass() }

  /** Gets an immediate sub class of this module, if any. */
  final ModuleNode getASubClass() { result = super.getASubClass() }

  /** Gets a `prepend`ed module. */
  final ModuleNode getAPrependedModule() { result = super.getAPrependedModule() }

  /** Gets an `include`d module. */
  final ModuleNode getAnIncludedModule() { result = super.getAnIncludedModule() }

  /** Gets the super class or an included or prepended module. */
  final ModuleNode getAnImmediateAncestor() { result = super.getAnImmediateAncestor() }

  /** Gets a direct subclass or module including or prepending this one. */
  final ModuleNode getAnImmediateDescendent() { result = super.getAnImmediateDescendent() }

  /** Gets a module that is transitively subclassed, included, or prepended by this module. */
  pragma[inline]
  final ModuleNode getAnAncestor() { result = super.getAnAncestor() }

  /** Gets a module that transitively subclasses, includes, or prepends this module. */
  pragma[inline]
  final ModuleNode getADescendent() { result = super.getADescendent() }

  /**
   * Gets the expression node denoting the super class or an included or prepended module.
   *
   * For example, `C` is an ancestor expression of `M` in each of the following examples:
   * ```rb
   * class M < C
   * end
   *
   * module M
   *   include C
   *   prepend C
   * end
   * ```
   */
  final ExprNode getAnAncestorExpr() {
    result.asExpr().getExpr() = super.getADeclaration().getAnAncestorExpr()
  }

  /** Holds if this module is a class. */
  predicate isClass() { super.isClass() }

  /** Gets a textual representation of this module. */
  final string toString() { result = super.toString() }

  /**
   * Gets the qualified name of this module, if any.
   *
   * Only modules that can be resolved will have a qualified name.
   */
  final string getQualifiedName() { result = super.getQualifiedName() }

  /** Gets the location of this module. */
  final Location getLocation() { result = super.getLocation() }

  /**
   * Gets `self` in a declaration of this module.
   *
   * This only gets `self` at the module level, not inside any (singleton) method.
   */
  LocalSourceNode getModuleLevelSelf() {
    result.(SsaDefinitionExtNode).getVariable() = super.getADeclaration().getModuleSelfVariable()
  }

  /**
   * Gets `self` in the module declaration or in one of its singleton methods.
   *
   * Does not take inheritance into account.
   */
  LocalSourceNode getAnOwnModuleSelf() {
    result = this.getModuleLevelSelf()
    or
    result = this.getAnOwnSingletonMethod().getSelfParameter()
  }

  /**
   * Gets a call to method `name` on `self` in the module-level scope of this module.
   *
   * For example,
   * ```rb
   * module M
   *   include A  # getAModuleLevelCall("include")
   *   foo :bar   # getAModuleLevelCall("foo")
   * end
   * ```
   */
  CallNode getAModuleLevelCall(string name) {
    result = this.getModuleLevelSelf().getAMethodCall(name)
  }

  /** Gets a constant or `self` variable that refers to this module. */
  LocalSourceNode getAnImmediateReference() {
    result.asExpr().getExpr() = super.getAnImmediateReference()
    or
    // Include 'self' parameters; these are not expressions and so not found by the case above
    result = this.getAnOwnModuleSelf()
  }

  /**
   * Gets a singleton method declared in this module (or in a singleton class
   * augmenting this module).
   *
   * Does not take inheritance into account.
   */
  MethodNode getAnOwnSingletonMethod() {
    result.asCallableAstNode() = super.getAnOwnSingletonMethod()
  }

  /**
   * Gets the singleton method named `name` declared in this module (or in a singleton class
   * augmenting this module).
   *
   * Does not take inheritance into account.
   */
  MethodNode getOwnSingletonMethod(string name) {
    result = this.getAnOwnSingletonMethod() and
    result.getMethodName() = name
  }

  /**
   * Gets an instance method declared in this module.
   *
   * Does not take inheritance into account.
   */
  MethodNode getAnOwnInstanceMethod() {
    result.asCallableAstNode() = this.getADeclaration().getAMethod().(Method)
  }

  /**
   * Gets an instance method named `name` declared in this module.
   *
   * Does not take inheritance into account.
   */
  MethodNode getOwnInstanceMethod(string name) {
    result = this.getAnOwnInstanceMethod() and
    result.getMethodName() = name
  }

  /**
   * Gets the `self` parameter of an instance method declared in this module.
   *
   * Does not take inheritance into account.
   */
  ParameterNode getAnOwnInstanceSelf() {
    result = TSelfMethodParameterNode(this.getAnOwnInstanceMethod().asCallableAstNode())
  }

  /**
   * Gets the `self` parameter of an instance method available in this module,
   * including those inherited from ancestors.
   */
  ParameterNode getAnInstanceSelf() {
    // Make sure to include the 'self' in overridden instance methods
    result = this.getAnAncestor().getAnOwnInstanceSelf()
  }

  private InstanceVariableAccess getAnOwnInstanceVariableAccess(string name) {
    exists(InstanceVariable v |
      v.getDeclaringScope() = this.getADeclaration() and
      v.getName() = name and
      result.getVariable() = v
    )
  }

  /**
   * Gets an access to the instance variable `name` in this module.
   *
   * Does not take inheritance into account.
   */
  LocalSourceNode getAnOwnInstanceVariableRead(string name) {
    result.asExpr().getExpr() =
      this.getAnOwnInstanceVariableAccess(name).(InstanceVariableReadAccess)
  }

  /**
   * Gets the right-hand side of an assignment to the instance variable `name` in this module.
   *
   * Does not take inheritance into account.
   */
  Node getAnOwnInstanceVariableWriteValue(string name) {
    exists(AssignExpr assignment |
      assignment.getLeftOperand() = this.getAnOwnInstanceVariableAccess(name) and
      result.asExpr().getExpr() = assignment.getRightOperand()
    )
  }

  /**
   * Gets the instance method named `name` available in this module, including methods inherited
   * from ancestors.
   *
   * Overridden methods are not included.
   */
  MethodNode getInstanceMethod(string name) {
    result.asCallableAstNode() = super.getInstanceMethod(name)
  }

  /**
   * Gets an instance method available in this module, including methods inherited
   * from ancestors.
   *
   * Overridden methods are not included.
   */
  MethodNode getAnInstanceMethod() { result = this.getInstanceMethod(_) }

  /**
   * Gets the enclosing module, as it appears in the qualified name of this module.
   *
   * For example, the parent module of `A::B` is `A`, and `A` itself has no parent module.
   */
  ModuleNode getParentModule() { result = super.getParentModule() }

  /**
   * Gets a module named `name` declared inside this one (not aliased), provided
   * that such a module is defined or reopened in the current codebase.
   *
   * For example, for `A::B` the nested module named `C` would be `A::B::C`.
   *
   * Note that this is not the same as constant lookup. If `A::B::C` would resolve to a
   * module whose qualified name is not `A::B::C`, then it will not be found by
   * this predicate.
   */
  ModuleNode getNestedModule(string name) { result = super.getNestedModule(name) }

  /**
   * Starts tracking the module object using API graphs.
   *
   * Concretely, this tracks forward from the following starting points:
   * - A constant access that resolves to this module.
   * - `self` in the module scope or in a singleton method of the module.
   * - A call to `self.class` in an instance method of this module or an ancestor module.
   */
  bindingset[this]
  pragma[inline]
  API::Node trackModule() { result = API::Internal::getModuleNode(this) }

  /**
   * Starts tracking instances of this module forward using API graphs.
   *
   * Concretely, this tracks forward from the following starting points:
   * - `self` in instance methods of this module and ancestor modules
   * - Calls to `new` on the module object
   *
   * Note that this includes references to `self` in ancestor modules, but not in descendent modules.
   * This is usually the desired behavior, particularly if this module was itself found using
   * a call to `getADescendentModule()`.
   */
  bindingset[this]
  pragma[inline]
  API::Node trackInstance() { result = API::Internal::getModuleInstance(this) }

  /**
   * Holds if this is a built-in module, e.g. `Object`.
   */
  predicate isBuiltin() { super.isBuiltin() }
}

/**
 * A representation of a run-time class.
 */
class ClassNode extends ModuleNode {
  ClassNode() { this.isClass() }
}

/**
 * A data flow node corresponding to a literal expression.
 */
class LiteralNode extends ExprNode {
  private CfgNodes::ExprNodes::LiteralCfgNode literalCfgNode;

  LiteralNode() { this.asExpr() = literalCfgNode }

  /** Gets the underlying AST node as a `Literal`. */
  Literal asLiteralAstNode() { result = literalCfgNode.getExpr() }
}

/**
 * A data flow node corresponding to an operation expression.
 */
class OperationNode extends ExprNode {
  private CfgNodes::ExprNodes::OperationCfgNode operationCfgNode;

  OperationNode() { this.asExpr() = operationCfgNode }

  /** Gets the underlying AST node as an `Operation`. */
  Operation asOperationAstNode() { result = operationCfgNode.getExpr() }

  /** Gets the operator of this operation. */
  final string getOperator() { result = operationCfgNode.getOperator() }

  /** Gets an operand of this operation. */
  final Node getAnOperand() { result.asExpr() = operationCfgNode.getAnOperand() }
}

/**
 * A data flow node corresponding to a control expression (e.g. `if`, `while`, `for`).
 */
class ControlExprNode extends ExprNode {
  private CfgNodes::ExprNodes::ControlExprCfgNode controlExprCfgNode;

  ControlExprNode() { this.asExpr() = controlExprCfgNode }

  /** Gets the underlying AST node as a `ControlExpr`. */
  ControlExpr asControlExprAstNode() { result = controlExprCfgNode.getExpr() }
}

/**
 * A data flow node corresponding to a variable access expression.
 */
class VariableAccessNode extends ExprNode {
  private CfgNodes::ExprNodes::VariableAccessCfgNode variableAccessCfgNode;

  VariableAccessNode() { this.asExpr() = variableAccessCfgNode }

  /** Gets the underlying AST node as a `VariableAccess`. */
  VariableAccess asVariableAccessAstNode() { result = variableAccessCfgNode.getExpr() }
}

/**
 * A data flow node corresponding to a constant access expression.
 */
class ConstantAccessNode extends ExprNode {
  private CfgNodes::ExprNodes::ConstantAccessCfgNode constantAccessCfgNode;

  ConstantAccessNode() { this.asExpr() = constantAccessCfgNode }

  /** Gets the underlying AST node as a `ConstantAccess`. */
  ConstantAccess asConstantAccessAstNode() { result = constantAccessCfgNode.getExpr() }

  /** Gets the node corresponding to the scope expression. */
  final Node getScopeNode() { result.asExpr() = constantAccessCfgNode.getScopeExpr() }
}

/**
 * A data flow node corresponding to a LHS expression.
 */
class LhsExprNode extends ExprNode {
  private CfgNodes::ExprNodes::LhsExprCfgNode lhsExprCfgNode;

  LhsExprNode() { this.asExpr() = lhsExprCfgNode }

  /** Gets the underlying AST node as a `LhsExpr`. */
  LhsExpr asLhsExprAstNode() { result = lhsExprCfgNode.getExpr() }

  /** Gets the variable used in (or introduced by) this LHS. */
  Variable getVariable() { result = lhsExprCfgNode.getVariable() }
}

/**
 * A data flow node corresponding to a statement sequence expression.
 */
class StmtSequenceNode extends ExprNode {
  private CfgNodes::ExprNodes::StmtSequenceCfgNode stmtSequenceCfgNode;

  StmtSequenceNode() { this.asExpr() = stmtSequenceCfgNode }

  /** Gets the underlying AST node as a `StmtSequence`. */
  StmtSequence asStmtSequenceAstNode() { result = stmtSequenceCfgNode.getExpr() }

  /** Gets the last statement in this sequence, if any. */
  final ExprNode getLastStmt() { result.asExpr() = stmtSequenceCfgNode.getLastStmt() }
}

/**
 * A data flow node corresponding to a method, block, or lambda expression.
 */
class CallableNode extends StmtSequenceNode {
  private Callable callable;

  CallableNode() { this.asExpr().getExpr() = callable }

  /** Gets the underlying AST node as a `Callable`. */
  Callable asCallableAstNode() { result = callable }

  private ParameterPosition getParameterPosition(ParameterNodeImpl node) {
    result = getSourceParameterPosition(node, callable)
  }

  /** Gets the `n`th positional parameter. */
  ParameterNode getParameter(int n) { this.getParameterPosition(result).isPositional(n) }

  /** Gets the number of positional parameters of this callable. */
  final int getNumberOfParameters() { result = count(this.getParameter(_)) }

  /** Gets the keyword parameter of the given name. */
  ParameterNode getKeywordParameter(string name) {
    this.getParameterPosition(result).isKeyword(name)
  }

  /** Gets the `self` parameter of this callable, if any. */
  ParameterNode getSelfParameter() { this.getParameterPosition(result).isSelf() }

  /**
   * Gets the `hash-splat` parameter. This is a synthetic parameter holding
   * a hash object with entries for each keyword argument passed to the function.
   */
  ParameterNode getHashSplatParameter() { this.getParameterPosition(result).isHashSplat() }

  /**
   * Gets the block parameter of this method, if any.
   */
  ParameterNode getBlockParameter() { this.getParameterPosition(result).isBlock() }

  /**
   * Gets a `yield` in this method or `.call` on the block parameter.
   */
  CallNode getABlockCall() {
    hasYieldCall(this.getBlockParameter(), result)
    or
    result = this.getBlockParameter().getAMethodCall("call")
  }

  /**
   * Gets a data flow node whose value is about to be returned by this callable.
   */
  Node getAReturnNode() { result = getAReturnNode(callable) }
}

/**
 * A data flow node corresponding to a method (possibly a singleton method).
 */
class MethodNode extends CallableNode {
  MethodNode() { super.asCallableAstNode() instanceof MethodBase }

  /** Gets the underlying AST node for this method. */
  override MethodBase asCallableAstNode() { result = super.asCallableAstNode() }

  /** Gets the name of this method. */
  string getMethodName() { result = this.asCallableAstNode().getName() }

  /** Holds if this method is public. */
  predicate isPublic() { this.asCallableAstNode().isPublic() }

  /** Holds if this method is private. */
  predicate isPrivate() { this.asCallableAstNode().isPrivate() }

  /** Holds if this method is protected. */
  predicate isProtected() { this.asCallableAstNode().isProtected() }

  /** Gets a `super` call in this method. */
  CallNode getASuperCall() { methodHasSuperCall(this, result) }
}

/**
 * A data flow node corresponding to a block argument.
 */
class BlockNode extends CallableNode {
  BlockNode() { super.asCallableAstNode() instanceof Block }

  /** Gets the underlying AST node for this block. */
  override Block asCallableAstNode() { result = super.asCallableAstNode() }
}

/**
 * A representation of a pair such as `K => V` or `K: V`.
 *
 * Unlike most expressions, pairs do not evaluate to actual objects at runtime and their nodes
 * cannot generally be expected to have meaningful data flow edges.
 * This node simply provides convenient access to the key and value as data flow nodes.
 */
class PairNode extends ExprNode {
  PairNode() { this.getExprNode() instanceof CfgNodes::ExprNodes::PairCfgNode }

  /**
   * Holds if this pair is of form `key => value` or `key: value`.
   */
  predicate hasKeyAndValue(Node key, Node value) {
    exists(CfgNodes::ExprNodes::PairCfgNode n |
      this.getExprNode() = n and
      key = TExprNode(n.getKey()) and
      value = TExprNode(n.getValue())
    )
  }

  /** Gets the key expression of this pair, such as the `K` in `K => V` or `K: V`. */
  Node getKey() { this.hasKeyAndValue(result, _) }

  /** Gets the value expression of this pair, such as the `V` in `K => V` or `K: V`. */
  Node getValue() { this.hasKeyAndValue(_, result) }
}

/**
 * A data-flow node that corresponds to a hash literal. Hash literals are desugared
 * into calls to `Hash.[]`, so this includes both desugared calls as well as
 * explicit calls.
 */
class HashLiteralNode extends LocalSourceNode, ExprNode {
  HashLiteralNode() { super.getExprNode() instanceof CfgNodes::ExprNodes::HashLiteralCfgNode }

  /** Gets a pair in this hash literal. */
  PairNode getAKeyValuePair() {
    result.getExprNode() =
      super.getExprNode().(CfgNodes::ExprNodes::HashLiteralCfgNode).getAKeyValuePair()
  }

  /** Gets the value associated with the constant `key`, if known. */
  Node getElementFromKey(ConstantValue key) {
    exists(ExprNode keyNode |
      this.getAKeyValuePair().hasKeyAndValue(keyNode, result) and
      keyNode.getConstantValue() = key
    )
  }
}

/**
 * A data-flow node corresponding to an array literal. Array literals are desugared
 * into calls to `Array.[]`, so this includes both desugared calls as well as
 * explicit calls.
 */
class ArrayLiteralNode extends LocalSourceNode, CallNode {
  ArrayLiteralNode() { super.getExprNode() instanceof CfgNodes::ExprNodes::ArrayLiteralCfgNode }

  /**
   * Gets an element of the array.
   */
  Node getAnElement() { result = this.getElement(_) }

  /** Gets the `i`th element of the array. */
  Node getElement(int i) { result = this.getPositionalArgument(i) }
}

/**
 * An access to a constant, such as `C`, `C::D`, or a class or module declaration.
 *
 * See `DataFlow::getConstant` for usage example.
 */
class ConstRef extends LocalSourceNode {
  private ConstantAccess access;

  ConstRef() { this = getConstantAccessNode(access) }

  /** Gets the underlying constant access AST node. */
  ConstantAccess asConstantAccess() { result = access }

  /** Gets the underlying module declaration, if any. */
  Namespace asNamespaceDeclaration() { result = access }

  /** Gets the module defined or re-opened by this constant access, if any. */
  ModuleNode asModule() { result.getADeclaration() = access }

  /**
   * Gets the simple name of the constant being referenced, such as
   * the `B` in `A::B`.
   */
  string getName() { result = access.getName() }

  /**
   * Holds if this might refer to a top-level constant.
   */
  predicate isPossiblyGlobal() {
    exists(Module mod |
      not exists(mod.getParentModule()) and
      mod.getAnImmediateReference() = access
    )
    or
    not exists(Module mod | mod.getAnImmediateReference() = access) and
    not exists(access.getScopeExpr())
  }

  /**
   * Gets the known target module.
   *
   * We resolve these differently to prune out infeasible constant lookups.
   */
  private Module getExactTarget() { result.getAnImmediateReference() = access }

  /**
   * Gets the scope expression, or the immediately enclosing `Namespace` (skipping over singleton classes).
   *
   * Top-levels are not included, since this is only needed for nested constant lookup, and unqualified constants
   * at the top-level are handled by `DataFlow::getConstant`, never `ConstRef.getConstant`.
   */
  private TConstLookupScope getLookupScope() {
    result = MkQualifiedLookup(access.getScopeExpr())
    or
    not exists(this.getExactTarget()) and
    not exists(access.getScopeExpr()) and
    not access.hasGlobalScope() and
    (
      result = MkAncestorLookup(access.getEnclosingModule().getNamespaceOrToplevel().getModule())
      or
      result = MkNestedLookup(access.getEnclosingModule().getEnclosingModule*().getModule())
    )
  }

  /**
   * Holds if this can reference a constant named `name` from `scope`.
   */
  cached
  private predicate accesses(TConstLookupScope scope, string name) {
    forceCachingInSameStage() and
    scope = this.getLookupScope() and
    name = this.getName()
    or
    exists(Module mod |
      this.getExactTarget() = mod.getNestedModule(name) and
      scope = MkExactLookup(mod)
    )
  }

  /**
   * Gets a constant reference that may resolve to a member of this node.
   *
   * For example `DataFlow::getConstant("A").getConstant("B")` finds the following:
   * ```rb
   * A::B # simple reference
   *
   * module A
   *   B # in scope
   *   module X
   *     B # in nested scope
   *   end
   * end
   *
   * module X
   *   include A
   *   B # via inclusion
   * end
   *
   * class X < A
   *   B # via subclassing
   * end
   * ```
   */
  pragma[inline]
  ConstRef getConstant(string name) {
    exists(TConstLookupScope scope |
      pragma[only_bind_into](scope) = getATargetScope(pragma[only_bind_out](this)) and
      result.accesses(pragma[only_bind_out](scope), name)
    )
  }

  /**
   * Gets a module that transitively subclasses, includes, or prepends the module referred to by
   * this constant.
   *
   * For example, `DataFlow::getConstant("A").getADescendentModule()` finds `B`, `C`, and `E`:
   * ```rb
   * class B < A
   * end
   *
   * class C < B
   * end
   *
   * module E
   *   include C
   * end
   * ```
   */
  bindingset[this]
  pragma[inline_late]
  ModuleNode getADescendentModule() { MkAncestorLookup(result) = getATargetScope(this) }
}

/**
 * Gets a constant reference that may resolve to the top-level constant `name`.
 *
 * To get nested constants, call `getConstant()` one or more times on the result.
 *
 * For example `DataFlow::getConstant("A").getConstant("B")` finds the following:
 * ```rb
 * A::B # simple reference
 *
 * module A
 *   B # in scope
 *   module X
 *     B # in nested scope
 *   end
 * end
 *
 * module X
 *   include A
 *   B # via inclusion
 * end
 *
 * class X < A
 *   B # via subclassing
 * end
 * ```
 */
pragma[nomagic]
ConstRef getConstant(string name) {
  result.getName() = name and
  result.isPossiblyGlobal()
}
