private import codeql.ruby.AST
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
      result.asCallableAstNode() = c.asCallable()
    )
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
class ParameterNode extends LocalSourceNode, TParameterNode instanceof ParameterNodeImpl {
  /** Gets the parameter corresponding to this node, if any. */
  final Parameter getParameter() { result = super.getParameter() }

  /** Gets the name of the parameter, if any. */
  final string getName() { result = this.getParameter().(NamedParameter).getName() }
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

  /**
   * Gets a node to which data may flow from this node in zero or
   * more local data-flow steps.
   */
  pragma[inline]
  Node getALocalUse() { hasLocalSource(result, this) }

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
class PostUpdateNode extends Node instanceof PostUpdateNodeImpl {
  /** Gets the node before the state update. */
  Node getPreUpdateNode() { result = super.getPreUpdateNode() }
}

cached
private module Cached {
  cached
  predicate hasLocalSource(Node sink, Node source) {
    // Declaring `source` to be a `SourceNode` currently causes a redundant check in the
    // recursive case, so instead we check it explicitly here.
    source = sink and
    source instanceof LocalSourceNode
    or
    exists(Node mid | hasLocalSource(mid, source) |
      localFlowStepTypeTracker(mid, sink)
      or
      // Explicitly include the SSA param input step as type-tracking omits this step.
      LocalFlow::localFlowSsaParamInput(mid, sink)
      or
      LocalFlow::localFlowSsaParamCaptureInput(mid, sink)
    )
  }

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
    this.isElementLowerBound(_) and
    result = TUnknownElementContent()
  }

  /** Gets a content that may be read from when reading from this set. */
  Content getAReadContent() {
    this.isSingleton(result)
    or
    this.isAnyElement() and
    result instanceof Content::ElementContent
    or
    exists(Content::KnownElementContent c | this.isKnownOrUnknownElement(c) |
      result = c or
      result = TUnknownElementContent()
    )
    or
    exists(int lower, boolean includeUnknown |
      this = TElementLowerBoundContent(lower, includeUnknown)
    |
      exists(int i |
        result.(Content::KnownElementContent).getIndex().isInt(i) and
        i >= lower
      )
      or
      includeUnknown = true and
      result = TUnknownElementContent()
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
  pragma[nomagic]
  private predicate guardChecksSsaDef(CfgNodes::AstCfgNode g, boolean branch, Ssa::Definition def) {
    guardChecks(g, def.getARead(), branch)
  }

  pragma[nomagic]
  private predicate guardControlsSsaDef(
    CfgNodes::AstCfgNode g, boolean branch, Ssa::Definition def, Node n
  ) {
    def.getARead() = n.asExpr() and
    guardControlsBlock(g, n.asExpr().getBasicBlock(), branch)
  }

  /** Gets a node that is safely guarded by the given guard check. */
  Node getABarrierNode() {
    exists(CfgNodes::AstCfgNode g, boolean branch, Ssa::Definition def |
      guardChecksSsaDef(g, branch, def) and
      guardControlsSsaDef(g, branch, def, result)
    )
    or
    result.asExpr() = getAMaybeGuardedCapturedDef().getARead()
  }

  /**
   * Gets an implicit entry definition for a captured variable that
   * may be guarded, because a call to the capturing callable is guarded.
   *
   * This is restricted to calls where the variable is captured inside a
   * block.
   */
  private Ssa::Definition getAMaybeGuardedCapturedDef() {
    exists(
      CfgNodes::ExprCfgNode g, boolean branch, CfgNodes::ExprCfgNode testedNode,
      Ssa::Definition def, CfgNodes::ExprNodes::CallCfgNode call
    |
      def.getARead() = testedNode and
      guardChecks(g, testedNode, branch) and
      SsaImpl::captureFlowIn(call, def, result) and
      guardControlsBlock(g, call.getBasicBlock(), branch) and
      result.getBasicBlock().getScope() = call.getExpr().(MethodCall).getBlock()
    )
  }
}

/** Holds if the guard `guard` controls block `bb` upon evaluating to `branch`. */
private predicate guardControlsBlock(CfgNodes::AstCfgNode guard, BasicBlock bb, boolean branch) {
  exists(ConditionBlock conditionBlock, SuccessorTypes::ConditionalSuccessor s |
    guard = conditionBlock.getLastNode() and
    s.getValue() = branch and
    conditionBlock.controls(bb, s)
  )
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
abstract deprecated class BarrierGuard extends CfgNodes::ExprCfgNode {
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
    result = TSelfParameterNode(this.getAnOwnInstanceMethod().asCallableAstNode())
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
}

/**
 * A representation of a run-time class.
 */
class ClassNode extends ModuleNode {
  ClassNode() { this.isClass() }
}

/**
 * A data flow node corresponding to a method, block, or lambda expression.
 */
class CallableNode extends ExprNode {
  private Callable callable;

  CallableNode() { this.asExpr().getExpr() = callable }

  /** Gets the underlying AST node as a `Callable`. */
  Callable asCallableAstNode() { result = callable }

  private ParameterPosition getParameterPosition(ParameterNodeImpl node) {
    node.isSourceParameterOf(callable, result)
  }

  /** Gets the `n`th positional parameter. */
  ParameterNode getParameter(int n) { this.getParameterPosition(result).isPositional(n) }

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
   * Gets the canonical return node from this callable.
   *
   * Each callable has exactly one such node, and its location may not correspond
   * to any particular return site - consider using `getAReturningNode` to get nodes
   * whose locations correspond to return sites.
   */
  Node getReturn() { result.(SynthReturnNode).getCfgScope() = callable }

  /**
   * Gets a data flow node whose value is about to be returned by this callable.
   */
  Node getAReturningNode() { result = this.getReturn().(SynthReturnNode).getAnInput() }
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
class ArrayLiteralNode extends LocalSourceNode, ExprNode {
  ArrayLiteralNode() { super.getExprNode() instanceof CfgNodes::ExprNodes::ArrayLiteralCfgNode }

  /**
   * Gets an element of the array.
   */
  Node getAnElement() { result = this.(CallNode).getPositionalArgument(_) }
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
   * Gets a module for which this constant is the reference to an ancestor module.
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
  private ModuleNode getAncestryTarget() { result.getAnAncestorExpr() = this }

  /**
   * Gets the known target module.
   *
   * We resolve these differently to prune out infeasible constant lookups.
   */
  private Module getExactTarget() { result.getAnImmediateReference() = access }

  /**
   * Gets a scope in which a constant lookup may access the contents of the module referenced by this constant.
   */
  cached
  private TConstLookupScope getATargetScope() {
    forceCachingInSameStage() and
    result = MkAncestorLookup(this.getAncestryTarget().getAnImmediateDescendent*())
    or
    access = any(ConstantAccess ac).getScopeExpr() and
    result = MkQualifiedLookup(access)
    or
    result = MkNestedLookup(this.getAncestryTarget())
    or
    result = MkExactLookup(access.(Namespace).getModule())
  }

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
      pragma[only_bind_into](scope) = pragma[only_bind_out](this).getATargetScope() and
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
  ModuleNode getADescendentModule() { MkAncestorLookup(result) = this.getATargetScope() }
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
