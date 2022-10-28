/**
 * INTERNAL: Do not use.
 *
 * TypeTracker based call-graph.
 *
 * A goal of this library is to support modeling calls that happens by third-party
 * libraries. For example `call_later(func, arg0, arg1, foo=val)`, and the fact that the
 * library might inject it's own arguments, for example a context that will always be
 * passed as the actual first argument to the function. Currently the aim is to provide
 * enough predicates for such `call_later` function to be modeled by providing
 * additional data-flow steps for the arguments/parameters. This means we cannot have
 * any special logic that requires an AST call to be made before we care to figure out
 * what callable this call might end up targeting.
 */

private import python
private import DataFlowPublic
private import FlowSummaryImpl as FlowSummaryImpl

/** A parameter position. */
class ParameterPosition extends Unit {
  // TODO(call-graph): implement this!
}

/** An argument position. */
abstract class ArgumentPosition extends Unit {
  // TODO(call-graph): implement this!
}

/** Holds if arguments at position `apos` match parameters at position `ppos`. */
pragma[inline]
predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) {
  // TODO(call-graph): implement this!
  none()
}

/** A callable defined in library code, identified by a unique string. */
abstract class LibraryCallable extends string {
  bindingset[this]
  LibraryCallable() { any() }

  /** Gets a call to this library callable. */
  abstract CallCfgNode getACall();

  /** Gets a data-flow node, where this library callable is used as a call-back. */
  abstract ArgumentNode getACallback();
}

newtype TDataFlowCallable =
  // TODO(call-graph): implement this!
  /** For enclosing `ModuleVariableNode`s -- don't actually have calls. */
  TModule(Module m) or
  TLibraryCallable(LibraryCallable callable)

/** A callable. */
abstract class DataFlowCallable extends TDataFlowCallable {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Gets the scope of this callable */
  abstract Scope getScope();

  /** Gets the parameter at position `ppos`, if any. */
  abstract ParameterNode getParameter(ParameterPosition ppos);

  /** Gets the underlying library callable, if any. */
  LibraryCallable asLibraryCallable() { this = TLibraryCallable(result) }

  /** Gets the location of this dataflow callable. */
  abstract Location getLocation();
}

/**
 * A module. This is not actually a callable, but we need this so a
 * `ModuleVariableNode` have an enclosing callable.
 */
class DataFlowModuleScope extends DataFlowCallable, TModule {
  Module mod;

  DataFlowModuleScope() { this = TModule(mod) }

  override string toString() { result = mod.toString() }

  override Module getScope() { result = mod }

  override Location getLocation() { result = mod.getLocation() }

  override ParameterNode getParameter(ParameterPosition ppos) { none() }
}

class LibraryCallableValue extends DataFlowCallable, TLibraryCallable {
  LibraryCallable callable;

  LibraryCallableValue() { this = TLibraryCallable(callable) }

  override string toString() { result = callable.toString() }

  /** Gets a data-flow node, where this library callable is used as a call-back. */
  ArgumentNode getACallback() { result = callable.getACallback() }

  override Scope getScope() { none() }

  override ParameterNode getParameter(ParameterPosition ppos) { none() }

  override LibraryCallable asLibraryCallable() { result = callable }

  override Location getLocation() { none() }
}

newtype TDataFlowCall =
  // TODO(call-graph): implement this!
  MkDataFlowCall() or
  /** A synthesized call inside a summarized callable */
  TSummaryCall(FlowSummaryImpl::Public::SummarizedCallable c, Node receiver) {
    FlowSummaryImpl::Private::summaryCallbackRange(c, receiver)
  }

/** A call that is taken into account by the global data flow computation. */
abstract class DataFlowCall extends TDataFlowCall {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Get the callable to which this call goes. */
  abstract DataFlowCallable getCallable();

  /** Gets the argument at position `apos`, if any. */
  abstract ArgumentNode getArgument(ArgumentPosition apos);

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
abstract class ExtractedDataFlowCall extends DataFlowCall {
  ExtractedDataFlowCall() { exists(this.getNode()) }

  override Location getLocation() { result = this.getNode().getLocation() }
}

/**
 * A call to a summarized callable, a `LibraryCallable`.
 *
 * We currently exclude all resolved calls. This means that a call to, say, `map`, which
 * is a `ClassCall`, cannot currently be given a summary.
 * We hope to lift this restriction in the future and include all potential calls to summaries
 * in this class.
 */
class LibraryCall extends DataFlowCall {
  LibraryCall() {
    // TODO(call-graph): implement this!
    none()
  }

  override string toString() {
    // TODO(call-graph): implement this!
    none()
  }

  // We cannot refer to a `LibraryCallable` here,
  // as that could in turn refer to type tracking.
  // This call will be tied to a `LibraryCallable` via
  // `getViableCallabe` when the global data flow is assembled.
  override DataFlowCallable getCallable() { none() }

  override ArgumentNode getArgument(ArgumentPosition apos) {
    // TODO(call-graph): implement this!
    none()
  }

  override ControlFlowNode getNode() {
    // TODO(call-graph): implement this!
    none()
  }

  override DataFlowCallable getEnclosingCallable() {
    // TODO(call-graph): implement this!
    none()
  }

  override Location getLocation() {
    // TODO(call-graph): implement this!
    none()
  }
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

  override ArgumentNode getArgument(ArgumentPosition apos) { none() }

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
   * position `ppos`.
   */
  abstract predicate isParameterOf(DataFlowCallable c, ParameterPosition ppos);
}

/** A parameter for a library callable with a flow summary. */
class SummaryParameterNode extends ParameterNodeImpl, TSummaryParameterNode {
  private FlowSummaryImpl::Public::SummarizedCallable sc;
  private ParameterPosition pos;

  SummaryParameterNode() { this = TSummaryParameterNode(sc, pos) }

  override Parameter getParameter() { none() }

  override predicate isParameterOf(DataFlowCallable c, ParameterPosition ppos) {
    sc = c.asLibraryCallable() and ppos = pos
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
