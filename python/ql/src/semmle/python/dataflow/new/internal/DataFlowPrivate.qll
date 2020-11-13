private import python
private import DataFlowPublic
import semmle.python.SpecialMethods
private import semmle.python.essa.SsaCompute

//--------
// Data flow graph
//--------
//--------
// Nodes
//--------
predicate isExpressionNode(ControlFlowNode node) { node.getNode() instanceof Expr }

/** A data flow node for which we should synthesise an associated pre-update node. */
abstract class NeedsSyntheticPreUpdateNode extends Node {
  /** A label for this kind of node. This will figure in the textual representation of the synthesized pre-update node. */
  abstract string label();
}

class SyntheticPreUpdateNode extends Node, TSyntheticPreUpdateNode {
  NeedsSyntheticPreUpdateNode post;

  SyntheticPreUpdateNode() { this = TSyntheticPreUpdateNode(post) }

  /** Gets the node for which this is a synthetic pre-update node. */
  Node getPostUpdateNode() { result = post }

  override string toString() { result = "[pre " + post.label() + "] " + post.toString() }

  override Scope getScope() { result = post.getScope() }

  override Location getLocation() { result = post.getLocation() }
}

/** A data flow node for which we should synthesise an associated post-update node. */
abstract class NeedsSyntheticPostUpdateNode extends Node {
  /** A label for this kind of node. This will figure in the textual representation of the synthesized post-update node. */
  abstract string label();
}

/** An argument might have its value changed as a result of a call. */
class ArgumentPreUpdateNode extends NeedsSyntheticPostUpdateNode, ArgumentNode {
  // Certain arguments, such as implicit self arguments are already post-update nodes
  // and should not have an extra node synthesised.
  ArgumentPreUpdateNode() {
    this = any(FunctionCall c).getArg(_)
    or
    // Avoid argument 0 of method calls as those have read post-update nodes.
    exists(MethodCall c, int n | n > 0 | this = c.getArg(n))
    or
    this = any(SpecialCall c).getArg(_)
    or
    // Avoid argument 0 of class calls as those have non-synthetic post-update nodes.
    exists(ClassCall c, int n | n > 0 | this = c.getArg(n))
  }

  override string label() { result = "arg" }
}

/** An object might have its value changed after a store. */
class StorePreUpdateNode extends NeedsSyntheticPostUpdateNode, CfgNode {
  StorePreUpdateNode() {
    exists(Attribute a |
      node = a.getObject().getAFlowNode() and
      a.getCtx() instanceof Store
    )
  }

  override string label() { result = "store" }
}

/** A node marking the state change of an object after a read. */
class ReadPreUpdateNode extends NeedsSyntheticPostUpdateNode, CfgNode {
  ReadPreUpdateNode() {
    exists(Attribute a |
      node = a.getObject().getAFlowNode() and
      a.getCtx() instanceof Load
    )
  }

  override string label() { result = "read" }
}

/** A post-update node is synthesized for all nodes which satisfy `NeedsSyntheticPostUpdateNode`. */
class SyntheticPostUpdateNode extends PostUpdateNode, TSyntheticPostUpdateNode {
  NeedsSyntheticPostUpdateNode pre;

  SyntheticPostUpdateNode() { this = TSyntheticPostUpdateNode(pre) }

  override Node getPreUpdateNode() { result = pre }

  override string toString() { result = "[post " + pre.label() + "] " + pre.toString() }

  override Scope getScope() { result = pre.getScope() }

  override Location getLocation() { result = pre.getLocation() }
}

/**
 * Calls to constructors are treated as post-update nodes for the synthesized argument
 * that is mapped to the `self` parameter. That way, constructor calls represent the value of the
 * object after the constructor (currently only `__init__`) has run.
 */
class ObjectCreationNode extends PostUpdateNode, NeedsSyntheticPreUpdateNode, CfgNode {
  ObjectCreationNode() { node.(CallNode) = any(ClassCall c).getNode() }

  override Node getPreUpdateNode() { result.(SyntheticPreUpdateNode).getPostUpdateNode() = this }

  override string label() { result = "objCreate" }
}

class DataFlowExpr = Expr;

/**
 * Flow between ESSA variables.
 * This includes both local and global variables.
 * Flow comes from definitions, uses and refinements.
 */
