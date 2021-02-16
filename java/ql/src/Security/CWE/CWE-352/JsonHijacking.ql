/**
 * @name JSON Hijacking
 * @description User-controlled callback function names that are not verified are vulnerable
 *              to json hijacking attacks.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/Json-hijacking
 * @tags security
 *       external/cwe/cwe-352
 */

import java
import DataFlow
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph
import JsonHijackingLib

class JsonHijackingConfig extends TaintTracking::Configuration {
  JsonHijackingConfig() { this = "JsonHijackingConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof JsonHijackingSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JsonHijackingSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, JsonHijackingConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Json hijacking might include code from $@.", source.getNode(),
  "this user input"
