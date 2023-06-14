/**
 * # Python Taint Tracking Library
 *
 * The taint tracking library is described in three parts.
 *
 * 1. Specification of kinds, sources, sinks and flows.
 * 2. The high level query API
 * 3. The implementation.
 *
 *
 * ## Specification
 *
 * There are four parts to the specification of a taint tracking query.
 * These are:
 *
 * 1. Kinds
 *
 *     The Python taint tracking library supports arbitrary kinds of taint.
 *     This is useful where you want to track something related to "taint", but that is in itself not dangerous.
 *     For example, we might want to track the flow of request objects.
 *     Request objects are not in themselves tainted, but they do contain tainted data.
 *     For example, the length or timestamp of a request may not pose a risk, but the GET or POST string probably do.
 *     So, we would want to track request objects distinctly from the request data in the GET or POST field.
 *
 *     Kinds can also specify additional flow steps, but we recommend using the `DataFlowExtension` module,
 *     which is less likely to cause issues with unwanted recursion.
 *
 * 2. Sources
 *
 *     Sources of taint can be added by importing a predefined sub-type of `TaintSource`, or by defining new ones.
 *
 * 3. Sinks (or vulnerabilities)
 *
 *     Sinks can be added by importing a predefined sub-type of `TaintSink`, or by defining new ones.
 *
 * 4. Flow extensions
 *
 *    Additional flow can be added by importing predefined sub-types of `DataFlowExtension::DataFlowNode`
 *    or `DataFlowExtension::DataFlowVariable` or by defining new ones.
 *
 *
 * ## The high-level query API
 *
 * The `TaintedNode` fully describes the taint flow graph.
 * The full graph can be expressed as:
 *
 * ```ql
 * from TaintedNode n, TaintedNode s
 * where s = n.getASuccessor()
 * select n, s
 * ```
 *
 * The source -> sink relation can be expressed either using `TaintedNode`:
 * ```ql
 * from TaintedNode src, TaintedNode sink
 * where src.isSource() and sink.isSink() and src.getASuccessor*() = sink
 * select src, sink
 * ```
 * or, using the specification API:
 * ```ql
 * from TaintSource src, TaintSink sink
 * where src.flowsToSink(sink)
 * select src, sink
 * ```
 *
 * ## The implementation
 *
 * The data-flow graph used by the taint-tracking library is the one created by the points-to analysis,
 * and consists of the base data-flow graph defined in `semmle/python/essa/Essa.qll`
 * enhanced with precise variable flows, call graph and type information.
 * This graph is then enhanced with additional flows as specified above.
 * Since the call graph and points-to information is context sensitive, the taint graph must also be context sensitive.
 *
 * The taint graph is a directed graph where each node consists of a
 * `(CFG node, context, taint)` triple although it could be thought of more naturally
 * as a number of distinct graphs, one for each input taint-kind consisting of data flow nodes,
 * `(CFG node, context)` pairs, labelled with their `taint`.
 *
 * The `TrackedValue` used in the implementation is not the taint kind specified by the user,
 * but describes both the kind of taint and how that taint relates to any object referred to by a data-flow graph node or edge.
 * Currently, only two types of `taint` are supported: simple taint, where the object is actually tainted;
 * and attribute taint where a named attribute of the referred object is tainted.
 *
 * Support for tainted members (both specific members of tuples and the like,
 * and generic members for mutable collections) are likely to be added in the near future and other forms are possible.
 * The types of taints are hard-wired with no user-visible extension method at the moment.
 */

import python
private import semmle.python.pointsto.Filters as Filters
private import semmle.python.objects.ObjectInternal
private import semmle.python.dataflow.Implementation
import semmle.python.dataflow.Configuration

/**
 * A 'kind' of taint. This may be almost anything,
 * but it is typically something like a "user-defined string".
 * Examples include, data from a http request object,
 * data from an SMS or other mobile data source,
 * or, for a super secure system, environment variables or
 * the local file system.
 */
abstract class TaintKind extends string {
  bindingset[this]
  TaintKind() { any() }

  /**
   * Gets the kind of taint that the named attribute will have if an object is tainted with this taint.
   * In other words, if `x` has this kind of taint then it implies that `x.name`
   * has `result` kind of taint.
   */
  TaintKind getTaintOfAttribute(string name) { none() }

  /**
   * Gets the kind of taint results from calling the named method if an object is tainted with this taint.
   * In other words, if `x` has this kind of taint then it implies that `x.name()`
   * has `result` kind of taint.
   */
  TaintKind getTaintOfMethodResult(string name) { none() }

