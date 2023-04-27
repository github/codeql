/**
 * Provides Python-specific definitions for use in the data flow library.
 */

private import python
private import DataFlowPrivate
import semmle.python.dataflow.new.TypeTracker
import Attributes
import LocalSources
private import semmle.python.essa.SsaCompute
private import semmle.python.dataflow.new.internal.ImportStar
private import FlowSummaryImpl as FlowSummaryImpl

/**
 * IPA type for data flow nodes.
 *
 * Flow between SSA variables are computed in `Essa.qll`
 *
 * Flow from SSA variables to control flow nodes are generally via uses.
 *
 * Flow from control flow nodes to SSA variables are generally via assignments.
 *
 * The current implementation of these cross flows can be seen in `EssaTaintTracking`.
 */
newtype TNode =
  /** A node corresponding to an SSA variable. */
  TEssaNode(EssaVariable var) or
  /** A node corresponding to a control flow node. */
  TCfgNode(ControlFlowNode node) {
    isExpressionNode(node)
    or
    node.getNode() instanceof Pattern
  } or
  /**
   * A synthetic node representing the value of an object before a state change.
   *
   * For class calls we pass a synthetic self argument, so attribute writes in
   * `__init__` is reflected on the resulting object (we need special logic for this
   * since there is no `return` in `__init__`)
   */
  // NOTE: since we can't rely on the call graph, but we want to have synthetic
  // pre-update nodes for class calls, we end up getting synthetic pre-update nodes for
  // ALL calls :|
  TSyntheticPreUpdateNode(CallNode call) or
  /**
   * A synthetic node representing the value of an object after a state change.
   * See QLDoc for `PostUpdateNode`.
   */
  TSyntheticPostUpdateNode(ControlFlowNode node) {
    exists(CallNode call |
      node = call.getArg(_)
      or
      node = call.getArgByName(_)
      or
      // `self` argument when handling class instance calls (`__call__` special method))
      node = call.getFunction()
    )
    or
    node = any(AttrNode a).getObject()
    or
    node = any(SubscriptNode s).getObject()
    or
    // self parameter when used implicitly in `super()`
    exists(Class cls, Function func, ParameterDefinition def |
      func = cls.getAMethod() and
      not isStaticmethod(func) and
      // this matches what we do in ExtractedParameterNode
      def.getDefiningNode() = node and
      def.getParameter() = func.getArg(0)
    )
  } or
  /** A node representing a global (module-level) variable in a specific module. */
  TModuleVariableNode(Module m, GlobalVariable v) {
    v.getScope() = m and
    (
      v.escapes()
      or
      isAccessedThroughImportStar(m) and
      ImportStar::globalNameDefinedInModule(v.getId(), m)
    )
  } or
  /**
   * A synthetic node representing that an iterable sequence flows to consumer.
   */
  TIterableSequenceNode(UnpackingAssignmentSequenceTarget consumer) or
  /**
   * A synthetic node representing that there may be an iterable element
   * for `consumer` to consume.
   */
  TIterableElementNode(UnpackingAssignmentTarget consumer) or
  /**
   * A synthetic node representing element content in a star pattern.
   */
  TStarPatternElementNode(MatchStarPattern target) or
  /**
   * INTERNAL: Do not use.
   *
   * A synthetic node representing the data for an ORM model saved in a DB.
   */
  // TODO: Limiting the classes here to the ones that are actually ORM models was
  // non-trivial, since that logic is based on API::Node results, and trying to do this
  // causes non-monotonic recursion, and makes the API graph evaluation recursive with
  // data-flow, which might do bad things for performance.
  //
  // So for now we live with having these synthetic ORM nodes for _all_ classes, which
  // is a bit wasteful, but we don't think it will hurt too much.
  TSyntheticOrmModelNode(Class cls) or
  TSummaryNode(
    FlowSummaryImpl::Public::SummarizedCallable c, FlowSummaryImpl::Private::SummaryNodeState state
  ) {
    FlowSummaryImpl::Private::summaryNodeRange(c, state)
  } or
  TSummaryParameterNode(FlowSummaryImpl::Public::SummarizedCallable c, ParameterPosition pos) {
    FlowSummaryImpl::Private::summaryParameterNodeRange(c, pos)
  } or
  /** A synthetic node to capture positional arguments that are passed to a `*args` parameter. */
  TSynthStarArgsElementParameterNode(DataFlowCallable callable) {
    exists(ParameterPosition ppos | ppos.isStarArgs(_) | exists(callable.getParameter(ppos)))
  } or
  /** A synthetic node to capture keyword arguments that are passed to a `**kwargs` parameter. */
  TSynthDictSplatArgumentNode(CallNode call) { exists(call.getArgByName(_)) } or
  /** A synthetic node to allow flow to keyword parameters from a `**kwargs` argument. */
  TSynthDictSplatParameterNode(DataFlowCallable callable) {
    exists(ParameterPosition ppos | ppos.isKeyword(_) | exists(callable.getParameter(ppos)))
  }

