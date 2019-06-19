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
 * and consists of the base data-flow graph produced by `semmle/python/data-flow/SsaDefinitions.qll`
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

/** A 'kind' of taint. This may be almost anything,
 * but it is typically something like a "user-defined string".
 * Examples include, data from a http request object,
 * data from an SMS or other mobile data source,
 * or, for a super secure system, environment variables or
 * the local file system.
 */
abstract class TaintKind extends string {

    bindingset[this]
    TaintKind() { any() }

    /** Gets the kind of taint that the named attribute will have if an object is tainted with this taint.
     * In other words, if `x` has this kind of taint then it implies that `x.name`
     * has `result` kind of taint.
     */
    TaintKind getTaintOfAttribute(string name) { none() }

    /** Gets the kind of taint results from calling the named method if an object is tainted with this taint.
     * In other words, if `x` has this kind of taint then it implies that `x.name()`
     * has `result` kind of taint.
     */
    TaintKind getTaintOfMethodResult(string name) { none() }

    /** Gets the taint resulting from the flow step `fromnode` -> `tonode`.
     */
    TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) { none() }

    /** DEPRECATED -- Use `TaintFlow.additionalFlowStepVar(EssaVariable fromvar, EssaVariable tovar, TaintKind kind)` instead.
     *
     * Holds if this kind of taint passes from variable `fromvar` to  variable `tovar`
     * This predicate is present for completeness. It is unlikely that any `TaintKind`
     * implementation will ever need to override it.
     */
    predicate additionalFlowStepVar(EssaVariable fromvar, EssaVariable tovar) { none() }

    /** Holds if this kind of taint "taints" `expr`.
     */
    final predicate taints(ControlFlowNode expr) {
        exists(TaintedNode n |
            n.getTaintKind() = this and n.getNode() = expr
        )
    }

    /** DEPRECATED -- Use getType() instead */
    ClassObject getClass() {
        none()
    }

    /** Gets the class of this kind of taint.
     * For example, if this were a kind of string taint
     * the `result` would be `theStrType()`.
     */
    ClassValue getType() {
        result.getSource() = this.getClass()
    }

    /** Gets the boolean values (may be one, neither, or both) that
     * may result from the Python expression `bool(this)`
     */
    boolean booleanValue() {
        /* Default to true as the vast majority of taint is strings and 
         * the empty string is almost always benign.
         */
        result = true
    }

    string repr() { result = this }

    /** Gets the taint resulting from iterating over this kind of taint.
     * For example iterating over a text file produces lines. So iterating
     * over a tainted file would result in tainted strings
     */
    TaintKind getTaintForIteration() { none() }

}

/** Taint kinds representing collections of other taint kind.
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
        not this.charAt(2) = "[" and not this.charAt(2) = "{"
    }

}

/** A taint kind representing a flat collections of kinds.
 * Typically a sequence, but can include sets.
 */
class SequenceKind extends CollectionKind {

    TaintKind itemKind;

    SequenceKind() {
        this = "[" + itemKind + "]"
    }

    TaintKind getItem() {
        result = itemKind
    }

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

    override string repr() {
        result = "sequence of " + itemKind
    }

    override TaintKind getTaintForIteration() {
        result = itemKind
    }

}


module SequenceKind {

    predicate flowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
        tonode.(BinaryExprNode).getAnOperand() = fromnode
        or
        TaintFlowImplementation::copyCall(fromnode, tonode)
        or
        sequence_call(fromnode, tonode)
        or
        sequence_subscript_slice(fromnode, tonode)
    }

    predicate itemFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
        sequence_subscript_index(fromnode, tonode)
    }

}


/* Helper for sequence flow steps */
pragma [noinline]
private predicate sequence_subscript_index(ControlFlowNode obj, SubscriptNode sub) {
    sub.isLoad() and
    sub.getValue() = obj and
    not sub.getNode().getIndex() instanceof Slice
}

pragma [noinline]
private predicate sequence_subscript_slice(ControlFlowNode obj, SubscriptNode sub) {
    sub.isLoad() and
    sub.getValue() = obj and
    sub.getNode().getIndex() instanceof Slice
}


/** A taint kind representing a mapping of objects to kinds.
 * Typically a dict, but can include other mappings.
 */
class DictKind extends CollectionKind {

    TaintKind valueKind;

    DictKind() {
        this = "{" + valueKind + "}"
    }

    TaintKind getValue() {
        result = valueKind
    }

    override TaintKind getTaintOfMethodResult(string name) {
        name = "get" and result = valueKind
        or
        name = "values" and result.(SequenceKind).getItem() = valueKind
        or
        name = "itervalues" and result.(SequenceKind).getItem() = valueKind
    }

    override string repr() {
        result = "dict of " + valueKind
    }

}


module DictKind {

    predicate flowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
        TaintFlowImplementation::copyCall(fromnode, tonode)
        or
        tonode.(CallNode).getFunction().pointsTo(ObjectInternal::builtin("dict")) and
        tonode.(CallNode).getArg(0) = fromnode
    }

    predicate valueFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
        tonode.(SubscriptNode).getValue() = fromnode and tonode.isLoad()
        or
        tonode.(CallNode).getFunction().(AttrNode).getObject("get") = fromnode
    }

}


/** A type of sanitizer of untrusted data.
 * Examples include sanitizers for http responses, for DB access or for shell commands.
 * Usually a sanitizer can only sanitize data for one particular use.
 * For example, a sanitizer for DB commands would not be safe to use for http responses.
 */
abstract class Sanitizer extends string {

    bindingset[this]
    Sanitizer() { any() }

    /** Holds if `taint` cannot flow through `node`. */
    predicate sanitizingNode(TaintKind taint, ControlFlowNode node) { none() }

    /** Holds if `call` removes removes the `taint` */
    predicate sanitizingCall(TaintKind taint, FunctionObject callee) { none() }

    /** Holds if `test` shows value to be untainted with `taint` */
    predicate sanitizingEdge(TaintKind taint, PyEdgeRefinement test) { none() }

    /** Holds if `test` shows value to be untainted with `taint` */
    predicate sanitizingSingleEdge(TaintKind taint, SingleSuccessorGuard test) { none() }

    /** Holds if `def` shows value to be untainted with `taint` */
    predicate sanitizingDefinition(TaintKind taint, EssaDefinition def) { none() }

}