  /**
   * Gets the taint resulting from the flow step `fromnode` -> `tonode`.
   */
  TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) { none() }

  /**
   * Gets the taint resulting from the flow step `fromnode` -> `tonode`, with `edgeLabel`
   */
  TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode, string edgeLabel) {
    result = this.getTaintForFlowStep(fromnode, tonode) and
    edgeLabel = "custom taint flow step for " + this
  }

  /**
   * Holds if this kind of taint "taints" `expr`.
   */
  final predicate taints(ControlFlowNode expr) {
    exists(TaintedNode n | n.getTaintKind() = this and n.getCfgNode() = expr)
  }

  /**
   * Gets the class of this kind of taint.
   * For example, if this were a kind of string taint
   * the `result` would be `theStrType()`.
   */
  ClassValue getType() { none() }

  /**
   * Gets the boolean values (may be one, neither, or both) that
   * may result from the Python expression `bool(this)`
   */
  boolean booleanValue() {
    /*
     * Default to true as the vast majority of taint is strings and
     * the empty string is almost always benign.
     */

    result = true
  }

  string repr() { result = this }

  /**
   * Gets the taint resulting from iterating over this kind of taint.
   * For example iterating over a text file produces lines. So iterating
   * over a tainted file would result in tainted strings
   */
  TaintKind getTaintForIteration() { none() }

  predicate flowStep(DataFlow::Node fromnode, DataFlow::Node tonode, string edgeLabel) {
    exists(DataFlowExtension::DataFlowVariable v |
      v = fromnode.asVariable() and
      v.getASuccessorVariable() = tonode.asVariable()
    ) and
    edgeLabel = "custom taint variable step"
  }
}

/**
 * An Alias of `TaintKind`, so the two types can be used interchangeably.
 */
class FlowLabel = TaintKind;

/**
 * Taint kinds representing collections of other taint kind.
 * We use `{kind}` to represent a mapping of string to `kind` and
 * `[kind]` to represent a flat collection of `kind`.
 * The use of `{` and `[` is chosen to reflect dict and list literals
 * in Python. We choose a single character prefix and suffix for simplicity
 * and ease of preventing infinite recursion.
 */
abstract class CollectionKind extends TaintKind {
  bindingset[this]
  CollectionKind() {
    (this.charAt(0) = "[" or this.charAt(0) = "{") and
    /* Prevent any collection kinds more than 2 deep */
    not this.charAt(2) = "[" and
    not this.charAt(2) = "{"
  }

  abstract TaintKind getMember();

  abstract predicate flowFromMember(DataFlow::Node fromnode, DataFlow::Node tonode);

  abstract predicate flowToMember(DataFlow::Node fromnode, DataFlow::Node tonode);
}

/**
 * A taint kind representing a flat collections of kinds.
 * Typically a sequence, but can include sets.
 */
class SequenceKind extends CollectionKind {
  TaintKind itemKind;

  SequenceKind() { this = "[" + itemKind + "]" }

  TaintKind getItem() { result = itemKind }

  override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
    exists(BinaryExprNode mod |
      mod = tonode and
      mod.getOp() instanceof Mod and
      mod.getAnOperand() = fromnode and
      result = this.getItem() and
      result.getType() = ObjectInternal::builtin("str")
    )
  }

  override TaintKind getTaintOfMethodResult(string name) {
    name = "pop" and result = this.getItem()
  }

  override string repr() { result = "sequence of " + itemKind }

  override TaintKind getTaintForIteration() { result = itemKind }

  override TaintKind getMember() { result = itemKind }

  override predicate flowFromMember(DataFlow::Node fromnode, DataFlow::Node tonode) {
    sequence_construct(fromnode.asCfgNode(), tonode.asCfgNode())
  }

  override predicate flowToMember(DataFlow::Node fromnode, DataFlow::Node tonode) {
    SequenceKind::itemFlowStep(fromnode.asCfgNode(), tonode.asCfgNode())
  }
}

module SequenceKind {
  predicate flowStep(ControlFlowNode fromnode, ControlFlowNode tonode, string edgeLabel) {
    tonode.(BinaryExprNode).getAnOperand() = fromnode and edgeLabel = "binary operation"
    or
    Implementation::copyCall(fromnode, tonode) and
    edgeLabel = "dict copy"
    or
    sequence_call(fromnode, tonode) and edgeLabel = "sequence construction"
    or
    subscript_slice(fromnode, tonode) and edgeLabel = "slicing"
  }

  predicate itemFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
    subscript_index(fromnode, tonode)
  }
}

