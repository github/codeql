private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate
private import semmle.python.dataflow.new.internal.TaintTrackingPublic
private import semmle.python.ApiGraphs

/**
 * Holds if `node` should be a sanitizer in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintSanitizer(DataFlow::Node node) { none() }

/**
 * Holds if default `TaintTracking::Configuration`s should allow implicit reads
 * of `c` at sinks and inputs to additional taint steps.
 */
bindingset[node]
predicate defaultImplicitTaintRead(DataFlow::Node node, DataFlow::Content c) { none() }

private module Cached {
  /**
   * Holds if the additional step from `nodeFrom` to `nodeTo` should be included in all
   * global taint flow configurations.
   */
  cached
  predicate defaultAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    localAdditionalTaintStep(nodeFrom, nodeTo)
    or
    any(AdditionalTaintStep a).step(nodeFrom, nodeTo)
  }

  /**
   * Holds if taint can flow in one local step from `nodeFrom` to `nodeTo` excluding
   * local data flow steps. That is, `nodeFrom` and `nodeTo` are likely to represent
   * different objects.
   */
  cached
  predicate localAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    concatStep(nodeFrom, nodeTo)
    or
    subscriptStep(nodeFrom, nodeTo)
    or
    stringManipulation(nodeFrom, nodeTo)
    or
    containerStep(nodeFrom, nodeTo)
    or
    copyStep(nodeFrom, nodeTo)
    or
    forStep(nodeFrom, nodeTo)
    or
    unpackingAssignmentStep(nodeFrom, nodeTo)
  }
}

import Cached

/**
 * Holds if taint can flow from `nodeFrom` to `nodeTo` with a step related to concatenation.
 *
 * Note that since we cannot easily distinguish interesting types (like string, list, tuple),
 * we consider any `+` operation to propagate taint. This is what is done in the JS libraries,
 * and isn't a big problem in practice.
 */
predicate concatStep(DataFlow::CfgNode nodeFrom, DataFlow::CfgNode nodeTo) {
  exists(BinaryExprNode add | add = nodeTo.getNode() |
    add.getOp() instanceof Add and add.getAnOperand() = nodeFrom.getNode()
  )
}

/**
 * Holds if taint can flow from `nodeFrom` to `nodeTo` with a step related to subscripting.
 */
predicate subscriptStep(DataFlow::CfgNode nodeFrom, DataFlow::CfgNode nodeTo) {
  nodeTo.getNode().(SubscriptNode).getObject() = nodeFrom.getNode()
}

/**
 * Holds if taint can flow from `nodeFrom` to `nodeTo` with a step related to string
 * manipulation.
 *
 * Note that since we cannot easily distinguish when something is a string, this can
 * also make taint flow on `<non string>.replace(foo, bar)`.
 */
predicate stringManipulation(DataFlow::CfgNode nodeFrom, DataFlow::CfgNode nodeTo) {
  // transforming something tainted into a string will make the string tainted
  exists(DataFlow::CallCfgNode call | call = nodeTo |
    (
      call = API::builtin(["str", "bytes", "unicode"]).getACall()
      or
      call.getFunction().asCfgNode().(NameNode).getId() in ["str", "bytes", "unicode"]
    ) and
    nodeFrom in [call.getArg(0), call.getArgByName("object")]
  )
  or
  // String methods. Note that this doesn't recognize `meth = "foo".upper; meth()`
  exists(CallNode call, string method_name, ControlFlowNode object |
    call = nodeTo.getNode() and
    object = call.getFunction().(AttrNode).getObject(method_name)
  |
    nodeFrom.getNode() = object and
    method_name in [
        "capitalize", "casefold", "center", "expandtabs", "format", "format_map", "join", "ljust",
        "lstrip", "lower", "replace", "rjust", "rstrip", "strip", "swapcase", "title", "upper",
        "zfill", "encode", "decode"
      ]
    or
    method_name = "replace" and
    nodeFrom.getNode() = call.getArg(1)
    or
    method_name = "format" and
    nodeFrom.getNode() = call.getAnArg()
    or
    // str -> List[str]
    // TODO: check if these should be handled differently in regards to content
    nodeFrom.getNode() = object and
    method_name in ["partition", "rpartition", "rsplit", "split", "splitlines"]
    or
    // Iterable[str] -> str
    // TODO: check if these should be handled differently in regards to content
    method_name = "join" and
    nodeFrom.getNode() = call.getArg(0)
    or
    // Mapping[str, Any] -> str
    method_name = "format_map" and
    nodeFrom.getNode() = call.getArg(0)
  )
  or
  // % formatting
  exists(BinaryExprNode fmt | fmt = nodeTo.getNode() |
    fmt.getOp() instanceof Mod and
    (
      fmt.getLeft() = nodeFrom.getNode()
      or
      fmt.getRight() = nodeFrom.getNode()
    )
  )
  or
  // string multiplication -- `"foo" * 10`
  exists(BinaryExprNode mult | mult = nodeTo.getNode() |
    mult.getOp() instanceof Mult and
    mult.getLeft() = nodeFrom.getNode()
  )
  or
  // f-strings
  nodeTo.asExpr().(Fstring).getAValue() = nodeFrom.asExpr()
  // TODO: Handle encode/decode from base64/quopri
  // TODO: Handle functions in https://docs.python.org/3/library/binascii.html
}