/** Hold if `sanitizer` is valid. A sanitizer is valid if there is
 * a `TaintTracking::Configuration` that declares `sanitizer` or
 * there are no `TaintTracking::Configuration`s.
 */
private predicate valid_sanitizer(Sanitizer sanitizer) {
    not exists(TaintTracking::Configuration c)
    or
    exists(TaintTracking::Configuration c | c.isSanitizer(sanitizer))
}

/** DEPRECATED -- Use DataFlowExtension instead.
 *  An extension to taint-flow. For adding library or framework specific flows.
 * Examples include flow from a request to untrusted part of that request or
 * from a socket to data from that socket.
 */
abstract class TaintFlow extends string {

    bindingset[this]
    TaintFlow() { any() }

    /** Holds if `fromnode` being tainted with `fromkind` will result in `tonode` being tainted with `tokind`.
     * Extensions to `TaintFlow` should override this to provide additional taint steps.
     */
    predicate additionalFlowStep(ControlFlowNode fromnode, TaintKind fromkind, ControlFlowNode tonode, TaintKind tokind) { none() }

    /** Holds if the given `kind` of taint passes from variable `fromvar` to variable `tovar`.
     * This predicate is present for completeness. Most `TaintFlow` implementations will not need to override it.
     */
    predicate additionalFlowStepVar(EssaVariable fromvar,  EssaVariable tovar, TaintKind kind) { none() }

    /** Holds if the given `kind` of taint cannot pass from variable `fromvar` to variable `tovar`.
     * This predicate is present for completeness. Most `TaintFlow` implementations will not need to override it.
     */
    predicate prunedFlowStepVar(EssaVariable fromvar,  EssaVariable tovar, TaintKind kind) { none() }

}

/** A source of taintedness.
 * Users of the taint tracking library should override this
 * class to provide their own sources.
 */
abstract class TaintSource extends @py_flow_node {

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
    predicate isSourceOf(TaintKind kind, CallContext context) {
        context.appliesTo(this) and this.isSourceOf(kind)
    }

    Location getLocation() {
        result = this.(ControlFlowNode).getLocation()
    }

    predicate hasLocationInfo(string fp, int bl, int bc, int el, int ec) {
        this.getLocation().hasLocationInfo(fp, bl, bc, el, ec)
    }

    /** Gets a TaintedNode for this taint source */
    TaintedNode getATaintNode() {
        exists(TaintFlowImplementation::TrackedTaint taint, CallContext context |
            this.isSourceOf(taint.getKind(), context) and
            result = TTaintedNode_(taint, context, this)
        )
    }

    /** Holds if taint can flow from this source to sink `sink` */
    final predicate flowsToSink(TaintKind srckind, TaintSink sink) {
        exists(TaintedNode t |
            t = this.getATaintNode() and
            t.getTaintKind() = srckind and
            t.flowsToSink(sink)
        )
    }

    /** Holds if taint can flow from this source to taint sink `sink` */
    final predicate flowsToSink(TaintSink sink) {
        this.flowsToSink(_, sink)
        or
        this instanceof ValidatingTaintSource and
        sink instanceof ValidatingTaintSink and
        exists(error())
    }
}


/** Warning: Advanced feature. Users are strongly recommended to use `TaintSource` instead.
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
    predicate isSourceOf(TaintKind kind, CallContext context) {
        context.appliesToScope(this.getScope()) and this.isSourceOf(kind)
    }

}

private class DictUpdate extends DataFlowExtension::DataFlowNode {

    MethodCallsiteRefinement call;

    DictUpdate() {
        exists(CallNode c |
            c = call.getCall()
            |
            c.getFunction().(AttrNode).getName() = "update" and
            c.getArg(0) = this
        )
    }

    override EssaVariable getASuccessorVariable() {
        call.getVariable() = result
    }

}

private class SequenceExtends extends DataFlowExtension::DataFlowNode {

    MethodCallsiteRefinement call;

    SequenceExtends() {
        exists(CallNode c |
            c = call.getCall()
            |
            c.getFunction().(AttrNode).getName() = "extend" and
            c.getArg(0) = this
        )
    }

    override EssaVariable getASuccessorVariable() {
        call.getVariable() = result
    }

}

/** A node that is vulnerable to one or more types of taint.
 * These nodes provide the sinks when computing the taint flow graph.
 * An example would be an argument to a write to a http response object,
 * such an argument would be vulnerable to unsanitized user-input (XSS).
 *
 * Users of the taint tracking library should extend this
 * class to provide their own sink nodes.
 */
abstract class TaintSink extends  @py_flow_node {

    string toString() { result = "Taint sink" }

    /**
     * Holds if `this` "sinks" taint kind `kind`
     * Typically this means that `this` is vulnerable to taint kind `kind`.
     *
     * This must be overridden by subclasses to specify vulnerabilities or other sinks of taint.
     */
    abstract predicate sinks(TaintKind taint);

    Location getLocation() {
        result = this.(ControlFlowNode).getLocation()
    }

    predicate hasLocationInfo(string fp, int bl, int bc, int el, int ec) {
        this.getLocation().hasLocationInfo(fp, bl, bc, el, ec)
    }

}

/** Extension for data-flow, to help express data-flow paths that are
 * library or framework specific and cannot be inferred by the general
 * data-flow machinery.
 */
module DataFlowExtension {

    /** A control flow node that modifies the basic data-flow. */
    abstract class DataFlowNode extends @py_flow_node {

        string toString() {
            result = "Dataflow extension node"
        }

        /** Gets a successor node for data-flow.
         * Data (all forms) is assumed to flow from `this` to `result`
         */
        ControlFlowNode getASuccessorNode() { none() }

        /** Gets a successor variable for data-flow.
         * Data (all forms) is assumed to flow from `this` to `result`.
         * Note: This is an unlikely form of flow. See `DataFlowVariable.getASuccessorVariable()`
         */
        EssaVariable getASuccessorVariable() { none() }

        /** Holds if data cannot flow from `this` to `succ`,
         * even though it would normally do so.
         */
        predicate prunedSuccessor(ControlFlowNode succ) { none() }

        /** Gets a successor node, where the successor node will be tainted with `tokind`
         * when `this` is tainted with `fromkind`.
         * Extensions to `DataFlowNode` should override this to provide additional taint steps.
         */
        ControlFlowNode getASuccessorNode(TaintKind fromkind, TaintKind tokind) { none() }

