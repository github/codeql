/**
 * INTERNAL: Do not use.
 *
 * Points-to based call-graph.
 */

private import python
private import DataFlowPublic
private import semmle.python.SpecialMethods
private import FlowSummaryImpl as FlowSummaryImpl

/** A parameter position represented by an integer. */
class ParameterPosition extends int {
  ParameterPosition() { exists(any(DataFlowCallable c).getParameter(this)) }

  /** Holds if this position represents a positional parameter at position `pos`. */
  predicate isPositional(int pos) { this = pos } // with the current representation, all parameters are positional
}

/** An argument position represented by an integer. */
class ArgumentPosition extends int {
  ArgumentPosition() { this in [-3, -2, -1] or exists(any(Call c).getArg(this)) }

  /** Holds if this position represents a positional argument at position `pos`. */
  predicate isPositional(int pos) { this = pos } // with the current representation, all arguments are positional
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
    exists(NormalCall c |
      call = c.getNode() and
      callable = c.getCallable().getCallableValue()
    )
  }

  private import semmle.python.essa.SsaCompute

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
    or
    // captured variable
    exists(string name, ScopeEntryDefinition def |
      captures_variable(callable, name, def) and
      // TODO: handle more than one captured variable
      n = -3 and
      result.getId() = name and
      AdjacentUses::firstUse(def.(EssaVariable).getDefinition(), result)
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
   * at an index, `argN`, in `call` which satisfies `paramN = mapping.getParamN(argN)`.
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
      // a synthesized argument passed to the starred parameter (at position -1)
      callable.getScope().hasVarArg() and
      paramN = -1 and
      result = TPosOverflowNode(call, callable)
      or
      // a synthesized argument passed to the doubly starred parameter (at position -2)
      callable.getScope().hasKwArg() and
      paramN = -2 and
      result = TKwOverflowNode(call, callable)
      or
      // argument unpacked from dict
      exists(string name |
        call_unpacks(call, mapping, callable, name, paramN) and
        result = TKwUnpackedNode(call, callable, name)
      )
      or
      // captured variable
      exists(string name, ScopeEntryDefinition def, NameNode var |
        captures_variable(callable, name, def) and
        // TODO: handle more than one captured variable
        paramN = -3 and
        var.getId() = name and
        result = TCfgNode(var) and
        var.getBasicBlock() = call.getBasicBlock()
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

  predicate captures_variable(CallableValue callable, string name, ScopeEntryDefinition def) {
    def.(EssaVariable).getSourceVariable().getName() = name and
    def.getScope() = callable.getScope() and
    not def instanceof GlobalSsaVariable and
    not def.(EssaVariable).isMetaVariable()
  }
}

import ArgumentPassing

/** A callable defined in library code, identified by a unique string. */
abstract class LibraryCallable extends string {
  bindingset[this]
  LibraryCallable() { any() }

  /** Gets a call to this library callable. */
  abstract CallCfgNode getACall();

  /** Gets a data-flow node, where this library callable is used as a call-back. */
  abstract ArgumentNode getACallback();
}

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
  TModule(Module m) or
  TLibraryCallable(LibraryCallable callable)

/** A callable. */
class DataFlowCallable extends TDataFlowCallable {
  /** Gets a textual representation of this element. */
  string toString() { result = "DataFlowCallable" }

  /** Gets a call to this callable. */
  CallNode getACall() { none() }

  /** Gets the scope of this callable */
  Scope getScope() { none() }

  /** Gets the specified parameter of this callable */
  NameNode getParameter(int n) { none() }

  /** Gets the name of this callable. */
  string getName() { none() }

  /** Gets a callable value for this callable, if any. */
  CallableValue getCallableValue() { none() }

  /** Gets the underlying library callable, if any. */
  LibraryCallable asLibraryCallable() { this = TLibraryCallable(result) }

  Location getLocation() { none() }
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

  Expr getDefinition() { result = lambda.getDefinition() }
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

class LibraryCallableValue extends DataFlowCallable, TLibraryCallable {
  LibraryCallable callable;

  LibraryCallableValue() { this = TLibraryCallable(callable) }

  override string toString() { result = callable.toString() }

  override CallNode getACall() { result = callable.getACall().getNode() }

  /** Gets a data-flow node, where this library callable is used as a call-back. */
  ArgumentNode getACallback() { result = callable.getACallback() }

  override Scope getScope() { none() }

  override NameNode getParameter(int n) { none() }

  override string getName() { result = callable }

  override LibraryCallable asLibraryCallable() { result = callable }
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
  /**
   * Includes function calls, method calls, class calls and library calls.
   * All these will be associated with a `CallNode`.
   */
  TNormalCall(CallNode call) or
  /**
   * Includes calls to special methods.
   * These will be associated with a `SpecialMethodCallNode`.
   */
  TSpecialCall(SpecialMethodCallNode special) or
  /** A synthesized call inside a summarized callable */
  TSummaryCall(FlowSummaryImpl::Public::SummarizedCallable c, Node receiver) {
    FlowSummaryImpl::Private::summaryCallbackRange(c, receiver)
  }

/** A call found in the program source (as opposed to a synthesised summary call). */
class TExtractedDataFlowCall = TSpecialCall or TNormalCall;

/** A call that is taken into account by the global data flow computation. */
abstract class DataFlowCall extends TDataFlowCall {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Get the callable to which this call goes, if such exists. */
  abstract DataFlowCallable getCallable();

  /**
   * Gets the argument to this call that will be sent
   * to the `n`th parameter of the callable, if any.
   */
  abstract Node getArg(int n);

  /** Get the control flow node representing this call, if any. */
  abstract ControlFlowNode getNode();

  /** Gets the enclosing callable of this call. */
  abstract DataFlowCallable getEnclosingCallable();

  /** Gets the location of this dataflow call. */
  abstract Location getLocation();

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
}

/** A call found in the program source (as opposed to a synthesised call). */
abstract class ExtractedDataFlowCall extends DataFlowCall, TExtractedDataFlowCall {
  final override Location getLocation() { result = this.getNode().getLocation() }

  abstract override DataFlowCallable getCallable();

  abstract override Node getArg(int n);

  abstract override ControlFlowNode getNode();
}

/** A call associated with a `CallNode`. */
class NormalCall extends ExtractedDataFlowCall, TNormalCall {
  CallNode call;

  NormalCall() { this = TNormalCall(call) }

  override string toString() { result = call.toString() }

  abstract override Node getArg(int n);

  override CallNode getNode() { result = call }

  abstract override DataFlowCallable getCallable();

  override DataFlowCallable getEnclosingCallable() { result.getScope() = call.getNode().getScope() }
}

/**
 * A call to a function.
 * This excludes calls to bound methods, classes, and special methods.
 * Bound method calls and class calls insert an argument for the explicit
 * `self` parameter, and special method calls have special argument passing.
 */
class FunctionCall extends NormalCall {
  DataFlowCallableValue callable;

  FunctionCall() {
    call = any(FunctionValue f).getAFunctionCall() and
    call = callable.getACall()
  }

  override Node getArg(int n) { result = getArg(call, TNoShift(), callable.getCallableValue(), n) }

  override DataFlowCallable getCallable() { result = callable }
}

/** A call to a lambda. */
class LambdaCall extends NormalCall {
  DataFlowLambda callable;

  LambdaCall() {
    call = callable.getACall() and
    callable = TLambda(any(Function f))
  }

  override Node getArg(int n) { result = getArg(call, TNoShift(), callable.getCallableValue(), n) }

  override DataFlowCallable getCallable() { result = callable }
}

/**
 * Represents a call to a bound method call.
 * The node representing the instance is inserted as argument to the `self` parameter.
 */
class MethodCall extends NormalCall {
  FunctionValue bm;

  MethodCall() { call = bm.getAMethodCall() }

  private CallableValue getCallableValue() { result = bm }

  override Node getArg(int n) {
    n > 0 and result = getArg(call, TShiftOneUp(), this.getCallableValue(), n)
    or
    n = 0 and result = TCfgNode(call.getFunction().(AttrNode).getObject())
  }

  override DataFlowCallable getCallable() { result = TCallableValue(this.getCallableValue()) }
}

/**
 * Represents a call to a class.
 * The pre-update node for the call is inserted as argument to the `self` parameter.
 * That makes the call node be the post-update node holding the value of the object
 * after the constructor has run.
 */
class ClassCall extends NormalCall {
  ClassValue c;

  ClassCall() {
    not c.isAbsent() and
    call = c.getACall()
  }

  private CallableValue getCallableValue() { c.getScope().getInitMethod() = result.getScope() }

  override Node getArg(int n) {
    n > 0 and result = getArg(call, TShiftOneUp(), this.getCallableValue(), n)
    or
    n = 0 and result = TSyntheticPreUpdateNode(TCfgNode(call))
  }

  override DataFlowCallable getCallable() { result = TCallableValue(this.getCallableValue()) }
}

/** A call to a special method. */
class SpecialCall extends ExtractedDataFlowCall, TSpecialCall {
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

/**
 * A call to a summarized callable, a `LibraryCallable`.
 *
 * We currently exclude all resolved calls. This means that a call to, say, `map`, which
 * is a `ClassCall`, cannot currently be given a summary.
 * We hope to lift this restriction in the future and include all potential calls to summaries
 * in this class.
 */
class LibraryCall extends NormalCall {
  LibraryCall() {
    // TODO: share this with `resolvedCall`
    not (
      call = any(DataFlowCallableValue cv).getACall()
      or
      call = any(DataFlowLambda l).getACall()
      or
      // TODO: this should be covered by `DataFlowCallableValue`, but a `ClassValue` is not a `CallableValue`.
      call = any(ClassValue c).getACall()
    )
  }

  // TODO: Implement Python calling convention?
  override Node getArg(int n) { result = TCfgNode(call.getArg(n)) }

  // We cannot refer to a `LibraryCallable` here,
  // as that could in turn refer to type tracking.
  // This call will be tied to a `LibraryCallable` via
  // `getViableCallabe` when the global data flow is assembled.
  override DataFlowCallable getCallable() { none() }
}

/**
 * A synthesized call inside a callable with a flow summary.
 *
 * For example, in
 * ```python
 * map(lambda x: x + 1, [1, 2, 3])
 * ```
 *
 * there is a synthesized call to the lambda argument inside `map`.
 */
class SummaryCall extends DataFlowCall, TSummaryCall {
  private FlowSummaryImpl::Public::SummarizedCallable c;
  private Node receiver;

  SummaryCall() { this = TSummaryCall(c, receiver) }

  /** Gets the data flow node that this call targets. */
  Node getReceiver() { result = receiver }

  override DataFlowCallable getEnclosingCallable() { result.asLibraryCallable() = c }

  override DataFlowCallable getCallable() { none() }

  override Node getArg(int n) { none() }

  override ControlFlowNode getNode() { none() }

  override string toString() { result = "[summary] call to " + receiver + " in " + c }

  override Location getLocation() { none() }
}

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph.
 */
abstract class ParameterNodeImpl extends Node {
  abstract Parameter getParameter();

  /**
   * Holds if this node is the parameter of callable `c` at the
   * (zero-based) index `i`.
   */
  abstract predicate isParameterOf(DataFlowCallable c, int i);
}

class CapturedParameterNode extends ParameterNodeImpl, TCapturedParameterNode {
  CallableValue callable;
  string name;
  ScopeEntryDefinition def;

  CapturedParameterNode() { this = TCapturedParameterNode(callable, name, def) }

  override Parameter getParameter() { none() }

  override predicate isParameterOf(DataFlowCallable c, int i) {
    c = TCallableValue(callable) and i = -3
  }

  override DataFlowCallable getEnclosingCallable() { result = TCallableValue(callable) }

  override string toString() { result = "captured parameter " + name + " of " + callable }
}

/** A parameter for a library callable with a flow summary. */
class SummaryParameterNode extends ParameterNodeImpl, TSummaryParameterNode {
  private FlowSummaryImpl::Public::SummarizedCallable sc;
  private int pos;

  SummaryParameterNode() { this = TSummaryParameterNode(sc, pos) }

  override Parameter getParameter() { none() }

  override predicate isParameterOf(DataFlowCallable c, int i) {
    sc = c.asLibraryCallable() and i = pos
  }

  override DataFlowCallable getEnclosingCallable() { result.asLibraryCallable() = sc }

  override string toString() { result = "parameter " + pos + " of " + sc }

  // Hack to return "empty location"
  override predicate hasLocationInfo(
    string file, int startline, int startcolumn, int endline, int endcolumn
  ) {
    file = "" and
    startline = 0 and
    startcolumn = 0 and
    endline = 0 and
    endcolumn = 0
  }
}

/** A data-flow node used to model flow summaries. */
class SummaryNode extends Node, TSummaryNode {
  private FlowSummaryImpl::Public::SummarizedCallable c;
  private FlowSummaryImpl::Private::SummaryNodeState state;

  SummaryNode() { this = TSummaryNode(c, state) }

  override DataFlowCallable getEnclosingCallable() { result.asLibraryCallable() = c }

  override string toString() { result = "[summary] " + state + " in " + c }

  // Hack to return "empty location"
  override predicate hasLocationInfo(
    string file, int startline, int startcolumn, int endline, int endcolumn
  ) {
    file = "" and
    startline = 0 and
    startcolumn = 0 and
    endline = 0 and
    endcolumn = 0
  }
}

private class SummaryReturnNode extends SummaryNode, ReturnNode {
  private ReturnKind rk;

  SummaryReturnNode() { FlowSummaryImpl::Private::summaryReturnNode(this, rk) }

  override ReturnKind getKind() { result = rk }
}

private class SummaryArgumentNode extends SummaryNode, ArgumentNode {
  SummaryArgumentNode() { FlowSummaryImpl::Private::summaryArgumentNode(_, this, _) }

  override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
    FlowSummaryImpl::Private::summaryArgumentNode(call, this, pos)
  }
}

private class SummaryPostUpdateNode extends SummaryNode, PostUpdateNode {
  private Node pre;

  SummaryPostUpdateNode() { FlowSummaryImpl::Private::summaryPostUpdateNode(this, pre) }

  override Node getPreUpdateNode() { result = pre }
}

/** Gets a viable run-time target for the call `call`. */
DataFlowCallable viableCallable(ExtractedDataFlowCall call) {
  result = call.getCallable()
  or
  // A call to a library callable with a flow summary
  // In this situation we can not resolve the callable from the call,
  // as that would make data flow depend on type tracking.
  // Instead we resolve the call from the summary.
  exists(LibraryCallable callable |
    result = TLibraryCallable(callable) and
    call.getNode() = callable.getACall().getNode()
  )
}

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
abstract class ReturnNode extends Node {
  /** Gets the kind of this return node. */
  ReturnKind getKind() { any() }
}

/** A data flow node that represents a value returned by a callable. */
class ExtractedReturnNode extends ReturnNode, CfgNode {
  // See `TaintTrackingImplementation::returnFlowStep`
  ExtractedReturnNode() { node = any(Return ret).getValue().getAFlowNode() }

  override ReturnKind getKind() { any() }
}

/** A data-flow node that represents the output of a call. */
abstract class OutNode extends Node {
  /** Gets the underlying call, where this node is a corresponding output of kind `kind`. */
  abstract DataFlowCall getCall(ReturnKind kind);
}

private module OutNodes {
  /**
   * A data-flow node that reads a value returned directly by a callable.
   */
  class ExprOutNode extends OutNode, ExprNode {
    private DataFlowCall call;

    ExprOutNode() { call.(ExtractedDataFlowCall).getNode() = this.getNode() }

    override DataFlowCall getCall(ReturnKind kind) {
      result = call and
      kind = kind
    }
  }

  private class SummaryOutNode extends SummaryNode, OutNode {
    SummaryOutNode() { FlowSummaryImpl::Private::summaryOutNode(_, this, _) }

    override DataFlowCall getCall(ReturnKind kind) {
      FlowSummaryImpl::Private::summaryOutNode(result, this, kind)
    }
  }
}

/**
 * Gets a node that can read the value returned from `call` with return kind
 * `kind`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) { call = result.getCall(kind) }
