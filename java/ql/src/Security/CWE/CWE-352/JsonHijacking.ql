/**
 * @name JSON Hijacking
 * @description User-controlled callback function names that are not verified are vulnerable
 *              to json hijacking attacks.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/Json-hijacking
 * @tags security
 *       external/cwe/cwe-352
 */

import java
import JsonHijackingLib
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

/** Taint-tracking configuration tracing flow from remote sources to output jsonp data. */
class JsonHijackingConfig extends TaintTracking::Configuration {
  JsonHijackingConfig() { this = "JsonHijackingConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JsonHijackingSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, JsonHijackingConfig conf
where
  conf.hasFlowPath(source, sink) and
  exists(JsonHijackingFlowConfig jhfc | jhfc.hasFlowTo(sink.getNode()))
select sink.getNode(), source, sink, "Json Hijacking query might include code from $@.",
  source.getNode(), "this user input"
