# Python Taint Tracking Library

The taint tracking library can be broken down into three parts.

1. Specification of sources, sinks and flows.
2. The high level query API
3. The implementation.


## Specification

There are five parts to the specification of a taint tracking query.
These are:

1. Kinds

    The Python taint tracking library supports arbitrary kinds of taint. This is useful where you want to track something related to "taint", but that is in itself not dangerous.
For example, we might want to track the flow of requests objects. Request objects are not in themselves tainted, but they do contain tainted data. For example, the length or timestamp of a request may not pose a risk, but the GET or POST string probably do.
So, we would want to track request objects distinctly from the request data in the GET or POST field.

2. Sources

    Sources of taint can be added by importing a predefined sub-type of `TaintSource`, or defining new ones.

3. Sinks (or vulnerabilities)

    Sinks can be add by importing a predefined sub-type of `TaintSink` or defining new ones.

4. Data flow extensions

    Additional dataflow edges; node->node, node->var, var->var or var->node can be added by importing predefined extensions or by adding new ones. Additional edges can be specified by overriding `DataFlowExtension::DataFlowNode` or `DataFlowExtension::DataFlowVariable`.

5. Taint tracking extensions

    Taint tracking extensions, where a only a particular kind of taint flows, can be added by overriding any or all of following the methods on `TaintKind`:

    The two general purpose extensions:

    `predicate additionalTaintStep(ControlFlowNode fromnode, ControlFlowNode tonode)`

    `predicate additionalTaintStepVar(EssaVariable fromvar, EssaVariable var)`

    And the two special purpose extensions for tainted methods or attributes. These allow simple taint-tracking extensions, without worrying about the underlying flow graph.

    `TaintKind getTaintFromAttribute(string name)`

    `TaintKind getTaintFromMethod(string name)`


## The high-level query API

The `TaintedNode` fully describes the taint flow graph.
The full graph can be expressed as:

```ql
from TaintedNode n, TaintedNode s
where s = n.getASuccessor()
select n, s
```

The source -> sink relation can be expressed either using `TaintedNode`:
```ql
from TaintedNode src, TaintedNode sink
where src.isSource() and sink.isSink() and src.getASuccessor*() = sink
select src, sink
```
or, using the specification API:
```ql
from TaintSource src, TaintSink sink
where src.flowsToSink(sink)
select src, sink
```

## The implementation

The data-flow graph used by the taint-tracking library is the one created by the points-to analysis,
and consists of the course data-flow graph produced by `semmle/python/data-flow/SsaDefinitions.qll`
enhanced with precise variable flows, call graph and type information.
This graph is then enhanced with additional flows specified in part 1 above.
Since the call graph and points-to information is context sensitive, the taint graph must also be context sensitive.

The taint graph is a simple directed graph where each node consists of a
`(CFG node, context, taint)` triple although it could be thought of more naturally
as a number of distinct graphs, one for each input taint-kind consisting of data flow nodes,
`(CFG node, context)` pairs, labelled with their `taint`.

The `TrackedValue` used in the implementation is not the taint kind specified by the user,
but describes both the kind of taint and how that taint relates to any object referred to by a data-flow graph node or edge.
Currently, only two types of `taint` are supported: simple taint, where the object is actually tainted;
and attribute taint where a named attribute of the referred object is tainted.

Support for tainted members (both specific members of tuples and the like,
and generic members for mutable collections) are likely to be added in the near future and others form are possible.
The types of taints are hard-wired with no user-visible extension method at the moment.