        /** Gets a successor node for data-flow with a change of context from callee to caller
         * (going *up* the call-stack) across call-site `call`.
         * Data (all forms) is assumed to flow from `this` to `result`
         * Extensions to `DataFlowNode` should override this to provide additional taint steps.
         */
        ControlFlowNode getAReturnSuccessorNode(CallNode call) { none() }

        /** Gets a successor node for data-flow with a change of context from caller to callee
         * (going *down* the call-stack) across call-site `call`.
         * Data (all forms) is assumed to flow from `this` to `result`
         * Extensions to `DataFlowNode` should override this to provide additional taint steps.
         */
        ControlFlowNode getACalleeSuccessorNode(CallNode call) { none() }

    }

    /** Data flow variable that modifies the basic data-flow. */
    class DataFlowVariable extends EssaVariable {

        /** Gets a successor node for data-flow.
         * Data (all forms) is assumed to flow from `this` to `result`
         * Note: This is an unlikely form of flow. See `DataFlowNode.getASuccessorNode()`
         */
        ControlFlowNode getASuccessorNode() { none() }

        /** Gets a successor variable for data-flow.
         * Data (all forms) is assumed to flow from `this` to `result`.
         */
        EssaVariable getASuccessorVariable() { none() }

        /** Holds if data cannot flow from `this` to `succ`,
         * even though it would normally do so.
         */
        predicate prunedSuccessor(EssaVariable succ) { none() }

    }
}

private newtype TTaintedNode =
    TTaintedNode_(TaintFlowImplementation::TrackedValue taint, CallContext context, ControlFlowNode n) {
        exists(TaintKind kind |
            taint = TaintFlowImplementation::TTrackedTaint(kind) |
            n.(TaintSource).isSourceOf(kind, context)
        )
        or
        exists(DataFlow::Configuration config, TaintKind kind |
            taint = TaintFlowImplementation::TTrackedTaint(kind) and
            config.isSource(n) and context.getDepth() = 0 and
            kind instanceof DataFlowType
        )
        or
        TaintFlowImplementation::step(_, taint, context, n) and
        exists(TaintKind kind |
            kind = taint.(TaintFlowImplementation::TrackedTaint).getKind()
            or
            kind = taint.(TaintFlowImplementation::TrackedAttribute).getKind(_) |
            not exists(Sanitizer sanitizer |
                valid_sanitizer(sanitizer) and
                sanitizer.sanitizingNode(kind, n)
            )
        )
        or
        user_tainted_def(_, taint, context, n)
    }

private predicate user_tainted_def(TaintedDefinition def, TaintFlowImplementation::TTrackedTaint taint, CallContext context, ControlFlowNode n) {
    exists(TaintKind kind |
        taint = TaintFlowImplementation::TTrackedTaint(kind) and
        def.isSourceOf(kind, context) and
        n = def.getDefiningNode()
    )
}

/** A tainted data flow graph node.
 * This is a triple of `(CFG node, data-flow context, taint)`
 */
class TaintedNode extends TTaintedNode {

    string toString() { result = this.getTrackedValue().repr() }

    string debug() { result = this.getTrackedValue().toString() + " at " + this.getNode().getLocation() }

    TaintedNode getASuccessor() {
        exists(TaintFlowImplementation::TrackedValue tokind, CallContext tocontext, ControlFlowNode tonode |
            result = TTaintedNode_(tokind, tocontext, tonode) and
            TaintFlowImplementation::step(this, tokind, tocontext, tonode)
        )
    }

    /** Gets the taint for this node. */
    TaintFlowImplementation::TrackedValue getTrackedValue() {
      this = TTaintedNode_(result, _, _)
    }

    /** Gets the CFG node for this node. */
    ControlFlowNode getNode() {
        this = TTaintedNode_(_, _, result)
    }

    /** Gets the data-flow context for this node. */
    CallContext getContext() {
        this = TTaintedNode_(_, result, _)
    }

    Location getLocation() {
        result = this.getNode().getLocation()
    }

    /** Holds if this node is a source of taint */
    predicate isSource() {
        exists(TaintFlowImplementation::TrackedTaint taint, CallContext context, TaintSource node |
            this = TTaintedNode_(taint, context, node) and
            node.isSourceOf(taint.getKind(), context)
        )
    }

    /** Gets the kind of taint that node is tainted with.
     * Doesn't apply if an attribute or item is tainted, only if this node directly tainted
     * */
    TaintKind getTaintKind() {
        this.getTrackedValue().(TaintFlowImplementation::TrackedTaint).getKind() = result
    }

    /** Holds if taint flows from this node to the sink `sink` and
     * reaches with a taint that `sink` is a sink of.
     */
    predicate flowsToSink(TaintSink sink) {
        exists(TaintedNode node |
            this.getASuccessor*() = node and
            node.getNode() = sink and
            sink.sinks(node.getTaintKind())
        )
    }

    /** Holds if the underlying CFG node for this node is a vulnerable node
     * and is vulnerable to this node's taint.
     */
    predicate isVulnerableSink() {
        exists(TaintedNode src, TaintSink vuln |
            src.isSource() and
            src.getASuccessor*() = this and
            vuln = this.getNode() and
            vuln.sinks(this.getTaintKind())
        )
    }

    TaintFlowImplementation::TrackedTaint fromAttribute(string name) {
        result = this.getTrackedValue().(TaintFlowImplementation::TrackedAttribute).fromAttribute(name)
    }

}

class TaintedPathSource extends TaintedNode {

    TaintedPathSource() {
        this.getNode().(TaintSource).isSourceOf(this.getTaintKind(), this.getContext())
    }

    /** Holds if taint can flow from this source to sink `sink` */
    final predicate flowsTo(TaintedPathSink sink) {
        this.getASuccessor*() = sink
    }

    TaintSource getSource() {
        result = this.getNode()
    }

}

class TaintedPathSink extends TaintedNode {

    TaintedPathSink() {
        this.getNode().(TaintSink).sinks(this.getTaintKind())
    }

    TaintSink getSink() {
        result = this.getNode()
    }

}

/** This module contains the implementation of taint-flow.
 * It is recommended that users use the `TaintedNode` class, rather than using this module directly
 * as the interface of this module may change without warning.
 */
