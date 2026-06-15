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
import experimental.semmle.javascript.FormParsers

/**
 * A taint-tracking configuration for test
 */
module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    sink = API::moduleImport("sink").getAParameter().asSink() or
    sink = API::moduleImport("sink").getReturn().asSource()
  }
}

module TestFlow = TaintTracking::Global<TestConfig>;

import TestFlow::PathGraph

from TestFlow::PathNode source, TestFlow::PathNode sink
where TestFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This entity depends on a $@.", source.getNode(),
  "user-provided value"