module DictKind {
  predicate flowStep(ControlFlowNode fromnode, ControlFlowNode tonode, string edgeLabel) {
    Implementation::copyCall(fromnode, tonode) and
    edgeLabel = "dict copy"
    or
    tonode.(CallNode).getFunction().pointsTo(ObjectInternal::builtin("dict")) and
    tonode.(CallNode).getArg(0) = fromnode and
    edgeLabel = "dict() call"
  }
}

/* Helper for sequence flow steps */
pragma[noinline]
private predicate subscript_index(ControlFlowNode obj, SubscriptNode sub) {
  sub.isLoad() and
  sub.getObject() = obj and
  not sub.getNode().getIndex() instanceof Slice
}

pragma[noinline]
private predicate subscript_slice(ControlFlowNode obj, SubscriptNode sub) {
  sub.isLoad() and
  sub.getObject() = obj and
  sub.getNode().getIndex() instanceof Slice
}

/**
 * A taint kind representing a mapping of objects to kinds.
 * Typically a dict, but can include other mappings.
 */
class DictKind extends CollectionKind {
  TaintKind valueKind;

  DictKind() { this = "{" + valueKind + "}" }

  TaintKind getValue() { result = valueKind }

  override TaintKind getTaintOfMethodResult(string name) {
    name = "get" and result = valueKind
    or
    name = "values" and result.(SequenceKind).getItem() = valueKind
    or
    name = "itervalues" and result.(SequenceKind).getItem() = valueKind
  }

  override string repr() { result = "dict of " + valueKind }

  override TaintKind getMember() { result = valueKind }

  override predicate flowFromMember(DataFlow::Node fromnode, DataFlow::Node tonode) {
    dict_construct(fromnode.asCfgNode(), tonode.asCfgNode())
  }

  override predicate flowToMember(DataFlow::Node fromnode, DataFlow::Node tonode) {
    subscript_index(fromnode.asCfgNode(), tonode.asCfgNode())
  }
}

/**
 * A type of sanitizer of untrusted data.
 * Examples include sanitizers for http responses, for DB access or for shell commands.
 * Usually a sanitizer can only sanitize data for one particular use.
 * For example, a sanitizer for DB commands would not be safe to use for http responses.
 */
abstract class Sanitizer extends string {
  bindingset[this]
  Sanitizer() { any() }

  /** Holds if `taint` cannot flow through `node`. */
  predicate sanitizingNode(TaintKind taint, ControlFlowNode node) { none() }

  /** Holds if `call` removes the `taint` */
  predicate sanitizingCall(TaintKind taint, FunctionObject callee) { none() }

  /** Holds if `test` shows value to be untainted with `taint` */
  predicate sanitizingEdge(TaintKind taint, PyEdgeRefinement test) { none() }

  /** Holds if `test` shows value to be untainted with `taint` */
  predicate sanitizingSingleEdge(TaintKind taint, SingleSuccessorGuard test) { none() }

  /** Holds if `def` shows value to be untainted with `taint` */
  predicate sanitizingDefinition(TaintKind taint, EssaDefinition def) { none() }
}

/**
 * A source of taintedness.
 * Users of the taint tracking library should override this
 * class to provide their own sources.
 */
abstract class TaintSource extends @py_flow_node {
  /** Gets a textual representation of this element. */
  string toString() { result = "Taint source" }

  /**
   * Holds if `this` is a source of taint kind `kind`
   *
   * This must be overridden by subclasses to specify sources of taint.
   *
   * The smaller this predicate is, the faster `Taint.flowsTo()` will converge.
   */
  abstract predicate isSourceOf(TaintKind kind);

  /**
   * Holds if `this` is a source of taint kind `kind` for the given context.
   * Generally, this should not need to be overridden; overriding `isSourceOf(kind)` should be sufficient.
   *
   * The smaller this predicate is, the faster `Taint.flowsTo()` will converge.
   */
  predicate isSourceOf(TaintKind kind, TaintTrackingContext context) {
    context.isTop() and this.isSourceOf(kind)
  }

  Location getLocation() { result = this.(ControlFlowNode).getLocation() }

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

  /** Gets a TaintedNode for this taint source */
  TaintedNode getATaintNode() {
    result.getCfgNode() = this and
    this.isSourceOf(result.getTaintKind(), result.getContext()) and
    result.getPath().noAttribute()
  }

  /** Holds if taint can flow from this source to sink `sink` */
  final predicate flowsToSink(TaintKind srckind, TaintSink sink) {
    exists(TaintedNode src, TaintedNode tsink |
      src = this.getATaintNode() and
      src.getTaintKind() = srckind and
      src.flowsTo(tsink) and
      this.isSourceOf(srckind, _) and
      sink = tsink.getCfgNode() and
      sink.sinks(tsink.getTaintKind()) and
      tsink.getPath().noAttribute() and
      tsink.isSink()
    )
  }

  /** Holds if taint can flow from this source to taint sink `sink` */
  final predicate flowsToSink(TaintSink sink) { this.flowsToSink(_, sink) }
}

/**
 * Warning: Advanced feature. Users are strongly recommended to use `TaintSource` instead.
 * A source of taintedness on the ESSA data-flow graph.
 * Users of the taint tracking library can override this
 * class to provide their own sources on the ESSA graph.
 */
abstract class TaintedDefinition extends EssaNodeDefinition {
  /**
   * Holds if `this` is a source of taint kind `kind`
   *
   * This should be overridden by subclasses to specify sources of taint.
   *
   * The smaller this predicate is, the faster `Taint.flowsTo()` will converge.
   */
  abstract predicate isSourceOf(TaintKind kind);

  /**
   * Holds if `this` is a source of taint kind `kind` for the given context.
   * Generally, this should not need to be overridden; overriding `isSourceOf(kind)` should be sufficient.
   *
   * The smaller this predicate is, the faster `Taint.flowsTo()` will converge.
   */
  predicate isSourceOf(TaintKind kind, TaintTrackingContext context) {
    context.isTop() and this.isSourceOf(kind)
  }
}

private class DictUpdate extends DataFlowExtension::DataFlowNode {
  MethodCallsiteRefinement call;

  DictUpdate() {
    exists(CallNode c | c = call.getCall() |
      c.getFunction().(AttrNode).getName() = "update" and
      c.getArg(0) = this
    )
  }

  override EssaVariable getASuccessorVariable() { call.getVariable() = result }
}

private class SequenceExtends extends DataFlowExtension::DataFlowNode {
  MethodCallsiteRefinement call;

  SequenceExtends() {
    exists(CallNode c | c = call.getCall() |
      c.getFunction().(AttrNode).getName() = "extend" and
      c.getArg(0) = this
    )
  }

  override EssaVariable getASuccessorVariable() { call.getVariable() = result }
}

/**
 * A node that is vulnerable to one or more types of taint.
 * These nodes provide the sinks when computing the taint flow graph.
 * An example would be an argument to a write to a http response object,
 * such an argument would be vulnerable to unsanitized user-input (XSS).
 *
 * Users of the taint tracking library should extend this
 * class to provide their own sink nodes.
 */
abstract class TaintSink extends @py_flow_node {
  /** Gets a textual representation of this element. */
  string toString() { result = "Taint sink" }

  /**
   * Holds if `this` "sinks" taint kind `kind`
   * Typically this means that `this` is vulnerable to taint kind `kind`.
   *
   * This must be overridden by subclasses to specify vulnerabilities or other sinks of taint.
   */
  abstract predicate sinks(TaintKind taint);

  Location getLocation() { result = this.(ControlFlowNode).getLocation() }

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

/**
 * Extension for data-flow, to help express data-flow paths that are
 * library or framework specific and cannot be inferred by the general
 * data-flow machinery.
 */
module DataFlowExtension {
  /** A control flow node that modifies the basic data-flow. */
  abstract class DataFlowNode extends @py_flow_node {
    /** Gets a textual representation of this element. */
    string toString() { result = "Dataflow extension node" }

    /**
     * Gets a successor node for data-flow.
     * Data (all forms) is assumed to flow from `this` to `result`
     */
    ControlFlowNode getASuccessorNode() { none() }

    /**
     * Gets a successor variable for data-flow.
     * Data (all forms) is assumed to flow from `this` to `result`.
     * Note: This is an unlikely form of flow. See `DataFlowVariable.getASuccessorVariable()`
     */
    EssaVariable getASuccessorVariable() { none() }

    /**
     * Holds if data cannot flow from `this` to `succ`,
     * even though it would normally do so.
     */
    predicate prunedSuccessor(ControlFlowNode succ) { none() }

    /**
     * Gets a successor node, where the successor node will be tainted with `tokind`
     * when `this` is tainted with `fromkind`.
     * Extensions to `DataFlowNode` should override this to provide additional taint steps.
     */
    ControlFlowNode getASuccessorNode(TaintKind fromkind, TaintKind tokind) { none() }

    /**
     * Gets a successor node for data-flow with a change of context from callee to caller
     * (going *up* the call-stack) across call-site `call`.
     * Data (all forms) is assumed to flow from `this` to `result`
     * Extensions to `DataFlowNode` should override this to provide additional taint steps.
     */
    ControlFlowNode getAReturnSuccessorNode(CallNode call) { none() }