// TODO: Consider constraining `nodeFrom` and `nodeTo` to be in the same scope.
module EssaFlow {
  predicate essaFlowStep(Node nodeFrom, Node nodeTo) {
    // Definition
    //   `x = f(42)`
    //   nodeFrom is `f(42)`, cfg node
    //   nodeTo is `x`, essa var
    nodeFrom.(CfgNode).getNode() =
      nodeTo.(EssaNode).getVar().getDefinition().(AssignmentDefinition).getValue()
    or
    // With definition
    //   `with f(42) as x:`
    //   nodeFrom is `f(42)`, cfg node
    //   nodeTo is `x`, essa var
    exists(With with, ControlFlowNode contextManager, ControlFlowNode var |
      nodeFrom.(CfgNode).getNode() = contextManager and
      nodeTo.(EssaNode).getVar().getDefinition().(WithDefinition).getDefiningNode() = var and
      // see `with_flow` in `python/ql/src/semmle/python/dataflow/Implementation.qll`
      with.getContextExpr() = contextManager.getNode() and
      with.getOptionalVars() = var.getNode() and
      contextManager.strictlyDominates(var)
    )
    or
    exists(ParameterDefinition pd |
      nodeFrom.asCfgNode() = pd.getDefiningNode() and
      nodeTo.asVar() = pd.getVariable()
    )
    or
    // First use after definition
    //   `y = 42`
    //   `x = f(y)`
    //   nodeFrom is `y` on first line, essa var
    //   nodeTo is `y` on second line, cfg node
    defToFirstUse(nodeFrom.asVar(), nodeTo.asCfgNode())
    or
    // Next use after use
    //   `x = f(y)`
    //   `z = y + 1`
    //   nodeFrom is 'y' on first line, cfg node
    //   nodeTo is `y` on second line, cfg node
    useToNextUse(nodeFrom.asCfgNode(), nodeTo.asCfgNode())
    or
    // If expressions
    nodeFrom.asCfgNode() = nodeTo.asCfgNode().(IfExprNode).getAnOperand()
    or
    // Overflow keyword argument
    exists(CallNode call, CallableValue callable |
      call = callable.getACall() and
      nodeTo = TKwOverflowNode(call, callable) and
      nodeFrom.asCfgNode() = call.getNode().getKwargs().getAFlowNode()
    )
  }

  predicate useToNextUse(NameNode nodeFrom, NameNode nodeTo) {
    AdjacentUses::adjacentUseUse(nodeFrom, nodeTo)
  }

  predicate defToFirstUse(EssaVariable var, NameNode nodeTo) {
    AdjacentUses::firstUse(var.getDefinition(), nodeTo)
  }
}

//--------
// Local flow
//--------
/**
 * This is the local flow predicate that is used as a building block in global
 * data flow. It is a strict subset of the `localFlowStep` predicate, as it
 * excludes SSA flow through instance fields.
 */
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
  // If there is ESSA-flow out of a node `node`, we want flow
  // both out of `node` and any post-update node of `node`.
  exists(Node node |
    EssaFlow::essaFlowStep(node, nodeTo) and
    nodeFrom = update(node) and
    (
      not node instanceof EssaNode or
      not nodeTo instanceof EssaNode or
      localEssaStep(node, nodeTo)
    )
  )
}

/**
 * Holds if there is an Essa flow step from `nodeFrom` to `nodeTo` that does not switch between
 * local and global SSA variables.
 */
private predicate localEssaStep(EssaNode nodeFrom, EssaNode nodeTo) {
  EssaFlow::essaFlowStep(nodeFrom, nodeTo) and
  (
    nodeFrom.getVar() instanceof GlobalSsaVariable and
    nodeTo.getVar() instanceof GlobalSsaVariable
    or
    not nodeFrom.getVar() instanceof GlobalSsaVariable and
    not nodeTo.getVar() instanceof GlobalSsaVariable
  )
}

/**
 * Holds if `result` is either `node`, or the post-update node for `node`.
 */
private Node update(Node node) {
  exists(PostUpdateNode pun |
    node = pun.getPreUpdateNode() and
    result = pun
  )
  or
  result = node
}

// TODO: Make modules for these headings
//--------
// Global flow
//--------
//
/**
 * Computes routing of arguments to parameters
 *
 * When a call contains more positional arguments than there are positional parameters,
 * the extra positional arguments are passed as a tuple to a starred parameter. This is
 * achieved by synthesizing a node `TPosOverflowNode(call, callable)`
 * that represents the tuple of extra positional arguments. There is a store step from each
 * extra positional argument to this node.
 *
 * CURRENTLY NOT SUPPORTED:
 * When a call contains an iterable unpacking argument, such as `func(*args)`, it is expanded into positional arguments.
 *
 * CURRENTLY NOT SUPPORTED:
 * If a call contains an iterable unpacking argument, such as `func(*args)`, and the callee contains a starred argument, any extra
 * positional arguments are passed to the starred argument.
 *
 * When a call contains keyword arguments that do not correspond to keyword parameters, these
 * extra keyword arguments are passed as a dictionary to a doubly starred parameter. This is
 * achieved by synthesizing a node `TKwOverflowNode(call, callable)`
 * that represents the dictionary of extra keyword arguments. There is a store step from each
 * extra keyword argument to this node.
 *
 * When a call contains a dictionary unpacking argument, such as `func(**kwargs)`, with entries corresponding to a keyword parameter,
 * the value at such a key is unpacked and passed to the parameter. This is achieved
 * by synthesizing an argument node `TKwUnpacked(call, callable, name)` representing the unpacked
 * value. This node is used as the argument passed to the matching keyword parameter. There is a read
 * step from the dictionary argument to the synthesized argument node.
 *
 * When a call contains a dictionary unpacking argument, such as `func(**kwargs)`, and the callee contains a doubly starred parameter,
 * entries which are not unpacked are passed to the doubly starred parameter. This is achieved by
 * adding a dataflow step from the dictionary argument to `TKwOverflowNode(call, callable)` and a
 * step to clear content of that node at any unpacked keys.
 *
 * ## Examples:
 * Assume that we have the callable
 * ```python
 * def f(x, y, *t, **d):
 *   pass
 * ```
 * Then the call
 * ```python
 * f(0, 1, 2, a=3)
 * ```
 * will be modelled as
 * ```python
 * f(0, 1, [*t], [**d])
 * ```
 * where `[` and `]` denotes synthesized nodes, so `[*t]` is the synthesized tuple argument
 * `TPosOverflowNode` and `[**d]` is the synthesized dictionary argument `TKwOverflowNode`.
 * There will be a store step from `2` to `[*t]` at pos `0` and one from `3` to `[**d]` at key
 * `a`.
 *
 * For the call
 * ```python
 * f(0, **{"y": 1, "a": 3})
 * ```
 * no tuple argument is synthesized. It is modelled as
 * ```python
 * f(0, [y=1], [**d])
 * ```
 * where `[y=1]` is the synthesized unpacked argument `TKwUnpacked` (with `name` = `y`). There is
 * a read step from `**{"y": 1, "a": 3}` to `[y=1]` at key `y` to get the value passed to the parameter
 * `y`. There is a dataflow step from `**{"y": 1, "a": 3}` to `[**d]` to transfer the content and
 * a clearing of content at key `y` for node `[**d]`, since that value has been unpacked.
 */