/**
 * Holds if taint can flow from `nodeFrom` to `nodeTo` with a step related to containers
 * (lists/sets/dictionaries): literals, constructor invocation, methods. Note that this
 * is currently very imprecise, as an example, since we model `dict.get`, we treat any
 * `<tainted object>.get(<arg>)` will be tainted, whether it's true or not.
 */
predicate containerStep(DataFlow::CfgNode nodeFrom, DataFlow::Node nodeTo) {
  // construction by literal
  // TODO: Not limiting the content argument here feels like a BIG hack, but we currently get nothing for free :|
  DataFlowPrivate::storeStep(nodeFrom, _, nodeTo)
  or
  // constructor call
  exists(DataFlow::CallCfgNode call | call = nodeTo |
    call = API::builtin(["list", "set", "frozenset", "dict", "tuple"]).getACall() and
    call.getArg(0) = nodeFrom
    // TODO: Properly handle defaultdict/namedtuple
  )
  or
  // functions operating on collections
  exists(DataFlow::CallCfgNode call | call = nodeTo |
    call = API::builtin(["sorted", "reversed", "iter", "next"]).getACall() and
    call.getArg(0) = nodeFrom
  )
  or
  // methods
  exists(DataFlow::MethodCallNode call, string methodName | call = nodeTo |
    methodName in [
        // general
        "copy", "pop",
        // dict
        "values", "items", "get", "popitem"
      ] and
    call.calls(nodeFrom, methodName)
  )
  or
  // list.append, set.add
  exists(DataFlow::MethodCallNode call, DataFlow::Node obj |
    call.calls(obj, ["append", "add"]) and
    obj = nodeTo.(DataFlow::PostUpdateNode).getPreUpdateNode() and
    call.getArg(0) = nodeFrom
  )
}

/**
 * Holds if taint can flow from `nodeFrom` to `nodeTo` with a step related to copying.
 */
predicate copyStep(DataFlow::CfgNode nodeFrom, DataFlow::CfgNode nodeTo) {
  exists(DataFlow::CallCfgNode call | call = nodeTo |
    call = API::moduleImport("copy").getMember(["copy", "deepcopy"]).getACall() and
    call.getArg(0) = nodeFrom
  )
}

/**
 * Holds if taint can flow from `nodeFrom` to `nodeTo` with a step related to `for`-iteration,
 * for example `for x in xs`, or `for x,y in points`.
 */
predicate forStep(DataFlow::CfgNode nodeFrom, DataFlow::EssaNode nodeTo) {
  exists(EssaNodeDefinition defn, For for |
    for.getTarget().getAChildNode*() = defn.getDefiningNode().getNode() and
    nodeTo.getVar() = defn and
    nodeFrom.asExpr() = for.getIter()
  )
}

/**
 * Holds if taint can flow from `nodeFrom` to `nodeTo` with a step related to iterable unpacking.
 * Only handles normal assignment (`x,y = calc_point()`), since `for x,y in points` is handled by `forStep`.
 */
predicate unpackingAssignmentStep(DataFlow::CfgNode nodeFrom, DataFlow::EssaNode nodeTo) {
  // `a, b = myiterable` or `head, *tail = myiterable` (only Python 3)
  exists(MultiAssignmentDefinition defn, Assign assign |
    assign.getATarget().contains(defn.getDefiningNode().getNode()) and
    nodeTo.getVar() = defn and
    nodeFrom.asExpr() = assign.getValue()
  )
}