/** Helper for `Node::getEnclosingCallable`. */
private DataFlowCallable getCallableScope(Scope s) {
  result.getScope() = s
  or
  not exists(DataFlowCallable c | c.getScope() = s) and
  result = getCallableScope(s.getEnclosingScope())
}

private import semmle.python.internal.CachedStages

/**
 * An element, viewed as a node in a data flow graph. Either an SSA variable
 * (`EssaNode`) or a control flow node (`CfgNode`).
 */
class Node extends TNode {
  /** Gets a textual representation of this element. */
  cached
  string toString() {
    Stages::DataFlow::ref() and
    result = "Data flow node"
  }

  /** Gets the scope of this node. */
  Scope getScope() { none() }

  /** Gets the enclosing callable of this node. */
  DataFlowCallable getEnclosingCallable() { result = getCallableScope(this.getScope()) }

  /** Gets the location of this node */
  Location getLocation() { none() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  cached
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    Stages::DataFlow::ref() and
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Gets the ESSA variable corresponding to this node, if any. */
  EssaVariable asVar() { none() }

  /** Gets the control-flow node corresponding to this node, if any. */
  ControlFlowNode asCfgNode() { none() }

  /** Gets the expression corresponding to this node, if any. */
  Expr asExpr() { none() }

  /**
   * Gets a local source node from which data may flow to this node in zero or more local data-flow steps.
   */
  LocalSourceNode getALocalSource() { result.flowsTo(this) }
}

/** A data-flow node corresponding to an SSA variable. */
class EssaNode extends Node, TEssaNode {
  EssaVariable var;

  EssaNode() { this = TEssaNode(var) }

  /** Gets the `EssaVariable` represented by this data-flow node. */
  EssaVariable getVar() { result = var }

  override EssaVariable asVar() { result = var }

  /** Gets a textual representation of this element. */
  override string toString() { result = var.toString() }

  override Scope getScope() { result = var.getScope() }

  override Location getLocation() { result = var.getLocation() }
}

/** A data-flow node corresponding to a control-flow node. */
class CfgNode extends Node, TCfgNode {
  ControlFlowNode node;

  CfgNode() { this = TCfgNode(node) }

  /** Gets the `ControlFlowNode` represented by this data-flow node. */
  ControlFlowNode getNode() { result = node }

  override ControlFlowNode asCfgNode() { result = node }

  /** Gets a textual representation of this element. */
  override string toString() { result = node.toString() }

  override Scope getScope() { result = node.getScope() }

  override Location getLocation() { result = node.getLocation() }
}

/** A data-flow node corresponding to a `CallNode` in the control-flow graph. */
class CallCfgNode extends CfgNode, LocalSourceNode {
  override CallNode node;

  /**
   * Gets the data-flow node for the function component of the call corresponding to this data-flow
   * node.
   */
  Node getFunction() { result.asCfgNode() = node.getFunction() }

