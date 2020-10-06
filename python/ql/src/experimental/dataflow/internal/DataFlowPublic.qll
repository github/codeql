/**
 * Provides Python-specific definitions for use in the data flow library.
 */

private import python
private import DataFlowPrivate
import experimental.dataflow.TypeTracker
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
  TCfgNode(DataFlowCfgNode node) or
  /** A synthetic node representing the value of an object before a state change */
  TSyntheticPreUpdateNode(NeedsSyntheticPreUpdateNode post) or
  /** A synthetic node representing the value of an object after a state change */
  TSyntheticPostUpdateNode(NeedsSyntheticPostUpdateNode pre) or
  /** A node representing a global (module-level) variable in a specific module */
  TModuleVariableNode(Module m, GlobalVariable v) { v.getScope() = m and v.escapes() }

/**
 * An element, viewed as a node in a data flow graph. Either an SSA variable
 * (`EssaNode`) or a control flow node (`CfgNode`).
 */
class Node extends TNode {
  /** Gets a textual representation of this element. */
  string toString() { result = "Data flow node" }

  /** Gets the scope of this node. */
  Scope getScope() { none() }

  private DataFlowCallable getCallableScope(Scope s) {
    result.getScope() = s
    or
    not exists(DataFlowCallable c | c.getScope() = s) and
    result = getCallableScope(s.getEnclosingScope())
  }

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

  /** Convenience method for casting to EssaNode and calling getVar. */
  EssaVariable asVar() { none() }

  /** Convenience method for casting to CfgNode and calling getNode. */
  ControlFlowNode asCfgNode() { none() }

  /** Convenience method for casting to ExprNode and calling getNode and getNode again. */
  Expr asExpr() { none() }

  /**
   * Gets a node that this node may flow to using one heap and/or interprocedural step.
   *
   * See `TypeTracker` for more details about how to use this.
   */
  pragma[inline]
  Node track(TypeTracker t2, TypeTracker t) { t = t2.step(this, result) }
}

class EssaNode extends Node, TEssaNode {
  EssaVariable var;

  EssaNode() { this = TEssaNode(var) }

  EssaVariable getVar() { result = var }

  override EssaVariable asVar() { result = var }

  /** Gets a textual representation of this element. */
  override string toString() { result = var.toString() }

  override Scope getScope() { result = var.getScope() }

  override Location getLocation() { result = var.getDefinition().getLocation() }
}

class CfgNode extends Node, TCfgNode {
  DataFlowCfgNode node;

  CfgNode() { this = TCfgNode(node) }

  ControlFlowNode getNode() { result = node }

  override ControlFlowNode asCfgNode() { result = node }

  /** Gets a textual representation of this element. */
  override string toString() { result = node.toString() }

  override Scope getScope() { result = node.getScope() }

  override Location getLocation() { result = node.getLocation() }
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
class ParameterNode extends EssaNode {
  ParameterNode() { var instanceof ParameterDefinition }

  /**
   * Holds if this node is the parameter of callable `c` at the
   * (zero-based) index `i`.
   */
  predicate isParameterOf(DataFlowCallable c, int i) {
    var.(ParameterDefinition).getDefiningNode() = c.getParameter(i)
  }

  override DataFlowCallable getEnclosingCallable() { this.isParameterOf(result, _) }
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
 * A reference contained in an object. This is either a field or a property.
 */
newtype TContent =
  /** An element of a list. */
  TListElementContent() or
  /** An element of a set. */
  TSetElementContent() or
  /** An element of a tuple at a specifik index. */
  TTupleElementContent(int index) { exists(any(TupleNode tn).getElement(index)) } or
  /** An element of a dictionary under a specific key. */
  TDictionaryElementContent(string key) {
    key = any(KeyValuePair kvp).getKey().(StrConst).getS()
    or
    key = any(Keyword kw).getArg()
  } or
  /** An element of a dictionary at any key. */
  TDictionaryElementAnyContent() or
  /** An object attribute. */
  TAttributeContent(string attr) { attr = any(Attribute a).getName() }

class Content extends TContent {
  /** Gets a textual representation of this element. */
  string toString() { result = "Content" }
}

class ListElementContent extends TListElementContent, Content {
  override string toString() { result = "List element" }
}

class SetElementContent extends TSetElementContent, Content {
  override string toString() { result = "Set element" }
}

class TupleElementContent extends TTupleElementContent, Content {
  int index;

  TupleElementContent() { this = TTupleElementContent(index) }

  /** Gets the index for this tuple element. */
  int getIndex() { result = index }

  override string toString() { result = "Tuple element at index " + index.toString() }
}

class DictionaryElementContent extends TDictionaryElementContent, Content {
  string key;

  DictionaryElementContent() { this = TDictionaryElementContent(key) }

  /** Gets the key for this dictionary element. */
  string getKey() { result = key }

  override string toString() { result = "Dictionary element at key " + key }
}

class DictionaryElementAnyContent extends TDictionaryElementAnyContent, Content {
  override string toString() { result = "Any dictionary element" }
}

class AttributeContent extends TAttributeContent, Content {
  private string attr;

  AttributeContent() { this = TAttributeContent(attr) }

  /** Gets the name of the attribute under which this content is stored. */
  string getAttribute() { result = attr }

  override string toString() { result = "Attribute " + attr }
}
