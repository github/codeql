/**
 * @name Improper code sanitization
 * @description Escaping code as HTML does not provide protection against code injection.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/bad-code-sanitization
 * @tags security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import semmle.javascript.security.dataflow.ImproperCodeSanitization::ImproperCodeSanitization
import DataFlow::PathGraph
private import semmle.javascript.heuristics.HeuristicSinks
private import semmle.javascript.security.dataflow.CodeInjectionCustomizations

/**
 * Gets a type-tracked instance of `RemoteFlowSource` using type-tracker `t`.
 */
private DataFlow::Node remoteFlow(DataFlow::TypeTracker t) {
  t.start() and
  result instanceof RemoteFlowSource
  or
  exists(DataFlow::TypeTracker t2, DataFlow::Node prev | prev = remoteFlow(t2) |
    t2 = t.smallstep(prev, result)
    or
    any(TaintTracking::AdditionalTaintStep dts).step(prev, result) and
    t = t2
  )
}

/**
 * Gets a type-tracked reference to a `RemoteFlowSource`.
 */
private DataFlow::Node remoteFlow() { result = remoteFlow(DataFlow::TypeTracker::end()) }

/**
 * Gets a type-back-tracked instance of a code injection sink using type-tracker `t`.
 */
private DataFlow::Node endsInCodeInjectionSink(DataFlow::TypeBackTracker t) {
  t.start() and
  (
    result instanceof CodeInjection::Sink
    or
    result instanceof HeuristicCodeInjectionSink and
    not result instanceof StringOps::ConcatenationRoot // the heuristic CodeInjection sink looks for string-concats, we are not interrested in those here.
  )
  or
  exists(DataFlow::TypeBackTracker t2 | t = t2.smallstep(result, endsInCodeInjectionSink(t2)))
}

/**
 * Gets a reference to to a data-flow node that ends in a code injection sink.
 */
private DataFlow::Node endsInCodeInjectionSink() {
  result = endsInCodeInjectionSink(DataFlow::TypeBackTracker::end())
}

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where
  cfg.hasFlowPath(source, sink) and
  // Basic detection of duplicate results with `js/code-injection`.
  not (
    sink.getNode().(StringOps::ConcatenationLeaf).getRoot() = endsInCodeInjectionSink() and
    remoteFlow() = source.getNode().(DataFlow::InvokeNode).getAnArgument()
  )
select sink.getNode(), source, sink, "$@ flows to here and is used to construct code.",
  source.getNode(), "Improperly sanitized value"