  /** Gets the data-flow node corresponding to the i'th positional argument of the call corresponding to this data-flow node */
  Node getArg(int i) { result.asCfgNode() = node.getArg(i) }

  /** Gets the data-flow node corresponding to the named argument of the call corresponding to this data-flow node */
  Node getArgByName(string name) { result.asCfgNode() = node.getArgByName(name) }
}

/**
 * A data-flow node corresponding to a method call, that is `foo.bar(...)`.
 *
 * Also covers the case where the method lookup is done separately from the call itself, as in
 * `temp = foo.bar; temp(...)`. Note that this is only tracked through local scope.
 */
class MethodCallNode extends CallCfgNode {
  AttrRead method_lookup;

  MethodCallNode() { method_lookup = this.getFunction().getALocalSource() }

  /**
   * Gets the name of the method being invoked (the `bar` in `foo.bar(...)`) if it can be determined.
   *
   * Note that this method may have multiple results if a single call node represents calls to
   * multiple different objects and methods. If you want to link up objects and method names
   * accurately, use the `calls` method instead.
   */
  string getMethodName() { result = method_lookup.getAttributeName() }

  /**
   * Gets the data-flow node corresponding to the object receiving this call. That is, the `foo` in
   * `foo.bar(...)`.
   *
   * Note that this method may have multiple results if a single call node represents calls to
   * multiple different objects and methods. If you want to link up objects and method names
   * accurately, use the `calls` method instead.
   */
  Node getObject() { result = method_lookup.getObject() }

  /** Holds if this data-flow node calls method `methodName` on the object node `object`. */
  predicate calls(Node object, string methodName) {
    // As `getObject` and `getMethodName` may both have multiple results, we must look up the object
    // and method name directly on `method_lookup`.
    object = method_lookup.getObject() and
    methodName = method_lookup.getAttributeName()
  }
}

/**
 * An expression, viewed as a node in a data flow graph.
 *
 * Note that because of control-flow splitting, one `Expr` may correspond
 * to multiple `ExprNode`s, just like it may correspond to multiple
 * `ControlFlow::Node`s.
 */
class ExprNode extends CfgNode {
  ExprNode() { isExpressionNode(node) }

  override Expr asExpr() { result = node.getNode() }
}

/** Gets a node corresponding to expression `e`. */
ExprNode exprNode(DataFlowExpr e) { result.getNode().getNode() = e }

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph.
 */
class ParameterNode extends Node instanceof ParameterNodeImpl {
  /** Gets the parameter corresponding to this node, if any. */
  final Parameter getParameter() { result = super.getParameter() }
}

/** A parameter node found in the source code (not in a summary). */
class ExtractedParameterNode extends ParameterNodeImpl, CfgNode {
  //, LocalSourceNode {
  ParameterDefinition def;

  ExtractedParameterNode() { node = def.getDefiningNode() }

  override Parameter getParameter() { result = def.getParameter() }
}

class LocalSourceParameterNode extends ExtractedParameterNode, LocalSourceNode { }

/** Gets a node corresponding to parameter `p`. */
ExtractedParameterNode parameterNode(Parameter p) { result.getParameter() = p }

/** A data flow node that represents a call argument. */
abstract class ArgumentNode extends Node {
  /** Holds if this argument occurs at the given position in the given call. */
  abstract predicate argumentOf(DataFlowCall call, ArgumentPosition pos);

  /** Gets the call in which this node is an argument, if any. */
  final ExtractedDataFlowCall getCall() { this.argumentOf(result, _) }
}

/**
 * A data flow node that represents a call argument found in the source code.
 */
class ExtractedArgumentNode extends ArgumentNode {
  ExtractedArgumentNode() {
    // for resolved calls, we need to allow all argument nodes
    getCallArg(_, _, _, this, _)
    or
    // for potential summaries we allow all normal call arguments
    normalCallArg(_, this, _)
    or
    // and self arguments
    this.asCfgNode() = any(CallNode c).getFunction().(AttrNode).getObject()
  }