library module TaintFlowImplementation {

    import semmle.python.pointsto.PointsTo
    import DataFlowExtension

    newtype TTrackedValue =
        TTrackedTaint(TaintKind kind)
        or
        TTrackedAttribute(string name, TaintKind kind) {
            exists(AttributeAssignment def, TaintedNode origin |
                def.getName() = name and
                def.getValue() = origin.getNode() and
                origin.getTaintKind() = kind
            )
            or
            exists(TaintedNode origin |
                import_flow(origin, _, _, name) and
                origin.getTaintKind() = kind
            )
            or
            exists(TaintKind src |
                kind = src.getTaintOfAttribute(name)
            )
            or
            exists(TaintedNode origin, AttrNode lhs, ControlFlowNode rhs |
                lhs.getName() = name and rhs = lhs.(DefinitionNode).getValue() |
                origin.getNode() = rhs and
                kind = origin.getTaintKind()
            )
        }

    /** The "taint" tracked internal by the TaintFlow module.
     *  This is not the taint kind specified by the user, but describes both the kind of taint
     *  and how that taint relates to any object referred to by a data-flow graph node or edge.
     */
    class TrackedValue extends TTrackedValue {

        abstract string toString();

        abstract string repr();

        abstract TrackedValue toKind(TaintKind kind);

    }

    class TrackedTaint extends TrackedValue, TTrackedTaint {

        override string repr() {
            result = this.getKind().repr()
        }

        override string toString() {
            result = "Taint " + this.getKind()
        }

        TaintKind getKind() {
            this = TTrackedTaint(result)
        }

        override TrackedValue toKind(TaintKind kind) {
            result = TTrackedTaint(kind)
        }

    }

    class TrackedAttribute extends TrackedValue, TTrackedAttribute {

        override string repr() {
            exists(string name, TaintKind kind |
                this = TTrackedAttribute(name, kind) and
                result = "." + name + "=" + kind.repr()
            )
        }

        override string toString() {
            exists(string name, TaintKind kind |
                this = TTrackedAttribute(name, kind) and
                result = "Attribute '" + name + "' taint " + kind
            )
        }

        TaintKind getKind(string name) {
            this = TTrackedAttribute(name, result)
        }

        TrackedValue fromAttribute(string name) {
            exists(TaintKind kind |
                this = TTrackedAttribute(name, kind) and
                result = TTrackedTaint(kind)
            )
        }

        string getName() {
            this = TTrackedAttribute(result, _)
        }

        override TrackedValue toKind(TaintKind kind) {
            result = TTrackedAttribute(this.getName(), kind)
        }

    }

    predicate step(TaintedNode fromnode, TrackedValue totaint, CallContext tocontext, ControlFlowNode tonode) {
        unpruned_step(fromnode, totaint, tocontext, tonode) and
        tonode.getBasicBlock().likelyReachable()
    }

    predicate unpruned_step(TaintedNode fromnode, TrackedValue totaint, CallContext tocontext, ControlFlowNode tonode) {
        import_step(fromnode, totaint, tocontext, tonode)
        or
        from_import_step(fromnode, totaint, tocontext, tonode)
        or
        attribute_load_step(fromnode, totaint, tocontext, tonode)
        or
        attribute_store_step(fromnode, totaint, tocontext, tonode)
        or
        getattr_step(fromnode, totaint, tocontext, tonode)
        or
        use_step(fromnode, totaint, tocontext, tonode)
        or
        call_taint_step(fromnode, totaint, tocontext, tonode)
        or
        iteration_step(fromnode, totaint, tocontext, tonode)
        or
        yield_step(fromnode, totaint, tocontext, tonode)
        or
        exists(DataFlowNode fromnodenode |
            fromnodenode = fromnode.getNode() and
            (
                not exists(TaintTracking::Configuration c)
                or
                exists(TaintTracking::Configuration c | c.isExtension(fromnodenode))
            )
            |
            fromnodenode.getASuccessorNode() = tonode and
            fromnode.getContext() = tocontext and
            totaint = fromnode.getTrackedValue()
            or
            exists(CallNode call |
                fromnodenode.getAReturnSuccessorNode(call) = tonode and
                fromnode.getContext() = tocontext.getCallee(call) and
                totaint = fromnode.getTrackedValue()
            )
            or
            exists(CallNode call |
                fromnodenode.getACalleeSuccessorNode(call) = tonode and
                fromnode.getContext().getCallee(call) = tocontext and
                totaint = fromnode.getTrackedValue()
            )
            or
            exists(TaintKind tokind |
                fromnodenode.getASuccessorNode(fromnode.getTaintKind(), tokind) = tonode and
                totaint = fromnode.getTrackedValue().toKind(tokind) and
                tocontext = fromnode.getContext()
            )
        )
        or
        exists(TaintKind tokind |
            tokind = fromnode.getTaintKind().getTaintForFlowStep(fromnode.getNode(), tonode) and
            totaint = fromnode.getTrackedValue().toKind(tokind) and
            tocontext = fromnode.getContext()
        )
        or
        exists(SequenceKind fromkind |
            fromkind = fromnode.getTaintKind() and
            tocontext = fromnode.getContext() |
            totaint = fromnode.getTrackedValue() and SequenceKind::flowStep(fromnode.getNode(), tonode)
            or
            totaint = fromnode.getTrackedValue().toKind(fromkind.getItem()) and SequenceKind::itemFlowStep(fromnode.getNode(), tonode)
        )
        or
        exists(DictKind fromkind |
            fromkind = fromnode.getTaintKind() and
            tocontext = fromnode.getContext() |
            totaint = fromnode.getTrackedValue() and DictKind::flowStep(fromnode.getNode(), tonode)
            or
            totaint = fromnode.getTrackedValue().toKind(fromkind.getValue()) and DictKind::valueFlowStep(fromnode.getNode(), tonode)
        )
        or
        exists(TaintFlow flow, TaintKind tokind |
            flow.additionalFlowStep(fromnode.getNode(), fromnode.getTaintKind(), tonode, tokind) and
            totaint = fromnode.getTrackedValue().toKind(tokind) and
            tocontext = fromnode.getContext()
        )
        or
        data_flow_step(fromnode.getContext(), fromnode.getNode(), tocontext, tonode) and
        totaint = fromnode.getTrackedValue()
        or
        exists(DataFlowVariable var |
            tainted_var(var, tocontext, fromnode) and
            var.getASuccessorNode() = tonode and
            totaint = fromnode.getTrackedValue()
        )
        or
        exists(TaintKind tokind |
            totaint = fromnode.getTrackedValue().toKind(tokind) and
            tocontext = fromnode.getContext()
            |
            tokind.(DictKind).getValue() = fromnode.getTaintKind() and
            dict_construct(fromnode.getNode(), tonode)
            or
            tokind.(SequenceKind).getItem() = fromnode.getTaintKind() and
            sequence_construct(fromnode.getNode(), tonode)
        )
    }

    pragma [noinline]
    predicate import_step(TaintedNode fromnode, TrackedAttribute totaint, CallContext tocontext, ImportExprNode tonode) {
        exists(string name |
            import_flow(fromnode, tonode, tocontext, name) and
            totaint.fromAttribute(name) = fromnode.getTrackedValue()
        )
    }

    pragma [noinline]
    private predicate import_flow(TaintedNode fromnode, ImportExprNode tonode, CallContext tocontext, string name) {
        exists(ModuleValue mod |
            tonode.pointsTo(mod) and
            module_attribute_tainted(mod, name, fromnode) and
            tocontext.appliesTo(tonode)
        )
    }

    pragma [noinline]
    predicate data_flow_step(CallContext fromcontext, ControlFlowNode fromnode, CallContext tocontext, ControlFlowNode tonode) {
        if_exp_step(fromcontext, fromnode, tocontext, tonode)
        or
        call_flow_step(fromcontext, fromnode, tocontext, tonode)
        or
        parameter_step(fromcontext, fromnode, tocontext, tonode)
    }

    pragma [noinline]
    predicate from_import_step(TaintedNode fromnode, TrackedValue totaint, CallContext tocontext, ControlFlowNode tonode) {
        exists(string name, ImportExprNode fmod, ModuleValue mod |
            fmod = tonode.(ImportMemberNode).getModule(name) and
            fmod.pointsTo(mod) and
            tocontext.appliesTo(tonode) and
            module_attribute_tainted(mod, name, fromnode) and
            totaint = fromnode.getTrackedValue()
        )
    }

    pragma [noinline]
    predicate getattr_step(TaintedNode fromnode, TrackedValue totaint, CallContext tocontext, CallNode tonode) {
        exists(ControlFlowNode arg, string name |
            tonode.getFunction().pointsTo(ObjectInternal::builtin("getattr")) and
            arg = tonode.getArg(0) and
            name = tonode.getArg(1).getNode().(StrConst).getText() and
            arg = fromnode.getNode() and
            totaint = fromnode.fromAttribute(name) and
            tocontext = fromnode.getContext()
        )
    }

    pragma [noinline]
    predicate attribute_load_step(TaintedNode fromnode, TrackedValue totaint, CallContext tocontext, AttrNode tonode) {
        tonode.isLoad() and
        exists(string name, ControlFlowNode f |
            f = tonode.getObject(name) and
            tocontext = fromnode.getContext() and
            f = fromnode.getNode() and
            (
                totaint = TTrackedTaint(fromnode.getTaintKind().getTaintOfAttribute(name))
                or
                totaint = fromnode.fromAttribute(name)
            )
        )
    }

    pragma [noinline]
    predicate attribute_store_step(TaintedNode fromnode, TrackedAttribute totaint, CallContext tocontext, ControlFlowNode tonode) {
        exists(string name |
            attribute_store_flow(fromnode.getNode(), tonode, name) and
            totaint.fromAttribute(name) = fromnode.getTrackedValue()
        ) and
        tocontext = fromnode.getContext()
    }

    pragma [noinline]
    private predicate attribute_store_flow(ControlFlowNode fromnode, ControlFlowNode tonode, string name) {
        exists(AttrNode lhs |
            tonode = lhs.getObject(name) and fromnode = lhs.(DefinitionNode).getValue()
        )
    }

    predicate module_attribute_tainted(ModuleValue m, string name, TaintedNode origin) {
        exists(EssaVariable var, CallContext c |
            var.getName() = name and
            BaseFlow::reaches_exit(var) and
            var.getScope() = m.getScope() and
            tainted_var(var, c, origin) and
            c = TTop()
        )
    }

    predicate use_step(TaintedNode fromnode, TrackedValue totaint, CallContext tocontext, ControlFlowNode tonode) {
        exists(EssaVariable var |
            var.getASourceUse() = tonode and
            tainted_var(var, tocontext, fromnode) and
            totaint = fromnode.getTrackedValue()
        )
    }

    pragma [noinline]
    predicate call_flow_step(CallContext callee, ControlFlowNode fromnode, CallContext caller, ControlFlowNode call) {
        exists(PyFunctionObject func |
            callee.appliesToScope(func.getFunction()) and
            func.getACall() = call and
            func.getAReturnedNode() = fromnode |
            callee = caller.getCallee(call)
            or
            caller = callee and caller = TTop()
        )
    }

    predicate yield_step(TaintedNode fromnode, TrackedValue totaint, CallContext tocontext, CallNode call) {
        exists(PyFunctionObject func |
            func.getFunction().isGenerator() and
            func.getACall() = call and
            (
                fromnode.getContext() = tocontext.getCallee(call)
                or
                fromnode.getContext() = tocontext and tocontext = TTop()
            ) and
            exists(Yield yield |
                yield.getScope() = func.getFunction() and
                yield.getValue() = fromnode.getNode().getNode()
            ) and
            exists(SequenceKind seq |
                seq.getItem() = fromnode.getTaintKind() and
                totaint = fromnode.getTrackedValue().toKind(seq)
            )
        )
    }

    predicate call_taint_step(TaintedNode fromnode, TrackedValue totaint, CallContext tocontext, CallNode call) {
        exists(string name |
            call.getFunction().(AttrNode).getObject(name) = fromnode.getNode() and
            totaint = TTrackedTaint(fromnode.getTaintKind().getTaintOfMethodResult(name)) and
            tocontext = fromnode.getContext()
        )
        or
        exists(EssaVariable self, CallContext callee |
            self_init_end_transfer(self, callee, call, tocontext) and
            tainted_var(self, callee, fromnode) and
            totaint = fromnode.getTrackedValue()
        )
    }

    /** Holds if `v` is defined by a `for` statement, the definition being `defn` */
    cached predicate iteration_step(TaintedNode fromnode, TrackedValue totaint, CallContext tocontext, ControlFlowNode iter) {
        exists(ForNode for | for.iterates(iter, fromnode.getNode())) and
        totaint = TTrackedTaint(fromnode.getTaintKind().getTaintForIteration()) and
        tocontext = fromnode.getContext()
    }

    predicate self_init_end_transfer(EssaVariable self, CallContext callee, CallNode call, CallContext caller) {
        exists(ClassValue cls, Function init |
            call.getFunction().pointsTo(cls) and
            init = cls.lookup("__init__").(CallableValue).getScope() and
            self.getSourceVariable().(Variable).isSelf() and self.getScope() = init
            |
            callee = caller.getCallee(call)
            or
            caller = callee and caller = TTop()
        )
    }

    predicate tainted_var(EssaVariable var, CallContext context, TaintedNode origin) {
        tainted_def(var.getDefinition(), context, origin)
        or
        exists(EssaVariable prev |
            tainted_var(prev, context, origin) and
            prev.(DataFlowVariable).getASuccessorVariable() = var
        )
        or
        exists(DataFlowNode originnode |
            originnode = origin.getNode() and
            (
                not exists(TaintTracking::Configuration c)
                or
                exists(TaintTracking::Configuration c | c.isExtension(originnode))
            ) and
            originnode.getASuccessorVariable() = var and
            context = origin.getContext()
        )
        or
        exists(TrackedTaint taint, EssaVariable prev |
            tainted_var(prev, context, origin) and
            origin.getTrackedValue() = taint and
            taint.getKind().additionalFlowStepVar(prev, var)
        )
        or
        exists(TaintFlow flow, TrackedTaint taint, EssaVariable prev |
            tainted_var(prev, context, origin) and
            origin.getTrackedValue() = taint and
            flow.additionalFlowStepVar(prev, var, taint.getKind())
        )
    }

    predicate tainted_def(EssaDefinition def, CallContext context, TaintedNode origin) {
        unsanitized_tainted_def(def, context, origin) and
        (
            origin.getTrackedValue() instanceof TrackedAttribute
            or
            exists(TaintKind kind |
                kind = origin.getTaintKind() and
                not exists(Sanitizer san |
                    valid_sanitizer(san) |
                    san.sanitizingDefinition(kind, def)
                    or
                    san.sanitizingNode(kind, def.(EssaNodeDefinition).getDefiningNode())
                    or
                    san.sanitizingNode(kind, def.(EssaNodeRefinement).getDefiningNode())
                )
            )
        )
    }

    predicate unsanitized_tainted_def(EssaDefinition def, CallContext context, TaintedNode origin) {
        exists(TrackedValue val, ControlFlowNode node |
            user_tainted_def(def, val, context, node) and
            origin = TTaintedNode_(val, context, node)
        )
        or
        tainted_phi(def, context, origin)
        or
        tainted_assignment(def, context, origin)
        or
        tainted_attribute_assignment(def, context, origin)
        or
        tainted_parameter_def(def, context, origin)
        or
        tainted_callsite(def, context, origin)
        or
        tainted_method_callsite(def, context, origin)
        or
        tainted_edge(def, context, origin)
        or
        tainted_argument(def, context, origin)
        or
        tainted_import_star(def, context, origin)
        or
        tainted_uni_edge(def, context, origin)
        or
        tainted_scope_entry(def, context, origin)
        or
        tainted_with(def, context, origin)
        or
        tainted_exception_capture(def, context, origin)
        or
        tainted_iteration(def, context, origin)

    }

    predicate tainted_scope_entry(ScopeEntryDefinition def, CallContext context, TaintedNode origin) {
        exists(EssaVariable var |
            BaseFlow::scope_entry_value_transfer_from_earlier(var, _, def, _) and
            tainted_var(var, context, origin)
        )
    }

    pragma [noinline]
    predicate tainted_phi(PhiFunction phi, CallContext context, TaintedNode origin) {
        exists(BasicBlock pred, EssaVariable predvar |
            predvar = phi.getInput(pred) and
            tainted_var(predvar, context, origin) and
            not pred.unlikelySuccessor(phi.getBasicBlock()) and
            not predvar.(DataFlowExtension::DataFlowVariable).prunedSuccessor(phi.getVariable())
        )
    }

    pragma [noinline]
    predicate tainted_assignment(AssignmentDefinition def, CallContext context, TaintedNode origin) {
        origin.getNode() = def.getValue() and
        context = origin.getContext()
    }

    pragma [noinline]
    predicate tainted_attribute_assignment(AttributeAssignment def, CallContext context, TaintedNode origin) {
        context = origin.getContext() and
        origin.getNode() = def.getDefiningNode().(AttrNode).getObject()
    }

    pragma [noinline]
    predicate tainted_callsite(CallsiteRefinement call, CallContext context, TaintedNode origin) {
        /* In the interest of simplicity and performance we assume that tainted escaping variables remain tainted across calls.
         * In the cases were this assumption is false, it is easy enough to add an additional sanitizer.
         */
        tainted_var(call.getInput(), context, origin)
    }

    pragma [noinline]
    predicate parameter_step(CallContext caller, ControlFlowNode argument, CallContext callee, NameNode param) {
        exists(ParameterDefinition def |
            def.getDefiningNode() = param and
            exists(CallableValue func, CallNode call |
                callee = caller.getCallee(call) |
                exists(int n | param = func.getParameter(n) and argument = func.getArgumentForCall(call, n))
                or
                exists(string name | param = func.getParameterByName(name) and argument = func.getNamedArgumentForCall(call, name))
                or
                class_initializer_argument(call, func, argument, param)
            )
        )
    }

    /* Helper for parameter_step */
    pragma [noinline]
    private predicate class_initializer_argument(CallNode call, CallableValue func, ControlFlowNode argument, NameNode param) {
        exists(ClassValue cls |
            cls.getACall() = call and
            cls.lookup("__init__") = func
        ) and
        exists(int n |
            call.getArg(n) = argument and
            param.getNode() = func.getScope().getArg(n+1)
        )
    }

    pragma [noinline]
    predicate tainted_parameter_def(ParameterDefinition def, CallContext context, TaintedNode fromnode) {
        fromnode.getNode() = def.getDefiningNode() and
        context = fromnode.getContext()
    }

    pragma [noinline]
    predicate if_exp_step(CallContext fromcontext, ControlFlowNode operand, CallContext tocontext, IfExprNode ifexp) {
        fromcontext = tocontext and fromcontext.appliesTo(operand) and
        ifexp.getAnOperand() = operand
    }

    pragma [noinline]
    predicate tainted_method_callsite(MethodCallsiteRefinement call, CallContext context, TaintedNode origin) {
        tainted_var(call.getInput(), context, origin) and
        exists(TaintKind kind |
            kind = origin.getTaintKind() |
            not exists(FunctionObject callee, Sanitizer sanitizer |
                valid_sanitizer(sanitizer) and
                callee.getACall() = call.getCall() and
                sanitizer.sanitizingCall(kind, callee)
            )
        )
    }

    pragma [noinline]
    predicate tainted_edge(PyEdgeRefinement test, CallContext context, TaintedNode origin) {
        exists(EssaVariable var, TaintKind kind |
            kind = origin.getTaintKind() and
            var = test.getInput() and
            tainted_var(var, context, origin) and
            not exists(Sanitizer sanitizer |
                valid_sanitizer(sanitizer) and
                sanitizer.sanitizingEdge(kind, test)
            )
            |
            not Filters::isinstance(test.getTest(), _, var.getSourceVariable().getAUse()) and
            not boolean_filter(test.getTest(), var.getSourceVariable().getAUse())
            or
            exists(ControlFlowNode c, ClassValue cls |
                Filters::isinstance(test.getTest(), c, var.getSourceVariable().getAUse())
                and c.pointsTo(cls)
                |
                test.getSense() = true and not exists(kind.getClass())
                or
                test.getSense() = true and kind.getType().getASuperType() = cls
                or
                test.getSense() = false and not kind.getType().getASuperType() = cls
            )
            or
            test.getSense() = test_evaluates(test.getTest(), var.getSourceVariable().getAUse(), kind)
        )
    }

    /** Gets the operand of a unary `not` expression. */
    private ControlFlowNode not_operand(ControlFlowNode expr) {
        expr.(UnaryExprNode).getNode().getOp() instanceof Not and
        result = expr.(UnaryExprNode).getOperand()
    }

    /** Holds if `test` is the test in a branch and `use` is that test
     * with all the `not` prefixes removed.
     */
    private predicate boolean_filter(ControlFlowNode test, ControlFlowNode use) {
        any(PyEdgeRefinement ref).getTest() = test and
        (
            use = test
            or
            exists(ControlFlowNode notuse |
                boolean_filter(test, notuse) and
                use = not_operand(notuse)
            )
        )
    }

    /** Gets the boolean value that `test` evaluates to when `use` is tainted with `kind`
     * and `test` and `use` are part of a test in a branch.
     */
    private boolean test_evaluates(ControlFlowNode test, ControlFlowNode use, TaintKind kind) {
        boolean_filter(_, use) and
        kind.taints(use) and
        test = use and result = kind.booleanValue()
        or
        result = test_evaluates(not_operand(test), use, kind).booleanNot()
    }

    pragma [noinline]
    predicate tainted_argument(ArgumentRefinement def, CallContext context, TaintedNode origin) {
        tainted_var(def.getInput(), context, origin)
    }

    pragma [noinline]
    predicate tainted_import_star(ImportStarRefinement def, CallContext context, TaintedNode origin) {
        exists(ModuleValue mod, string name |
            PointsTo::pointsTo(def.getDefiningNode().(ImportStarNode).getModule(), _, mod, _) and
            name = def.getSourceVariable().getName() |
            if mod.exports(name) then (
                /* Attribute from imported module */
                module_attribute_tainted(mod, name, origin) and
                context.appliesTo(def.getDefiningNode())
            ) else (
                /* Retain value held before import */
                exists(EssaVariable var |
                    var = def.getInput() and
                    tainted_var(var, context, origin)
                )
            )
        )
    }

    pragma [noinline]
    predicate tainted_uni_edge(SingleSuccessorGuard uniphi, CallContext context, TaintedNode origin) {
        exists(EssaVariable var, TaintKind kind |
            kind = origin.getTaintKind() and
            var = uniphi.getInput() and
            tainted_var(var, context, origin) and
            not exists(Sanitizer sanitizer |
                valid_sanitizer(sanitizer) and
                sanitizer.sanitizingSingleEdge(kind, uniphi)
            )
        )
    }

    pragma [noinline]
    predicate tainted_with(WithDefinition def, CallContext context, TaintedNode origin) {
        with_flow(_, origin.getNode(),def.getDefiningNode()) and
        context = origin.getContext()
    }

    pragma [noinline]
    predicate tainted_exception_capture(ExceptionCapture def, CallContext context, TaintedNode fromnode) {
        fromnode.getNode() = def.getDefiningNode() and
        context = fromnode.getContext()
    }

    pragma [noinline]
    private predicate tainted_iteration(IterationDefinition def, CallContext context, TaintedNode fromnode) {
        def.getDefiningNode() = fromnode.getNode() and
        context = fromnode.getContext()
    }

    /* A call that returns a copy (or similar) of the argument */
    predicate copyCall(ControlFlowNode fromnode, CallNode tonode) {
        tonode.getFunction().(AttrNode).getObject("copy") = fromnode
        or
        exists(ModuleObject copy, string name |
            name = "copy" or name = "deepcopy" |
            copy.attr(name).(FunctionObject).getACall() = tonode and
            tonode.getArg(0) = fromnode
        )
        or
        tonode.getFunction().pointsTo(ObjectInternal::builtin("reversed")) and
        tonode.getArg(0) = fromnode
    }

}

