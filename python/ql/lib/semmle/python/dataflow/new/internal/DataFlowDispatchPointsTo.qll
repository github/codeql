/**
 * INTERNAL: Do not use.
 *
 * Points-to based call-graph.
 */

private import python
private import DataFlowPublic
private import semmle.python.SpecialMethods

/** A parameter position represented by an integer. */
class ParameterPosition extends int {
  ParameterPosition() { exists(any(DataFlowCallable c).getParameter(this)) }
}

/** An argument position represented by an integer. */
class ArgumentPosition extends int {
  ArgumentPosition() { exists(any(DataFlowCall c).getArg(this)) }
}

/** Holds if arguments at position `apos` match parameters at position `ppos`. */
pragma[inline]
predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) { ppos = apos }

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
 * will be modeled as
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
 * no tuple argument is synthesized. It is modeled as
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

/** A callable. */
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

  override CallNode getACall() { result = this.getCallableValue().getACall() }

  override Scope getScope() { result = lambda.getEvaluatingScope() }

  override NameNode getParameter(int n) { result = getParameter(this.getCallableValue(), n) }

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
  TClassCall(CallNode call) { call = any(ClassValue c | not c.isAbsent()).getACall() } or
  TSpecialCall(SpecialMethodCallNode special)

/** A call. */
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
 * A call to a function/lambda.
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

/** A call to a special method. */
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