  final override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
    this = call.getArgument(pos) and
    call instanceof ExtractedDataFlowCall
  }
}

/**
 * A node associated with an object after an operation that might have
 * changed its state.
 *
 * This can be either the argument to a callable after the callable returns
 * (which might have mutated the argument), the qualifier of a field after
 * an update to the field, or a container such as a list/dictionary after an element
 * update.
 *
 * Nodes corresponding to AST elements, for example `ExprNode`s, usually refer
 * to the value before the update with the exception of class calls,
 * which represents the value _after_ the constructor has run.
 */
class PostUpdateNode extends Node instanceof PostUpdateNodeImpl {
  /** Gets the node before the state update. */
  Node getPreUpdateNode() { result = super.getPreUpdateNode() }
}

/**
 * A data flow node corresponding to a module-level (global) variable that is accessed outside of the module scope.
 *
 * Global variables may appear twice in the data flow graph, as both `EssaNode`s and
 * `ModuleVariableNode`s. The former is used to represent data flow between global variables as it
 * occurs during module initialization, and the latter is used to represent data flow via global
 * variable reads and writes during run-time.
 *
 * It is possible for data to flow from assignments made at module initialization time to reads made
 * at run-time, but not vice versa. For example, there will be flow from `SOURCE` to `SINK` in the
 * following snippet:
 *
 * ```python
 * g = SOURCE
 *
 * def foo():
 *     SINK(g)
 * ```
 * but not the other way round:
 *
 * ```python
 * SINK(g)
 *
 * def bar()
 *     global g
 *     g = SOURCE
 * ```
 *
 * Data flow through `ModuleVariableNode`s is represented as `jumpStep`s, and so any write of a
 * global variable can flow to any read of the same variable.
 */
class ModuleVariableNode extends Node, TModuleVariableNode {
  Module mod;
  GlobalVariable var;

  ModuleVariableNode() { this = TModuleVariableNode(mod, var) }

  override Scope getScope() { result = mod }

  override string toString() {
    result = "ModuleVariableNode for " + mod.getName() + "." + var.getId()
  }

  /** Gets the module in which this variable appears. */
  Module getModule() { result = mod }

  /** Gets the global variable corresponding to this node. */
  GlobalVariable getVariable() { result = var }

  /** Gets a node that reads this variable. */
  Node getARead() {
    result.asCfgNode() = var.getALoad().getAFlowNode() and
    // Ignore reads that happen when the module is imported. These are only executed once.
    not result.getScope() = mod
    or
    this = import_star_read(result)
  }

  /** Gets an `EssaNode` that corresponds to an assignment of this global variable. */
  EssaNode getAWrite() {
    result.getVar().getDefinition().(EssaNodeDefinition).definedBy(var, any(DefinitionNode defn))
  }

  /** Gets the possible values of the variable at the end of import time */
  CfgNode getADefiningWrite() {
    exists(SsaVariable def |
      def = any(SsaVariable ssa_var).getAnUltimateDefinition() and
      def.getDefinition() = result.asCfgNode() and
      def.getVariable() = var
    )
  }

  override DataFlowCallable getEnclosingCallable() { result.(DataFlowModuleScope).getScope() = mod }

  override Location getLocation() { result = mod.getLocation() }
}

private predicate isAccessedThroughImportStar(Module m) { m = ImportStar::getStarImported(_) }

private ModuleVariableNode import_star_read(Node n) {
  resolved_import_star_module(result.getModule(), result.getVariable().getId(), n)
}

pragma[nomagic]
private predicate resolved_import_star_module(Module m, string name, Node n) {
  exists(NameNode nn | nn = n.asCfgNode() |
    ImportStar::importStarResolvesTo(pragma[only_bind_into](nn), m) and
    nn.getId() = name
  )
}

/**
 * A synthetic node representing an iterable sequence. Used for changing content type
 * for instance from a `ListElement` to a `TupleElement`, especially if the content is
 * transferred via a read step which cannot be broken up into a read and a store. The
 * read step then targets TIterableSequence, and the conversion can happen via a read
 * step to TIterableElement followed by a store step to the target.
 */