    /**
     * Gets a successor node for data-flow with a change of context from caller to callee
     * (going *down* the call-stack) across call-site `call`.
     * Data (all forms) is assumed to flow from `this` to `result`
     * Extensions to `DataFlowNode` should override this to provide additional taint steps.
     */
    ControlFlowNode getACalleeSuccessorNode(CallNode call) { none() }
  }

  /** A data flow variable that modifies the basic data-flow. */
  class DataFlowVariable extends EssaVariable {
    /**
     * Gets a successor node for data-flow.
     * Data (all forms) is assumed to flow from `this` to `result`
     * Note: This is an unlikely form of flow. See `DataFlowNode.getASuccessorNode()`
     */
    ControlFlowNode getASuccessorNode() { none() }

    /**
     * Gets a successor variable for data-flow.
     * Data (all forms) is assumed to flow from `this` to `result`.
     */
    EssaVariable getASuccessorVariable() { none() }

    /**
     * Holds if data cannot flow from `this` to `succ`,
     * even though it would normally do so.
     */
    predicate prunedSuccessor(EssaVariable succ) { none() }
  }
}

class TaintedPathSource extends TaintTrackingNode {
  TaintedPathSource() { this.isSource() }

  DataFlow::Node getSource() { result = this.getNode() }
}

class TaintedPathSink extends TaintTrackingNode {
  TaintedPathSink() { this.isSink() }

  DataFlow::Node getSink() { result = this.getNode() }
}

/* Backwards compatible name */
class TaintedNode = TaintTrackingNode;

/* Helpers for Validating classes */
private import semmle.python.pointsto.PointsTo

/**
 * Data flow module providing an interface compatible with
 * the other language implementations.
 */
module DataFlow {
  /**
   * The generic taint kind, source and sink classes for convenience and
   * compatibility with other language libraries
   */
  class Extension = DataFlowExtension::DataFlowNode;

  private newtype TDataFlowNode =
    TEssaNode(EssaVariable var) or
    TCfgNode(ControlFlowNode node)

  abstract class Node extends TDataFlowNode {
    abstract ControlFlowNode asCfgNode();

    abstract EssaVariable asVariable();

    /** Gets a textual representation of this element. */
    abstract string toString();

    abstract Scope getScope();

    abstract BasicBlock getBasicBlock();

    abstract Location getLocation();

    AstNode asAstNode() { result = this.asCfgNode().getNode() }
  }

  class CfgNode extends Node, TCfgNode {
    override ControlFlowNode asCfgNode() { this = TCfgNode(result) }

    override EssaVariable asVariable() { none() }

    /** Gets a textual representation of this element. */
    override string toString() { result = this.asAstNode().toString() }

    override Scope getScope() { result = this.asCfgNode().getScope() }

    override BasicBlock getBasicBlock() { result = this.asCfgNode().getBasicBlock() }

    override Location getLocation() { result = this.asCfgNode().getLocation() }
  }

  class EssaNode extends Node, TEssaNode {
    override ControlFlowNode asCfgNode() { none() }

    override EssaVariable asVariable() { this = TEssaNode(result) }

    /** Gets a textual representation of this element. */
    override string toString() { result = this.asVariable().toString() }

    override Scope getScope() { result = this.asVariable().getScope() }

    override BasicBlock getBasicBlock() {
      result = this.asVariable().getDefinition().getBasicBlock()
    }

    override Location getLocation() { result = this.asVariable().getDefinition().getLocation() }
  }
}

pragma[noinline]
private predicate dict_construct(ControlFlowNode itemnode, ControlFlowNode dictnode) {
  dictnode.(DictNode).getAValue() = itemnode
  or
  dictnode.(CallNode).getFunction().pointsTo(ObjectInternal::builtin("dict")) and
  dictnode.(CallNode).getArgByName(_) = itemnode
}

pragma[noinline]
private predicate sequence_construct(ControlFlowNode itemnode, ControlFlowNode seqnode) {
  seqnode.isLoad() and
  (
    seqnode.(ListNode).getElement(_) = itemnode
    or
    seqnode.(TupleNode).getElement(_) = itemnode
    or
    seqnode.(SetNode).getAnElement() = itemnode
  )
}

/* A call to construct a sequence from a sequence or iterator*/
pragma[noinline]
private predicate sequence_call(ControlFlowNode fromnode, CallNode tonode) {
  tonode.getArg(0) = fromnode and
  exists(ControlFlowNode cls | cls = tonode.getFunction() |
    cls.pointsTo(ObjectInternal::builtin("list"))
    or
    cls.pointsTo(ObjectInternal::builtin("tuple"))
    or
    cls.pointsTo(ObjectInternal::builtin("set"))
  )
}
