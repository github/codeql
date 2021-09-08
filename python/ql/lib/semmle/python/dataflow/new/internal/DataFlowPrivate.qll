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

/** A module collecting the different reasons for synthesising a pre-update node. */
module syntheticPreUpdateNode {
  class SyntheticPreUpdateNode extends Node, TSyntheticPreUpdateNode {
    NeedsSyntheticPreUpdateNode post;

    SyntheticPreUpdateNode() { this = TSyntheticPreUpdateNode(post) }

    /** Gets the node for which this is a synthetic pre-update node. */
    Node getPostUpdateNode() { result = post }

    override string toString() { result = "[pre " + post.label() + "] " + post.toString() }

    override Scope getScope() { result = post.getScope() }

    override Location getLocation() { result = post.getLocation() }
  }

  /** A data flow node for which we should synthesise an associated pre-update node. */
  class NeedsSyntheticPreUpdateNode extends PostUpdateNode {
    NeedsSyntheticPreUpdateNode() { this = objectCreationNode() }

    override Node getPreUpdateNode() { result.(SyntheticPreUpdateNode).getPostUpdateNode() = this }

    /**
     * A label for this kind of node. This will figure in the textual representation of the synthesized pre-update node.
     *
     * There is currently only one reason for needing a pre-update node, so we always use that as the label.
     */
    string label() { result = "objCreate" }
  }

  /**
   * Calls to constructors are treated as post-update nodes for the synthesized argument
   * that is mapped to the `self` parameter. That way, constructor calls represent the value of the
   * object after the constructor (currently only `__init__`) has run.
   */
  CfgNode objectCreationNode() { result.getNode().(CallNode) = any(ClassCall c).getNode() }
}

import syntheticPreUpdateNode

/** A module collecting the different reasons for synthesising a post-update node. */
module syntheticPostUpdateNode {
  /** A post-update node is synthesized for all nodes which satisfy `NeedsSyntheticPostUpdateNode`. */
  class SyntheticPostUpdateNode extends PostUpdateNode, TSyntheticPostUpdateNode {
    NeedsSyntheticPostUpdateNode pre;

    SyntheticPostUpdateNode() { this = TSyntheticPostUpdateNode(pre) }

    override Node getPreUpdateNode() { result = pre }

    override string toString() { result = "[post " + pre.label() + "] " + pre.toString() }

    override Scope getScope() { result = pre.getScope() }

    override Location getLocation() { result = pre.getLocation() }
  }

  /** A data flow node for which we should synthesise an associated post-update node. */
  class NeedsSyntheticPostUpdateNode extends Node {
    NeedsSyntheticPostUpdateNode() {
      this = argumentPreUpdateNode()
      or
      this = storePreUpdateNode()
      or
      this = readPreUpdateNode()
    }

    /**
     * A label for this kind of node. This will figure in the textual representation of the synthesized post-update node.
     * We favour being an arguments as the reason for the post-update node in case multiple reasons apply.
     */
    string label() {
      if this = argumentPreUpdateNode()
      then result = "arg"
      else
        if this = storePreUpdateNode()
        then result = "store"
        else result = "read"
    }
  }

  /**
   * An argument might have its value changed as a result of a call.
   * Certain arguments, such as implicit self arguments are already post-update nodes
   * and should not have an extra node synthesised.
   */
  ArgumentNode argumentPreUpdateNode() {
    result = any(FunctionCall c).getArg(_)
    or
    // Avoid argument 0 of method calls as those have read post-update nodes.
    exists(MethodCall c, int n | n > 0 | result = c.getArg(n))
    or
    result = any(SpecialCall c).getArg(_)
    or
    // Avoid argument 0 of class calls as those have non-synthetic post-update nodes.
    exists(ClassCall c, int n | n > 0 | result = c.getArg(n))
  }

  /** An object might have its value changed after a store. */
  CfgNode storePreUpdateNode() {
    exists(Attribute a |
      result.getNode() = a.getObject().getAFlowNode() and
      a.getCtx() instanceof Store
    )
  }