module ArgumentPassing {
  /**
   * Holds if `call` represents a `DataFlowCall` to a `DataFlowCallable` represented by `callable`.
   *
   * It _may not_ be the case that `call = callable.getACall()`, i.e. if `call` represents a `ClassCall`.
   *
   * Used to limit the size of predicates.
   */
  predicate connects(CallNode call, CallableValue callable) {
    exists(DataFlowCall c |
      call = c.getNode() and
      callable = c.getCallable().getCallableValue()
    )
  }

  /**
   * Gets the `n`th parameter of `callable`.
   * If the callable has a starred parameter, say `*tuple`, that is matched with `n=-1`.
   * If the callable has a doubly starred parameter, say `**dict`, that is matched with `n=-2`.
   * Note that, unlike other languages, we do _not_ use -1 for the position of `self` in Python,
   * as it is an explicit parameter at position 0.
   */
  NameNode getParameter(CallableValue callable, int n) {
    // positional parameter
    result = callable.getParameter(n)
    or
    // starred parameter, `*tuple`
    exists(Function f |
      f = callable.getScope() and
      n = -1 and
      result = f.getVararg().getAFlowNode()
    )
    or
    // doubly starred parameter, `**dict`
    exists(Function f |
      f = callable.getScope() and
      n = -2 and
      result = f.getKwarg().getAFlowNode()
    )
  }

  /**
   * A type representing a mapping from argument indices to parameter indices.
   * We currently use two mappings: NoShift, the identity, used for ordinary
   * function calls, and ShiftOneUp which is used for calls where an extra argument
   * is inserted. These include method calls, constructor calls and class calls.
   * In these calls, the argument at index `n` is mapped to the parameter at position `n+1`.
   */
  newtype TArgParamMapping =
    TNoShift() or
    TShiftOneUp()

  /** A mapping used for parameter passing. */
  abstract class ArgParamMapping extends TArgParamMapping {
    /** Gets the index of the parameter that corresponds to the argument at index `argN`. */
    bindingset[argN]
    abstract int getParamN(int argN);

    /** Gets a textual representation of this element. */
    abstract string toString();
  }

  /** A mapping that passes argument `n` to parameter `n`. */
  class NoShift extends ArgParamMapping, TNoShift {
    NoShift() { this = TNoShift() }

    override string toString() { result = "NoShift [n -> n]" }

    bindingset[argN]
    override int getParamN(int argN) { result = argN }
  }

  /** A mapping that passes argument `n` to parameter `n+1`. */
  class ShiftOneUp extends ArgParamMapping, TShiftOneUp {
    ShiftOneUp() { this = TShiftOneUp() }

    override string toString() { result = "ShiftOneUp [n -> n+1]" }

    bindingset[argN]
    override int getParamN(int argN) { result = argN + 1 }
  }

  /**
   * Gets the node representing the argument to `call` that is passed to the parameter at
   * (zero-based) index `paramN` in `callable`. If this is a positional argument, it must appear
   * at an index, `argN`, in `call` wich satisfies `paramN = mapping.getParamN(argN)`.
   *
   * `mapping` will be the identity for function calls, but not for method- or constructor calls,
   * where the first parameter is `self` and the first positional argument is passed to the second positional parameter.
   * Similarly for classmethod calls, where the first parameter is `cls`.
   *
   * NOT SUPPORTED: Keyword-only parameters.
   */
  Node getArg(CallNode call, ArgParamMapping mapping, CallableValue callable, int paramN) {
    connects(call, callable) and
    (
      // positional argument
      exists(int argN |
        paramN = mapping.getParamN(argN) and
        result = TCfgNode(call.getArg(argN))
      )
      or
      // keyword argument
      // TODO: Since `getArgName` have no results for keyword-only parameters,
      // these are currently not supported.
      exists(Function f, string argName |
        f = callable.getScope() and
        f.getArgName(paramN) = argName and
        result = TCfgNode(call.getArgByName(unbind_string(argName)))
      )
      or
      // a synthezised argument passed to the starred parameter (at position -1)
      callable.getScope().hasVarArg() and
      paramN = -1 and
      result = TPosOverflowNode(call, callable)
      or
      // a synthezised argument passed to the doubly starred parameter (at position -2)
      callable.getScope().hasKwArg() and
      paramN = -2 and
      result = TKwOverflowNode(call, callable)
      or
      // argument unpacked from dict
      exists(string name |
        call_unpacks(call, mapping, callable, name, paramN) and
        result = TKwUnpacked(call, callable, name)
      )
    )
  }

  /** Currently required in `getArg` in order to prevent a bad join. */
  bindingset[result, s]
  private string unbind_string(string s) { result <= s and s <= result }

  /** Gets the control flow node that is passed as the `n`th overflow positional argument. */
  ControlFlowNode getPositionalOverflowArg(CallNode call, CallableValue callable, int n) {
    connects(call, callable) and
    exists(Function f, int posCount, int argNr |
      f = callable.getScope() and
      f.hasVarArg() and
      posCount = f.getPositionalParameterCount() and
      result = call.getArg(argNr) and
      argNr >= posCount and
      argNr = posCount + n
    )
  }

  /** Gets the control flow node that is passed as the overflow keyword argument with key `key`. */
  ControlFlowNode getKeywordOverflowArg(CallNode call, CallableValue callable, string key) {
    connects(call, callable) and
    exists(Function f |
      f = callable.getScope() and
      f.hasKwArg() and
      not exists(f.getArgByName(key)) and
      result = call.getArgByName(key)
    )
  }

  /**
   * Holds if `call` unpacks a dictionary argument in order to pass it via `name`.
   * It will then be passed to the parameter of `callable` at index `paramN`.
   */
  predicate call_unpacks(
    CallNode call, ArgParamMapping mapping, CallableValue callable, string name, int paramN
  ) {
    connects(call, callable) and
    exists(Function f |
      f = callable.getScope() and
      not exists(int argN | paramN = mapping.getParamN(argN) | exists(call.getArg(argN))) and // no positional argument available
      name = f.getArgName(paramN) and
      // not exists(call.getArgByName(name)) and // only matches keyword arguments not preceded by **
      // TODO: make the below logic respect control flow splitting (by not going to the AST).
      not call.getNode().getANamedArg().(Keyword).getArg() = name and // no keyword argument available
      paramN >= 0 and
      paramN < f.getPositionalParameterCount() + f.getKeywordOnlyParameterCount() and
      exists(call.getNode().getKwargs()) // dict argument available
    )
  }
}

import ArgumentPassing

/**
 * IPA type for DataFlowCallable.
 *
 * A callable is either a function value, a class value, or a module (for enclosing `ModuleVariableNode`s).
 * A module has no calls.
 */
newtype TDataFlowCallable =
  TCallableValue(CallableValue callable) {
    callable instanceof FunctionValue
    or
    callable instanceof ClassValue
  } or
  TModule(Module m)

/** Represents a callable. */
abstract class DataFlowCallable extends TDataFlowCallable {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Gets a call to this callable. */
  abstract CallNode getACall();

  /** Gets the scope of this callable */
  abstract Scope getScope();

  /** Gets the specified parameter of this callable */
  abstract NameNode getParameter(int n);

  /** Gets the name of this callable. */
  abstract string getName();

  /** Gets a callable value for this callable, if one exists. */
  abstract CallableValue getCallableValue();
}

/** A class representing a callable value. */
class DataFlowCallableValue extends DataFlowCallable, TCallableValue {
  CallableValue callable;

  DataFlowCallableValue() { this = TCallableValue(callable) }

  override string toString() { result = callable.toString() }

  override CallNode getACall() { result = callable.getACall() }

  override Scope getScope() { result = callable.getScope() }

  override NameNode getParameter(int n) { result = getParameter(callable, n) }

  override string getName() { result = callable.getName() }

  override CallableValue getCallableValue() { result = callable }
}

/** A class representing the scope in which a `ModuleVariableNode` appears. */
class DataFlowModuleScope extends DataFlowCallable, TModule {
  Module mod;

  DataFlowModuleScope() { this = TModule(mod) }

  override string toString() { result = mod.toString() }

  override CallNode getACall() { none() }

  override Scope getScope() { result = mod }

  override NameNode getParameter(int n) { none() }

  override string getName() { result = mod.getName() }

  override CallableValue getCallableValue() { none() }
}

/**
 * IPA type for DataFlowCall.
 *
 * Calls corresponding to `CallNode`s are either to callable values or to classes.
 * The latter is directed to the callable corresponding to the `__init__` method of the class.
 *
 * An `__init__` method can also be called directly, so that the callable can be targeted by
 * different types of calls. In that case, the parameter mappings will be different,
 * as the class call will synthesize an argument node to be mapped to the `self` parameter.
 *
 * A call corresponding to a special method call is handled by the corresponding `SpecialMethodCallNode`.
 *
 * TODO: Add `TClassMethodCall` mapping `cls` appropriately.
 */
newtype TDataFlowCall =
  TFunctionCall(CallNode call) { call = any(FunctionValue f).getAFunctionCall() } or
  /** Bound methods need to make room for the explicit self parameter */
  TMethodCall(CallNode call) { call = any(FunctionValue f).getAMethodCall() } or
  TClassCall(CallNode call) { call = any(ClassValue c).getACall() } or
  TSpecialCall(SpecialMethodCallNode special)

/** Represents a call. */
abstract class DataFlowCall extends TDataFlowCall {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Get the callable to which this call goes. */
  abstract DataFlowCallable getCallable();

  /**
   * Gets the argument to this call that will be sent
   * to the `n`th parameter of the callable.
   */
  abstract Node getArg(int n);

  /** Get the control flow node representing this call. */
  abstract ControlFlowNode getNode();

  /** Gets the enclosing callable of this call. */
  abstract DataFlowCallable getEnclosingCallable();

  /** Gets the location of this dataflow call. */
  Location getLocation() { result = this.getNode().getLocation() }
}

/**
 * Represents a call to a function/lambda.
 * This excludes calls to bound methods, classes, and special methods.
 * Bound method calls and class calls insert an argument for the explicit
 * `self` parameter, and special method calls have special argument passing.
 */
class FunctionCall extends DataFlowCall, TFunctionCall {
  CallNode call;
  DataFlowCallable callable;

  FunctionCall() {
    this = TFunctionCall(call) and
    call = callable.getACall()
  }

  override string toString() { result = call.toString() }

  override Node getArg(int n) { result = getArg(call, TNoShift(), callable.getCallableValue(), n) }

  override ControlFlowNode getNode() { result = call }

  override DataFlowCallable getCallable() { result = callable }

  override DataFlowCallable getEnclosingCallable() { result.getScope() = call.getNode().getScope() }
}

/**
 * Represents a call to a bound method call.
 * The node representing the instance is inserted as argument to the `self` parameter.
 */
class MethodCall extends DataFlowCall, TMethodCall {
  CallNode call;
  FunctionValue bm;

  MethodCall() {
    this = TMethodCall(call) and
    call = bm.getACall()
  }

  private CallableValue getCallableValue() { result = bm }

  override string toString() { result = call.toString() }

  override Node getArg(int n) {
    n > 0 and result = getArg(call, TShiftOneUp(), this.getCallableValue(), n)
    or
    n = 0 and result = TCfgNode(call.getFunction().(AttrNode).getObject())
  }

  override ControlFlowNode getNode() { result = call }

  override DataFlowCallable getCallable() { result = TCallableValue(this.getCallableValue()) }

  override DataFlowCallable getEnclosingCallable() { result.getScope() = call.getScope() }
}

/**
 * Represents a call to a class.
 * The pre-update node for the call is inserted as argument to the `self` parameter.
 * That makes the call node be the post-update node holding the value of the object
 * after the constructor has run.
 */
class ClassCall extends DataFlowCall, TClassCall {
  CallNode call;
  ClassValue c;

  ClassCall() {
    this = TClassCall(call) and
    call = c.getACall()
  }

  private CallableValue getCallableValue() { c.getScope().getInitMethod() = result.getScope() }

  override string toString() { result = call.toString() }

  override Node getArg(int n) {
    n > 0 and result = getArg(call, TShiftOneUp(), this.getCallableValue(), n)
    or
    n = 0 and result = TSyntheticPreUpdateNode(TCfgNode(call))
  }

  override ControlFlowNode getNode() { result = call }

  override DataFlowCallable getCallable() { result = TCallableValue(this.getCallableValue()) }

  override DataFlowCallable getEnclosingCallable() { result.getScope() = call.getScope() }
}

/** Represents a call to a special method. */
class SpecialCall extends DataFlowCall, TSpecialCall {
  SpecialMethodCallNode special;

  SpecialCall() { this = TSpecialCall(special) }

  override string toString() { result = special.toString() }

  override Node getArg(int n) { result = TCfgNode(special.(SpecialMethod::Potential).getArg(n)) }

  override ControlFlowNode getNode() { result = special }

  override DataFlowCallable getCallable() {
    result = TCallableValue(special.getResolvedSpecialMethod())
  }

  override DataFlowCallable getEnclosingCallable() {
    result.getScope() = special.getNode().getScope()
  }
}

/** A data flow node that represents a call argument. */
class ArgumentNode extends Node {
  ArgumentNode() { this = any(DataFlowCall c).getArg(_) }

  /** Holds if this argument occurs at the given position in the given call. */
  predicate argumentOf(DataFlowCall call, int pos) { this = call.getArg(pos) }

  /** Gets the call in which this node is an argument. */
  final DataFlowCall getCall() { this.argumentOf(result, _) }
}

/** Gets a viable run-time target for the call `call`. */
DataFlowCallable viableCallable(DataFlowCall call) { result = call.getCallable() }

private newtype TReturnKind = TNormalReturnKind()

/**
 * A return kind. A return kind describes how a value can be returned
 * from a callable. For Python, this is simply a method return.
 */
class ReturnKind extends TReturnKind {
  /** Gets a textual representation of this element. */
  string toString() { result = "return" }
}

/** A data flow node that represents a value returned by a callable. */
class ReturnNode extends CfgNode {
  Return ret;

  // See `TaintTrackingImplementation::returnFlowStep`
  ReturnNode() { node = ret.getValue().getAFlowNode() }

  /** Gets the kind of this return node. */
  ReturnKind getKind() { any() }

  override DataFlowCallable getEnclosingCallable() {
    result.getScope().getAStmt() = ret // TODO: check nested function definitions
  }
}

/** A data flow node that represents the output of a call. */
class OutNode extends CfgNode {
  OutNode() { node instanceof CallNode }
}

/**
 * Gets a node that can read the value returned from `call` with return kind
 * `kind`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
  call.getNode() = result.getNode() and
  kind = TNormalReturnKind()
}

//--------
// Type pruning
//--------
newtype TDataFlowType = TAnyFlow()

class DataFlowType extends TDataFlowType {
  /** Gets a textual representation of this element. */
  string toString() { result = "DataFlowType" }
}

/** A node that performs a type cast. */
class CastNode extends Node {
  CastNode() { none() }
}

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
pragma[inline]
predicate compatibleTypes(DataFlowType t1, DataFlowType t2) { any() }

/**
 * Gets the type of `node`.
 */
DataFlowType getNodeType(Node node) {
  result = TAnyFlow() and
  // Suppress unused variable warning
  node = node
}

/** Gets a string representation of a type returned by `getErasedRepr`. */
string ppReprType(DataFlowType t) { none() }

//--------
// Extra flow
//--------
/**
 * Holds if `pred` can flow to `succ`, by jumping from one callable to
 * another. Additional steps specified by the configuration are *not*
 * taken into account.
 */
predicate jumpStep(Node nodeFrom, Node nodeTo) {
  // Module variable read
  nodeFrom.(ModuleVariableNode).getARead() = nodeTo
  or
  // Module variable write
  nodeFrom = nodeTo.(ModuleVariableNode).getAWrite()
  or
  // Read of module attribute:
  exists(AttrRead r, ModuleValue mv |
    r.getObject().asCfgNode().pointsTo(mv) and
    module_export(mv.getScope(), r.getAttributeName(), nodeFrom) and
    nodeTo = r
  )
}

/**
 * Holds if the module `m` defines a name `name` by assigning `defn` to it. This is an
 * overapproximation, as `name` may not in fact be exported (e.g. by defining an `__all__` that does
 * not include `name`).
 */
private predicate module_export(Module m, string name, CfgNode defn) {
  exists(EssaVariable v |
    v.getName() = name and
    v.getAUse() = m.getANormalExit()
  |
    defn.getNode() = v.getDefinition().(AssignmentDefinition).getValue()
    or
    defn.getNode() = v.getDefinition().(ArgumentRefinement).getArgument()
  )
}

//--------
// Field flow
//--------
/**
 * Holds if data can flow from `nodeFrom` to `nodeTo` via an assignment to
 * content `c`.
 */
predicate storeStep(Node nodeFrom, Content c, Node nodeTo) {
  listStoreStep(nodeFrom, c, nodeTo)
  or
  setStoreStep(nodeFrom, c, nodeTo)
  or
  tupleStoreStep(nodeFrom, c, nodeTo)
  or
  dictStoreStep(nodeFrom, c, nodeTo)
  or
  comprehensionStoreStep(nodeFrom, c, nodeTo)
  or
  attributeStoreStep(nodeFrom, c, nodeTo)
  or
  posOverflowStoreStep(nodeFrom, c, nodeTo)
  or
  kwOverflowStoreStep(nodeFrom, c, nodeTo)
}

/** Data flows from an element of a list to the list. */
predicate listStoreStep(CfgNode nodeFrom, ListElementContent c, CfgNode nodeTo) {
  // List
  //   `[..., 42, ...]`
  //   nodeFrom is `42`, cfg node
  //   nodeTo is the list, `[..., 42, ...]`, cfg node
  //   c denotes element of list
  nodeTo.getNode().(ListNode).getAnElement() = nodeFrom.getNode() and
  // Suppress unused variable warning
  c = c
}

/** Data flows from an element of a set to the set. */
predicate setStoreStep(CfgNode nodeFrom, ListElementContent c, CfgNode nodeTo) {
  // Set
  //   `{..., 42, ...}`
  //   nodeFrom is `42`, cfg node
  //   nodeTo is the set, `{..., 42, ...}`, cfg node
  //   c denotes element of list
  nodeTo.getNode().(SetNode).getAnElement() = nodeFrom.getNode() and
  // Suppress unused variable warning
  c = c
}

/** Data flows from an element of a tuple to the tuple at a specific index. */
predicate tupleStoreStep(CfgNode nodeFrom, TupleElementContent c, CfgNode nodeTo) {
  // Tuple
  //   `(..., 42, ...)`
  //   nodeFrom is `42`, cfg node
  //   nodeTo is the tuple, `(..., 42, ...)`, cfg node
  //   c denotes element of tuple and index of nodeFrom
  exists(int n |
    nodeTo.getNode().(TupleNode).getElement(n) = nodeFrom.getNode() and
    c.getIndex() = n
  )
}

