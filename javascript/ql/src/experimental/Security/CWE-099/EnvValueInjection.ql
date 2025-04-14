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

/** A taint tracking configuration for unsafe environment injection. */
module EnvValueInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    sink = API::moduleImport("process").getMember("env").getAMember().asSink()
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module EnvValueInjectionFlow = TaintTracking::Global<EnvValueInjectionConfig>;

import EnvValueInjectionFlow::PathGraph

from EnvValueInjectionFlow::PathNode source, EnvValueInjectionFlow::PathNode sink
where EnvValueInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "this environment variable assignment is $@.",
  source.getNode(), "user controllable"