  /**
   * A node marking the state change of an object after a read.
   *
   * A reverse read happens when the result of a read is modified, e.g. in
   * ```python
   * l = [ mutable ]
   * l[0].mutate()
   * ```
   * we may now have changed the content of `l`. To track this, there must be
   * a postupdate node for `l`.
   */
  CfgNode readPreUpdateNode() {
    exists(Attribute a |
      result.getNode() = a.getObject().getAFlowNode() and
      a.getCtx() instanceof Load
    )
    or
    result.getNode() = any(SubscriptNode s).getObject()
    or
    // The dictionary argument is read from if the callable has parameters matching the keys.
    result.getNode().getNode() = any(Call call).getKwargs()
  }
}

import syntheticPostUpdateNode

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
    // Parameter definition
    //   `def foo(x):`
    //   nodeFrom is `x`, cfgNode
    //   nodeTo is `x`, essa var
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
    // Flow inside an unpacking assignment
    iterableUnpackingFlowStep(nodeFrom, nodeTo)
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
  result = node
  or
  result.(PostUpdateNode).getPreUpdateNode() = node
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
        result = TKwUnpackedNode(call, callable, name)
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
    callable instanceof FunctionValue and
    not callable.(FunctionValue).isLambda()
    or
    callable instanceof ClassValue
  } or
  TLambda(Function lambda) { lambda.isLambda() } or
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

/** A class representing a callable lambda. */
class DataFlowLambda extends DataFlowCallable, TLambda {
  Function lambda;

  DataFlowLambda() { this = TLambda(lambda) }

  override string toString() { result = lambda.toString() }

  override CallNode getACall() { result = getCallableValue().getACall() }

  override Scope getScope() { result = lambda.getEvaluatingScope() }

  override NameNode getParameter(int n) { result = getParameter(getCallableValue(), n) }

  override string getName() { result = "Lambda callable" }