/** Data flows from an element of a dictionary to the dictionary at a specific key. */
predicate dictStoreStep(CfgNode nodeFrom, DictionaryElementContent c, CfgNode nodeTo) {
  // Dictionary
  //   `{..., "key" = 42, ...}`
  //   nodeFrom is `42`, cfg node
  //   nodeTo is the dict, `{..., "key" = 42, ...}`, cfg node
  //   c denotes element of dictionary and the key `"key"`
  exists(KeyValuePair item |
    item = nodeTo.getNode().(DictNode).getNode().(Dict).getAnItem() and
    nodeFrom.getNode().getNode() = item.getValue() and
    c.getKey() = item.getKey().(StrConst).getS()
  )
}

/** Data flows from an element expression in a comprehension to the comprehension. */
predicate comprehensionStoreStep(CfgNode nodeFrom, Content c, CfgNode nodeTo) {
  // Comprehension
  //   `[x+1 for x in l]`
  //   nodeFrom is `x+1`, cfg node
  //   nodeTo is `[x+1 for x in l]`, cfg node
  //   c denotes list or set or dictionary without index
  //
  // List
  nodeTo.getNode().getNode().(ListComp).getElt() = nodeFrom.getNode().getNode() and
  c instanceof ListElementContent
  or
  // Set
  nodeTo.getNode().getNode().(SetComp).getElt() = nodeFrom.getNode().getNode() and
  c instanceof SetElementContent
  or
  // Dictionary
  nodeTo.getNode().getNode().(DictComp).getElt() = nodeFrom.getNode().getNode() and
  c instanceof DictionaryElementAnyContent
  or
  // Generator
  nodeTo.getNode().getNode().(GeneratorExp).getElt() = nodeFrom.getNode().getNode() and
  c instanceof ListElementContent
}

/**
 * Holds if `nodeFrom` flows into an attribute (corresponding to `c`) of `nodeTo` via an attribute assignment.
 *
 * For example, in
 * ```python
 * obj.foo = x
 * ```
 * data flows from `x` to (the post-update node for) `obj` via assignment to `foo`.
 */
predicate attributeStoreStep(CfgNode nodeFrom, AttributeContent c, PostUpdateNode nodeTo) {
  exists(AttrNode attr |
    nodeFrom.asCfgNode() = attr.(DefinitionNode).getValue() and
    attr.getName() = c.getAttribute() and
    attr.getObject() = nodeTo.getPreUpdateNode().(CfgNode).getNode()
  )
}

/**
 * Holds if `nodeFrom` flows into the synthezised positional overflow argument (`nodeTo`)
 * at the position indicated by `c`.
 */
predicate posOverflowStoreStep(CfgNode nodeFrom, TupleElementContent c, Node nodeTo) {
  exists(CallNode call, CallableValue callable, int n |
    nodeFrom.asCfgNode() = getPositionalOverflowArg(call, callable, n) and
    nodeTo = TPosOverflowNode(call, callable) and
    c.getIndex() = n
  )
}

/**
 * Holds if `nodeFrom` flows into the synthezised keyword overflow argument (`nodeTo`)
 * at the key indicated by `c`.
 */
predicate kwOverflowStoreStep(CfgNode nodeFrom, DictionaryElementContent c, Node nodeTo) {
  exists(CallNode call, CallableValue callable, string key |
    nodeFrom.asCfgNode() = getKeywordOverflowArg(call, callable, key) and
    nodeTo = TKwOverflowNode(call, callable) and
    c.getKey() = key
  )
}

/**
 * Holds if data can flow from `nodeFrom` to `nodeTo` via a read of content `c`.
 */
predicate readStep(Node nodeFrom, Content c, Node nodeTo) {
  subscriptReadStep(nodeFrom, c, nodeTo)
  or
  popReadStep(nodeFrom, c, nodeTo)
  or
  comprehensionReadStep(nodeFrom, c, nodeTo)
  or
  attributeReadStep(nodeFrom, c, nodeTo)
  or
  kwUnpackReadStep(nodeFrom, c, nodeTo)
}

/** Data flows from a sequence to a subscript of the sequence. */
predicate subscriptReadStep(CfgNode nodeFrom, Content c, CfgNode nodeTo) {
  // Subscript
  //   `l[3]`
  //   nodeFrom is `l`, cfg node
  //   nodeTo is `l[3]`, cfg node
  //   c is compatible with 3
  nodeFrom.getNode() = nodeTo.getNode().(SubscriptNode).getObject() and
  (
    c instanceof ListElementContent
    or
    c instanceof SetElementContent
    or
    c instanceof DictionaryElementAnyContent
    or
    c.(TupleElementContent).getIndex() =
      nodeTo.getNode().(SubscriptNode).getIndex().getNode().(IntegerLiteral).getValue()
    or
    c.(DictionaryElementContent).getKey() =
      nodeTo.getNode().(SubscriptNode).getIndex().getNode().(StrConst).getS()
  )
}

