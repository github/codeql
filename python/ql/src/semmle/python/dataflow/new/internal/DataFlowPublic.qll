/**
 * Provides Python-specific definitions for use in the data flow library.
 */

private import python
private import DataFlowPrivate
import semmle.python.dataflow.new.TypeTracker
import Attributes
private import semmle.python.essa.SsaCompute

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
  TCfgNode(ControlFlowNode node) { isExpressionNode(node) } or
  /** A synthetic node representing the value of an object before a state change */
  TSyntheticPreUpdateNode(NeedsSyntheticPreUpdateNode post) or
  /** A synthetic node representing the value of an object after a state change. */
  TSyntheticPostUpdateNode(NeedsSyntheticPostUpdateNode pre) or
  /** A node representing a global (module-level) variable in a specific module. */
  TModuleVariableNode(Module m, GlobalVariable v) { v.getScope() = m and v.escapes() } or
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
  TIterableElementNode(UnpackingAssignmentTarget consumer)

/** Helper for `Node::getEnclosingCallable`. */
private DataFlowCallable getCallableScope(Scope s) {
  result.getScope() = s
  or
  not exists(DataFlowCallable c | c.getScope() = s) and
  result = getCallableScope(s.getEnclosingScope())
}

/**
 * An element, viewed as a node in a data flow graph. Either an SSA variable
 * (`EssaNode`) or a control flow node (`CfgNode`).
 */
class Node extends TNode {
  /** Gets a textual representation of this element. */
  string toString() { result = "Data flow node" }

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
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Gets the ESSA variable corresponding to this node, if any. */
  EssaVariable asVar() { none() }

  /** Gets the control-flow node corresponding to this node, if any. */
  ControlFlowNode asCfgNode() { none() }

  /** Gets the expression corresponding to this node, if any. */
  Expr asExpr() { none() }

  /**
   * Gets a node that this node may flow to using one heap and/or interprocedural step.
   *
   * See `TypeTracker` for more details about how to use this.
   */
  pragma[inline]
  Node track(TypeTracker t2, TypeTracker t) { t = t2.step(this, result) }

  /**
   * Gets a node that may flow into this one using one heap and/or interprocedural step.
   *
   * See `TypeBackTracker` for more details about how to use this.
   */
  pragma[inline]
  LocalSourceNode backtrack(TypeBackTracker t2, TypeBackTracker t) { t2 = t.step(result, this) }

  /**
   * Gets a local source node from which data may flow to this node in zero or more local steps.
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
class CallCfgNode extends CfgNode {
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
class ParameterNode extends CfgNode {
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
    result = "ModuleVariableNode for " + var.toString() + " in " + mod.toString()
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
  }

  /** Gets an `EssaNode` that corresponds to an assignment of this global variable. */
  EssaNode getAWrite() {
    result.asVar().getDefinition().(EssaNodeDefinition).definedBy(var, any(DefinitionNode defn))
  }

  override DataFlowCallable getEnclosingCallable() { result.(DataFlowModuleScope).getScope() = mod }

  override Location getLocation() { result = mod.getLocation() }
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
 * A data flow node that is a source of local flow. This includes things like
 * - Expressions
 * - Function parameters
 */
class LocalSourceNode extends Node {
  LocalSourceNode() {
    not simpleLocalFlowStep+(any(CfgNode n), this) and
    not this instanceof ModuleVariableNode
    or
    this = any(ModuleVariableNode mvn).getARead()
  }

  /** Holds if this `LocalSourceNode` can flow to `nodeTo` in one or more local flow steps. */
  pragma[inline]
  predicate flowsTo(Node nodeTo) { Cached::hasLocalSource(nodeTo, this) }

  /**
   * Gets a reference (read or write) of attribute `attrName` on this node.
   */
  AttrRef getAnAttributeReference(string attrName) { Cached::namedAttrRef(this, attrName, result) }

  /**
   * Gets a read of attribute `attrName` on this node.
   */
  AttrRead getAnAttributeRead(string attrName) { result = getAnAttributeReference(attrName) }

  /**
   * Gets a reference (read or write) of any attribute on this node.
   */
  AttrRef getAnAttributeReference() {
    Cached::namedAttrRef(this, _, result)
    or
    Cached::dynamicAttrRef(this, result)
  }

  /**
   * Gets a read of any attribute on this node.
   */
  AttrRead getAnAttributeRead() { result = getAnAttributeReference() }

  /**
   * Gets a call to this node.
   */
  CallCfgNode getACall() { Cached::call(this, result) }
}

cached
private module Cached {
  /**
   * Holds if `source` is a `LocalSourceNode` that can reach `sink` via local flow steps.
   *
   * The slightly backwards parametering ordering is to force correct indexing.
   */
  cached
  predicate hasLocalSource(Node sink, Node source) {
    // Declaring `source` to be a `SourceNode` currently causes a redundant check in the
    // recursive case, so instead we check it explicitly here.
    source = sink and
    source instanceof LocalSourceNode
    or
    exists(Node mid |
      hasLocalSource(mid, source) and
      simpleLocalFlowStep(mid, sink)
    )
  }

  /**
   * Holds if `base` flows to the base of `ref` and `ref` has attribute name `attr`.
   */
  cached
  predicate namedAttrRef(LocalSourceNode base, string attr, AttrRef ref) {
    base.flowsTo(ref.getObject()) and
    ref.getAttributeName() = attr
  }

  /**
   * Holds if `base` flows to the base of `ref` and `ref` has no known attribute name.
   */
  cached
  predicate dynamicAttrRef(LocalSourceNode base, AttrRef ref) {
    base.flowsTo(ref.getObject()) and
    not exists(ref.getAttributeName())
  }

  /**
   * Holds if `func` flows to the callee of `call`.
   */
  cached
  predicate call(LocalSourceNode func, CallCfgNode call) {
    exists(CfgNode n |
      func.flowsTo(n) and
      n = call.getFunction()
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