/* Helper predicate for tainted_with */
private predicate with_flow(With with, ControlFlowNode contextManager, ControlFlowNode var) {
    with.getContextExpr() = contextManager.getNode() and
    with.getOptionalVars() = var.getNode() and
    contextManager.strictlyDominates(var)
}

/* "Magic" sources and sinks which only have `toString()`s when
 * no sources are defined or no sinks are defined or no kinds are present.
 * In those cases, these classes make sure that an informative error
 * message is presented to the user.
 */

library class ValidatingTaintSource extends TaintSource {

    override string toString() {
        result = error()
    }

    ValidatingTaintSource() {
        this = uniqueCfgNode()
    }

    override predicate isSourceOf(TaintKind kind) { none() }

    override predicate hasLocationInfo(string fp, int bl, int bc, int el, int ec) {
        fp = error() and bl = 0 and bc = 0 and el = 0 and ec = 0
    }


}

library class ValidatingTaintSink extends TaintSink {

    override string toString() {
        result = error()
    }

    ValidatingTaintSink() {
        this = uniqueCfgNode()
    }

    override predicate sinks(TaintKind kind) { none() }

    override predicate hasLocationInfo(string fp, int bl, int bc, int el, int ec) {
        fp = error() and bl = 0 and bc = 0 and el = 0 and ec = 0
    }

}


/* Helpers for Validating classes */

private string locatable_module_name() {
    exists(Module m |
        exists(m.getLocation()) and
        result = m.getName()
    )
}

private ControlFlowNode uniqueCfgNode() {
    exists(Module m |
        result = m.getEntryNode() and
        m.getName() = min(string name | name = locatable_module_name())
    )
}

private string error() {
    forall(TaintSource s | s instanceof ValidatingTaintSource) and
    result = "No sources defined"
    or
    forall(TaintSink s | s instanceof ValidatingTaintSink) and
    result = "No sinks defined"
}


private newtype TCallContext =
    TTop()
    or
    TCalleeContext(CallNode call, CallContext caller, int depth) {
        caller.appliesToScope(call.getScope()) and
        depth = caller.getDepth() + 1 and depth < 7 and
        exists(TaintedNode n |
            n = TTaintedNode_(_, caller, call.getAnArg())
        )
    }

private import semmle.python.pointsto.PointsTo

pragma [inline]
private string shortLocation(Location l) {
    result = l.getFile().getShortName() + ":" + l.getStartLine()
}

/** Call context for use in taint-tracking.
 * Using call contexts prevents "cross talk" between different calls
 * to the same function. For example, if a function f is defined as
 * ```python
 * def f(arg):
 *     return arg
 * ```
 * Then `f("tainted")` is "tainted", but `f("ok") is "ok".
 */