class IterableSequenceNode extends Node, TIterableSequenceNode {
  CfgNode consumer;

  IterableSequenceNode() { this = TIterableSequenceNode(consumer.getNode()) }

  override string toString() { result = "IterableSequence" }

  override DataFlowCallable getEnclosingCallable() { result = consumer.getEnclosingCallable() }

  override Location getLocation() { result = consumer.getLocation() }
}

/**
 * A synthetic node representing an iterable element. Used for changing content type
 * for instance from a `ListElement` to a `TupleElement`. This would happen via a
 * read step from the list to IterableElement followed by a store step to the tuple.
 */
class IterableElementNode extends Node, TIterableElementNode {
  CfgNode consumer;

  IterableElementNode() { this = TIterableElementNode(consumer.getNode()) }

  override string toString() { result = "IterableElement" }

  override DataFlowCallable getEnclosingCallable() { result = consumer.getEnclosingCallable() }

  override Location getLocation() { result = consumer.getLocation() }
}

/**
 * A synthetic node representing element content of a star pattern.
 */
class StarPatternElementNode extends Node, TStarPatternElementNode {
  CfgNode consumer;

  StarPatternElementNode() { this = TStarPatternElementNode(consumer.getNode().getNode()) }

  override string toString() { result = "StarPatternElement" }

  override DataFlowCallable getEnclosingCallable() { result = consumer.getEnclosingCallable() }

  override Location getLocation() { result = consumer.getLocation() }
}

/**
 * Gets a node that controls whether other nodes are evaluated.
 *
 * In the base case, this is the last node of `conditionBlock`, and `flipped` is `false`.
 * This definition accounts for (short circuting) `and`- and `or`-expressions, as the structure
 * of basic blocks will reflect their semantics.
 *
 * However, in the program
 * ```python
 * if not is_safe(path):
 *   return
 * ```
 * the last node in the `ConditionBlock` is `not is_safe(path)`.
 *
 * We would like to consider also `is_safe(path)` a guard node, albeit with `flipped` being `true`.
 * Thus we recurse through `not`-expressions.
 */
ControlFlowNode guardNode(ConditionBlock conditionBlock, boolean flipped) {
  // Base case: the last node truly does determine which successor is chosen
  result = conditionBlock.getLastNode() and
  flipped = false
  or
  // Recursive case: if a guard node is a `not`-expression,
  // the operand is also a guard node, but with inverted polarity.
  exists(UnaryExprNode notNode |
    result = notNode.getOperand() and
    notNode.getNode().getOp() instanceof Not
  |
    notNode = guardNode(conditionBlock, flipped.booleanNot())
  )
}

/**
 * A node that controls whether other nodes are evaluated.
 *
 * The field `flipped` allows us to match `GuardNode`s underneath
 * `not`-expressions and still choose the appropriate branch.
 */
class GuardNode extends ControlFlowNode {
  ConditionBlock conditionBlock;
  boolean flipped;

  GuardNode() { this = guardNode(conditionBlock, flipped) }

  /** Holds if this guard controls block `b` upon evaluating to `branch`. */
  predicate controlsBlock(BasicBlock b, boolean branch) {
    branch in [true, false] and
    conditionBlock.controls(b, branch.booleanXor(flipped))
  }
}

/**
 * Holds if the guard `g` validates `node` upon evaluating to `branch`.
 *
 * The expression `e` is expected to be a syntactic part of the guard `g`.
 * For example, the guard `g` might be a call `isSafe(x)` and the expression `e`
 * the argument `x`.
 */
signature predicate guardChecksSig(GuardNode g, ControlFlowNode node, boolean branch);

/**
 * Provides a set of barrier nodes for a guard that validates a node.
 *
 * This is expected to be used in `isBarrier`/`isSanitizer` definitions
 * in data flow and taint tracking.
 */