  override FunctionValue getCallableValue() {
    result.getOrigin().getNode() = lambda.getDefinition()
  }
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
  // We include read- and store steps here to force them to be
  // shown in path explanations.
  // This hack is necessary, because we have included some of these
  // steps as default taint steps, making them be suppressed in path
  // explanations.
  // We should revert this once, we can remove this steps from the
  // default taint steps; this should be possible once we have
  // implemented flow summaries and recursive content.
  CastNode() { readStep(_, _, this) or storeStep(_, _, this) }
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
  or
  // Default value for parameter flows to that parameter
  defaultValueFlowStep(nodeFrom, nodeTo)
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
  iterableUnpackingStoreStep(nodeFrom, c, nodeTo)
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
  not nodeTo.getNode() instanceof UnpackingAssignmentSequenceTarget and
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
    not nodeTo.getNode() instanceof UnpackingAssignmentSequenceTarget and
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

predicate defaultValueFlowStep(CfgNode nodeFrom, CfgNode nodeTo) {
  exists(Function f, Parameter p, ParameterDefinition def |
    // `getArgByName` supports, unlike `getAnArg`, keyword-only parameters
    p = f.getArgByName(_) and
    nodeFrom.asExpr() = p.getDefault() and
    // The following expresses
    // nodeTo.(ParameterNode).getParameter() = p
    // without non-monotonic recursion
    def.getParameter() = p and
    nodeTo.getNode() = def.getDefiningNode()
  )
}

/**
 * Holds if data can flow from `nodeFrom` to `nodeTo` via a read of content `c`.
 */
predicate readStep(Node nodeFrom, Content c, Node nodeTo) {
  subscriptReadStep(nodeFrom, c, nodeTo)
  or
  iterableUnpackingReadStep(nodeFrom, c, nodeTo)
  or
  popReadStep(nodeFrom, c, nodeTo)
  or
  forReadStep(nodeFrom, c, nodeTo)
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

/**
 * The unpacking assignment takes the general form
 * ```python
 *   sequence = iterable
 * ```
 * where `sequence` is either a tuple or a list and it can contain wildcards.
 * The iterable can be any iterable, which means that (CodeQL modeling of) content
 * will need to change type if it should be transferred from the LHS to the RHS.
 *
 * Note that (CodeQL modeling of) content does not have to change type on data-flow
 * paths _inside_ the LHS, as the different allowed syntaxes here are merely a convenience.
 * Consequently, we model all LHS sequences as tuples, which have the more precise content
 * model, making flow to the elements more precise. If an element is a starred variable,
 * we will have to mutate the content type to be list content.
 *
 * We may for instance have
 * ```python
 *    (a, b) = ["a", SOURCE]  # RHS has content `ListElementContent`
 * ```
 * Due to the abstraction for list content, we do not know whether `SOURCE`
 * ends up in `a` or in `b`, so we want to overapproximate and see it in both.
 *
 * Using wildcards we may have
 * ```python
 *   (a, *b) = ("a", "b", SOURCE)  # RHS has content `TupleElementContent(2)`
 * ```
 * Since the starred variables are always assigned (Python-)type list, `*b` will be
 * `["b", SOURCE]`, and we will again overapproximate and assign it
 * content corresponding to anything found in the RHS.
 *
 * For a precise transfer
 * ```python
 *    (a, b) = ("a", SOURCE)  # RHS has content `TupleElementContent(1)`
 * ```
 * we wish to keep the precision, so only `b` receives the tuple content at index 1.
 *
 * Finally, `sequence` is actually a pattern and can have a more complicated structure,
 * such as
 * ```python
 *   (a, [b, *c]) = ("a", ["b", SOURCE])  # RHS has content `TupleElementContent(1); ListElementContent`
 * ```
 * where `a` should not receive content, but `b` and `c` should. `c` will be `[SOURCE]` so
 * should have the content transferred, while `b` should read it.
 *
 * To transfer content from RHS to the elements of the LHS in the expression `sequence = iterable`,
 * we use two synthetic nodes:
 *
 * - `TIterableSequence(sequence)` which captures the content-modeling the entire `sequence` will have
 * (essentially just a copy of the content-modeling the RHS has)
 *
 * - `TIterableElement(sequence)` which captures the content-modeling that will be assigned to an element.
 * Note that an empty access path means that the value we are tracking flows directly to the element.
 *
 *
 * The `TIterableSequence(sequence)` is at this point superflous but becomes useful when handling recursive
 * structures in the LHS, where `sequence` is some internal sequence node. We can have a uniform treatment
 * by always having these two synthetic nodes. So we transfer to (or, in the recursive case, read into)
 * `TIterableSequence(sequence)`, from which we take a read step to `TIterableElement(sequence)` and then a
 * store step to `sequence`.
 *
 * This allows the unknown content from the RHS to be read into `TIterableElement(sequence)` and tuple content
 * to then be stored into `sequence`. If the content is already tuple content, this inderection creates crosstalk
 * between indices. Therefore, tuple content is never read into `TIterableElement(sequence)`; it is instead
 * transferred directly from `TIterableSequence(sequence)` to `sequence` via a flow step. Such a flow step will
 * also transfer other content, but only tuple content is further read from `sequence` into its elements.
 *
 * The strategy is then via several read-, store-, and flow steps:
 * 1. a) [Flow] Content is transferred from `iterable` to `TIterableSequence(sequence)` via a
 *    flow step. From here, everything happens on the LHS.
 *
 *    b) [Read] If the unpacking happens inside a for as in
 *    ```python
 *       for sequence in iterable
 *    ```
 *    then content is read from `iterable` to `TIterableSequence(sequence)`.
 *
 * 2. [Flow] Content is transferred from `TIterableSequence(sequence)` to `sequence` via a
 *    flow step. (Here only tuple content is relevant.)
 *
 * 3. [Read] Content is read from `TIterableSequence(sequence)` into  `TIterableElement(sequence)`.
 *    As `sequence` is modeled as a tuple, we will not read tuple content as that would allow
 *    crosstalk.
 *
 * 4. [Store] Content is stored from `TIterableElement(sequence)` to `sequence`.
 *    Content type is `TupleElementContent` with indices taken from the syntax.
 *    For instance, if `sequence` is `(a, *b, c)`, content is written to index 0, 1, and 2.
 *    This is adequate as the route through `TIterableElement(sequence)` does not transfer precise content.
 *
 * 5. [Read] Content is read from `sequence` to its elements.
 *    a) If the element is a plain variable, the target is the corresponding essa node.
 *
 *    b) If the element is itself a sequence, with control-flow node `seq`, the target is `TIterableSequence(seq)`.
 *
 *    c) If the element is a starred variable, with control-flow node `v`, the target is `TIterableElement(v)`.
 *
 * 6. [Store] Content is stored from `TIterableElement(v)` to the essa variable for `v`, with
 *    content type `ListElementContent`.
 *
 * 7. [Flow, Read, Store] Steps 2 through 7 are repeated for all recursive elements which are sequences.
 *
 *
 * We illustrate the above steps on the assignment
 *
 * ```python
 * (a, b) = ["a", SOURCE]
 * ```
 *
 * Looking at the content propagation to `a`:
 *   `["a", SOURCE]`: [ListElementContent]
 *
 * --Step 1a-->
 *
 *   `TIterableSequence((a, b))`: [ListElementContent]
 *
 * --Step 3-->
 *
 *   `TIterableElement((a, b))`: []
 *
 * --Step 4-->
 *
 *   `(a, b)`: [TupleElementContent(0)]
 *
 * --Step 5a-->
 *
 *   `a`: []
 *
 * Meaning there is data-flow from the RHS to `a` (an over approximation). The same logic would be applied to show there is data-flow to `b`. Note that _Step 3_ and _Step 4_ would not have been needed if the RHS had been a tuple (since that would have been able to use _Step 2_ instead).
 *
 * Another, more complicated example:
 * ```python
 *   (a, [b, *c]) = ["a", [SOURCE]]
 * ```
 * where the path to `c` is
 *
 *   `["a", [SOURCE]]`: [ListElementContent; ListElementContent]
 *
 * --Step 1a-->
 *
 *   `TIterableSequence((a, [b, *c]))`: [ListElementContent; ListElementContent]
 *
 * --Step 3-->
 *
 *   `TIterableElement((a, [b, *c]))`: [ListElementContent]
 *
 * --Step 4-->
 *
 *   `(a, [b, *c])`: [TupleElementContent(1); ListElementContent]
 *
 * --Step 5b-->
 *
 *   `TIterableSequence([b, *c])`: [ListElementContent]
 *
 * --Step 3-->
 *
 *   `TIterableElement([b, *c])`: []
 *
 * --Step 4-->
 *
 *   `[b, *c]`: [TupleElementContent(1)]
 *
 * --Step 5c-->
 *
 *   `TIterableElement(c)`: []
 *
 * --Step 6-->
 *
 *  `c`: [ListElementContent]
 */
module IterableUnpacking {
  /**
   * The target of a `for`, e.g. `x` in `for x in list` or in `[42 for x in list]`.
   * This class also records the source, which in both above cases is `list`.
   * This class abstracts away the differing representations of comprehensions and
   * for statements.
   */
  class ForTarget extends ControlFlowNode {
    Expr source;

    ForTarget() {
      exists(For for |
        source = for.getIter() and
        this.getNode() = for.getTarget() and
        not for = any(Comp comp).getNthInnerLoop(0)
      )
      or
      exists(Comp comp |
        source = comp.getIterable() and
        this.getNode() = comp.getNthInnerLoop(0).getTarget()
      )
    }

    Expr getSource() { result = source }
  }

  /** The LHS of an assignment, it also records the assigned value. */
  class AssignmentTarget extends ControlFlowNode {
    Expr value;

    AssignmentTarget() {
      exists(Assign assign | this.getNode() = assign.getATarget() | value = assign.getValue())
    }

    Expr getValue() { result = value }
  }

  /** A direct (or top-level) target of an unpacking assignment. */
  class UnpackingAssignmentDirectTarget extends ControlFlowNode {
    Expr value;

    UnpackingAssignmentDirectTarget() {
      this instanceof SequenceNode and
      (
        value = this.(AssignmentTarget).getValue()
        or
        value = this.(ForTarget).getSource()
      )
    }

    Expr getValue() { result = value }
  }

  /** A (possibly recursive) target of an unpacking assignment. */
  class UnpackingAssignmentTarget extends ControlFlowNode {
    UnpackingAssignmentTarget() {
      this instanceof UnpackingAssignmentDirectTarget
      or
      this = any(UnpackingAssignmentSequenceTarget parent).getAnElement()
    }
  }

  /** A (possibly recursive) target of an unpacking assignment which is also a sequence. */
  class UnpackingAssignmentSequenceTarget extends UnpackingAssignmentTarget {
    UnpackingAssignmentSequenceTarget() { this instanceof SequenceNode }

    ControlFlowNode getElement(int i) { result = this.(SequenceNode).getElement(i) }

    ControlFlowNode getAnElement() { result = this.getElement(_) }
  }

  /**
   * Step 1a
   * Data flows from `iterable` to `TIterableSequence(sequence)`
   */
  predicate iterableUnpackingAssignmentFlowStep(Node nodeFrom, Node nodeTo) {
    exists(AssignmentTarget target |
      nodeFrom.asExpr() = target.getValue() and
      nodeTo = TIterableSequenceNode(target)
    )
  }

  /**
   * Step 1b
   * Data is read from `iterable` to `TIterableSequence(sequence)`
   */
  predicate iterableUnpackingForReadStep(CfgNode nodeFrom, Content c, Node nodeTo) {
    exists(ForTarget target |
      nodeFrom.asExpr() = target.getSource() and
      target instanceof SequenceNode and
      nodeTo = TIterableSequenceNode(target)
    ) and
    (
      c instanceof ListElementContent
      or
      c instanceof SetElementContent
    )
  }

  /**
   * Step 2
   * Data flows from `TIterableSequence(sequence)` to `sequence`
   */
  predicate iterableUnpackingTupleFlowStep(Node nodeFrom, Node nodeTo) {
    exists(UnpackingAssignmentSequenceTarget target |
      nodeFrom = TIterableSequenceNode(target) and
      nodeTo.asCfgNode() = target
    )
  }

  /**
   * Step 3
   * Data flows from `TIterableSequence(sequence)` into  `TIterableElement(sequence)`.
   * As `sequence` is modeled as a tuple, we will not read tuple content as that would allow
   * crosstalk.
   */
  predicate iterableUnpackingConvertingReadStep(Node nodeFrom, Content c, Node nodeTo) {
    exists(UnpackingAssignmentSequenceTarget target |
      nodeFrom = TIterableSequenceNode(target) and
      nodeTo = TIterableElementNode(target) and
      (
        c instanceof ListElementContent
        or
        c instanceof SetElementContent
        // TODO: dict content in iterable unpacking not handled
      )
    )
  }

  /**
   * Step 4
   * Data flows from `TIterableElement(sequence)` to `sequence`.
   * Content type is `TupleElementContent` with indices taken from the syntax.
   * For instance, if `sequence` is `(a, *b, c)`, content is written to index 0, 1, and 2.
   */
  predicate iterableUnpackingConvertingStoreStep(Node nodeFrom, Content c, Node nodeTo) {
    exists(UnpackingAssignmentSequenceTarget target |
      nodeFrom = TIterableElementNode(target) and
      nodeTo.asCfgNode() = target and
      exists(int index | exists(target.getElement(index)) |
        c.(TupleElementContent).getIndex() = index
      )
    )
  }

  /**
   * Step 5
   * For a sequence node inside an iterable unpacking, data flows from the sequence to its elements. There are
   * three cases for what `toNode` should be:
   *    a) If the element is a plain variable, `toNode` is the corresponding essa node.
   *
   *    b) If the element is itself a sequence, with control-flow node `seq`, `toNode` is `TIterableSequence(seq)`.
   *
   *    c) If the element is a starred variable, with control-flow node `v`, `toNode` is `TIterableElement(v)`.
   */
  predicate iterableUnpackingElementReadStep(Node nodeFrom, Content c, Node nodeTo) {
    exists(
      UnpackingAssignmentSequenceTarget target, int index, ControlFlowNode element, int starIndex
    |
      target.getElement(starIndex) instanceof StarredNode
      or
      not exists(target.getAnElement().(StarredNode)) and
      starIndex = -1
    |
      nodeFrom.asCfgNode() = target and
      element = target.getElement(index) and
      (
        if starIndex = -1 or index < starIndex
        then c.(TupleElementContent).getIndex() = index
        else
          // This could get big if big tuples exist
          if index = starIndex
          then c.(TupleElementContent).getIndex() >= index
          else c.(TupleElementContent).getIndex() >= index - 1
      ) and
      (
        if element instanceof SequenceNode
        then
          // Step 5b
          nodeTo = TIterableSequenceNode(element)
        else
          if element instanceof StarredNode
          then
            // Step 5c
            nodeTo = TIterableElementNode(element)
          else
            // Step 5a
            nodeTo.asVar().getDefinition().(MultiAssignmentDefinition).getDefiningNode() = element
      )
    )
  }

  /**
   * Step 6
   * Data flows from `TIterableElement(v)` to the essa variable for `v`, with
   * content type `ListElementContent`.
   */
  predicate iterableUnpackingStarredElementStoreStep(Node nodeFrom, Content c, Node nodeTo) {
    exists(ControlFlowNode starred | starred.getNode() instanceof Starred |
      nodeFrom = TIterableElementNode(starred) and
      nodeTo.asVar().getDefinition().(MultiAssignmentDefinition).getDefiningNode() = starred and
      c instanceof ListElementContent
    )
  }

  /** All read steps associated with unpacking assignment. */
  predicate iterableUnpackingReadStep(Node nodeFrom, Content c, Node nodeTo) {
    iterableUnpackingForReadStep(nodeFrom, c, nodeTo)
    or
    iterableUnpackingElementReadStep(nodeFrom, c, nodeTo)
    or
    iterableUnpackingConvertingReadStep(nodeFrom, c, nodeTo)
  }

  /** All store steps associated with unpacking assignment. */
  predicate iterableUnpackingStoreStep(Node nodeFrom, Content c, Node nodeTo) {
    iterableUnpackingStarredElementStoreStep(nodeFrom, c, nodeTo)
    or
    iterableUnpackingConvertingStoreStep(nodeFrom, c, nodeTo)
  }

  /** All flow steps associated with unpacking assignment. */
  predicate iterableUnpackingFlowStep(Node nodeFrom, Node nodeTo) {
    iterableUnpackingAssignmentFlowStep(nodeFrom, nodeTo)
    or
    iterableUnpackingTupleFlowStep(nodeFrom, nodeTo)
  }
}

import IterableUnpacking

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

predicate forReadStep(CfgNode nodeFrom, Content c, Node nodeTo) {
  exists(ForTarget target |
    nodeFrom.asExpr() = target.getSource() and
    nodeTo.asVar().(EssaNodeDefinition).getDefiningNode() = target
  ) and
  (
    c instanceof ListElementContent
    or
    c instanceof SetElementContent
    or
    c = small_tuple()
  )
}

pragma[noinline]
TupleElementContent small_tuple() { result.getIndex() <= 7 }

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
    nodeTo = TKwUnpackedNode(call, callable, name) and
    name = c.getKey()
  )
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`. For example,
 * any value stored inside `f` is cleared at the pre-update node associated with `x`
 * in `x.f = newValue`.
 */
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

class LambdaCallKind = Unit;

/** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) { none() }

/** Holds if `call` is a lambda call of kind `kind` where `receiver` is the lambda expression. */
predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) { none() }

/** Extra data-flow steps needed for lambda flow analysis. */
predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }
