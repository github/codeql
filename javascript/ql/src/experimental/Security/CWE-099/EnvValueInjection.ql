/**
 * @name User controlled environment variable value injection
 * @description assigning important environment variables from user controlled data is not secure
 * @kind path-problem
 * @id js/env-value-injection
 * @problem.severity error
 * @security-severity 7.5
 * @precision medium
 * @tags security
 *       external/cwe/cwe-089
 */

import javascript
import DataFlow::PathGraph

/** A taint tracking configuration for unsafe environment injection. */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "envInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink = API::moduleImport("process").getMember("env").getAMember().asSink()
  }
}

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "this environment variable assignment is $@.",
  source.getNode(), "user controllable"
