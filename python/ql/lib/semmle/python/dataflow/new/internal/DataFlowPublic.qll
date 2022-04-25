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
  /** A synthetic node representing the value of an object before a state change */
  TSyntheticPreUpdateNode(NeedsSyntheticPreUpdateNode post) or
  /** A synthetic node representing the value of an object after a state change. */
  TSyntheticPostUpdateNode(NeedsSyntheticPostUpdateNode pre) or
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
   * A node representing the overflow positional arguments to a call.
   * That is, `call` contains more positional arguments than there are
   * positional parameters in `callable`. The extra ones are passed as
   * a tuple to a starred parameter; this synthetic node represents that tuple.
   */
  TPosOverflowNode(CallNode call, CallableValue callable) {
    exists(getPositionalOverflowArg(call, callable, _))
  } or
  /**
   * A node representing the overflow keyword arguments to a call.
   * That is, `call` contains keyword arguments for keys that do not have
   * keyword parameters in `callable`. These extra ones are passed as
   * a dictionary to a doubly starred parameter; this synthetic node
   * represents that dictionary.
   */
  TKwOverflowNode(CallNode call, CallableValue callable) {
    exists(getKeywordOverflowArg(call, callable, _))
    or
    ArgumentPassing::connects(call, callable) and
    exists(call.getNode().getKwargs()) and
    callable.getScope().hasKwArg()
  } or
  /**
   * A node representing an unpacked element of a dictionary argument.
   * That is, `call` contains argument `**{"foo": bar}` which is passed
   * to parameter `foo` of `callable`.
   */
  TKwUnpackedNode(CallNode call, CallableValue callable, string name) {
    call_unpacks(call, _, callable, name, _)
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
  TSyntheticOrmModelNode(Class cls)

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

  /** Gets the data-flow node corresponding to the i'th argument of the call corresponding to this data-flow node */
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
class ParameterNode extends CfgNode, LocalSourceNode {
  ParameterDefinition def;

  ParameterNode() {
    node = def.getDefiningNode() and
    // Disregard parameters that we cannot resolve
    // TODO: Make this unnecessary
    exists(DataFlowCallable c | node = c.getParameter(_))
  }

  /**
   * Holds if this node is the parameter of callable `c` at the
   * (zero-based) index `i`.
   */
  predicate isParameterOf(DataFlowCallable c, int i) { node = c.getParameter(i) }

  override DataFlowCallable getEnclosingCallable() { this.isParameterOf(result, _) }

  /** Gets the `Parameter` this `ParameterNode` represents. */
  Parameter getParameter() { result = def.getParameter() }
}

/** Gets a node corresponding to parameter `p`. */
ParameterNode parameterNode(Parameter p) { result.getParameter() = p }

/** A data flow node that represents a call argument. */
class ArgumentNode extends Node {
  ArgumentNode() { this = any(DataFlowCall c).getArg(_) }

  /** Holds if this argument occurs at the given position in the given call. */
  predicate argumentOf(DataFlowCall call, int pos) { this = call.getArg(pos) }

  /** Gets the call in which this node is an argument. */
  final DataFlowCall getCall() { this.argumentOf(result, _) }
}

/**
 * A node associated with an object after an operation that might have
 * changed its state.
 *
 * This can be either the argument to a callable after the callable returns
 * (which might have mutated the argument), or the qualifier of a field after
 * an update to the field.
 *
 * Nodes corresponding to AST elements, for example `ExprNode`s, usually refer
 * to the value before the update with the exception of `ObjectCreationNode`s,
 * which represents the value _after_ the constructor has run.
 */
abstract class PostUpdateNode extends Node {
  /** Gets the node before the state update. */
  abstract Node getPreUpdateNode();
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
    result.asVar().getDefinition().(EssaNodeDefinition).definedBy(var, any(DefinitionNode defn))
  }

  override DataFlowCallable getEnclosingCallable() { result.(DataFlowModuleScope).getScope() = mod }

  override Location getLocation() { result = mod.getLocation() }
}

private predicate isAccessedThroughImportStar(Module m) { m = ImportStar::getStarImported(_) }

private ModuleVariableNode import_star_read(Node n) {
  ImportStar::importStarResolvesTo(n.asCfgNode(), result.getModule()) and
  n.asCfgNode().(NameNode).getId() = result.getVariable().getId()
}

/**
 * The node holding the extra positional arguments to a call. This node is passed as a tuple
 * to the starred parameter of the callable.
 */
class PosOverflowNode extends Node, TPosOverflowNode {
  CallNode call;

  PosOverflowNode() { this = TPosOverflowNode(call, _) }

  override string toString() { result = "PosOverflowNode for " + call.getNode().toString() }

  override DataFlowCallable getEnclosingCallable() {
    exists(Node node |
      node = TCfgNode(call) and
      result = node.getEnclosingCallable()
    )
  }

  override Location getLocation() { result = call.getLocation() }
}

/**
 * The node holding the extra keyword arguments to a call. This node is passed as a dictionary
 * to the doubly starred parameter of the callable.
 */
class KwOverflowNode extends Node, TKwOverflowNode {
  CallNode call;

  KwOverflowNode() { this = TKwOverflowNode(call, _) }

  override string toString() { result = "KwOverflowNode for " + call.getNode().toString() }

  override DataFlowCallable getEnclosingCallable() {
    exists(Node node |
      node = TCfgNode(call) and
      result = node.getEnclosingCallable()
    )
  }

  override Location getLocation() { result = call.getLocation() }
}

/**
 * The node representing the synthetic argument of a call that is unpacked from a dictionary
 * argument.
 */
class KwUnpackedNode extends Node, TKwUnpackedNode {
  CallNode call;
  string name;

  KwUnpackedNode() { this = TKwUnpackedNode(call, _, name) }

  override string toString() { result = "KwUnpacked " + name }

  override DataFlowCallable getEnclosingCallable() {
    exists(Node node |
      node = TCfgNode(call) and
      result = node.getEnclosingCallable()
    )
  }

  override Location getLocation() { result = call.getLocation() }
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
 * A node that controls whether other nodes are evaluated.
 */
class GuardNode extends ControlFlowNode {
  ConditionBlock conditionBlock;

  GuardNode() { this = conditionBlock.getLastNode() }

  /** Holds if this guard controls block `b` upon evaluating to `branch`. */
  predicate controlsBlock(BasicBlock b, boolean branch) { conditionBlock.controls(b, branch) }
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
class BarrierGuard extends GuardNode {
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