class CallContext extends TCallContext {

    string toString() {
        this = TTop() and result = ""
        or
        exists(CallNode callsite, CallContext caller |
            this = TCalleeContext(callsite, caller, _) |
            result = shortLocation(callsite.getLocation()) + " from " + caller.toString() and caller = TCalleeContext(_, _, _)
            or
            result = shortLocation(callsite.getLocation()) and caller = TTop()
        )
    }

    /** Holds if this context can apply to `n`.
     */
    pragma[inline]
    predicate appliesTo(ControlFlowNode n) {
        this.appliesToScope(n.getScope())
    }

    /** Holds if this context can apply to `s`
     */
    predicate appliesToScope(Scope s) {
        this = TTop()
        or
        exists(FunctionObject f, CallNode call |
            this = TCalleeContext(call, _, _) and
            f.getFunction() = s and f.getACall() = call
        )
        or
        exists(ClassValue cls,CallNode call |
            this = TCalleeContext(call, _, _) and
            call.getFunction().pointsTo(cls) and
            s = cls.lookup("__init__").(CallableValue).getScope() and
            call.getFunction().pointsTo(cls)
        )
    }

    /** Gets the call depth of this context.
     */
    int getDepth() {
        this = TTop() and result = 0
        or
        this = TCalleeContext(_, _, result)
    }