/** Data flows from a sequence to a call to `pop` on the sequence. */
predicate popReadStep(CfgNode nodeFrom, Content c, CfgNode nodeTo) {
  // set.pop or list.pop
  //   `s.pop()`
  //   nodeFrom is `s`, cfg node
  //   nodeTo is `s.pop()`, cfg node
  //   c denotes element of list or set
  exists(CallNode call, AttrNode a |
    call.getFunction() = a and
    a.getName() = "pop" and // Should match appropriate call since we tracked a sequence here.
    not exists(call.getAnArg()) and
    nodeFrom.getNode() = a.getObject() and
    nodeTo.getNode() = call and
    (
      c instanceof ListElementContent
      or
      c instanceof SetElementContent
    )
  )
  or
  // dict.pop
  //   `d.pop("key")`
  //   nodeFrom is `d`, cfg node
  //   nodeTo is `d.pop("key")`, cfg node
  //   c denotes the key `"key"`
  exists(CallNode call, AttrNode a |
    call.getFunction() = a and
    a.getName() = "pop" and // Should match appropriate call since we tracked a dictionary here.
    nodeFrom.getNode() = a.getObject() and
    nodeTo.getNode() = call and
    c.(DictionaryElementContent).getKey() = call.getArg(0).getNode().(StrConst).getS()
  )
}

/** Data flows from a iterated sequence to the variable iterating over the sequence. */
predicate comprehensionReadStep(CfgNode nodeFrom, Content c, EssaNode nodeTo) {
  // Comprehension
  //   `[x+1 for x in l]`
  //   nodeFrom is `l`, cfg node
  //   nodeTo is `x`, essa var
  //   c denotes element of list or set
  exists(Comp comp |
    // outermost for
    nodeFrom.getNode().getNode() = comp.getIterable() and
    nodeTo.getVar().getDefinition().(AssignmentDefinition).getDefiningNode().getNode() =
      comp.getIterationVariable(0).getAStore()
    or
    // an inner for
    exists(int n | n > 0 |
      nodeFrom.getNode().getNode() = comp.getNthInnerLoop(n).getIter() and
      nodeTo.getVar().getDefinition().(AssignmentDefinition).getDefiningNode().getNode() =
        comp.getNthInnerLoop(n).getTarget()
    )
  ) and
  (
    c instanceof ListElementContent
    or
    c instanceof SetElementContent
  )
}

/**
 * Holds if `nodeTo` is a read of an attribute (corresponding to `c`) of the object in `nodeFrom`.
 *
 * For example, in
 * ```python
 * obj.foo
 * ```
 * data flows from `obj` to `obj.foo` via a read from `foo`.
 */
predicate attributeReadStep(CfgNode nodeFrom, AttributeContent c, CfgNode nodeTo) {
  exists(AttrNode attr |
    nodeFrom.asCfgNode() = attr.getObject() and
    nodeTo.asCfgNode() = attr and
    attr.getName() = c.getAttribute() and
    attr.isLoad()
  )
}

/**
 * Holds if `nodeFrom` is a dictionary argument being unpacked and `nodeTo` is the
 * synthezised unpacked argument with the name indicated by `c`.
 */
predicate kwUnpackReadStep(CfgNode nodeFrom, DictionaryElementContent c, Node nodeTo) {
  exists(CallNode call, CallableValue callable, string name |
    nodeFrom.asCfgNode() = call.getNode().getKwargs().getAFlowNode() and
    nodeTo = TKwUnpacked(call, callable, name) and
    name = c.getKey()
  )
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`. For example,
 * any value stored inside `f` is cleared at the pre-update node associated with `x`
 * in `x.f = newValue`.
 */
cached
predicate clearsContent(Node n, Content c) {
  exists(CallNode call, CallableValue callable, string name |
    call_unpacks(call, _, callable, name, _) and
    n = TKwOverflowNode(call, callable) and
    c.(DictionaryElementContent).getKey() = name
  )
}

//--------
// Fancy context-sensitive guards
//--------
/**
 * Holds if the node `n` is unreachable when the call context is `call`.
 */
predicate isUnreachableInCall(Node n, DataFlowCall call) { none() }

//--------
// Virtual dispatch with call context
//--------
/**
 * Gets a viable dispatch target of `call` in the context `ctx`. This is
 * restricted to those `call`s for which a context might make a difference.
 */
DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) { none() }

/**
 * Holds if the set of viable implementations that can be called by `call`
 * might be improved by knowing the call context. This is the case if the qualifier accesses a parameter of
 * the enclosing callable `c` (including the implicit `this` parameter).
 */
predicate mayBenefitFromCallContext(DataFlowCall call, DataFlowCallable c) { none() }

//--------
// Misc
//--------
/**
 * Holds if `n` does not require a `PostUpdateNode` as it either cannot be
 * modified or its modification cannot be observed, for example if it is a
 * freshly created object that is not saved in a variable.
 *
 * This predicate is only used for consistency checks.
 */
predicate isImmutableOrUnobservable(Node n) { none() }

int accessPathLimit() { result = 5 }

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) { none() }
