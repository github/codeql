/**
 * @kind path-problem
 */

import codeql.ruby.AST
import codeql.ruby.CFG
import utils.test.InlineFlowTest
import codeql.ruby.dataflow.BarrierGuards
import PathGraph

module FlowConfig implements DataFlow::ConfigSig {
  predicate isSource = DefaultFlowConfig::isSource/1;

  predicate isSink = DefaultFlowConfig::isSink/1;

  predicate isBarrier(DataFlow::Node n) { n instanceof StringConstCompareBarrier }
}

import ValueFlowTest<FlowConfig>

from PathNode source, PathNode sink
where flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