    CallContext getCallee(CallNode call) {
        result = TCalleeContext(call, this, _)
    }

    CallContext getCaller() {
        this = TCalleeContext(_, result, _)
    }

}


/** Data flow module providing an interface compatible with
 * the other language implementations.
 */
module DataFlow {

    /** Generic taint kind, source and sink classes for convenience and
     * compatibility with other language libraries
     */

    class Node = ControlFlowNode;

    class Extension = DataFlowExtension::DataFlowNode;

    abstract class Configuration extends string {

        bindingset[this]
        Configuration() { this = this }

        abstract predicate isSource(Node source);

        abstract predicate isSink(Node sink);

        private predicate hasFlowPath(TaintedNode source, TaintedNode sink) {
            this.isSource(source.getNode()) and
            this.isSink(sink.getNode()) and
            source.getASuccessor*() = sink
        }

        predicate hasFlow(Node source, Node sink) {
            exists(TaintedNode psource, TaintedNode psink |
                psource.getNode() = source and
                psink.getNode() = sink and
                this.isSource(source) and
                this.isSink(sink) and
                this.hasFlowPath(psource, psink)
            )
        }

    }

}

private class DataFlowType extends TaintKind {

    DataFlowType() {
        this = "Data flow"  and
        exists(DataFlow::Configuration c)
    }

}

module TaintTracking {

    class Source = TaintSource;

    class Sink = TaintSink;

    class PathSource = TaintedPathSource;

    class PathSink = TaintedPathSink;

    class Extension = DataFlowExtension::DataFlowNode;

    abstract class Configuration extends string {

        bindingset[this]
        Configuration() { this = this }

        abstract predicate isSource(Source source);

        abstract predicate isSink(Sink sink);

        predicate isSanitizer(Sanitizer sanitizer) { none() }

        predicate isExtension(Extension extension) { none() }

        predicate hasFlowPath(PathSource source, PathSink sink) {
            this.isSource(source.getNode()) and
            this.isSink(sink.getNode()) and
            source.flowsTo(sink)
        }

        predicate hasFlow(Source source, Sink sink) {
            this.isSource(source) and
            this.isSink(sink) and
            source.flowsToSink(sink)
        }

    }

}


pragma [noinline]
private predicate dict_construct(ControlFlowNode itemnode, ControlFlowNode dictnode) {
    dictnode.(DictNode).getAValue() = itemnode
    or
    dictnode.(CallNode).getFunction().pointsTo(ObjectInternal::builtin("dict")) and
    dictnode.(CallNode).getArgByName(_) = itemnode
}

pragma [noinline]
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
pragma [noinline]
private predicate sequence_call(ControlFlowNode fromnode, CallNode tonode) {
    tonode.getArg(0) = fromnode and
    exists(ControlFlowNode cls |
        cls = tonode.getFunction() |
        cls.pointsTo(ObjectInternal::builtin("list"))
        or
        cls.pointsTo(ObjectInternal::builtin("tuple"))
        or
        cls.pointsTo(ObjectInternal::builtin("set"))
    )
}