module BarrierGuard<guardChecksSig/3 guardChecks> {
  /** Gets a node that is safely guarded by the given guard check. */
  ExprNode getABarrierNode() {
    exists(GuardNode g, EssaDefinition def, ControlFlowNode node, boolean branch |
      AdjacentUses::useOfDef(def, node) and
      guardChecks(g, node, branch) and
      AdjacentUses::useOfDef(def, result.asCfgNode()) and
      g.controlsBlock(result.asCfgNode().getBasicBlock(), branch)
    )
  }
}

/**
 * DEPRECATED: Use `BarrierGuard` module instead.
 *
 * A guard that validates some expression.
 *
 * To use this in a configuration, extend the class and provide a
 * characteristic predicate precisely specifying the guard, and override
 * `checks` to specify what is being validated and in which branch.
 *
 * It is important that all extending classes in scope are disjoint.
 */
deprecated class BarrierGuard extends GuardNode {
  /** Holds if this guard validates `node` upon evaluating to `branch`. */
  abstract predicate checks(ControlFlowNode node, boolean branch);

  /** Gets a node guarded by this guard. */
  final ExprNode getAGuardedNode() {
    exists(EssaDefinition def, ControlFlowNode node, boolean branch |
      AdjacentUses::useOfDef(def, node) and
      this.checks(node, branch) and
      AdjacentUses::useOfDef(def, result.asCfgNode()) and
      this.controlsBlock(result.asCfgNode().getBasicBlock(), branch)
    )
  }
}

/**
 * Algebraic datatype for tracking data content associated with values.
 * Content can be collection elements or object attributes.
 */
newtype TContent =
  /** An element of a list. */
  TListElementContent() or
  /** An element of a set. */
  TSetElementContent() or
  /** An element of a tuple at a specific index. */
  TTupleElementContent(int index) {
    exists(any(TupleNode tn).getElement(index))
    or
    // Arguments can overflow and end up in the starred parameter tuple.
    exists(any(CallNode cn).getArg(index))
  } or
  /** An element of a dictionary under a specific key. */
  TDictionaryElementContent(string key) {
    key = any(KeyValuePair kvp).getKey().(StrConst).getS()
    or
    key = any(Keyword kw).getArg()
  } or
  /** An element of a dictionary under any key. */
  TDictionaryElementAnyContent() or
  /** An object attribute. */
  TAttributeContent(string attr) { attr = any(Attribute a).getName() }

/**
 * A data-flow value can have associated content.
 * If the value is a collection, it can have elements,
 * if it is an object, it can have attribute values.
 */
class Content extends TContent {
  /** Gets a textual representation of this element. */
  string toString() { result = "Content" }
}

/** An element of a list. */
class ListElementContent extends TListElementContent, Content {
  override string toString() { result = "List element" }
}

/** An element of a set. */
class SetElementContent extends TSetElementContent, Content {
  override string toString() { result = "Set element" }
}

/** An element of a tuple at a specific index. */
class TupleElementContent extends TTupleElementContent, Content {
  int index;

  TupleElementContent() { this = TTupleElementContent(index) }

  /** Gets the index for this tuple element. */
  int getIndex() { result = index }

  override string toString() { result = "Tuple element at index " + index.toString() }
}

/** An element of a dictionary under a specific key. */
class DictionaryElementContent extends TDictionaryElementContent, Content {
  string key;

  DictionaryElementContent() { this = TDictionaryElementContent(key) }

  /** Gets the key for this dictionary element. */
  string getKey() { result = key }

  override string toString() { result = "Dictionary element at key " + key }
}

/** An element of a dictionary under any key. */
class DictionaryElementAnyContent extends TDictionaryElementAnyContent, Content {
  override string toString() { result = "Any dictionary element" }
}

/** An object attribute. */
class AttributeContent extends TAttributeContent, Content {
  private string attr;

  AttributeContent() { this = TAttributeContent(attr) }

  /** Gets the name of the attribute under which this content is stored. */
  string getAttribute() { result = attr }

  override string toString() { result = "Attribute " + attr }
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
}
