/**
 * @name Remote Form Flow Sources
 * @description Using remote user controlled sources from Forms
 * @kind path-problem
 * @problem.severity error
 * @security-severity 5
 * @precision high
 * @id js/remote-flow-source
 * @tags correctness
 *       security
 */

import javascript
import DataFlow::PathGraph
import experimental.semmle.javascript.FormParsers

/**
 * A taint-tracking configuration for test
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "RemoteFlowSourcesOUserForm" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink = API::moduleImport("sink").getAParameter().asSink() or
    sink = API::moduleImport("sink").getReturn().asSource()
  }
}

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This entity depends on a $@.", source.getNode(),
  "user-provided value"
