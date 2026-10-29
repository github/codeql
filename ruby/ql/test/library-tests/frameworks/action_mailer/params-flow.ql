/**
 * @kind path-problem
 */

import ruby
import utils.test.InlineFlowTest
import TaintFlow::PathGraph
import codeql.ruby.frameworks.Rails

module ParamsTaintFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr().getExpr() instanceof Rails::ParamsCall }

  predicate isSink(DataFlow::Node n) { DefaultFlowConfig::isSink(n) }
}

import FlowTest<DefaultFlowConfig, ParamsTaintFlowConfig>

from TaintFlow::PathNode source, TaintFlow::PathNode sink
where TaintFlow::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
